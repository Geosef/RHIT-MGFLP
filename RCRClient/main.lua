WINDOW_HEIGHT = application:getLogicalWidth()
WINDOW_WIDTH = application:getLogicalHeight()


local titleScene = gideros.class(Sprite)

local secondScene = gideros.class(Sprite)



sceneManager = SceneManager.new({ 
	["splash"] = splash,
	["login"] = login,
})

stage:addChild(sceneManager)

sceneManager:changeScene("splash", 1, SceneManager.crossfade, easing.outBack)