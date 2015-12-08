WINDOW_HEIGHT = application:getLogicalWidth()
WINDOW_WIDTH = application:getLogicalHeight()

KEYBOARD = Keyboard.new()

sceneManager = SceneManager.new({ 
	["splash"] = splash,
	["login"] = login,
	["mainMenu"] = mainMenu
})

stage:addChild(sceneManager)

sceneManager:changeScene("mainMenu", 1, SceneManager.crossfade, easing.outBack)