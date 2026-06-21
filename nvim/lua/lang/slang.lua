-- Project-specific compiler args are read from vim.g.slangc_args (set in .nvim.lua).
-- Example .nvim.lua:
--   vim.g.slangc_args = { "-target", "spirv", "-o", "/dev/null" }

local sev_map  = {
    error   = vim.diagnostic.severity.ERROR,
    warning = vim.diagnostic.severity.WARN,
    note    = vim.diagnostic.severity.INFO,
}
local type_map = { error = "E", warning = "W", note = "I" }

local ns       = vim.api.nvim_create_namespace("slangc")
local job      = nil
local slangc   = "/data/devtools/compilers/slang-2026.4.2/bin/slangc"

-- Slang uses Rust-style diagnostics spanning multiple lines, e.g.:
--   error[E30015]: undefined identifier
--     --> /path/to/file.slang:13:5
--
-- Parser is stateful: hold the severity+message until the --> location line.
local function parse_output(output, cwd)
    local items   = {}
    local qflist  = {}
    local pending = nil  -- { sev_str, msg } waiting for a --> line

    for line in output:gmatch("[^\n]+") do
        -- severity line: error[EXXXXX]: message  or  warning[...]: message
        local sev_str, msg = line:match("^(%a+)%[%a*%d+%]:%s*(.+)$")
        if not sev_str then
            -- also catch bare "error: message" / "warning: message"
            sev_str, msg = line:match("^(%a+):%s*(.+)$")
        end
        if sev_str then
            sev_str = sev_str:match("error") and "error"
                   or sev_str:match("warning") and "warning"
                   or nil
            if sev_str and sev_map[sev_str] then
                pending = { sev_str = sev_str, msg = msg }
            end
        end

        -- location line:   --> file:line:col
        if pending then
            local file, lnum, col = line:match("^%s*%-+>%s*(.+):(%d+):(%d+)$")
            if file then
                local abs = (file:sub(1, 1) == "/") and file or (cwd .. "/" .. file)
                table.insert(items, {
                    abs     = abs,
                    lnum    = tonumber(lnum) - 1,
                    col     = tonumber(col) - 1,
                    sev_str = pending.sev_str,
                    msg     = pending.msg,
                })
                table.insert(qflist, {
                    filename = abs,
                    lnum     = tonumber(lnum),
                    col      = tonumber(col),
                    type     = type_map[pending.sev_str],
                    text     = pending.msg,
                })
                pending = nil
            end
        end
    end
    return items, qflist
end

local function run_check(filepath, cwd)
    if job then job:kill(9) end
    local extra = type(vim.g.slangc_args) == "table" and vim.g.slangc_args or {}
    local cmd = { slangc }
    for _, a in ipairs(extra) do cmd[#cmd + 1] = a end
    cmd[#cmd + 1] = filepath

    job = vim.system(
        cmd,
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
                        source   = "slangc",
                    })
                end
                vim.diagnostic.reset(ns)
                for bufnr, diags in pairs(diags_by_buf) do
                    vim.diagnostic.set(ns, bufnr, diags)
                end
                vim.fn.setqflist({}, "r", { title = "slangc", items = qflist })
                if #qflist > 0 then
                    vim.cmd("copen | wincmd p")
                else
                    vim.cmd("cclose")
                end
            end)
        end
    )
end

vim.api.nvim_create_autocmd("BufWritePost", {
    desc     = "Run slangc and populate diagnostics/quickfix",
    pattern  = "*.slang",
    callback = function(ev)
        local filepath = vim.api.nvim_buf_get_name(ev.buf)
        local root     = vim.fn.fnamemodify(filepath, ":h")
        run_check(filepath, root)
    end,
})
