acctSettings = Core.class(BaseScreen)

local font = TTFont.new("fonts/arial-rounded.ttf", 40)

function acctSettings:init()
	-- need to change this probably
	self.sceneName = "Account Settings"
	local submitButtonUp = Bitmap.new(Texture.new("images/submitButtonUp.png"))
	local submitButtonDown = Bitmap.new(Texture.new("images/submitButtonDown.png"))
	local submitButton = CustomButton.new(submitButtonUp, submitButtonDown, function() 
		sceneManager:changeScene("gameScreen", 1, SceneManager.crossfade, easing.outBack)
	end)
	submitButton:setPosition((WINDOW_WIDTH / 2) - (submitButton:getWidth() / 2) , WINDOW_HEIGHT - submitButton:getHeight() - 70)
	self:addChild(submitButton)
	local helpText = TextField.new(font, "Hit submit to go to the game screen.")
	helpText:setPosition((WINDOW_WIDTH / 2) - (helpText:getWidth() / 2), (WINDOW_HEIGHT / 2) - (helpText:getHeight() / 2))
	self:addChild(helpText)

end