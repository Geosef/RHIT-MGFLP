-- program is being exported under the TSU exception

Button = gideros.class(Sprite)

function Button:init(upState, downState, func)
	self.func = func
	--print(self.name)
	self.upState = upState
	self.downState = downState
	self:addChild(self.upState)
		
	self.focus = false

	-- set the visual state as "up"
	self:updateVisualState(false)

	-- register to all mouse and touch events
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)

	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
	self:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
	self:addEventListener(Event.TOUCHES_CANCEL, self.onTouchesCancel, self)
	--print(self.name)
end

function Button:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) then
		self.focus = true
		self:updateVisualState(true)
		event:stopPropagation()
		--print(self.name)
		self.func()
	end
end

function Button:onMouseMove(event)
	if self.focus then
		if not self:hitTestPoint(event.x, event.y) then	
			self.focus = false
			self:updateVisualState(false)
		end
		event:stopPropagation()
	end
end

function Button:onMouseUp(event)
	if self.focus then
		self.focus = false
		self:updateVisualState(false)
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
	end
end

-- if button is on focus, stop propagation of touch events
function Button:onTouchesBegin(event)
	if self.focus then
		event:stopPropagation()
	end
end

-- if button is on focus, stop propagation of touch events
function Button:onTouchesMove(event)
	if self.focus then
		event:stopPropagation()
	end
end

-- if button is on focus, stop propagation of touch events
function Button:onTouchesEnd(event)
	if self.focus then
		event:stopPropagation()
	end
end

-- if touches are cancelled, reset the state of the button
function Button:onTouchesCancel(event)
	if self.focus then
		self.focus = false;
		self:updateVisualState(false)
		event:stopPropagation()
	end
end

-- if state is true show downState else show upState
function Button:updateVisualState(state)
	if state then
		if self:contains(self.upState) then
			self:removeChild(self.upState)
		end
		
		if not self:contains(self.downState) then
			self:addChild(self.downState)
		end
	else
		if self:contains(self.downState) then
			self:removeChild(self.downState)
		end
		
		if not self:contains(self.upState) then
			self:addChild(self.upState)
		end
	end
end
