gameScreen = Core.class(BaseScreen)
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

local StatementBox = Core.class(SceneObject)

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

function StatementBox:sendScript(timerAlert)
	local scriptPacket = {}
	scriptPacket.type = "Submit Move"
	scriptPacket.moves = {}
	local scriptToSend = {}
	if timerAlert then
		scriptToSend = self.savedScript
	else
		scriptToSend = self.scriptArea.script
	end
	for i=1,table.getn(scriptToSend),1 do
		local command = scriptToSend[i]
		local commandData = command:getData()
		table.insert(scriptPacket.moves, commandData)
	end	
	NET_ADAPTER:registerCallback('Run Events', function(data)
		if data.type == 'Run Events' then
			self.parent.gameboard:performNextTurn(data.moves)
			self.scriptArea:clearScript()
		else
			print('Could not send moves.')
		end
	end,
	SERVER_MOCKS['Run Events'](scriptPacket.moves))
	NET_ADAPTER:registerCallback('Update Locations', function(data)
		self.parent.gameboard:updateLocations()
	end)
	NET_ADAPTER:sendData(scriptPacket)
end


local CommandBox = Core.class(SceneObject)

function CommandBox:init(parent)
	self.headerBottom = 49
	self.parent = parent
	self.boxImage = Bitmap.new(Texture.new("images/command-box.png"))
	self:addChild(self.boxImage)
	-- eventually, this will query the game for the buttons to add
	self:initButtons()
end

function CommandBox:initButtons()
	local commandSet = COMMAND_FACTORY:getSubLibrary(self.parent.sceneName)
	self.commandTypes = {}
	for i,v in pairs(commandSet) do
		local gameButtonUp = Bitmap.new(Texture.new("images/game-button.png"))
		local gameButtonDown = Bitmap.new(Texture.new("images/game-button-down.png"))
		local addButton = function(name)
			self.parent.statementBox:addCommand(v(self.parent.statementBox.scriptArea))
			--self.parentScreen.statementBox:scriptCountCheck(false)
		end
		local gameButton = GameButton.new(gameButtonUp, gameButtonDown, addButton, i)
		table.insert(self.commandTypes, gameButton)
	end
	local numCommands = # self.commandTypes
	local buttonYPadding = self:calculateYPadding(numCommands)
	local yLoc = self.headerBottom + buttonYPadding
	for i,v in ipairs(self.commandTypes) do
		v:setPosition((self:getWidth() / 2) - (v:getWidth() / 2), yLoc)
		self:addChild(v)
		yLoc = yLoc + v:getHeight() + buttonYPadding
	end
end

function CommandBox:calculateYPadding(numCommands)
	local boxHeight = self:getHeight() - self.headerBottom
	local buttonYSpace = gameCommandButtonHeight * numCommands
	local yPadding = (boxHeight - buttonYSpace) / (numCommands + 1)
	return yPadding
end	


