ScriptObject = Core.class(SceneObject)
local font = TTFont.new("fonts/arial-rounded.ttf", 20)
local scriptButtonHeight = 25

function ScriptObject:init()
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function ScriptObject:postInit()
	if self.name then
		local scriptName = TextField.new(font, self.name)
		scriptName:setPosition((self.image:getWidth()/2) - (scriptName:getWidth()/2), 20)
		self:addChild(scriptName)
	end
	self:registerListeners()
end

function ScriptObject:onEnterEnd()
	self:registerListeners()
end

function ScriptObject:onExitBegin()
	self:unregisterListeners()
end

function ScriptObject:registerListeners() 
	-- register to all mouse and touch events
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)

	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
	self:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
	self:addEventListener(Event.TOUCHES_CANCEL, self.onTouchesCancel, self)
end

function ScriptObject:unregisterListeners()
	-- unregister all mouse and touch event listeners
	self:removeEventListener(Event.MOUSE_DOWN, self.onMouseDown)
	self:removeEventListener(Event.MOUSE_MOVE, self.onMouseMove)
	self:removeEventListener(Event.MOUSE_UP, self.onMouseUp)
	
	self:removeEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin)
	self:removeEventListener(Event.TOUCHES_MOVE, self.onTouchesMove)
	self:removeEventListener(Event.TOUCHES_END, self.onTouchesEnd)
	self:removeEventListener(Event.TOUCHES_CANCEL, self.onTouchesCancel)
end

function ScriptObject:makeHitArea(width, height, x, y)
	local shape = Shape.new()
	shape:setFillStyle(Shape.SOLID, 0xff0000, 1)
	shape:beginPath()
	shape:moveTo(0,0)
	
	shape:lineTo(width, 0)
	shape:lineTo(width, height)
	shape:lineTo(0, height)
	shape:lineTo(0, 0)
	shape:endPath()
	shape:setVisible(false)
	shape:setPosition(x, y)
	return shape
end

function ScriptObject:onMouseDown(event)
	print("onMouseDown not implemented")
end

function ScriptObject:onMouseMove(event)
	print("onMouseMove not implemented")
end

function ScriptObject:onMouseUp(event)
	print("onMouseUp not implemented")
end

-- if button is on focus, stop propagation of touch events
function ScriptObject:onTouchesBegin(event)
end

-- if button is on focus, stop propagation of touch events
function ScriptObject:onTouchesMove(event)
end

-- if button is on focus, stop propagation of touch events
function ScriptObject:onTouchesEnd(event)
end

-- if touches are cancelled, reset the state of the button
function ScriptObject:onTouchesCancel(event)
end

DoubleScriptObject = Core.class(ScriptObject)
local doubleScriptButtonWidth = 67.5

function DoubleScriptObject:init(name, data1, data2)
	self.image = Bitmap.new(Texture.new("images/ScriptObject.png"))
	self:addChild(self.image)
	self.name = name
	self.dataSet1 = data1
	self.dataSet2 = data2
	self.d1Index = 1
	self.d2Index = 1
	self:setUpScriptButtons()
end

function DoubleScriptObject:setUpScriptButtons()
	self.dataSet1IncrementButton = self:makeHitArea(doubleScriptButtonWidth, scriptButtonHeight, 67.5, 25)
	self.dataSet1DecrementButton = self:makeHitArea(doubleScriptButtonWidth, scriptButtonHeight, 67.5, 50)
	self.dataSet2IncrementButton = self:makeHitArea(doubleScriptButtonWidth, scriptButtonHeight, 202.5, 25)
	self.dataSet2DecrementButton = self:makeHitArea(doubleScriptButtonWidth, scriptButtonHeight, 202.5, 50)
	self:addChild(self.dataSet1IncrementButton)
	self:addChild(self.dataSet1DecrementButton)
	self:addChild(self.dataSet2IncrementButton)
	self:addChild(self.dataSet2DecrementButton)
	self:setTextBoxes()
end

