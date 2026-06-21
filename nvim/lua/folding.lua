local M = {}

-- Cache: { [bufnr] = { tick = N, ranges = {{start_lnum, end_lnum}, ...} } }
-- ranges are sorted by start_lnum for binary search.
local cache = {}

-- A region marker must start with a comment character (non-alphanumeric,
-- non-whitespace) so that identifiers like `const region:` are ignored.
local function is_comment_line(line)
    return line:match("^%s*[^%w%s_]") ~= nil
end

-- Scan the whole buffer and return sorted region ranges {start, end}.
-- Unclosed regions (no matching endregion) are ignored.
local function build_ranges(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local ranges = {}
    local stack = {} -- stack of start lnums (1-based)

    for i, line in ipairs(lines) do
        if is_comment_line(line) then
            if line:find("endregion:") and #stack > 0 then
                local start = table.remove(stack)
                table.insert(ranges, { start, i })
            elseif line:find("region:") then
                table.insert(stack, i)
            end
        end
    end

    table.sort(ranges, function(a, b) return a[1] < b[1] end)
    return ranges
end

local function get_ranges(bufnr)
    local tick = vim.api.nvim_buf_get_changedtick(bufnr)
    local entry = cache[bufnr]
    if not entry or entry.tick ~= tick then
        cache[bufnr] = { tick = tick, ranges = build_ranges(bufnr) }
    end
    return cache[bufnr].ranges
end

-- Binary search: is lnum inside any region range?
local function inside_region(lnum, ranges)
    local lo, hi = 1, #ranges
    while lo <= hi do
        local mid = math.floor((lo + hi) / 2)
        local r = ranges[mid]
        if lnum < r[1] then
            hi = mid - 1
        elseif lnum > r[2] then
            lo = mid + 1
        else
            return true
        end
    end
    return false
end

-- Shift a treesitter fold level string up by 1.
-- e.g. "0" -> "0", "1" -> "2", ">1" -> ">2", "<1" -> "<2", "=" -> "="
local function shift_ts(ts)
    local s = tostring(ts)
    if s == "=" then return "=" end
    local prefix, num = s:match("^([<>]?)(%d+)$")
    if num then
        local n = tonumber(num)
        if n == 0 then return "0" end
        return prefix .. (n + 1)
    end
    return ts
end

-- Custom foldexpr: region markers take priority, treesitter handles the rest.
-- Region folds are at level 1; treesitter levels are shifted up by 1 inside regions
-- so they nest correctly as children.
function M.foldexpr()
    local lnum = vim.v.lnum
    local line = vim.fn.getline(lnum)

    if is_comment_line(line) then
        if line:find("endregion:") then
            return "<1"
        elseif line:find("region:") then
            return ">1"
        end
    end

    local ts = vim.treesitter.foldexpr()

    local bufnr = vim.api.nvim_get_current_buf()
    if not inside_region(lnum, get_ranges(bufnr)) then
        return ts
    end

    -- Inside a region: treesitter level 0 → stay at region level 1
    local s = tostring(ts)
    if s == "0" then return "1" end
    return shift_ts(ts)
end

return M
