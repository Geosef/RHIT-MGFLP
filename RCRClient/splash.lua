splash = Core.class(Sprite)

function splash:init()
	local titleBackground = Bitmap.new(Texture.new("images/moonbackground.png"))
	titleBackground:setScale(1.5, 1)
	local titleClick = Button.new(titleBackground, titleBackground, function() 
		sceneManager:changeScene("login", 1, SceneManager.crossfade, easing.outBack) 
	end)
	self:addChild(titleClick)
	local logo = Bitmap.new(Texture.new("images/RcrLogo.png"))
	self:addChild(logo)
end