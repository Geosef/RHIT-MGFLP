-- program is being exported under the TSU exception

aboutTraps = Core.class(BaseScreen)

function aboutTraps:init()
	self.sceneName = "About"
	local font = TTFont.new("fonts/arial-rounded.ttf", 60)

	-- Add title
	local titleText = TextField.new(font, "Traps Gameplay")
	titleText:setPosition((WINDOW_WIDTH / 2) - (titleText:getWidth() / 2), 125)
	self:addChild(titleText)
	
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
		 -- No transition needed.
	end)
	local loopsClick = CustomButton.new(loopsButtonUp, loopsButtonDown, function() 
		sceneManager:changeScene("aboutLoops", 1, SceneManager.crossfade, easing.outBack)
	end)
	local parametersClick = CustomButton.new(parametersButtonUp, parametersButtonDown, function() 
		 sceneManager:changeScene("aboutParameters", 1, SceneManager.crossfade, easing.outBack)
	end)
	local mainMenuClick = CustomButton.new(mainMenuButtonUp, mainMenuButtonDown, function() 
		sceneManager:changeScene("mainMenu", 1, SceneManager.crossfade, easing.outBack)
	end)
	
	-- Set positions
	gameplayClick:setPosition(15, 600)
	collectorClick:setPosition(180, 600)
	trapsClick:setPosition(345, 600)
	loopsClick:setPosition(510, 600)
	parametersClick:setPosition(675, 600)
	mainMenuClick:setPosition(840, 600)
	
	-- Add buttons to scene
	self:addChild(gameplayClick)
	self:addChild(collectorClick)
	self:addChild(trapsClick)
	self:addChild(loopsClick)
	self:addChild(parametersClick)
	self:addChild(mainMenuClick)
	
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function aboutTraps:onEnterEnd()
	
end

function aboutTraps:onExitBegin()
	
end