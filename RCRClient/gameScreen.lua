gameScreen = Core.class(BaseScreen)
local padding = 12
local scriptPadding = 10
local spritePadding = 3

local StatementBox = Core.class(SceneObject)

function StatementBox:init()
	self.headerBottom = 51
	self.boxImage = Bitmap.new(Texture.new("images/statement-box.png"))
	self:addChild(self.boxImage)
	self.resourceBox = Bitmap.new(Texture.new("images/resource-box.png"))
	self.resourceBox:setPosition((self:getWidth() / 2) - (self.resourceBox:getWidth() / 2), self.headerBottom + padding)
	self:addChild(self.resourceBox)
	self.script = {}
	self.visibleScript = {}
	self.scrollCount = 0
	self:initScriptControlButtons()
	self.movementLine = Shape.new()
	self.movementLine:setFillStyle(Shape.SOLID, 0xff0000, 2)
	self.movementLine:beginPath()
	self.movementLine:moveTo(0,0)
	self.movementLine:lineTo(self:getWidth(), 0)
	self.movementLine:lineTo(self:getWidth(), 1)
	self.movementLine:lineTo(0, 1)
	self.movementLine:lineTo(0, 0)
	self.movementLine:endPath()
end

function StatementBox:initScriptControlButtons()
	local scriptUpButtonUp = Bitmap.new(Texture.new("images/script-up-button-up.png"))
	local scriptUpButtonDown = Bitmap.new(Texture.new("images/script-up-button-down.png"))
	self.scriptUpButton = CustomButton.new(scriptUpButtonUp, scriptUpButtonDown, function() 
		self.scrollCount = self.scrollCount - 1
		self:scriptCountCheck(true)
	end)
	self.scriptUpButton:setPosition((self:getWidth() / 2) - (self.scriptUpButton:getWidth() / 2), self.resourceBox:getY() + self.resourceBox:getHeight() + padding)
	self:addChild(self.scriptUpButton)
	local scriptDownButtonUp = Bitmap.new(Texture.new("images/script-down-button-up.png"))
	local scriptDownButtonDown = Bitmap.new(Texture.new("images/script-down-button-down.png"))
	self.scriptDownButton = CustomButton.new(scriptDownButtonUp, scriptDownButtonDown, function() 
		self.scrollCount = self.scrollCount + 1
		self:scriptCountCheck(true)
	end)
	-- This is calculated assuming 4 script objects of height 75 px
	local scriptDownHeight = self.scriptUpButton:getY() + self.scriptUpButton:getHeight() + scriptPadding + 4 * (scriptPadding + 75)
	self.scriptDownButton:setPosition((self:getWidth() / 2) - (self.scriptDownButton:getWidth() / 2), scriptDownHeight)
	self:addChild(self.scriptDownButton)
	self:scriptCountCheck()
end

function StatementBox:scroll()
	self:removeScript()
	for i, v in ipairs(self.visibleScript) do
		self.visibleScript[i] = self.script[self.scrollCount+i]
	end
	self:drawScript()
end

function StatementBox:removeScript()
	for i, v in ipairs(self.visibleScript) do
		self:removeChild(v)
	end
end

function StatementBox:scriptCountCheck(needScroll)
	local scriptCount = table.getn(self.script)
	if self.scrollCount > 0 then
		self.scriptUpButton:enable()
	else 
		self.scriptUpButton:disable()
	end
	local scriptLocation = scriptCount - self.scrollCount
	if scriptLocation > 4 then
		self.scriptDownButton:enable()
	elseif scriptLocation <= 4 then
		self.scriptDownButton:disable()
	end
	if needScroll then
		self:scroll()
	end
end

function StatementBox:addNewScript(name)
	local newCommand = DoubleScriptObject.new(self, name, {"N", "E", "S", "W"}, {1, 2, 3, 4})
	table.insert(self.script, newCommand)
	if table.getn(self.visibleScript) < 4 then
		table.insert(self.visibleScript, newCommand)
		self:drawScript()
	else
		self.scrollCount = table.getn(self.script) - 4
		self:scroll()
	end
	--print(name)
end

function StatementBox:drawScript()
	local containerLocation = self.scriptUpButton:getY() + self.scriptUpButton:getHeight()
	for i, v in ipairs(self.visibleScript) do
		v:setPosition((self:getWidth() / 2) - (v:getWidth() / 2), containerLocation + scriptPadding)
		self:addChild(v)
		containerLocation = v:getY() + v:getHeight()
	end
end

function StatementBox:redrawScript()
	self:removeScript()
	self:drawScript()
end

function StatementBox:removeCommand(command)
	local index = inTable(self.script, command)
	if index then
		removedCommand = table.remove(self.script, index)
		if self.scrollCount > 0 then
			self.scrollCount = self.scrollCount - 1
		end
		self:scriptCountCheck(true)
	end
end

