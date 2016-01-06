gameWait = Core.class(BaseScreen)

function gameWait:init()
	-- need to change this probably
	local titleClick = CustomButton.new(titleBackground, titleBackground, function() 
		sceneManager:changeScene("gameScreen", 1, SceneManager.crossfade, easing.outBack)
	end)
	self:addChild(titleClick)
	local logo = Bitmap.new(Texture.new("images/RcrLogoLarge.png"))
	logo:setPosition(70, 100)
	self:addChild(logo)
end