function DoubleScriptObject:setTextBoxes()
	if self.d1Text then
		self:removeChild(self.d1Text)
	end
	if self.d2Text then
		self:removeChild(self.d2Text)
	end
	local textBox1MiddleX = 33.75
	local textBox2MiddleX = 168.75
	local textBoxMiddleY = 50
	local d1Item = self.dataSet1[self.d1Index]
	local d2Item = self.dataSet2[self.d2Index]
	self.d1Text = TextField.new(font, d1Item)
	self.d2Text = TextField.new(font, d2Item)
	self.d1Text:setPosition(textBox1MiddleX - (self.d1Text:getWidth() / 2), textBoxMiddleY + (self.d1Text:getHeight() / 2))
	self.d2Text:setPosition(textBox2MiddleX - (self.d2Text:getWidth() / 2), textBoxMiddleY + (self.d2Text:getHeight() / 2))
	self:addChild(self.d1Text)
	self:addChild(self.d2Text)
end

function DoubleScriptObject:onMouseDown(event)
	if self.dataSet1IncrementButton:hitTestPoint(event.x, event.y) then
		self.focus = "I1"
		--self:updateVisualState(true)
		event:stopPropagation()
		--print(self.name)
	elseif self.dataSet1DecrementButton:hitTestPoint(event.x, event.y) then
		self.focus = "D1"
		--self:updateVisualState(true)
		event:stopPropagation()
		--print(self.name)
	elseif self.dataSet2IncrementButton:hitTestPoint(event.x, event.y) then
		self.focus = "I2"
		--self:updateVisualState(true)
		event:stopPropagation()
		--print(self.name)
	elseif self.dataSet2DecrementButton:hitTestPoint(event.x, event.y) then
		self.focus = "D2"
		--self:updateVisualState(true)
		event:stopPropagation()
		--print(self.name)
	end
end

function DoubleScriptObject:onMouseMove(event)
	if self.focus == "I1" then
		if not self.dataSet1IncrementButton:hitTestPoint(event.x, event.y) then	
			self.focus = false
			--self:updateVisualState(false)
			event:stopPropagation()
		end
	elseif self.focus == "D1" then
		if not self.dataSet1DecrementButton:hitTestPoint(event.x, event.y) then	
			self.focus = false
			--self:updateVisualState(false)
			event:stopPropagation()
		end
	elseif self.focus == "I2" then
		if not self.dataSet2IncrementButton:hitTestPoint(event.x, event.y) then	
			self.focus = false
			--self:updateVisualState(false)
			event:stopPropagation()
		end
	elseif self.focus == "D2" then
		if not self.dataSet2DecrementButton:hitTestPoint(event.x, event.y) then	
			self.focus = false
			--self:updateVisualState(false)
			event:stopPropagation()
		end
	end
end

function DoubleScriptObject:onMouseUp(event)
	if self.focus == "I1" then
		self.focus = false
		--self:updateVisualState(false)
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self:incrementDataset1()
	elseif self.focus == "D1" then
		self.focus = false
		--self:updateVisualState(false)
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self:decrementDataset1()
	elseif self.focus == "I2" then
		self.focus = false
		--self:updateVisualState(false)
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self:incrementDataset2()
	elseif self.focus == "D2" then
		self.focus = false
		--self:updateVisualState(false)
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self:decrementDataset2()
	end
end

function DoubleScriptObject:incrementDataset1()
	self.d1Index = (self.d1Index % table.getn(self.dataSet1)) + 1
	self:setTextBoxes()
end

function DoubleScriptObject:decrementDataset1()
	self.d1Index = self.d1Index - 1
	if self.d1Index == 0 then
		self.d1Index = table.getn(self.dataSet1)
	end
	self:setTextBoxes()
end

function DoubleScriptObject:incrementDataset2()
	self.d2Index = (self.d2Index % table.getn(self.dataSet2)) + 1
	self:setTextBoxes()
end

function DoubleScriptObject:decrementDataset2()
	self.d2Index = self.d2Index - 1
	if self.d2Index == 0 then
		self.d2Index = table.getn(self.dataSet2)
	end
	self:setTextBoxes()
end

function DoubleScriptObject:getData()
	
end







