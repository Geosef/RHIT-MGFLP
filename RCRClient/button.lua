-- program is being exported under the TSU exception
--[[
A generic button class
This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
(C) 2010 - 2011 Gideros Mobile 

This code was modified from the original source by
Michael Kochell, Prithvi Kanherkar, Joseph Carroll and William Mader
on 12/14/2015
]]

Button = Core.class(SceneObject)
function Button:init(upState, downState)
	self.upState = upState
	self.downState = downState
	
	self.focus = false
	
	-- set the visual state as "up"
	self:addChild(self.upState)
	
	--Extracted listeners to new register function and placed registry function in onEnterEnd
	--Also placed an unregister function in onExitBegin
	--self:registerListeners()
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function Button:onEnterEnd()
	
	self:registerListeners()
end

function Button:onExitBegin()
	self:unregisterListeners()
end

function Button:registerListeners() 
	-- register to all mouse and touch events
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)

	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
	self:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
	self:addEventListener(Event.TOUCHES_CANCEL, self.onTouchesCancel, self)
end

function Button:unregisterListeners()
	-- unregister all mouse and touch event listeners
	self:removeEventListener(Event.MOUSE_DOWN, self.onMouseDown)
	self:removeEventListener(Event.MOUSE_MOVE, self.onMouseMove)
	self:removeEventListener(Event.MOUSE_UP, self.onMouseUp)
	
	self:removeEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin)
	self:removeEventListener(Event.TOUCHES_MOVE, self.onTouchesMove)
	self:removeEventListener(Event.TOUCHES_END, self.onTouchesEnd)
	self:removeEventListener(Event.TOUCHES_CANCEL, self.onTouchesCancel)
end

function Button:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) then
		self.focus = true
		self:updateVisualState(true)
		event:stopPropagation()
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
