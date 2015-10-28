local M = {}

local WaitingForOpponent = {}
WaitingForOpponent.__index = WaitingForOpponent

setmetatable(WaitingForOpponent, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function WaitingForOpponent:_init(netAdapter)
	self.text = Bitmap.new(Texture.new("images/grassbackground.png"))
	stage:addChild(self.background)
	self.netAdapter = netAdapter
end

M.WaitingForOpponent = WaitingForOpponent
return M