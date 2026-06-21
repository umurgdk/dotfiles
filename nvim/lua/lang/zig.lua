local sev_map  = {
    error   = vim.diagnostic.severity.ERROR,
    warning = vim.diagnostic.severity.WARN,
    note    = vim.diagnostic.severity.INFO,
}
local type_map = { error = "E", warning = "W", note = "I" }

local ns       = vim.api.nvim_create_namespace("zig_build_check")
local job      = nil

-- Returns items and qflist — no Vimscript calls (safe outside vim.schedule).
local function parse_output(output, cwd)
    local items  = {}
    local qflist = {}
    for line in output:gmatch("[^\n]+") do
        local file, lnum, col, sev_str, msg =
            line:match("^(.+):(%d+):(%d+): (%a+): (.+)$")
        if file and sev_map[sev_str] then
            local abs = (file:sub(1, 1) == "/") and file or (cwd .. "/" .. file)
            table.insert(items, {
                abs     = abs,
                lnum    = tonumber(lnum) - 1,
                col     = tonumber(col) - 1,
                sev_str = sev_str,
                msg     = msg,
            })
            table.insert(qflist, {
                filename = abs,
                lnum     = tonumber(lnum),
                col      = tonumber(col),
                type     = type_map[sev_str],
                text     = msg,
            })
        end
    end
    return items, qflist
end

local function run_check(cwd)
    if job then job:kill(9) end
    job = vim.system(
        { "zig", "build", "check" },
        { cwd = cwd, text = true },
        function(result)
            job = nil
            local output = (result.stdout or "") .. (result.stderr or "")
            local items, qflist = parse_output(output, cwd)
            vim.schedule(function()
                local diags_by_buf = {}
                for _, item in ipairs(items) do
                    local bufnr = vim.fn.bufadd(item.abs)
                    diags_by_buf[bufnr] = diags_by_buf[bufnr] or {}
                    table.insert(diags_by_buf[bufnr], {
                        lnum     = item.lnum,
                        col      = item.col,
                        severity = sev_map[item.sev_str],
                        message  = item.msg,
                        source   = "zig build check",
                    })
                end
                vim.diagnostic.reset(ns)
                for bufnr, diags in pairs(diags_by_buf) do
                    vim.diagnostic.set(ns, bufnr, diags)
                end
                vim.fn.setqflist({}, "r", { title = "zig build check", items = qflist })
                if #qflist > 0 then
                    vim.cmd("copen 3 | wincmd p")
                else
                    vim.cmd("cclose")
                end
            end)
        end
    )
end

vim.api.nvim_create_autocmd("BufWritePost", {
    desc     = "Run zig build check and populate diagnostics/quickfix",
    pattern  = "*.zig",
    callback = function(ev)
        local root = vim.fs.root(ev.buf, "build.zig")
        if root then run_check(root) end
    end,
})
