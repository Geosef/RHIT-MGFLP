local M={}

local Notifier = {}
Notifier.__index = Notifier

setmetatable(Notifier, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Notifier:_init()
	self.notifyField = TextField.new(nil)
	self.shovelCount:setScale(2.5)
end



return M