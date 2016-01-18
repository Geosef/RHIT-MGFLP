GameButton = Core.class(CustomButton)
local font = TTFont.new("fonts/arial-rounded.ttf", 20)

function GameButton:init(upState, downState, func, action)
	self.action = action
	self.buttonNameField = TextField.new(font, self.action)
	self.buttonNameField:setPosition((self:getWidth() / 2) - (self.buttonNameField:getWidth() / 2), (self:getHeight() / 2) + (self.buttonNameField:getHeight() / 2))
	self:addChild(self.buttonNameField)
end

function GameButton:onMouseDown(event)
	if not self.enabled then
		return
	end
	if self.hitArea:hitTestPoint(event.x, event.y) then
		self:removeChild(self.buttonNameField)
		self.focus = true
		self:updateVisualState(true)
		self.buttonNameField:setTextColor("0xffffff")
		self:addChild(self.buttonNameField)
		event:stopPropagation()
		--print(self.name)
	end
end

function GameButton:onMouseUp(event)
	if not self.enabled then
		return
	end
	if self.focus then
		self:removeChild(self.buttonNameField)
		self.focus = false
		self:updateVisualState(false)
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		self.buttonNameField:setTextColor("0x000000")
		self:addChild(self.buttonNameField)
		event:stopPropagation()
		--Runs specified function
		self.func(self.action)
	end
end
