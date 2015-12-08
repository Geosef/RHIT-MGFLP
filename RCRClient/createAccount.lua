splash = gideros.class(Sprite)

function splash:init()
	local titleBackground = Bitmap.new(Texture.new("images/moonbackground.png"))
	titleBackground:setScale(1.5, 1)
	local titleClick = Button.new(titleBackground, titleBackground, function() 
		sceneManager:changeScene("second", 1, SceneManager.crossfade, easing.outBack) 
	end)
	self:addChild(titleClick)
end