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
	["gameScreen"] = gameScreen,
})

BlankScene = Core.class(Sprite)

popupManager = SceneManager.new({
	["settings"] = settings,
	["blank"] = BlankScene
})

stage:addChild(sceneManager)
stage:addChild(popupManager)

sceneManager:changeScene("mainMenu", 1, SceneManager.crossfade, easing.outBack)
popupManager:changeScene("blank", 1, SceneManager.crossfade, easing.outBack)
