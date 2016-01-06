-- program is being exported under the TSU exception

WINDOW_HEIGHT = application:getLogicalWidth()
WINDOW_WIDTH = application:getLogicalHeight()

KEYBOARD = Keyboard.new()

sceneManager = SceneManager.new({ 
	["splash"] = splash,
	["login"] = login,
	["mainMenu"] = mainMenu,
	["create"] = createAccount,
	["textBox"] = textBoxScene,
	["gameWait"] = gameWait,
	["gameScreen"] = gameScreen
})

stage:addChild(sceneManager)


sceneManager:changeScene("splash", 1, SceneManager.crossfade, easing.outBack)

