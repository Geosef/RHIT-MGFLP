local List = {}

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
	if objs == null	then
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

function List:removeindex(objindex)
	for i = objindex + 1, # self.objs do
		self.objs[i].objindex = self.objs[i].objindex - 1
	end
	table.remove(self.objs, objindex)
end

function List:remove(obj)
	self:removeindex(obj.objindex)
end

function List:append(obj)
	table.insert(self.objs, obj)
	obj.objindex = # self.objs
end

function List:insert(obj, objindex)
	table.insert(self.objs, objindex, obj)
	for i = objindex + 1, # self.objs do
		self.objs[i].objindex = self.objs[i].objindex + 1
	end
end