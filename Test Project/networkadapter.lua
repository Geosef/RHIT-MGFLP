M = {}

local gameMod = require('game')

local NetworkAdapter = {}
NetworkAdapter.__index = NetworkAdapter

setmetatable(NetworkAdapter, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})



--These methods are used to react to receiving packets from the server
function NetworkAdapter:createAccount(packet)

end

function NetworkAdapter:login(username, password)
	if not self.on then 
	return end
	print("LOGGING IN")
	
	packet = {
		type="Login",
		username=username,
		password=password
	}
	self:sendData(packet)
end

function NetworkAdapter:createGame()
	if not self.on then 
	self.game = gameMod.CollectGame(self)
	self.game.gameSetup(self:getGameState("Collect"))
	self.game.show()
	return end 
	
	local packet = {type="Create Game", gametype="Collect", difficulty="Easy"}
	self:sendData(packet)
	self:startRecv()
end

function NetworkAdapter:joinGame(gameID)
	if not self.on then 
	self.game = gameMod.CollectGame(self)
	self.game.gameSetup(self:getGameState("Collect"))
	self.game.show()
	return end

	local packet = {type="Join Game", gameID = gameID}
	self:sendData(packet)
	self:startRecv()
end

function NetworkAdapter:recvJoinGame(packet)
	print("HERE JOIN GAME")
	if packet.success then
		self.game = gameMod.CollectGame(self, false)
		self:startRecv()
	end
end


function NetworkAdapter:recvLogin(packet)

	if packet.success then
		print("LOGGED IN")
		--self:joinGame(1)
		--self:createGame()
	end
end

function NetworkAdapter:recvCreateGame(packet)
	print("CREATEGAME")
	if packet.success then
		print("SUCCESS")
		self.game = gameMod.CollectGame(self, true)
		self:startRecv()
	end
end

function NetworkAdapter:playerJoined(packet)
	--get choice of accepting the player or not
	local outPacket = {type="Player Joined", accept=true}
	self:sendData(outPacket)
	self:startRecv()
end

function NetworkAdapter:browseGames(packet)
	--display packet.games
	--[[
	[
		{
			'gameid':
			'gametype':
			'difficulty':
			'hostname':
		}, ...
	]
	]]
end

function NetworkAdapter:gameSetup(packet)
	print("hello")
	

	self.game.gameSetup(packet)
	
	self:startGame()
	--pass setup to game object setup method
end

function NetworkAdapter:startGame()
	local packet = {type="Start Game"}
	self:sendData(packet)
	self:startRecv()
	
	--show the game's stage
	--allow user to start interacting with game
end

function NetworkAdapter:recvStartGame(packet)
	self.game.show()
end

function NetworkAdapter:runEvents(packet)
	self.game.runEvents(packet.events)
end

function NetworkAdapter:uploadLocations(locations)
	local packet = {type="Update Locations", locations = locations}
	self:sendData(packet)
	self:startRecv()
	
end

function NetworkAdapter:recvUpdateLocations(packet)
	self.game.updateLocations(packet.locations)
	print("UPDATE")
end

function NetworkAdapter:endGame(packet)
	--if packet.rematch, reset game
	--else kick to main menu
	--self.game.destroy()
	--self.game = nil
end

function NetworkAdapter:playerLeft(packet)
	--kick to main menu
	--self.game = nil
end

function NetworkAdapter:sendData(packet)
	if not self.on then return end
	local jsonString = JSON:encode(packet)
	self.sock:send(jsonString)
end


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
	else
		--self.game = gameMod.CollectGame(self)
		--self.game.gameSetup(self:getGameState("Collect"))
		--self.game.show()
		--self.game.destroy()
		--moved into createGame and joinGame
	end
end

defaultMoves = {p2={"LeftMove", "UpMove", "UpMove", "LeftMove", "UpMove"}, lep={"LeftMove", "UpMove", "RightMove", "DownMove"}}

function NetworkAdapter:sendMoves(game, events)
	if not self.on then
		local moves = defaultMoves
		moves.p1 = events
		game.runEvents(moves)
		return
	end
	
	local packet = {type = "Submit Move"}
	packet.events = events
	local jsonstring = JSON:encode(packet)
	self.sock:send(jsonstring)
	
	self:startRecv()
	
	--local line, err, rBuf = self.sock:receive("*l", rBuf)
	
end


function NetworkAdapter:getGameState(gameType)
		return {gridsize=10, celldata = {lepStart={x=5, y=6}, goldLocations={{x=2, y=2}, {x=3,y=3}, {x=5,y=5}, {x=6,y=6}, {x=8,y=8}, {x=9,y=9}, {x=2,y=9}, {x=3,y=8}, {x=5,y=6}, {x=6,y=5}, {x=8,y=3}, {x=9,y=2}}, gemLocations={{x=4,y=4}, {x=7,y=7}, {x=4,y=7}, {x=7,y=4}}, treasureLocations={{x=1,y=10}, {x=10,y=1}}} }
end

local packetRoute = {
["Create Account"] = NetworkAdapter.createAccount,
["Login"] = NetworkAdapter.recvLogin,
["Create Game"] = NetworkAdapter.recvCreateGame,
["Player Joined"] = NetworkAdapter.playerJoined,
["Browse Games"] = NetworkAdapter.browseGames,
["Join Game"] = NetworkAdapter.recvJoinGame,
["Game Setup"] = NetworkAdapter.gameSetup,
["Start Game"] = NetworkAdapter.recvStartGame,
["Run Events"] = NetworkAdapter.runEvents,
["Update Locations"] = NetworkAdapter.recvUpdateLocations,
["End Game"] = NetworkAdapter.endGame,
["Player Left"] = NetworkAdapter.playerLeft
}
function NetworkAdapter:startRecv()
	if not self.on then
		return
	end
	print("RECV")

	while true do
		local line, err, rBuf = self.sock:receive("*l", rBuf)
		local inPacket = JSON:decode(line)
		local type = inPacket.type
		print("TYPE: "..type)
		local method = packetRoute[type]
		--print_r(inPacket)
		
		if method ~= nil then
			method(self, inPacket)
		else
			print("METHOD MESS")
		end
		return
		
	end
end

M.NetworkAdapter = NetworkAdapter
return M