function gameScreen:init(gameInit)
	if not gameInit then gameInit = SERVER_MOCKS['Game Setup'] end
	self.host = gameInit.host
	self.gameboard = CollectGameboard.new(gameInit)
	self.gameboard:setPosition(padding, (WINDOW_HEIGHT - padding) - self.gameboard:getHeight())
	self:addChild(self.gameboard)
	-- Eventually sceneName will be set by the type of game
	self.sceneName = "Space Collectors"
	self.statementBox = StatementBox.new(self, self.gameboard.maxMoves)
	self.statementBox:setPosition(self.gameboard:getX() + self.gameboard:getWidth() + padding, (WINDOW_HEIGHT - padding) - (gameActionButtonHeight + padding) - self.statementBox:getHeight())
	self:addChild(self.statementBox)
	self.commandBox = CommandBox.new(self)
	self.commandBox:setPosition(self.statementBox:getX() + self.statementBox:getWidth() + padding, self.statementBox:getY())
	self:addChild(self.commandBox)
	-- Player names will be passed into gameInit
	local playerObjects = {
		{
			name = "User 1",
			level = 1
		}, 
		{
			name = "User 2",
			level = 1
		}
	}
	self:addPlayerInfo(playerObjects)
	local saveButtonUp = Bitmap.new(Texture.new("images/save-button-up.png"))
	local saveButtonDown = Bitmap.new(Texture.new("images/save-button-down.png"))
	self.saveButton = CustomButton.new(saveButtonUp, saveButtonDown, function()
		self.statementBox:saveScript()
	end)
	local submitButtonUp = Bitmap.new(Texture.new("images/script-submit-buttom-up.png"))
	local submitButtonDown = Bitmap.new(Texture.new("images/script-submit-button-down.png"))
	self.submitButton = CustomButton.new(submitButtonUp, submitButtonDown, function()
		self.statementBox:sendScript(false)
	end)
	local helpButtonUp = Bitmap.new(Texture.new("images/help-button-up.png"))
	local helpButtonDown = Bitmap.new(Texture.new("images/help-button-down.png"))
	self.helpButton = CustomButton.new(helpButtonUp, helpButtonDown, function()
		
	end)
	
	self.saveButton:setPosition(self.statementBox:getX(), self.statementBox:getY() + self.statementBox:getHeight() + padding)
	self:addChild(self.saveButton)
	self.submitButton:setPosition(self.saveButton:getX() + self.saveButton:getWidth() + padding, self.saveButton:getY())
	self:addChild(self.submitButton)
	self.helpButton:setPosition(self.commandBox:getX(), self.saveButton:getY())
	self:addChild(self.helpButton)
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function gameScreen:addPlayerInfo(playerObjects)
	-- Locations were calculated based on aesthetic positioning within the info image.
	local player1 = self.gameboard.player1
	local player2 = self.gameboard.player2
	local infoFont = TTFont.new("fonts/arial-rounded.ttf", 40)
	local levelFont = TTFont.new("fonts/arial-rounded.ttf", 30)
	
	local playerImagePaths = self.gameboard:getPlayerImagePaths()
	local p1Image = Bitmap.new(Texture.new(playerImagePaths[1]))
	local p2Image = Bitmap.new(Texture.new(playerImagePaths[2]))
	p1Image:setScale(160/p1Image:getWidth(),160/p1Image:getHeight())
	p2Image:setScale(160/p2Image:getWidth(),160/p2Image:getHeight())
	p1Image:setPosition(100.53 - (p1Image:getWidth() / 2), 150 - (p1Image:getHeight() / 2))
	p2Image:setPosition(319.47 - (p2Image:getWidth() / 2), 150 - (p2Image:getHeight() / 2))
	
	local p1NameText = TextField.new(infoFont, playerObjects[1].name)
	local p2NameText = TextField.new(infoFont, playerObjects[2].name)	
	p1NameText:setPosition(301.59 - (p1NameText:getWidth() / 2), 122.22 + (p1NameText:getHeight() / 2))
	p2NameText:setPosition(51.94, 122.22 +(p1NameText:getHeight() / 2))
	
	local p1LevelText = TextField.new(levelFont, playerObjects[1].level)
	local p2LevelText = TextField.new(levelFont, playerObjects[2].level)
	p1LevelText:setPosition(392.97 - (p1LevelText:getWidth() / 2), 122.22 + (p1LevelText:getHeight() / 2))
	p2LevelText:setPosition(25.97 - (p2LevelText:getWidth() / 2), 122.22 + (p2LevelText:getHeight() / 2))
	
	local p1scoreField = TextField.new(infoFont, "Score: " .. player1.score)
	local p2scoreField = TextField.new(infoFont, "Score: " .. player2.score)
	p1scoreField:setPosition(301.59 - (p1scoreField:getWidth() / 2), 177.78 + (p1scoreField:getHeight() / 2))
	p2scoreField:setPosition(122.88 - (p2scoreField:getWidth() / 2), 177.78 + (p2scoreField:getHeight() / 2))	
	player1.scoreField = p1scoreField
	player2.scoreField = p2scoreField
		
	local infoImage1 = Bitmap.new(Texture.new("images/p1-character-info.png"))
	local infoImage2 = Bitmap.new(Texture.new("images/p2-character-info.png"))
	
	infoImage1:addChild(p1Image)
	infoImage2:addChild(p2Image)
	infoImage1:addChild(p1NameText)
	infoImage2:addChild(p2NameText)
	infoImage1:addChild(p1LevelText)
	infoImage2:addChild(p2LevelText)	
	infoImage1:addChild(p1scoreField)
	infoImage2:addChild(p2scoreField)
	
	infoImage1:setScale(0.5, 0.5)
	infoImage2:setScale(0.5, 0.5)
	
	infoImage1:setPosition(padding, self.statementBox:getY())
	infoImage2:setPosition(infoImage1:getX() + infoImage1:getWidth() + 60, infoImage1:getY())
	
	self:addChild(infoImage1)
	self:addChild(infoImage2)
end

function gameScreen:onEnterEnd()
	
end

function gameScreen:onExitBegin()
	self:removeEventListener("enterEnd", self.onEnterEnd)
	self:removeEventListener("exitBegin", self.onExitBegin)
end
