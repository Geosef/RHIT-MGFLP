WINDOW_HEIGHT = application:getLogicalWidth()
WINDOW_WIDTH = application:getLogicalHeight()


local titleScene = gideros.class(Sprite)

local secondScene = gideros.class(Sprite)

function secondScene:init()
	local logo = Bitmap.new(Texture.new("images/RcrLogo.png"))
	stage:addChild(logo)
end

sceneManager = SceneManager.new({ 
	["title"] = titleScene,
	["second"] = secondScene
})

function titleScene:init()
	local titleBackground = Bitmap.new(Texture.new("images/moonbackground.png"))
	titleBackground:setScale(1.5, 1)
	local titleClick = Button.new(titleBackground, titleBackground, function() 
		sceneManager:changeScene("second", 1, SceneManager.flipWithFade, easing.outBack) 
	end)
	stage:addChild(titleClick)
end

stage:addChild(sceneManager)

sceneManager:changeScene("title", 1, SceneManager.flipWithFade, easing.outBack)

