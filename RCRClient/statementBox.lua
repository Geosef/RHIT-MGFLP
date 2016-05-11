local padding = 12
local scriptPadding = 10
local spritePadding = 3
local gameActionButtonHeight = 50
local gameCommandButtonHeight = 65
local scoreFont = TTFont.new("fonts/arial-rounded.ttf", 15)
local ScriptArea = Core.class(SceneObject)

function ScriptArea:init(parent, maxMoves)
	-- width is based on ScriptObject.png width, height is assuming 4 ScriptObject.png plus padding
	self.parent = parent
	local blankBox = Bitmap.new(Texture.new("images/blank-box.png"))
	self:addChild(blankBox)
	self.script = {}
	self.visibleScript = {}
	self.scrollCount = 0
	self.maxMoves = maxMoves
	self.movementLine = Shape.new()
	self.movementLine:setFillStyle(Shape.SOLID, 0xff0000, 2)
	self.movementLine:beginPath()
	self.movementLine:moveTo(0,0)
	self.movementLine:lineTo(self:getWidth(), 0)
	self.movementLine:lineTo(self:getWidth(), 1)
	self.movementLine:lineTo(0, 1)
	self.movementLine:lineTo(0, 0)
	self.movementLine:endPath()
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function ScriptArea:onEnterEnd()
	
end

function ScriptArea:onExitBegin()
	self:removeEventListener("enterEnd", self.onEnterEnd)
	self:removeEventListener("exitBegin", self.onExitBegin)
end

function ScriptArea:drawScript()
	self:removeScript()
	self:setCommandSizes()
	local location = 0
	for i = 1,4 do
		local v = self.script[self.scrollCount+i]
		if v == nil then
			break
		end
		self.visibleScript[i] = v
		v:setPosition(v:getX(), location + scriptPadding)
		self:addChild(v)
		location = v:getY() + v:getHeight()
	end
	self.parent:scrollCheck(true)
end

function ScriptArea:setCommandSizes()
	local loopCounter = 0
	for i=1,table.getn(self.script) do
		local command = self.script[i]
		if command.name == "Loop End" then
			loopCounter = loopCounter - 1
		end
		if loopCounter > 0 then
			command:setScale(math.pow(0.90, loopCounter), 1)
			command:setPosition(self:getWidth() / 2 - command:getWidth() / 2, command:getY())
		else
			command:setScale(1, 1)
			command:setPosition(0, command:getY())
		end
		if command.name == "Loop" then
			loopCounter = loopCounter + 1
		end
	end
end

-- This only clears the visible script
function ScriptArea:removeScript()
	for i=table.getn(self.visibleScript),1,-1 do
		local v = table.remove(self.visibleScript)
		self:removeChild(v)
	end
end

--[[
	This function clears the script from internal data and visible script
]]
function ScriptArea:clearScript()
	self:removeScript()
	clearArray(self.script)
	self.scrollCount = 0
end

function ScriptArea:scroll(doDraw, scrollDist)
	self.scrollCount = self.scrollCount + scrollDist
	if self.scrollCount < 0 then
		self.scrollCount = 0
	elseif self.scrollCount > table.getn(self.script) - 4 then
		self.scrollCount = table.getn(self.script) - 4
	end
	if doDraw then
		self:drawScript()
	end
end

function ScriptArea:scrollTo(doDraw, scrollTarget)
	self.scrollCount = scrollTarget
	if self.scrollCount < 0 then
		self.scrollCount = 0
	elseif self.scrollCount > table.getn(self.script) - 4 then
		self.scrollCount = table.getn(self.script) - 4
	end
	if doDraw then
		self:drawScript()
	end
end

function ScriptArea:addCommand(command)
	local scriptSize = table.getn(self.script)
	if scriptSize >= self.maxMoves then
		print("Can't add anymore commands!")
		return
	end
	table.insert(self.script, command)
	if scriptSize >= 4 then
		self:scrollTo(true, (table.getn(self.script) - 4))
		return
	end
	self:drawScript()
end

function ScriptArea:removeCommand(command)
	local index = inTable(self.script, command)
	local numRemoved = 0
	if index then
		removedCommand = table.remove(self.script, index)
		numRemoved = numRemoved + 1
		if removedCommand.name == "Loop" then
			while index < (table.getn(self.script) + 1) do
				if self.script[index].name == "Loop End" then
					table.remove(self.script, index)
					numRemoved = numRemoved + 1
					break
				end
				index = index + 1
			end
		elseif removedCommand.name == "Loop End" then
			while index > 1 do
				index = index - 1
				if self.script[index].name == "Loop" then
					table.remove(self.script, index)
					numRemoved = numRemoved + 1
					break
				end
			end
		end
		if self.scrollCount > 0 then
			self:scroll(true, -numRemoved)
		else 
			self:drawScript()
		end
	end
end