function StatementBox:moveCommand(y)
	if self:contains(self.movementLine) then
		self:removeChild(self.movementLine)
	end
	local scriptUpX, scriptUpY = self:localToGlobal(self.scriptUpButton:getX(), self.scriptUpButton:getY())
	local scriptDownX, scriptDownY = self:localToGlobal(self.scriptDownButton:getX(), self.scriptDownButton:getY())
	local scriptButtonUpMiddle = scriptUpY + (self.scriptUpButton:getHeight()/2)
	local scriptButtonDownMiddle = scriptDownY + (self.scriptDownButton:getHeight()/2)
	if y < scriptButtonUpMiddle then
		if self.scrollCount > 0 then
			self.scrollCount = self.scrollCount - 1
		end
		self:scriptCountCheck(true)
		return nil
	elseif y > scriptButtonDownMiddle then
		if self.scrollCount < table.getn(self.script) - 4 then
			self.scrollCount = self.scrollCount + 1
		end
		self:scriptCountCheck(true)
		return nil
	end
	for i, v in ipairs(self.visibleScript) do
		local vX, vY = self:localToGlobal(v:getX(), v:getY())
		local vMiddle = vY + (v:getHeight()/2)
		if y < vMiddle then	
			self.movementLine:setPosition(0, v:getY() - (scriptPadding/2))
			self:addChild(self.movementLine)
			return i
		end
	end
	if y < scriptButtonDownMiddle then
		local bottomScript = self.visibleScript[table.getn(self.visibleScript)]
		self.movementLine:setPosition(0, bottomScript:getY() + bottomScript:getHeight() + (scriptPadding/2))
		self:addChild(self.movementLine)
		return table.getn(self.visibleScript) + 1
	end
end

function StatementBox:replaceCommand(targetCommand, moveRegion)
	if self:contains(self.movementLine) then
		self:removeChild(self.movementLine)
	end
	scriptIndex = inTable(self.script, targetCommand)
	if not moveRegion then
		return
	end
	if moveRegion == 1 then
		if self.visibleScript[moveRegion] == targetCommand then
			return
		end
	elseif moveRegion == 2 then
		if self.visibleScript[moveRegion] == targetCommand or self.visibleScript[moveRegion-1] == targetCommand then
			return
		end
	elseif moveRegion == 3 then
		if self.visibleScript[moveRegion] == targetCommand or self.visibleScript[moveRegion-1] == targetCommand then
			return
		end
	elseif moveRegion == 4 then
		if self.visibleScript[moveRegion] == targetCommand or self.visibleScript[moveRegion-1] == targetCommand then
			return
		end
	elseif moveRegion == 5 then
		if self.visibleScript[moveRegion-1] == targetCommand then
			return
		end
		local removedCommand = table.remove(self.script, scriptIndex)
		table.insert(self.script, removedCommand)
	end
	local removedCommand = table.remove(self.script, scriptIndex)
	table.insert(self.script, self.scrollCount + moveRegion, removedCommand)
	self:scroll()
end	

local ScriptArea = Core.class(SceneObject)

function ScriptArea:init()
	
end

local CommandBox = Core.class(SceneObject)

function CommandBox:init(parentScreen)
	self.headerBottom = 49
	self.parentScreen = parentScreen
	self.boxImage = Bitmap.new(Texture.new("images/command-box.png"))
	self:addChild(self.boxImage)
	-- eventually, this will query the game for the buttons to add
	self:initButtons()
end

function CommandBox:initButtons()
	local moveButtonUp = Bitmap.new(Texture.new("images/game-button.png"))
	local moveButtonDown = Bitmap.new(Texture.new("images/game-button-down.png"))
	local addButton = function(name)
		self.parentScreen.statementBox:addNewScript(name)
		self.parentScreen.statementBox:scriptCountCheck(false)
	end
	local moveButton = GameButton.new(moveButtonUp, moveButtonDown, addButton, "Move")
	moveButton:setPosition((self:getWidth() / 2) - (moveButton:getWidth() / 2), self.headerBottom + padding)
	self:addChild(moveButton)
end

function gameScreen:init()
	local gameBoard = Bitmap.new(Texture.new("images/8x8-board.png"))
	gameBoard:setScale(480/gameBoard:getWidth(), 480/gameBoard:getHeight())
	gameBoard:setPosition(padding, (WINDOW_HEIGHT - padding) - gameBoard:getHeight())
	self:addChild(gameBoard)
	
	-- Add sprite images
	local player1 = Bitmap.new(Texture.new("images/board-cat-icon.png"))
	player1:setScale(60/player1:getWidth(), 60/player1:getHeight())
	player1:setPosition(gameBoard:getX() + spritePadding, gameBoard:getY() + spritePadding)
	self:addChild(player1)
	
	local player2 = Bitmap.new(Texture.new("images/board-rat-icon.png"))
		player2:setScale(60/player2:getWidth(), 60/player2:getHeight())
	player2:setPosition(gameBoard:getX() + gameBoard:getWidth() - player2:getWidth() - spritePadding,
		gameBoard:getY() + gameBoard:getHeight() - player2:getHeight() - spritePadding)
	self:addChild(player2)
	
	-- Eventually sceneName will be set by the type of game
	self.sceneName = "Game X"
	self.statementBox = StatementBox.new()
	self.statementBox:setPosition(gameBoard:getX() + gameBoard:getWidth() + padding, (WINDOW_HEIGHT - padding) - self.statementBox:getHeight())
	self:addChild(self.statementBox)
	self.commandBox = CommandBox.new(self)
	self.commandBox:setPosition(self.statementBox:getX() + self.statementBox:getWidth() + padding, (WINDOW_HEIGHT - padding) - self.commandBox:getHeight())
	self:addChild(self.commandBox)
end
