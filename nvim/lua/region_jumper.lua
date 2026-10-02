local M = {}

local function find_regions()
  local cmd
  local use_rg = vim.fn.executable("rg") == 1
  if use_rg then
    cmd = { "rg", "--no-heading", "--line-number", "--color", "never", "-e", "@region:" }
  elseif vim.fn.executable("grep") == 1 then
    cmd = { "grep", "-rn", "--color=never", "@region:" }
  else
    vim.notify("region_jumper: need ripgrep or grep", vim.log.levels.WARN)
    return nil
  end

  local output = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    return nil
  end

  local results = {}
  for _, raw in ipairs(output) do
    local path, lnum, content = raw:match("^(.*):(%d+):(.*)$")
    if path and lnum then
      local region_name = content:match("@regions*:%s*(.+)")
      if region_name then
        region_name = region_name:gsub("%s*%*%/.*$", "")
        region_name = region_name:gsub("%s*$", "")

        if #region_name > 0 then
          table.insert(results, {
            path = path,
            lnum = tonumber(lnum),
            region = region_name,
          })
        end
      end
    end
  end

  if #results == 0 then
    return nil
  end

  local dirs = {}
  for _, r in ipairs(results) do
    local dir = r.path:match("^(.*/)") or ""
    dirs[dir] = (dirs[dir] or 0) + 1
  end

  local dir_count = 0
  local common_dir = ""
  for dir, _ in pairs(dirs) do
    dir_count = dir_count + 1
    common_dir = dir
  end

  local strip = dir_count == 1 and #common_dir > 0

  for _, r in ipairs(results) do
    if strip then
      r.filename_rel = r.path:sub(#common_dir + 1)
    else
      r.filename_rel = r.path
    end
  end

  return results
end

function M.open_picker(opts)
  opts = opts or {}
  local results = find_regions()
  if not results then
    vim.notify("No @region: markers found", vim.log.levels.INFO)
    return
  end

  local max_len = 0
  for _, r in ipairs(results) do
    if #r.region > max_len then
      max_len = #r.region
    end
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers.new(opts, {
    prompt_title = " Regions",
    finder = finders.new_table({
      results = results,
      entry_maker = function(entry)
        return {
          value = entry,
          display = function()
            local ok, status = pcall(require("telescope.state").get_status, vim.api.nvim_get_current_buf())
            if ok and status and status.layout and status.layout.results then
              local results_width = vim.api.nvim_win_get_width(status.layout.results.winid)
              local caret = #(status.picker.selection_caret or "")
              local avail = results_width - caret - max_len - 2
              local right_w = math.max(avail, #entry.filename_rel)
              return string.format("%-" .. max_len .. "s  %" .. right_w .. "s", entry.region, entry.filename_rel)
            end
            return entry.region .. "  " .. entry.filename_rel
          end,
          ordinal = entry.region .. " " .. entry.filename_rel,
          filename = vim.fn.fnamemodify(entry.path, ":p"),
          lnum = entry.lnum,
          text = entry.region,
        }
      end,
    }),
    sorter = conf.generic_sorter(opts),
    previewer = conf.grep_previewer(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection then
          actions.close(prompt_bufnr)
          vim.cmd("edit " .. vim.fn.fnameescape(selection.filename))
          vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
          vim.cmd("normal! zz")
        end
      end)
      return true
    end,
  }):find()
end

return M