function ScriptArea:moveCommand(toMove, y)
	if self:contains(self.movementLine) then
		self:removeChild(self.movementLine)
	end
	local myX, myY = self.parent:localToGlobal(self:getX(), self:getY())
	local scrollUpY = myY - self.parent.scriptUpButton:getHeight()
	local scrollDownY = myY + self:getHeight() + self.parent.scriptDownButton:getHeight()
	if y < scrollUpY then
		if self.scrollCount > 0 then
			self:scroll(true, -1)
		end
		self:drawScript()
		return nil
	elseif y > scrollDownY then
		if self.scrollCount < table.getn(self.script) - 4 then
			self:scroll(true, 1)
		end
		self:drawScript()
		return nil
	end
	local location = myY
	for i, v in ipairs(self.visibleScript) do
		local vX, vY = self:localToGlobal(v:getX(), v:getY())
		local vMiddle = vY + (v:getHeight()/2)
		location = vY + v:getHeight()
		if y < location then
			self.movementLine:setPosition(0, v:getY())
			self:addChild(self.movementLine)
			return i
		end
	end
	if y > location then
		local bottomScript = self.visibleScript[table.getn(self.visibleScript)]
		self.movementLine:setPosition(0, bottomScript:getY() + bottomScript:getHeight() + (scriptPadding/2))
		self:addChild(self.movementLine)
		return table.getn(self.visibleScript) + 1
	end
end

function ScriptArea:replaceCommand(toMove, moveRegion)
	if self:contains(self.movementLine) then
		self:removeChild(self.movementLine)
	end
	local newState = self:copyScript()
	local visibleIndex = inTable(self.visibleScript, toMove)
	local removedIndex = self.scrollCount + visibleIndex
	local removedCommand = table.remove(newState, removedIndex)
	local targetIndex = removedIndex
	if moveRegion == nil then
		-- Mouse is released above arrow keys
		return
	end
	local currentNumCommands = table.getn(newState)
	if moveRegion > table.getn(self.visibleScript) then
		-- If want to move below all visible commands
		if moveRegion > currentNumCommands then
			targetIndex = currentNumCommands + 1
		else
			targetIndex = self.scrollCount + (moveRegion - 1)
		end
	else
		targetIndex = self.scrollCount + moveRegion
	end
	table.insert(newState, targetIndex, removedCommand)
	if targetIndex == removedIndex or not self:ruleCheck(newState, targetIndex) then
		-- Command doesn't need to move
		return
	end
	self.script = newState
	self:drawScript()
end

function ScriptArea:ruleCheck(newState, targetIndex)
	return self:loopCheck(newState)
end

function ScriptArea:loopCheck(newState)
	local loopCounter = 0
	for i=1,table.getn(newState),1 do
		local command = newState[i]
		if command.name == "Loop" then
			loopCounter = loopCounter + 1
		elseif command.name == "Loop End" then
			loopCounter = loopCounter - 1
		end
		if loopCounter < 0 or loopCounter > 2 then
			return false
		end
	end
	return (loopCounter == 0)
end

function ScriptArea:copyScript()
	local scriptCopy = {}
	for i=1,table.getn(self.script),1 do
		scriptCopy[i] = self.script[i]
	end
	return scriptCopy
end

local ResourceBox = Core.class(SceneObject)

function ResourceBox:init(parent)
	self.parent = parent
	self.boxImage = Bitmap.new(Texture.new("images/resource-box.png"))
	self:addChild(self.boxImage)
	self.resources = {1,2,3,4}
end

function ResourceBox:getResources()
	return self.resources
end

StatementBox = Core.class(SceneObject)

function StatementBox:init(parent, maxMoves)
	self.parent = parent
	self.headerBottom = 51
	self.boxImage = Bitmap.new(Texture.new("images/statement-box.png"))
	self:addChild(self.boxImage)
	self.resourceBox = ResourceBox.new(self)
	self.resourceBox:setPosition((self:getWidth() / 2) - (self.resourceBox:getWidth() / 2), self.headerBottom + padding)
	self:addChild(self.resourceBox)
	self:initScript(maxMoves)
	self.savedScript = nil
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function StatementBox:onEnterEnd()

end

function StatementBox:onExitBegin()
	self:removeEventListener("enterEnd", self.onEnterEnd)
	self:removeEventListener("exitBegin", self.onExitBegin)
end

function StatementBox:initScript(maxMoves)
	local scriptUpButtonUp = Bitmap.new(Texture.new("images/script-up-button-up.png"))
	local scriptUpButtonDown = Bitmap.new(Texture.new("images/script-up-button-down.png"))
	self.scriptUpButton = CustomButton.new(scriptUpButtonUp, scriptUpButtonDown, function() 
		--self.scrollCount = self.scrollCount - 1
		self.scriptArea:scroll(true, -1)
	end)
	self.scriptUpButton:setPosition((self:getWidth() / 2) - (self.scriptUpButton:getWidth() / 2), self.resourceBox:getY() + self.resourceBox:getHeight() + padding)
	self:addChild(self.scriptUpButton)
	self.scriptArea = ScriptArea.new(self, maxMoves)
	self.scriptArea:setPosition((self:getWidth() / 2) - (self.scriptArea:getWidth() / 2), self.scriptUpButton:getY() + self.scriptUpButton:getHeight())
	self:addChild(self.scriptArea)
	local scriptDownButtonUp = Bitmap.new(Texture.new("images/script-down-button-up.png"))
	local scriptDownButtonDown = Bitmap.new(Texture.new("images/script-down-button-down.png"))
	self.scriptDownButton = CustomButton.new(scriptDownButtonUp, scriptDownButtonDown, function() 
		--self.scrollCount = self.scrollCount + 1
		self.scriptArea:scroll(true, 1)
	end)
	-- This is calculated assuming 4 script objects of height 75 px
	local scriptDownHeight = self.scriptUpButton:getY() + self.scriptUpButton:getHeight() 
	self.scriptDownButton:setPosition((self:getWidth() / 2) - (self.scriptDownButton:getWidth() / 2), self.scriptArea:getY() + self.scriptArea:getHeight())
	self:addChild(self.scriptDownButton)
	self:scrollCheck()
	
