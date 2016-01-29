-- program is being exported under the TSU exception

--[[
	Looks for item in table tbl.
	Returns key/index of item if found, false otherwise.
]]
function inTable(tbl, item)
    for key, value in ipairs(tbl) do
        if value == item then return key end
    end
    return false
end

--[[
	Performs a deep copy of orig.
]]
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
