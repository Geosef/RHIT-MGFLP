-- program is being exported under the TSU exception

local M={}

inputMod = require('inputobj')
local EventObject = inputMod.EventObject

local DigCommand = {}
DigCommand.__index = DigCommand
setmetatable(DigCommand, {
  __index = EventObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})
function DigCommand:_init(player, objIndex)
	self.func = function(x) player.dig() end
	self.param = nil
	self.objIndex = objIndex
	self.name = 'Dig'
	self.frames = 32
end

M.Dig = DigCommand

return M