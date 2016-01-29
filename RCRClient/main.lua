-- program is being exported under the TSU exception

WINDOW_HEIGHT = application:getLogicalWidth()
WINDOW_WIDTH = application:getLogicalHeight()

local multiplayerMode = false

JSON = (loadfile "JSON.lua")()

NET_ADAPTER = NetworkAdapter(multiplayerMode)
--NET_ADAPTER:connect()
COMMAND_FACTORY = CommandFactory.new()
--netAdapter:login()
VOLUME = .5
MUSIC = Music.new("music.mp3")
MUSIC:on()

sceneManager = SceneManager.new({ 
	["splash"] = splash,
	["login"] = loginScreen,
	["mainMenu"] = mainMenu,
	["create"] = createAccount,
	["gameWait"] = gameWait,
	["gameScreen"] = gameScreen,
	["acctSettings"] = acctSettings,
	["joinGame"] = joiningGame
})

BlankScene = Core.class(Sprite)

popupManager = SceneManager.new({
	["settings"] = settings,
	["about"] = about,
	["blank"] = BlankScene
})

stage:addChild(sceneManager)
stage:addChild(popupManager)

sceneManager:changeScene("gameScreen", 1, SceneManager.crossfade, easing.outBack)


