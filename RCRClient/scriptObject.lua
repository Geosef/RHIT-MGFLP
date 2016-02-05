ScriptObject = Core.class(SceneObject)
local font = TTFont.new("fonts/arial-rounded.ttf", 20)
local scriptButtonHeight = 25

function ScriptObject:init(parent, name)
	self.parent = parent
	self.name = name
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

ZeroScriptObject = Core.class(ScriptObject)

function ZeroScriptObject:init(parent, name)
	self.image = Bitmap.new(Texture.new("images/ZeroScriptObject.png"))
	self:addChild(self.image)
	self:setUpScriptButtons()
end

function ZeroScriptObject:setUpScriptButtons()
	self.removeButton = self:makeHitArea(25, 25, 0, 0)
	self.moveButton = self:makeHitArea(25, 25, 245, 0)
	self:addChild(self.removeButton)
	self:addChild(self.moveButton)
end

function ZeroScriptObject:onMouseDown(event)
	if self.removeButton:hitTestPoint(event.x, event.y) then
		self.focus = "R"
		event:stopPropagation()
	elseif self.moveButton:hitTestPoint(event.x, event.y) then
		self.focus = "M"
		event:stopPropagation()
	end
end

function ZeroScriptObject:onMouseMove(event)
	if self.focus == "R" then
		if not self.removeButton:hitTestPoint(event.x, event.y) then	
			self.focus = false
			event:stopPropagation()
		end
	elseif self.focus == "M" then
		if not self:hitTestPoint(event.x, event.y) then	
			event:stopPropagation()
			self.moveLocation = self.parent:moveCommand(self, event.y)
		end
	end
end

function ZeroScriptObject:onMouseUp(event)
	if self.focus == "R" then
		self.focus = false
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self.parent:removeCommand(self)
	elseif self.focus == "M" then
		self.focus = false
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self.parent:replaceCommand(self, self.moveLocation)
	end
end

function ZeroScriptObject:getData()
	local commandData = {}
	commandData.name = self.name
	return commandData
end

SingleScriptObject = Core.class(ScriptObject)
local singleScriptButtonWidth = 135

function SingleScriptObject:init(parent, name, data)
	self.image = Bitmap.new(Texture.new("images/SingleScriptObject.png"))
	self:addChild(self.image)
	self.dataSet = data
	self.dIndex = 1
	self:setUpScriptButtons()
end

function SingleScriptObject:setUpScriptButtons()
	self.dataSetIncrementButton = self:makeHitArea(singleScriptButtonWidth, scriptButtonHeight, 135, 25)
	self.dataSetDecrementButton = self:makeHitArea(singleScriptButtonWidth, scriptButtonHeight, 135, 50)
	self.removeButton = self:makeHitArea(25, 25, 0, 0)
	self.moveButton = self:makeHitArea(25, 25, 245, 0)
	self:addChild(self.dataSetIncrementButton)
	self:addChild(self.dataSetDecrementButton)
	self:addChild(self.removeButton)
	self:addChild(self.moveButton)
	self:setTextBox()
end

function SingleScriptObject:setTextBox()
	if self.dText then
		self:removeChild(self.dText)
	end
	local textBoxMiddleX = 67.5
	local textBoxMiddleY = 50
	local dItem = self.dataSet[self.dIndex]
	self.dText = TextField.new(font, dItem)
	self.dText:setPosition(textBoxMiddleX - (self.dText:getWidth() / 2), textBoxMiddleY + (self.dText:getHeight() / 2))
	self:addChild(self.dText)
end

function SingleScriptObject:onMouseDown(event)
	if self.dataSetIncrementButton:hitTestPoint(event.x, event.y) then
		self.focus = "I"
		event:stopPropagation()
	elseif self.dataSetDecrementButton:hitTestPoint(event.x, event.y) then
		self.focus = "D"
		event:stopPropagation()
	elseif self.removeButton:hitTestPoint(event.x, event.y) then
		self.focus = "R"
		event:stopPropagation()
	elseif self.moveButton:hitTestPoint(event.x, event.y) then
		self.focus = "M"
		event:stopPropagation()
	end
end

function SingleScriptObject:onMouseMove(event)
	if self.focus == "I" then
		if not self.dataSetIncrementButton:hitTestPoint(event.x, event.y) then	
			self.focus = false
			event:stopPropagation()
		end
	elseif self.focus == "D" then
		if not self.dataSetDecrementButton:hitTestPoint(event.x, event.y) then	
			self.focus = false
			event:stopPropagation()
		end
	elseif self.focus == "R" then
		if not self.removeButton:hitTestPoint(event.x, event.y) then	
			self.focus = false
			event:stopPropagation()
		end
	elseif self.focus == "M" then
		if not self:hitTestPoint(event.x, event.y) then	
			event:stopPropagation()
			self.moveLocation = self.parent:moveCommand(self, event.y)
		end
	end
