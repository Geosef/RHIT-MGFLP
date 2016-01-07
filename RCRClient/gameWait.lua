gameWait = Core.class(BaseScreen)

function gameWait:init()
	-- need to change this probably
	self.sceneName = "Waiting for Opponent..."
	local submitButtonUp = Bitmap.new(Texture.new("images/submitButtonUp.png"))
	local submitButtonDown = Bitmap.new(Texture.new("images/submitButtonDown.png"))
	local submitButton = CustomButton.new(submitButtonUp, submitButtonDown, function() 
		sceneManager:changeScene("gameScreen", 1, SceneManager.crossfade, easing.outBack)
	end)
	submitButton:setPosition((WINDOW_WIDTH / 2) - (submitButton:getWidth() / 2) , WINDOW_HEIGHT - submitButton:getHeight() - 70)
	self:addChild(submitButton)
	local logo = Bitmap.new(Texture.new("images/waitingForOppText.png"))
	logo:setPosition(0, 200)
	self:addChild(logo)
end




