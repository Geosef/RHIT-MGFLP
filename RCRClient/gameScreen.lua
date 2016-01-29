gameScreen = Core.class(BaseScreen)
local padding = 12
local scriptPadding = 10
local spritePadding = 3
local ScriptArea = Core.class(SceneObject)
local GameMod = Core.class(Game)

function ScriptArea:init(parent)
	-- width is based on ScriptObject.png width, height is assuming 4 ScriptObject.png plus padding
	self.parent = parent
	local blankBox = Bitmap.new(Texture.new("images/blank-box.png"))
	self:addChild(blankBox)
	self.script = {}
	self.visibleScript = {}
	self.scrollCount = 0
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

function ScriptArea:drawScript()
	self:removeScript()
	local location = 0
	for i = 1,4 do
		local v = self.script[self.scrollCount+i]
		if v == nil then
			break
		end
		self.visibleScript[i] = v
		v:setPosition(0, location + scriptPadding)
		self:addChild(v)
		location = v:getY() + v:getHeight()
	end
	self.parent:scrollCheck(true)
end

function ScriptArea:removeScript()
	for i=table.getn(self.visibleScript),1,-1 do
		local v = table.remove(self.visibleScript)
		self:removeChild(v)
	end
end

function ScriptArea:scrollUp()
	self.scrollCount = self.scrollCount - 1
	self:drawScript()
end

function ScriptArea:scrollDown()
	self.scrollCount = self.scrollCount + 1
	self:drawScript()
end

function ScriptArea:addCommand(name)
	local newCommand = DoubleScriptObject.new(self, name, {"N", "E", "S", "W"}, {1, 2, 3, 4})
	table.insert(self.script, newCommand)
	print(table.getn(self.script))
	if table.getn(self.script) >= 4 then
		self.scrollCount = table.getn(self.script) - 4
	end
	self:drawScript()
end

function ScriptArea:removeCommand(command)
	local index = inTable(self.script, command)
	if index then
		removedCommand = table.remove(self.script, index)
		if self.scrollCount > 0 then
			self.scrollCount = self.scrollCount - 1
		end
		self:drawScript()
	end
end

function ScriptArea:moveCommand(y)
	if self:contains(self.movementLine) then
		self:removeChild(self.movementLine)
	end
	local myX, myY = self.parent:localToGlobal(self:getX(), self:getY())
	local scrollUpY = myY - self.parent.scriptUpButton:getHeight()
	local scrollDownY = myY + self:getHeight() + self.parent.scriptDownButton:getHeight()
	if y < scrollUpY then
		if self.scrollCount > 0 then
			self.scrollCount = self.scrollCount - 1
		end
		self:drawScript()
		return nil
	elseif y > scrollDownY then
		if self.scrollCount < table.getn(self.script) - 4 then
			self.scrollCount = self.scrollCount + 1
		end
		self:drawScript()
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
	if y > (myY + self:getHeight()) then
		local bottomScript = self.visibleScript[table.getn(self.visibleScript)]
		self.movementLine:setPosition(0, bottomScript:getY() + bottomScript:getHeight() + (scriptPadding/2))
		self:addChild(self.movementLine)
		return table.getn(self.visibleScript) + 1
	end
end

function ScriptArea:replaceCommand(targetCommand, moveRegion)
	if self:contains(self.movementLine) then
		self:removeChild(self.movementLine)
	end
	--[[
		Need to fix the bug that happens when moving commands down
	]]
	local scriptIndex = inTable(self.script, targetCommand)
	local visibleIndex = inTable(self.visibleScript, targetCommand)
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
		table.insert(self.script, table.getn(self.visibleScript) + self.scrollCount, removedCommand)
		return
	end
	local removedCommand = table.remove(self.script, scriptIndex)
	print(visibleIndex)
	if visibleIndex > moveRegion then
		table.insert(self.script, self.scrollCount + moveRegion - 1, removedCommand)
	else
		table.insert(self.script, self.scrollCount + moveRegion, removedCommand)
	end
	
	self:drawScript()
end

local StatementBox = Core.class(SceneObject)

function StatementBox:init()
	self.headerBottom = 51
	self.boxImage = Bitmap.new(Texture.new("images/statement-box.png"))
	self:addChild(self.boxImage)
	self.resourceBox = Bitmap.new(Texture.new("images/resource-box.png"))
	self.resourceBox:setPosition((self:getWidth() / 2) - (self.resourceBox:getWidth() / 2), self.headerBottom + padding)
	self:addChild(self.resourceBox)
	self:initScript()
end

function StatementBox:initScript()
	local scriptUpButtonUp = Bitmap.new(Texture.new("images/script-up-button-up.png"))
	local scriptUpButtonDown = Bitmap.new(Texture.new("images/script-up-button-down.png"))
	self.scriptUpButton = CustomButton.new(scriptUpButtonUp, scriptUpButtonDown, function() 
		--self.scrollCount = self.scrollCount - 1
		self.scriptArea:scrollUp()
	end)
	self.scriptUpButton:setPosition((self:getWidth() / 2) - (self.scriptUpButton:getWidth() / 2), self.resourceBox:getY() + self.resourceBox:getHeight() + padding)
	self:addChild(self.scriptUpButton)
	self.scriptArea = ScriptArea.new(self)
	self.scriptArea:setPosition((self:getWidth() / 2) - (self.scriptArea:getWidth() / 2), self.scriptUpButton:getY() + self.scriptUpButton:getHeight())
	self:addChild(self.scriptArea)
	local scriptDownButtonUp = Bitmap.new(Texture.new("images/script-down-button-up.png"))
	local scriptDownButtonDown = Bitmap.new(Texture.new("images/script-down-button-down.png"))
	self.scriptDownButton = CustomButton.new(scriptDownButtonUp, scriptDownButtonDown, function() 
		--self.scrollCount = self.scrollCount + 1
		self.scriptArea:scrollDown()
		--self:scriptCountCheck(true) 
	end)
	-- This is calculated assuming 4 script objects of height 75 px
	local scriptDownHeight = self.scriptUpButton:getY() + self.scriptUpButton:getHeight() 
	self.scriptDownButton:setPosition((self:getWidth() / 2) - (self.scriptDownButton:getWidth() / 2), self.scriptArea:getY() + self.scriptArea:getHeight())
	self:addChild(self.scriptDownButton)
	self:scrollCheck()
	
end

function StatementBox:addCommand(name)
	self.scriptArea:addCommand(name)
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
		self.parentScreen.statementBox:addCommand(name)
		--self.parentScreen.statementBox:scriptCountCheck(false)
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
	self.sceneName = "Collect Game"
	self.statementBox = StatementBox.new()
	self.statementBox:setPosition(gameBoard:getX() + gameBoard:getWidth() + padding, (WINDOW_HEIGHT - padding) - self.statementBox:getHeight())
	self:addChild(self.statementBox)
	self.commandBox = CommandBox.new(self)
	self.commandBox:setPosition(self.statementBox:getX() + self.statementBox:getWidth() + padding, (WINDOW_HEIGHT - padding) - self.commandBox:getHeight())
	self:addChild(self.commandBox)
	--self.GameMod = GameMod.CollectGame(self)
	--self.GameMod.gameSetup(self:getGameState("Collect"))
	--self.GameMod.show()
end
