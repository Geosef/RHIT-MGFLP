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

local multiplayerMode = false

JSON = (loadfile "JSON.lua")()
local netAdapter = networkModule.NetworkAdapter(multiplayerMode)



netAdapter:login("user", "pass")


co = coroutine.create(function ()
	netAdapter:startRecv()
end)

--coroutine.resume(co)

netAdapter:startRecv()

function routePacket(jsonObject)
	if jsonObject.type == "events" then
		collectGame.runEvents(jsonObject)
	else
		print("unsupported packet from server")
		print_r(jsonObject)
	end
end
