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

bg = Bitmap.new(Texture.new("images/rcrbg.png", true))
stage:addChild(bg)

logo = Bitmap.new(Texture.new("images/RcrLogo.png", true))
local logoScale = WINDOW_WIDTH/logo:getWidth()/1.05
logo:setScale(logoScale,logoScale)

logo:setPosition(WINDOW_WIDTH/30, WINDOW_HEIGHT/11)

stage:addChild(logo)

createGameButton = Button.new(Bitmap.new(Texture.new("images/creategame_up.png")), Bitmap.new(Texture.new("images/creategame_down.png")), function() clickCreate() end)
local createGameButtonX = WINDOW_WIDTH/2 - createGameButton:getWidth()/2
local createGameButtonY = WINDOW_HEIGHT/11 + logo:getHeight()+ 50
createGameButton:setPosition(createGameButtonX, createGameButtonY)
stage:addChild(createGameButton)

joinGameButton = Button.new(Bitmap.new(Texture.new("images/joingame_up.png")), Bitmap.new(Texture.new("images/joingame_down.png")), function() clickJoin() end)
joinGameButton:setPosition(createGameButtonX, createGameButtonY + createGameButton:getHeight() + 50)
stage:addChild(joinGameButton)

function destroyMenu()
	stage:removeChild(logo)
	stage:removeChild(createGameButton)
	stage:removeChild(joinGameButton)
	stage:removeChild(bg)
end

function clickCreate()
	destroyMenu()
	netAdapter:createGame()
end

function clickJoin()
	destroyMenu()
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
