-- program is being exported under the TSU exception

--[[
	Base screen that all scenes extend. Provides core functionality
	common to all scenes.
]]
BaseScreen = Core.class(SceneObject)
local font = TTFont.new("fonts/arial-rounded.ttf", 20)
local padding = 12
local buttonPadding = 8
local topBarTextStart = 200
local topBarButtonSeparator = 875

--[[
	Initializes the background for the scene.
]]
function BaseScreen:init()
	local titleBackground = Bitmap.new(Texture.new("images/background.png"))
	self:addChild(titleBackground)
	if not self.noBar then
		self.topBar = Bitmap.new(Texture.new("images/RCRTopBar.png"))
		self:addChild(self.topBar)
		self.topBarTextLine = self.topBar:getHeight() / 2
	end
end

--[[
	Called after init(). Initializes the top bar if the scene
	requires it.
]]
function BaseScreen:postInit()
	if not self.noBar then
		self:initTopBar()
	end
end

--[[
	Initializes all elements in the top bar for all scenes.
]]
function BaseScreen:initTopBar()
	if self.sceneName == nil then
		self.sceneName = "No Scene Name Set"
	end
	
	-- Add scene title text
	local sceneTitleText = TextField.new(font, self.sceneName)
	sceneTitleText:setTextColor("0xffa500")
	sceneTitleText:setPosition(topBarTextStart, self.topBarTextLine + (sceneTitleText:getHeight() / 2))
	self:addChild(sceneTitleText)
	
	-- Add player level
	local playerLevel = self:getPlayerLevel()
	playerLevelText = TextField.new(font, playerLevel)
	playerLevelText:setTextColor("0x34b8f9")
	playerLevelText:setPosition(topBarButtonSeparator - (playerLevelText:getWidth() + padding), self.topBarTextLine + (playerLevelText:getHeight() / 2))
	self:addChild(playerLevelText)
	
	-- Add settings button
	local settingsButtonUp = Bitmap.new(Texture.new("images/settings-button-up.png"))
	local settingsButtonDown = Bitmap.new(Texture.new("images/settings-button-down.png"))
	local settingsButton = CustomButton.new(settingsButtonUp, settingsButtonDown, function() 
		popupManager:changeScene("settings", 0.2, SceneManager.crossfade, easing.outBack)
	end)
	settingsButton:setPosition(topBarButtonSeparator + padding, self.topBarTextLine - settingsButton:getHeight()/2)
	self:addChild(settingsButton)
	
	-- Add about button
	local aboutButtonUp = Bitmap.new(Texture.new("images/about-button-up.png"))
	local aboutButtonDown = Bitmap.new(Texture.new("images/about-button-down.png"))
	local aboutButton = CustomButton.new(aboutButtonUp, aboutButtonDown, function() 
		popupManager:changeScene("about", 0.2, SceneManager.crossfade, easing.outBack)
	end)
	aboutButton:setPosition(settingsButton:getX() + settingsButton:getWidth() + buttonPadding, self.topBarTextLine - aboutButton:getHeight()/2)
	self:addChild(aboutButton)
	
	-- Add mute button 
	local muteButtonUp = Bitmap.new(Texture.new("images/mute-button-up.png"))
	local muteButtonDown = Bitmap.new(Texture.new("images/mute-button-down.png"))
	local muteButton = RadioButton.new(muteButtonUp, muteButtonDown, function()
		-- Music muting based on muted boolean in music class.
		if MUSIC.muted then
			MUSIC:unmute()
		else
			MUSIC:mute()
		end
	end)
	muteButton:setPosition(aboutButton:getX() + aboutButton:getWidth() + buttonPadding, self.topBarTextLine - muteButton:getHeight()/2)
	self:addChild(muteButton)
end

--[[
	Uses netAdapter to get the user's level.
]]
function BaseScreen:getPlayerLevel()
	-- Eventually, this method should use the netAdapter to query the server
	-- for the user's level
	return "Level 0"
end

