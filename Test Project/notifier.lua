-- program is being exported under the TSU exception

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
	self.notifyField:setTextColor(0xff0000)
	self.notifyField:setScale(2.5)
end

function Notifier:notify(text)
	self.notifyField:setText(text)
	notifyFieldXPos = (WINDOW_WIDTH / 2) - (self.notifyField:getWidth() / 2)
	notifyFieldYPos = WINDOW_HEIGHT - 10
	self.notifyField:setPosition(notifyFieldXPos, notifyFieldYPos)
	local frameCounter = 30
	local frameDecrement = function ()
		if frameCounter == 0 then
			stage:removeChild(self.notifyField)
			stage:removeEventListener(Event.ENTER_FRAME, self.frameDecrement)
		end
		self.notifyField:setAlpha(frameCounter / 20)
		frameCounter = frameCounter - 1
	end
	self.frameDecrement = frameDecrement
	stage:addEventListener(Event.ENTER_FRAME, self.frameDecrement)
	stage:addChild(self.notifyField)
end

M.Notifier = Notifier
return M