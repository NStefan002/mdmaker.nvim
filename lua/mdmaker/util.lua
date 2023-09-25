local M = {}

---notify user of an error
---@param msg string
function M.error(msg)
    -- "\n" for nvim configs that don't use nvim-notify
    vim.notify("\n" .. msg, vim.log.levels.WARN, { title = "Mdmaker" })
end

---@param msg string
function M.info(msg)
    -- "\n" for nvim configs that don't use nvim-notify
    vim.notify("\n" .. msg, vim.log.levels.INFO, { title = "Mdmaker" })
end

-- TODO: use something like vim.fn.jobstart or vim.system instead
---@param url string
function M.url_is_valid(url)
    local reader = io.popen(
        "/usr/bin/curl --head --silent " .. url .. " | /usr/bin/head -n 1 | /usr/bin/grep -o 200",
        "r"
    )
    local status_code = reader:read("*n")
    -- print(status_code)
    reader:close()
    return status_code == 200
end

return M
