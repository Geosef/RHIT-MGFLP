-- program is being exported under the TSU exception

local function setGlobals()
	WINDOW_WIDTH = application:getLogicalWidth()
	WINDOW_HEIGHT = application:getLogicalHeight()
end

setGlobals()

local networkModule = require('networkadapter')
require('printer')
local gameMod = require('game')
--local tests = require('runtests')

--tests.run()

local multiplayerMode = true

JSON = (loadfile "JSON.lua")()
local netAdapter = networkModule.NetworkAdapter(multiplayerMode)

netAdapter:login("user", "pass")


co = coroutine.create(function ()
	netAdapter:startRecv()
end)

--coroutine.resume(co)
netAdapter:startRecv()

stage:addChild(Bitmap.new(Texture.new("images/moonbackground.png")))

logo = Bitmap.new(Texture.new("images/RcrLogo.png"))
logoScale = WINDOW_WIDTH/logo:getWidth()/1.05
logo:setScale(logoScale,logoScale)

logo:setPosition(WINDOW_WIDTH/30, WINDOW_HEIGHT/2.75)

stage:addChild(logo)

createGameButton = Button.new(Bitmap.new(Texture.new("images/creategame_up.png")), Bitmap.new(Texture.new("images/creategame_down.png")), function() clickCreate() end)
createGameButton:setPosition(WINDOW_WIDTH/7, WINDOW_HEIGHT/1.5)
stage:addChild(createGameButton)

joinGameButton = Button.new(Bitmap.new(Texture.new("images/joingame_up.png")), Bitmap.new(Texture.new("images/joingame_down.png")), function() clickJoin() end)
joinGameButton:setPosition(WINDOW_WIDTH/7, WINDOW_HEIGHT/1.2)
stage:addChild(joinGameButton)

function clickCreate()
	netAdapter:createGame()
end

function clickJoin()
	netAdapter:joinGame(1)
end

function routePacket(jsonObject)
	if jsonObject.type == "events" then
		collectGame.runEvents(jsonObject)
	else
		print("unsupported packet from server")
		print_r(jsonObject)
	end
end
