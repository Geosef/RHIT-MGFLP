gameScreen = Core.class(BaseScreen)
local padding = 12
local scriptPadding = 10

local StatementBox = Core.class(SceneObject)

function StatementBox:init()
	self.headerBottom = 51
	self.boxImage = Bitmap.new(Texture.new("images/statement-box.png"))
	self:addChild(self.boxImage)
	self.resourceBox = Bitmap.new(Texture.new("images/resource-box.png"))
	self.resourceBox:setPosition((self:getWidth() / 2) - (self.resourceBox:getWidth() / 2), self.headerBottom + padding)
	self:addChild(self.resourceBox)
	self.script = {}
	self.scrollCount = 0
	self:initScriptControlButtons()
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

function StatementBox:scroll(scriptIndex)
	self:removeScript()
	self.s1 = self.script[self.scrollCount+1]
	self.s2 = self.script[self.scrollCount+2]
	self.s3 = self.script[self.scrollCount+3]
	self.s4 = self.script[self.scrollCount+4]
	self:drawScript()
end

function StatementBox:removeScript()
	if self.s1 then
		self:removeChild(self.s1)
	end
	if self.s2 then
		self:removeChild(self.s2)
	end
	if self.s3 then
		self:removeChild(self.s3)
	end
	if self.s4 then
		self:removeChild(self.s4)
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
	local newCommand = DoubleScriptObject.new(name, {"N", "E", "S", "W"}, {1, 2, 3, 4})
	table.insert(self.script, newCommand)
	print(table.getn(self.script))
	if not self.s1 then
		self.s1 = newCommand
	elseif not self.s2 then
		self.s2 = newCommand
	elseif not self.s3 then
		self.s3 = newCommand
	elseif not self.s4 then
		self.s4 = newCommand
	else
		return
	end
	self:drawScript()
	--print(name)
end

function StatementBox:drawScript()
	if self.s1 then
		self.s1:setPosition((self:getWidth() / 2) - (self.s1:getWidth() / 2), self.scriptUpButton:getY() + self.scriptUpButton:getHeight() + scriptPadding)
		self:addChild(self.s1)
	end
	if self.s2 then
		self.s2:setPosition((self:getWidth() / 2) - (self.s2:getWidth() / 2), self.s1:getY() + self.s1:getHeight() + scriptPadding)
		self:addChild(self.s2)
	end
	if self.s3 then
		self.s3:setPosition((self:getWidth() / 2) - (self.s3:getWidth() / 2), self.s2:getY() + self.s2:getHeight() + scriptPadding)
		self:addChild(self.s3)
	end
	if self.s4 then
		self.s4:setPosition((self:getWidth() / 2) - (self.s4:getWidth() / 2), self.s3:getY() + self.s3:getHeight() + scriptPadding)
		self:addChild(self.s4)
	end
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
	--local titleBackground = Bitmap.new(Texture.new("images/background.png"))
	--self:addChild(titleBackground)
	local gameBoard = Bitmap.new(Texture.new("images/8x8-board.png"))
	gameBoard:setPosition(padding, (WINDOW_HEIGHT - padding) - gameBoard:getHeight())
	self:addChild(gameBoard)
	-- Eventually sceneName will be set by the type of game
	self.sceneName = "Game X"
	self.statementBox = StatementBox.new()
	self.statementBox:setPosition(gameBoard:getX() + gameBoard:getWidth() + padding, (WINDOW_HEIGHT - padding) - self.statementBox:getHeight())
	self:addChild(self.statementBox)
	self.commandBox = CommandBox.new(self)
	self.commandBox:setPosition(self.statementBox:getX() + self.statementBox:getWidth() + padding, (WINDOW_HEIGHT - padding) - self.commandBox:getHeight())
	self:addChild(self.commandBox)
end
