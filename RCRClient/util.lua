-- program is being exported under the TSU exception

function inTable(tbl, item)
    for key, value in ipairs(tbl) do
        if value == item then return key end
    end
    return false
end