end

function SingleScriptObject:onMouseUp(event)
	if self.focus == "I" then
		self.focus = false
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self:incrementDataset()
	elseif self.focus == "D" then
		self.focus = false
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self:decrementDataset()
	elseif self.focus == "R" then
		self.focus = false
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self.parent:removeCommand(self)
	elseif self.focus == "M" then
		self.focus = false
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self.parent:replaceCommand(self, self.moveLocation)
	end
end

function SingleScriptObject:incrementDataset()
	self.dIndex = (self.dIndex % table.getn(self.dataSet)) + 1
	self:setTextBox()
end

function SingleScriptObject:decrementDataset()
	self.dIndex = self.dIndex - 1
	if self.dIndex == 0 then
		self.dIndex = table.getn(self.dataSet)
	end
	self:setTextBox()
end

function SingleScriptObject:getData()
	local commandData = {}
	commandData.name = self.name
	commandData.params.param1 = self.dataSet[self.dIndex]
	return commandData
end

DoubleScriptObject = Core.class(ScriptObject)
local doubleScriptButtonWidth = 67.5

function DoubleScriptObject:init(parent, name, data1, data2)
	self.image = Bitmap.new(Texture.new("images/ScriptObject.png"))
	self:addChild(self.image)
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
	self.removeButton = self:makeHitArea(25, 25, 0, 0)
	self.moveButton = self:makeHitArea(25, 25, 245, 0)
	self:addChild(self.dataSet1IncrementButton)
	self:addChild(self.dataSet1DecrementButton)
	self:addChild(self.dataSet2IncrementButton)
	self:addChild(self.dataSet2DecrementButton)
	self:addChild(self.removeButton)
	self:addChild(self.moveButton)
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
		event:stopPropagation()
	elseif self.dataSet1DecrementButton:hitTestPoint(event.x, event.y) then
		self.focus = "D1"
		event:stopPropagation()
	elseif self.dataSet2IncrementButton:hitTestPoint(event.x, event.y) then
		self.focus = "I2"
		event:stopPropagation()
	elseif self.dataSet2DecrementButton:hitTestPoint(event.x, event.y) then
		self.focus = "D2"
		event:stopPropagation()
	elseif self.removeButton:hitTestPoint(event.x, event.y) then
		self.focus = "R"
		event:stopPropagation()
	elseif self.moveButton:hitTestPoint(event.x, event.y) then
		self.focus = "M"
		event:stopPropagation()
	end
end

function DoubleScriptObject:onMouseMove(event)
	if self.focus == "I1" then
		if not self.dataSet1IncrementButton:hitTestPoint(event.x, event.y) then	
			self.focus = false
			event:stopPropagation()
		end
	elseif self.focus == "D1" then
		if not self.dataSet1DecrementButton:hitTestPoint(event.x, event.y) then	
			self.focus = false
			event:stopPropagation()
		end
	elseif self.focus == "I2" then
		if not self.dataSet2IncrementButton:hitTestPoint(event.x, event.y) then	
			self.focus = false
			event:stopPropagation()
		end
	elseif self.focus == "D2" then
		if not self.dataSet2DecrementButton:hitTestPoint(event.x, event.y) then	
			self.focus = false
			event:stopPropagation()
		end
	elseif self.focus == "R" then
		if not self.removeButton:hitTestPoint(event.x, event.y) then	
			self.focus = false
			event:stopPropagation()
		end
	elseif self.focus == "M" then
		if not self:hitTestPoint(event.x, event.y) then	
			event:stopPropagation()
			self.moveLocation = self.parent:moveCommand(self, event.y)
		end
	end
end

function DoubleScriptObject:onMouseUp(event)
	if self.focus == "I1" then
		self.focus = false
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self:incrementDataset1()
	elseif self.focus == "D1" then
		self.focus = false
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self:decrementDataset1()
	elseif self.focus == "I2" then
		self.focus = false
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self:incrementDataset2()
	elseif self.focus == "D2" then
		self.focus = false
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self:decrementDataset2()
	elseif self.focus == "R" then
		self.focus = false
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self.parent:removeCommand(self)
	elseif self.focus == "M" then
		self.focus = false
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self.parent:replaceCommand(self, self.moveLocation)
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
	local commandData = {}
	commandData.name = self.name
	commandData.params.param1 = self.dataSet1[self.d1Index]
	commandData.params.param2 = self.dataSet2[self.d2Index]
	return commandData
end