--[[
	Used by About Pages to add extra objects.
	
	NOTE: This function is a work-around for extension. Original idea was to
	create a class that extends base screen with this functionality and then
	have the about scenes extend that class. However, we ran into a bug with
	extension saying that addChild was a nil value. Could not find documentation
	on that specific issue.
]]
function BaseScreen:addAboutObjects()
	self.sceneName = "About"
	
	-- Add button images
	local gameplayButtonUp = Bitmap.new(Texture.new("images/gameplayButtonUp.png"))
	local gameplayButtonDown = Bitmap.new(Texture.new("images/gameplayButtonDown.png"))
	local collectorButtonUp = Bitmap.new(Texture.new("images/collectorButtonUp.png"))
	local collectorButtonDown = Bitmap.new(Texture.new("images/collectorButtonDown.png"))
	local trapsButtonUp = Bitmap.new(Texture.new("images/trapsButtonUp.png"))
	local trapsButtonDown = Bitmap.new(Texture.new("images/trapsButtonDown.png"))
	local loopsButtonUp = Bitmap.new(Texture.new("images/loopsButtonUp.png"))
	local loopsButtonDown = Bitmap.new(Texture.new("images/loopsButtonDown.png"))
	local parametersButtonUp = Bitmap.new(Texture.new("images/parametersButtonUp.png"))
	local parametersButtonDown = Bitmap.new(Texture.new("images/parametersButtonDown.png"))
	local functionsButtonUp = Bitmap.new(Texture.new("images/functionsButtonUp.png"))
	local functionsButtonDown = Bitmap.new(Texture.new("images/functionsButtonDown.png"))
	local mainMenuButtonUp = Bitmap.new(Texture.new("images/mainMenuButtonUp.png"))
	local mainMenuButtonDown = Bitmap.new(Texture.new("images/mainMenuButtonDown.png"))
	
	-- Create transition buttons
	local gameplayClick = CustomButton.new(gameplayButtonUp, gameplayButtonDown, function() 
		sceneManager:changeScene("aboutGameplay", 1, SceneManager.crossfade, easing.outBack)
	end)
	local collectorClick = CustomButton.new(collectorButtonUp, collectorButtonDown, function() 
		sceneManager:changeScene("aboutCollector", 1, SceneManager.crossfade, easing.outBack)
	end)
	local trapsClick = CustomButton.new(trapsButtonUp, trapsButtonDown, function() 
		sceneManager:changeScene("aboutTraps", 1, SceneManager.crossfade, easing.outBack)
	end)
	local loopsClick = CustomButton.new(loopsButtonUp, loopsButtonDown, function() 
		sceneManager:changeScene("aboutLoops", 1, SceneManager.crossfade, easing.outBack)
	end)
	local parametersClick = CustomButton.new(parametersButtonUp, parametersButtonDown, function() 
		sceneManager:changeScene("aboutParameters", 1, SceneManager.crossfade, easing.outBack)
	end)
	local functionsClick = CustomButton.new(functionsButtonUp, functionsButtonDown, function()
		sceneManager:changeScene("aboutFunctions", 1, SceneManager.crossfade, easing.outBack)
	end)
	local mainMenuClick = CustomButton.new(mainMenuButtonUp, mainMenuButtonDown, function() 
		 sceneManager:changeScene("mainMenu", 1, SceneManager.crossfade, easing.outBack)
	end)
	
	-- Set positions
	gameplayClick:setPosition(15, 650)
	collectorClick:setPosition(180, 650)
	trapsClick:setPosition(345, 650)
	loopsClick:setPosition(510, 650)
	parametersClick:setPosition(675, 650)
	functionsClick:setPosition(840, 650)
	mainMenuClick:setPosition(840, 75)
	
	-- Add buttons to scene
	self:addChild(gameplayClick)
	self:addChild(collectorClick)
	self:addChild(trapsClick)
	self:addChild(loopsClick)
	self:addChild(parametersClick)
	self:addChild(functionsClick)
	self:addChild(mainMenuClick)
end