end

function StatementBox:addCommand(commandList)
	for i,v in ipairs(commandList) do
		self.scriptArea:addCommand(v)
	end
end

function StatementBox:scrollCheck()
	if self.scriptArea.scrollCount > 0 then
		self.scriptUpButton:enable()
	else 
		self.scriptUpButton:disable()
	end
	local scriptLocation = table.getn(self.scriptArea.script) - self.scriptArea.scrollCount
	if scriptLocation > 4 then
		self.scriptDownButton:enable()
	elseif scriptLocation <= 4 then
		self.scriptDownButton:disable()
	end
end

function StatementBox:saveScript()
	self.savedScript = self.scriptArea:copyScript()
end

function StatementBox:expandAllPlayers(moves)
	local t = {}
    for k,v in pairs(moves) do
        local expanded = self:expandLoops(v)
		t[k] = expanded
    end
    return t
end

function StatementBox:growAndAddArray(dest, arr, iterations)
	local i
	local j
	for i=1, iterations do
		for j=1, #arr do
			local elem = arr[j]
			if elem.name == 'Move' and elem.params[2] > 1 then
				self:growAndAddMove(dest, elem)
			else
				table.insert(dest, elem)
			end
		end
	end
end

function StatementBox:growAndAddMove(dest, item)
	if item.name == 'Move' and item.params[2] > 1 then
		local iters = item.params[2]
		item.params[2] = 1
		for k=1, iters do
			table.insert(dest, item)
		end
		--table.insert(dest, item)
	end
end

function StatementBox:expandLoops(script)
	local result = {}
	local dataStack = {}
	local iterationsStack = {}
	local currentLevel = 0
	local i
	for i=1, table.getn(script) do
		local elem = script[i]
		if elem.name == 'Loop' then
			currentLevel = currentLevel + 1
			table.insert(dataStack, {})
			table.insert(iterationsStack, elem.params[1])
		elseif elem.name == 'Loop End' then
			if currentLevel > 0 then
				currentLevel = currentLevel - 1
				local dest
				if currentLevel == 0 then
					dest = result
				else
					dest = dataStack[currentLevel]
				end
				self:growAndAddArray(dest, table.remove(dataStack), table.remove(iterationsStack))
			else
				print('Error, loop end found but no loop start')
			end			
		else
			if currentLevel == 0 then
				if elem.name == 'Move' and elem.params[2] > 1 then
					self:growAndAddMove(result, elem)
				else
					table.insert(result, elem)
				end
			else
				if elem.name == 'Move' and elem.params[2] > 1 then
					self:growAndAddMove(dataStack[currentLevel], elem)
				else
					table.insert(dataStack[currentLevel], elem)
				end
			end
		end
	end
	return result
end

function map(tbl, f)
    local t = {}
    for k,v in pairs(tbl) do
        t[k] = f(v)
    end
    return t
end

function StatementBox:sendScript(timerAlert)
	local scriptPacket = {}
	scriptPacket.type = "Submit Move"
	scriptPacket.moves = {}
	local sourceScript = {}
	if timerAlert then
		sourceScript = self.savedScript
	else
		sourceScript = self.scriptArea.script
	end
	
	local scriptToSend = map(sourceScript, function(elem) return elem:getData() end)
	--scriptToSend = self:expandLoops(scriptToSend)
	
	--[[for i=1,table.getn(scriptToSend),1 do
		local command = scriptToSend[i]
		local commandData = command:getData()
		table.insert(scriptPacket.moves, commandData)
	end	]]
	scriptPacket.moves = scriptToSend
	
	print_r(scriptPacket.moves)
	NET_ADAPTER:registerCallback('Run Events', function(data)
		if data.type == 'Run Events' then
			print('here56')
			print_r(data.moves)
			local moves = self:expandAllPlayers(data.moves)
			self.parent.gameboard:performNextTurn(moves)
			self.scriptArea:clearScript()
		else
			print('Could not send moves.')
		end
	end,
	SERVER_MOCKS['Run Events'](scriptPacket.moves))
	NET_ADAPTER:registerCallback('Update Locations', function(data)
		self.parent.gameboard:updateLocations(data.locations)
	end)
	NET_ADAPTER:sendData(scriptPacket)
end

