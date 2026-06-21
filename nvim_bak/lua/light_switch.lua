local M = {}

---Setup LightSwitch with desired light and dark themes
---@param path string Interface style file path
---@param colorschemes { light: string, dark: string } Color schemes
---
function M.setup(path, colorschemes)
	local w = vim.loop.new_fs_event()
	local fullpath = vim.api.nvim_call_function("fnamemodify", { path, ":p" })

	if w == nil then
		print("File watching is disabled due to event loop returned nil")
		return
	end

	w:start(fullpath, {}, function(err, _, _)
		if err ~= nil then
			print("LightSwitch error: " .. err)
			return
		end

		vim.schedule(function()
			M.update_colorscheme(fullpath, colorschemes.light, colorschemes.dark)
		end)
	end)

	M.update_colorscheme(fullpath, colorschemes.light, colorschemes.dark)
end

---Activates desired light and dark themes according to style file
---@param light string Light mode colorscheme
---@param dark string Dark mode colorscheme
function M.update_colorscheme(filename, light, dark)
	local lines = vim.fn.readfile(filename)
	local style = lines[1]
	local colorscheme = ""

	if style == "light" then
		colorscheme = light
	else
		colorscheme = dark
	end

	vim.cmd.colorscheme(colorscheme)
	print("LightSwitch: " .. colorscheme)
end

return M
