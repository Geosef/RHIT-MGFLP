gameScreen = Core.class(BaseScreen)

function gameScreen:init(gameInit)
	if not gameInit then gameInit = SERVER_MOCKS['Game Setup']('Collectors') end
	print_r(gameInit)
	
	self.uiConfig = configuration["ui_config"]
	self.host = gameInit.host
	-- This needs to be eventually replaced with GameLib in order to enable switching of game types
	self.gameboard = CollectGameboard.new(gameInit)
	self.padding = self.uiConfig["padding"]
	self.gameActionButtonHeight = self.uiConfig["gameActionButtonHeight"]
	self.gameCommandButtonHeight = self.uiConfig["gameCommandButtonHeight"]
	self.gameboard:setPosition(self.padding, (WINDOW_HEIGHT - self.padding) - self.gameboard:getHeight())
	self:addChild(self.gameboard)
	-- Eventually sceneName will be set by the type of game
	self.sceneName = gameInit.game
	self.statementBox = StatementBox.new(self, self.gameboard.maxMoves)
	self.statementBox:setPosition(self.gameboard:getX() + self.gameboard:getWidth() + self.padding, (WINDOW_HEIGHT - self.padding) - (self.gameActionButtonHeight + self.padding) - self.statementBox:getHeight())
	self:addChild(self.statementBox)
	self.commandBox = CommandBox.new(self)
	self.commandBox:setPosition(self.statementBox:getX() + self.statementBox:getWidth() + self.padding, self.statementBox:getY())
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
	
	self.saveButton:setPosition(self.statementBox:getX(), self.statementBox:getY() + self.statementBox:getHeight() + self.padding)
	self:addChild(self.saveButton)
	self.submitButton:setPosition(self.saveButton:getX() + self.saveButton:getWidth() + self.padding, self.saveButton:getY())
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
	
	infoImage1:setPosition(self.padding, self.statementBox:getY())
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
