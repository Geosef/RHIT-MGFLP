BaseScreen = Core.class(Sprite)
local font = TTFont.new("fonts/arial-rounded.ttf", 20)
local padding = 16

function BaseScreen:init()
	local titleBackground = Bitmap.new(Texture.new("images/background.png"))
	self:addChild(titleBackground)
	self.topBar = Bitmap.new(Texture.new("images/RCRTopBar.png"))
	self:addChild(self.topBar)
	self.topBarTextLine = self.topBar:getHeight() / 2 + 5
	self.topBarButtonSeparator = 875
end

function BaseScreen:postInit()
	self:initTopBar()
end

function BaseScreen:initTopBar()
	if self.sceneName == nil then
		self.sceneName = "No Scene Name Set"
	end
	local sceneTitleText = TextField.new(font, self.sceneName)
	sceneTitleText:setTextColor("0xffa500")
	sceneTitleText:setPosition(200, self.topBarTextLine)
	self:addChild(sceneTitleText)
	local playerLevel = self:getPlayerLevel()
	playerLevelText = TextField.new(font, playerLevel)
	playerLevelText:setTextColor("0x34b8f9")
	playerLevelText:setPosition(self.topBarButtonSeparator - (playerLevelText:getWidth() + padding), self.topBarTextLine)
	self:addChild(playerLevelText)
	local settingsButtonUp = Bitmap.new(Texture.new("images/settings-button-up.png"))
	local settingsButtonDown = Bitmap.new(Texture.new("images/settings-button-down.png"))
	local settingsButton = CustomButton.new(settingsButtonUp, settingsButtonDown, function() end)
	settingsButton:setPosition(self.topBarButtonSeparator + padding, self.topBarTextLine - settingsButton:getHeight()/2)
	self:addChild(settingsButton)
	local facebookButtonUp = Bitmap.new(Texture.new("images/facebook-button-up.png"))
	local facebookButtonDown = Bitmap.new(Texture.new("images/facebook-button-down.png"))
	local facebookButton = CustomButton.new(facebookButtonUp, facebookButtonDown, function() end)
	facebookButton:setPosition(settingsButton:getX() + settingsButton:getWidth() + 5, self.topBarTextLine - facebookButton:getHeight()/2)
	self:addChild(facebookButton)
	local twitterButtonUp = Bitmap.new(Texture.new("images/twitter-button-up.png"))
	local twitterButtonDown = Bitmap.new(Texture.new("images/twitter-button-down.png"))
	local twitterButton = CustomButton.new(twitterButtonUp, twitterButtonDown, function() end)
	twitterButton:setPosition(facebookButton:getX() + facebookButton:getWidth() + 5, self.topBarTextLine - twitterButton:getHeight()/2)
	self:addChild(twitterButton)
end

function BaseScreen:getPlayerLevel()
	-- Eventually, this method should use the netAdapter to query the server
	-- for the user's level
	return "Level 0"
end