local env = vim.fn.environ()

local HOME = env.HOME
local USERPROFILE = env.USERPROFILE
local CONFIG_KEYMAPS_FILE_PATH = "/nvim/plugin/keymaps.lua"
local CONFIG_ROOT

if HOME then
	CONFIG_ROOT = HOME .. "/.config"
else
	assert(USERPROFILE, "Could not determine config root directory")
	CONFIG_ROOT = USERPROFILE .. [[\AppData\Local]]
	CONFIG_ROOT = CONFIG_ROOT:gsub("\\", "/") -- Normalize path for Neovim
end

local KEYMAPS_LUA_FILE_PATH = CONFIG_ROOT .. CONFIG_KEYMAPS_FILE_PATH

---@param file_path string
local function get_lua_markdown(file_path)
	local file_content = vim.fn.readfile(file_path) --[[@as table<string>]]
	local formatted_content = ""
	local code_block = ""

	for _, line in pairs(file_content) do
		line = line --[[@as string]]

		local is_comment = line:sub(1, 2) == "--"
		local is_empty_line = line:gsub("%s+", "") == ""

		if is_comment then
			if #code_block > 0 then
				formatted_content = formatted_content .. code_block .. "```\n"
				code_block = ""
			end

			local stripped = formatted_content
				.. "\n"
				.. line:gsub("^%-%-%s+", ""):gsub("^%-%-%[%[%s+", ""):gsub("%-%-%]%]%s*", "---")
			formatted_content = stripped:gsub("%s+$", "") .. "\n"
		elseif is_empty_line then
			if #code_block > 0 then
				formatted_content = formatted_content .. code_block .. "```"
				code_block = ""
			end

			formatted_content = formatted_content .. "\n"
		elseif #code_block > 0 then
			code_block = code_block .. line .. "\n"
		else
			code_block = "\n```lua\n" .. line .. "\n"
		end
	end

	if #code_block > 0 then
		formatted_content = formatted_content .. code_block .. "```\n"
	end

	return formatted_content
end

---@param text string
local function create_markdown_output_window(text)
	-- Trim text before showing
	text = text:gsub("^%s+", ""):gsub("%s$", "")

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, 0, false, vim.split(text, "\n"))

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		-- Center the window
		width = 160,
		height = 30,
		col = vim.o.columns / 2 - 80,
		row = vim.o.lines / 2 - 15,
		border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
		focusable = true,
	})

	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
	vim.api.nvim_set_option_value("bufhidden", "delete", { buf = buf })
	vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
	vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
	vim.api.nvim_set_option_value("number", false, { win = win })
	vim.api.nvim_set_option_value("relativenumber", false, { win = win })
end

vim.api.nvim_create_user_command("MeineKeymaps", function(opts)
	-- opts.args
	local keymaps_content = get_lua_markdown(KEYMAPS_LUA_FILE_PATH)
	create_markdown_output_window(keymaps_content)
end, {
	desc = "Lists the keymaps from .meine",
	-- nargs = 1, -- Requires one argument
	-- complete = 'file', -- Suggests filenames as arguments
})
