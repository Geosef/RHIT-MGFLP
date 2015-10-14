local M={}

inputMod = require('inputobj')

local EventObject = inputMod.EventObject

local MoveLeftCommand = {}
MoveLeftCommand.__index = MoveLeftCommand
setmetatable(MoveLeftCommand, {
  __index = EventObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})
function MoveLeftCommand:_init(player, param, objIndex)
	self.func = function(x) player:moveLeft(x) end
	self.param = param
	self.objIndex = objIndex
	self.name = 'LeftMove'
end

local MoveRightCommand = {}
MoveRightCommand.__index = MoveRightCommand
setmetatable(MoveRightCommand, {
  __index = EventObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})
function MoveRightCommand:_init(player, param, objIndex)
	self.func = function(x) player:moveRight(x) end
	self.param = param
	self.objIndex = objIndex
	self.name = 'RightMove'
end

local MoveUpCommand = {}
MoveUpCommand.__index = MoveUpCommand
setmetatable(MoveUpCommand, {
  __index = EventObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})
function MoveUpCommand:_init(player, param, objIndex)
	self.func = function(x) player:moveUp(x) end
	self.param = param
	self.objIndex = objIndex
	self.name = 'UpMove'
end

local MoveDownCommand = {}
MoveDownCommand.__index = MoveDownCommand
setmetatable(MoveDownCommand, {
  __index = EventObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})
function MoveDownCommand:_init(player, param, objIndex)
	self.func = function(x) player:moveDown(x) end
	self.param = param
	self.objIndex = objIndex
	self.name = 'DownMove'
end

M.LeftMove = MoveLeftCommand
M.RightMove = MoveRightCommand
M.UpMove = MoveUpCommand
M.DownMove = MoveDownCommand

function getEvent(name)
	return M[name]
end

M.getEvent = getEvent

return M
