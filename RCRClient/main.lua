-- program is being exported under the TSU exception

WINDOW_HEIGHT = application:getLogicalWidth()
WINDOW_WIDTH = application:getLogicalHeight()

local multiplayerMode = true

JSON = (loadfile "JSON.lua")()
local configString = readAll("config.json")
configuration = JSON:decode(configString)
local startupConfig = configuration["startup_config"]

NET_ADAPTER = NetworkAdapter(startupConfig["multiplayer_mode"])
--NET_ADAPTER:connect()
COMMAND_FACTORY = CommandFactory.new()
--netAdapter:login()
VOLUME = .5
MUSIC = Music.new("music.mp3")
--MUSIC:on()

sceneManager = SceneManager.new({ 
	["splash"] = splash,
	["login"] = loginScreen,
	["mainMenu"] = mainMenu,
	["create"] = createAccount,
	["gameWait"] = gameWait,
	["gameScreen"] = gameScreen,
	["acctSettings"] = acctSettings,
	["joinGame"] = joiningGame,
	["gameOver"] = gameOver,
	["aboutGameplay"] = aboutGameplay,
	["aboutCollector"] = aboutCollector,
	["aboutTraps"] = aboutTraps,
	["aboutLoops"] = aboutLoops,
	["aboutParameters"] = aboutParameters,
	["aboutFunctions"] = aboutFunctions
})

BlankScene = Core.class(Sprite)

popupManager = SceneManager.new({
	["settings"] = settings,
	["about"] = about,
	["blank"] = BlankScene
})

stage:addChild(sceneManager)
stage:addChild(popupManager)

sceneManager:changeScene(startupConfig["start_screen"], 1, SceneManager.crossfade, easing.outBack)


