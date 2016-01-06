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
end

function BaseScreen:getPlayerLevel()
	-- Eventually, this method should use the netAdapter to query the server
	-- for the user's level
	return "Level 0"
end