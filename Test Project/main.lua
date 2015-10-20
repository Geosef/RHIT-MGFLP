local networkModule = require('networkadapter')
require('inputobj')
require('printer')
local gameMod = require('collectgame')

local multiplayerMode = false

JSON = (loadfile "JSON.lua")()
local netAdapter = networkModule.NetworkAdapter(multiplayerMode)





local game = gameMod.CollectGame(6, playerIndex, netAdapter)


function onEnterFrame(event)
    game:update()
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)

function routePacket(jsonObject)
	if jsonObject.type == "events" then
		game:runEvents(jsonObject)
	else
		print("unsupported packet from server")
		print_r(jsonObject)
	end
end
