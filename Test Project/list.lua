local M = {}
local List = {}

-- Any object that uses this list must have the objindex property defined for it. 
-- For simplicity sake, simply extend the InputObject table.

setmetatable(List, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

List.__index = List

setmetatable(List, {
  __index = InputObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function List:_init(objs)
	if objs == nil	then
		self.objs = {}
	else
		self.objs = objs
	end
end

function List:iterate(func)
	for index,value in ipairs(self.objs) do
		func(value)
	end
end

function List:backwardsIterate(func)
	for i = # self.objs, 1, -1 do
		func(self.objs[i])
	end
end


function List:removeIndex(objIndex)
	for i = objIndex + 1, # self.objs do
		self.objs[i].objIndex = self.objs[i].objIndex - 1
	end
	table.remove(self.objs, objIndex)
end

function List:remove(obj)
	self:removeIndex(obj.objIndex)
end

function List:append(obj)
	table.insert(self.objs, obj)
	obj.objIndex = # self.objs
end

function List:insert(obj, objIndex)
	obj.objIndex = objIndex
	table.insert(self.objs, objIndex, obj)
	for i = objIndex + 1, # self.objs do
		self.objs[i].objIndex = self.objs[i].objIndex + 1
	end
end

function List:length()
	return # self.objs
end

M.List = List
return M