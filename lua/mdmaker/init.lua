local M = {}
local api = vim.api
local util = require("mdmaker.util")

---@type table<string, any>
M.default_opts = {
    nvim_dir = "~/.config/nvim/",
    output = "~/.config/nvim/README.md",
    package_maganer = "folke/lazy.nvim",
    -- if you don't want any of the following fields, set them to ""
    title = "Neovim configuration",
    version_manager = { name = "", url = "" },
    gui = { name = "", url = "" },
    enable_url_check = false, -- greatly slows down neovim for few seconds, use it when you REALLY need it
}

---@type table<string, any>
M.opts = {}

function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", M.default_opts, opts or {})
    if string.sub(M.opts.nvim_dir, 1, 1) == "~" then
        local home_dir = os.getenv("HOME")
        M.opts.nvim_dir = home_dir .. string.sub(M.opts.nvim_dir, 2)
    end
    api.nvim_create_user_command("MdMake", M.generate, {
        nargs = 0,
        desc = "Generate README.md file for personal nvim config directory.",
    })
end

function M.generate()
    local ok, files =
        pcall(io.popen, "/usr/bin/find " .. M.opts.nvim_dir .. " -type f | /usr/bin/grep lua$", "r")
    if not ok then
        util.error("Could open/find directory.")
        return
    end
    local repo_pattern1 = '"[^%s/]+/[^%s/]-"'
    local repo_pattern2 = "'[^%s/]+/[^%s/]-'"
    local links = {}
    for file in files:lines("*l") do
        local reader = io.open(file, "r")
        local repo_name = nil
        local plugin_name = nil
        for line in reader:lines("*l") do
            repo_name = string.match(line, repo_pattern1)
            if not repo_name then
                repo_name = string.match(line, repo_pattern2)
            end
            if repo_name and #repo_name <= 39 then
                repo_name = string.sub(repo_name, 2, -2)
                plugin_name = string.sub(repo_name, string.find(repo_name, "/") + 1)
                local url = "https://github.com/" .. repo_name
                if M.opts.enable_url_check then
                    if util.url_is_valid(url) then
                        table.insert(links, "* [" .. plugin_name .. "](" .. url .. ")\n")
                    end
                else
                    table.insert(links, "* [" .. plugin_name .. "](" .. url .. ")\n")
                end
            end
        end
        reader:close()
    end
    local output_string = ""
    if #M.opts.title > 0 then
        output_string = output_string .. "# " .. M.opts.title .. "\n"
    end
    output_string = output_string
        .. "## 📦 Package manager\n* ["
        .. string.sub(M.opts.package_maganer, string.find(M.opts.package_maganer, "/") + 1)
        .. "](https://github.com/"
        .. M.opts.package_maganer
        .. ")\n## 🔌 Plugins"
        .. "\n"
    table.sort(links)
    links = util.remove_duplicates(links)
    for _, l in ipairs(links) do
        output_string = output_string .. l
    end
    if #M.opts.version_manager.name > 0 then
        output_string = output_string
            .. "## 🗃️ Version manager\n* ["
            .. M.opts.version_manager.name
            .. "]("
            .. M.opts.version_manager.url
            .. ")\n"
    end
    if #M.opts.gui.name > 0 then
        output_string = output_string
            .. "## ✨ GUI\n* ["
            .. M.opts.gui.name
            .. "]("
            .. M.opts.gui.url
            .. ")\n"
    end
    local output_file
    ok, output_file = pcall(io.open, M.opts.output, "w")
    if not ok then
        util.error("Could not write file.")
        return
    end
    util.info(M.opts.output .. " successfully generated.")
    output_file:write(output_string)
    output_file:close()
end

return M
