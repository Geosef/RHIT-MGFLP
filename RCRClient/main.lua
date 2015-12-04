WINDOW_HEIGHT = application:getLogicalWidth()
WINDOW_WIDTH = application:getLogicalHeight()


local titleScene = gideros.class(Sprite)

local secondScene = gideros.class(Sprite)



sceneManager = SceneManager.new({ 
	["title"] = titleScene,
	["second"] = secondScene
})

function titleScene:init()
	local titleBackground = Bitmap.new(Texture.new("images/moonbackground.png"))
	titleBackground:setScale(1.5, 1)
	local titleClick = Button.new(titleBackground, titleBackground, function() 
		sceneManager:changeScene("second", 1, SceneManager.crossfade, easing.outBack) 
	end)
	self:addChild(titleClick)
end

function secondScene:init()
	local logo = Bitmap.new(Texture.new("images/RcrLogo.png"))
	local logoClick = Button.new(logo, logo, function() 
		sceneManager:changeScene("title", 1, SceneManager.crossfade, easing.outBack) 
	end)
	self:addChild(logoClick)
end

stage:addChild(sceneManager)

sceneManager:changeScene("title", 1, SceneManager.crossfade, easing.outBack)

