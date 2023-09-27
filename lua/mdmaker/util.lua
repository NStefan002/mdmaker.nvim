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

---@param tbl table
function M.remove_duplicates(tbl)
    table.sort(tbl, function(a, b)
        return string.lower(a) < string.lower(b)
    end)
    local uniques = {}
    for _, e in ipairs(tbl) do
        if e ~= uniques[#uniques] then
            table.insert(uniques, #uniques + 1, e)
        end
    end
    return uniques
end

return M
