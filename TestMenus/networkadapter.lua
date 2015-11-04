M = {}



local NetworkAdapter = {}
NetworkAdapter.__index = NetworkAdapter

setmetatable(NetworkAdapter, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function NetworkAdapter:_init(multiplayerMode)
	self.on = multiplayerMode
	if self.on then
		local http = require("socket.http")
		local socket = require("socket")
		local ip = '192.168.254.21'
		local port = 5005
		self.sock = socket.tcp()
		self.sock:connect(ip, port)
		self.sock:settimeout()
		local data = {type="Create Game", gametype="Collect", difficulty="Easy"}
		local jsonString = JSON:encode(data)
		self.sock:send(jsonString)
		local line, err, rBuf = self.sock:receive("*l", rBuf)
		local inPacket = JSON:decode(line)
		print_r(inPacket)
	end
end

defaultMoves = {p2={"LeftMove", "UpMove", "UpMove", "LeftMove", "UpMove"}, lep={"LeftMove", "UpMove", "RightMove", "DownMove"}}

function NetworkAdapter:sendMoves(game, packet)
	if not self.on then
		local events = defaultMoves
		events.p1 = packet.events
		game.runEvents(events)
		return
	end
	
	local jsonstring = JSON:encode(packet)
	self.sock:send(jsonstring)
	local rBuf = ""
	local line, err, rBuf = self.sock:receive("*l", rBuf)
	local inPacket = JSON:decode(line)
	if inPacket.valid == true then
		print('MOVE VALID')
		line, err, rBuf = self.sock:receive("*l", rBuf)
		inPacket = JSON:decode(line)
		game.runEvents(inPacket)
	else
		print('MOVE INVALID')
	end
end

function NetworkAdapter:getGameState(gameType)
		return {gridSize=10, lepStart={5, 6}, goldLocations={{2, 2}, {3,3}, {5,5}, {6,6}, {8,8}, {9,9}, {2,9}, {3,8}, {5,6}, {6,5}, {8,3}, {9,2}}, gemLocations={{4,4}, {7,7}, {4,7}, {7,4}}, treasureLocations={{1,10}, {10,1}} }
	

end

M.NetworkAdapter = NetworkAdapter
return M