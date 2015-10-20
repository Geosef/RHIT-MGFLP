M = {}

local http = require("socket.http")
local socket = require("socket")



local ip = '192.168.254.21'
local port = 5005

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
		self.sock = socket.tcp()
		self.sock:connect(ip, port)
		self.sock:settimeout()
		local dataTable = {hello="goodbye"}
		local outerData = {data=dataTable}
		local jsonString = JSON:encode(outerData)
		self.sock:send(jsonString)
		local line, err, rBuf = self.sock:receive("*l", rBuf)
		local inPacket = JSON:decode(line)
		local playerIndex = inPacket.playerIndex
		print("Player Index: " .. playerIndex)
	end
end

defaultMoves = {p2={"LeftMove", "UpMove", "UpMove", "LeftMove", "UpMove"}}

function NetworkAdapter:sendMoves(game, packet)
	if not self.on then
		local events = defaultMoves
		events.p1 = packet.events
		game:runEvents(events)
		return
	end
	
	local jsonstring = JSON:encode(packet)
	self.socket:send(jsonstring)
	local rBuf = ""
	local line, err, rBuf = self.socket:receive("*l", rBuf)
	local inPacket = JSON:decode(line)
	if inPacket.valid == true then
		print('MOVE VALID')
		line, err, rBuf = self.socket:receive("*l", rBuf)
		inPacket = JSON:decode(line)
		game:runEvents(inPacket)
	else
		print('MOVE INVALID')
	end
end

M.NetworkAdapter = NetworkAdapter
return M