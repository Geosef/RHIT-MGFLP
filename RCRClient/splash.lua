-- program is being exported under the TSU exception

splash = Core.class(Sprite)

function splash:init()
	local titleBackground = Bitmap.new(Texture.new("images/background.png"))
	titleBackground:setScale(1.5, 1)
	local titleClick = Button.new(titleBackground, titleBackground, function() 
		sceneManager:changeScene("login", 1, SceneManager.crossfade, easing.outBack) 
	end)
	self:addChild(titleClick)
	local logo = Bitmap.new(Texture.new("images/NewRcrLogo.png"))
	logo:setPosition(0, 100)
	self:addChild(logo)
end