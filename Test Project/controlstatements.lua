local M={}

inputMod = require('inputobj')
local EventObject = inputMod.EventObject

local LoopStartCommand = {}
LoopStartCommand.__index = LoopStartCommand
setmetatable(LoopStartCommand, {
  __index = EventObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})
function LoopStartCommand:_init(player, objIndex)
	self.func = function(x) player:loopStart() end
	self.iterations = 0
	self.objIndex = objIndex
	self.name = 'LoopStart'
end

local LoopEndCommand = {}
LoopEndCommand.__index = LoopEndCommand
setmetatable(LoopEndCommand, {
  __index = EventObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})
function LoopEndCommand:_init(player, objIndex)
	self.func = function(x) player:loopEnd() end
	self.iterations = 0
	self.objIndex = objIndex
	self.name = 'LoopEnd'
end

M.LoopStart = LoopStartCommand
M.LoopEnd = LoopEndCommand

return M