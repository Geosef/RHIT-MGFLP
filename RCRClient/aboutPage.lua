-- program is being exported under the TSU exception

aboutPage = Core.class(BaseScreen)

function aboutPage:init()
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
		--sceneManager:changeScene("aboutFunctions", 1, SceneManager.crossfade, easing.outBack)
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
	
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function aboutPage:onEnterEnd()
	
end

function aboutPage:onExitBegin()
	
end