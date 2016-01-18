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
		self:scriptCountCheck()
	end)
	self.scriptUpButton:setPosition((self:getWidth() / 2) - (self.scriptUpButton:getWidth() / 2), self.resourceBox:getY() + self.resourceBox:getHeight() + padding)
	self:addChild(self.scriptUpButton)
	local scriptDownButtonUp = Bitmap.new(Texture.new("images/script-down-button-up.png"))
	local scriptDownButtonDown = Bitmap.new(Texture.new("images/script-down-button-down.png"))
	self.scriptDownButton = CustomButton.new(scriptDownButtonUp, scriptDownButtonDown, function() 
		self.scrollCount = self.scrollCount + 1
		self:scriptCountCheck()
	end)
	-- This is calculated assuming 4 script objects of height 75 px
	local scriptDownHeight = self.scriptUpButton:getY() + self.scriptUpButton:getHeight() + scriptPadding + 4 * (scriptPadding + 75)
	self.scriptDownButton:setPosition((self:getWidth() / 2) - (self.scriptDownButton:getWidth() / 2), scriptDownHeight)
	self:addChild(self.scriptDownButton)
	self:scriptCountCheck()
end

function StatementBox:scriptCountCheck()
	if self.scrollCount > 0 then
		self.scriptUpButton:enable()
	else 
		self.scriptUpButton:disable()
	end
	local scriptLocation = table.getn(self.script) - self.scrollCount
	if scriptLocation > 4 then
		self.scriptDownButton:enable()
	elseif scriptLocation == 4 then
		self.scriptDownButton:disable()
	end
end

function StatementBox:addNewScript(name)
	
	table.insert(self.script, "script obj")
	print(name)
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
		self.parentScreen.statementBox:scriptCountCheck()
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
