require('inputobj')
require('printer')
--oldmain.run()
local gameMod = require('collectgame')

local http = require("socket.http")
local socket = require("socket")

JSON = (loadfile "JSON.lua")()
local dataTable = {hello="goodbye"}
local outerData = {data=dataTable}
local jsonString = JSON:encode(outerData)
--sock = socket.try(socket.tcp())
local sock = socket.tcp()
--sock:connect('localhost', 5005)
sock:connect('192.168.254.21', 5005)
sock:settimeout()
sock:send(jsonString)
local line, err, rBuf = sock:receive("*l", rBuf)
	--local line, err = self.socket:receive()
local inPacket = JSON:decode(line)
local playerIndex = inPacket.playerIndex
print(playerIndex)

game = gameMod.CollectGame(6, playerIndex, sock)




--need functionality to remove objects from stage by having them remove their children
--eg remove grid should call remove cell which should call remove gold
--also need a global loadmodule func to avoid running top level module code every time we import

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
