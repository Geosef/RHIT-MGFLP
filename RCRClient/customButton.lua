-- program is being exported under the TSU exception

CustomButton = Core.class(Button)
-- Added func to constructor that is run in onMouseUp
function CustomButton:init(upState, downState, func)
	--print(self.name)
	self.super = Core.class(Sprite)
	self.func = func
	self.hitArea = self:makeHitArea()
	self:addHitArea()
	self:enable()
end

local padding = 5

function CustomButton:makeHitArea()
	local shape = Shape.new()
	shape:setFillStyle(Shape.SOLID, 0xff0000, 1)
	shape:beginPath()
	shape:moveTo(0,0)
	
	shape:lineTo(self.upState:getWidth() + padding*2, 0)
	shape:lineTo(self.upState:getWidth() + padding*2, self.upState:getHeight() + padding*2)
	shape:lineTo(0, self.upState:getHeight() + padding*2)
	shape:lineTo(0, 0)
	shape:endPath()
	shape:setVisible(false)
	return shape
end

function CustomButton:addHitArea()
	self.hitArea:setPosition(-padding, -padding)
	self:addChild(self.hitArea)
end

function CustomButton:setPosition(x, y)
	self.super.setPosition(self, x, y)
	self:addHitArea()
end

function CustomButton:getWidth()
	return math.max(self.upState:getWidth(), self.downState:getWidth())
end

function CustomButton:getHeight()
	return math.max(self.upState:getHeight(), self.downState:getHeight())
end

function CustomButton:onMouseDown(event)
	if not self.enabled then
		return
	end
	if self.hitArea:hitTestPoint(event.x, event.y) then
		self.focus = true
		self:updateVisualState(true)
		event:stopPropagation()
		--print(self.name)
	end
end

function CustomButton:onMouseMove(event)
	if not self.enabled then
		return
	end
	if self.focus then
		if not self.hitArea:hitTestPoint(event.x, event.y) then	
			self.focus = false
			self:updateVisualState(false)
		end
		event:stopPropagation()
	end
end

function CustomButton:onMouseUp(event)
	if not self.enabled then
		return
	end
	if self.focus then
		self.focus = false
		self:updateVisualState(false)
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		--Runs specified function
		self.func()
	end
end

function CustomButton:disable()
	self.enabled = false
end

function CustomButton:enable()
	self.enabled = true
end