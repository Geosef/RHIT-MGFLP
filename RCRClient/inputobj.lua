-- program is being exported under the TSU exception

local M = {}
local listMod = Core.class(list)

local EventObject = {}
EventObject.__index = EventObject

setmetatable(EventObject, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

-- func must be function that takes one parameter
function EventObject:_init(func, param, objIndex)
	self.func = func
	self.objIndex = objIndex
	self.param = param
end

-- func must be function that takes one parameter
function EventObject:setFunc(func)
	self.func = func
end

function EventObject:setObjIndex(objIndex)
	self.objIndex = objIndex
end

function EventObject:execute()
	self.func(self.param)
end

function EventObject:tick()
	self.frames = self.frames - 1
end

function EventObject:isFinished()
	return self.frames <= 0
end

local ScriptObject = {}
ScriptObject.__index = ScriptObject

setmetatable(ScriptObject, {
  __index = EventObject, -- this is what makes the inheritance work
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function ScriptObject:_init()
	self.list = listMod.List(nil)
end

function ScriptObject:execute()
	self.list:iterate(function(command) command:execute() end)
end

function ScriptObject:removeIndex(objIndex)
	self.list:removeIndex(objIndex)
end

function ScriptObject:remove(obj)
	self:removeIndex(obj.objIndex)
end

function ScriptObject:append(obj)
	self.list:append(obj)
end

function ScriptObject:insert(obj, objIndex)
	self.list:insert(obj, objIndex)
end

function ScriptObject:length()
	return self.list:length()
end

local LoopObject = {}
LoopObject.__index = LoopObject

setmetatable(LoopObject, {
  __index = EventObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function LoopObject:_init(objs, numRuns, objIndex)
	if objs == null then
		self.objs = listMod.List(nil)
	else
		self.objs = objs
	end
	self.numRuns = numRuns
	self.objIndex = objIndex
end

function LoopObject:execute()
	for i = 1, self.numRuns do
		self.objs:iterate(function(command) command:execute() end)
	end
end

function LoopObject:append(obj)
	self.objs:append(obj)
end

function LoopObject:removeIndex(objIndex)
	self.objs:removeIndex(obj.objIndex)
end

function LoopObject:remove(obj)
	self:removeIndex(obj.objIndex)
end

function LoopObject:setObjIndex(objIndex)
	self.objIndex = objIndex
end

M.EventObject = EventObject
M.ScriptObject = ScriptObject
M.LoopObject = LoopObject

return M