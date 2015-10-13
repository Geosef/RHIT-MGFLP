M = {}

local InputObject = {}
InputObject.__index = InputObject

setmetatable(InputObject, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function InputObject:_init()
end

function InputObject:execute()
end


EventObject = {}
EventObject.__index = EventObject

setmetatable(EventObject, {
  __index = InputObject, -- this is what makes the inheritance work
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function EventObject:_init(func, objindex)
	self.func = func
	self.objindex = objindex
end

function EventObject:setfunc(func)
	self.func = func
end

function EventObject:setobjindex(objindex)
	self.objindex = objindex
end


function EventObject:execute()
	--local timer = Timer.delayedCall(1000, self.func)
	self.func()
end

ScriptObject = {}
ScriptObject.__index = ScriptObject

setmetatable(ScriptObject, {
  __index = InputObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function ScriptObject:_init(objs)
	self.objs = objs
end

function ScriptObject:execute()
	for index,value in ipairs(self.objs) do
		value:execute()
	end
end

function ScriptObject:removeindex(objindex)
	for i = objindex + 1, # self.objs do
		self.objs[i].objindex = self.objs[i].objindex - 1
	end
	table.remove(self.objs, objindex)
end

function ScriptObject:remove(obj)
	self:removeindex(obj.objindex)
end

function ScriptObject:append(obj)
	table.insert(self.objs, obj)
	obj.objindex = # self.objs
end

function ScriptObject:insert(obj, objindex)
	table.insert(self.objs, objindex, obj)
	for i = objindex + 1, # self.objs do
		self.objs[i].objindex = self.objs[i].objindex + 1
	end
end

LoopObject = {}
LoopObject.__index = LoopObject

setmetatable(LoopObject, {
  __index = InputObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function LoopObject:_init(obj, numruns)
	self.obj = obj
	self.numruns = numruns
end

function LoopObject:execute()
	for i = 1, self.numruns do
		self.obj:execute()
	end
end


M.EventObject = EventObject
M.ScriptObject = ScriptObject
M.LoopObject = LoopObject

return M