---@diagnostic disable: need-check-nil

local M = {}
local api = vim.api
local util = require("mdmaker.util")

---@type table<string, any>
M.default_opts = {
    nvim_dir = "~/.config/nvim/",
    output = "~/.config/nvim/README.md",
    enable_url_check = false, -- disable if generating README.md offline of with bad connection
    package_maganer = "folke/lazy.nvim",
    -- if you don't want any of the following fields, set them to ""
    title = "Neovim configuration",
    version_manager = { name = "", url = "" },
    gui = { name = "", url = "" },
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

M.repo_names = {}

function M.generate()
    M.read_files()
    if M.opts.enable_url_check then
        vim.g.n_repo_names = #M.repo_names
        M.mark_invalid_urls()
        local timer = (vim.uv or vim.loop).new_timer()
        timer:start(
            0,
            100,
            vim.schedule_wrap(function()
                if vim.g.n_repo_names == 0 then
                    M.write_to_file()
                    timer:stop()
                    timer:close()
                end
            end)
        )
    else
        M.write_to_file()
    end
end

function M.read_files()
    local ok, files = pcall(
        io.popen,
        "/usr/bin/find " .. M.opts.nvim_dir .. " -type f | /usr/bin/grep '.lua$'",
        "r"
    )
    if not ok then
        util.error("Could open/find directory.")
        return
    end
    local repo_pattern1 = '"[^%s/]+/[^%s/]-"'
    local repo_pattern2 = "'[^%s/]+/[^%s/]-'"
    local repos = {}
    for file in files:lines("*l") do
        local reader = io.open(file, "r")
        local repo_name = nil
        for line in reader:lines("*l") do
            repo_name = string.match(line, repo_pattern1)
            if not repo_name then
                repo_name = string.match(line, repo_pattern2)
            end
            if repo_name and #repo_name <= 39 then
                repo_name = string.sub(repo_name, 2, -2)
                table.insert(M.repo_names, { name = repo_name, valid = true })
            end
        end
        reader:close()
    end
end

function M.write_to_file()
    local ok, output_file = pcall(io.open, M.opts.output, "w")
    if not ok then
        util.error("Could not write file.")
        return
    end
    util.info(M.opts.output .. " successfully generated.")
    output_file:write(M.generate_string())
    output_file:close()
end

function M.generate_string()
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
    local ul = {}
    for _, rn in ipairs(M.repo_names) do
        if rn.valid then
            local plugin_name = string.sub(rn.name, string.find(rn.name, "/") + 1)
            local url = "https://github.com/" .. rn.name
            table.insert(ul, "* [" .. plugin_name .. "](" .. url .. ")\n")
        end
    end
    ul = util.remove_duplicates(ul)
    for _, li in ipairs(ul) do
        output_string = output_string .. li
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
    return output_string
end

function M.mark_invalid_urls()
    for _, rn in ipairs(M.repo_names) do
        local function on_exit(obj)
            vim.g.n_repo_names = vim.g.n_repo_names - 1
            rn.valid = (string.match(obj.stdout, "200") ~= nil)
        end
        local url = "https://github.com/" .. rn.name
        vim.system({ "curl", "--head", "--silent", url }, { text = true }, on_exit)
    end
end

return M
