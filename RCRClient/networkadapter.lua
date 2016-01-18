-- program is being exported under the TSU exception



--local gameMod = require('game')
local serverIP = '137.112.226.156';

NetworkAdapter = {}
NetworkAdapter.__index = NetworkAdapter

setmetatable(NetworkAdapter, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

--[[
	These methods are used to react to receiving packets from the server
	S= Send, R= Recv

----------------------------------------------------------------------------------------------------------------
	Login (SR) and Create Account (SR)
]]
function NetworkAdapter:createAccount(packet)

end

function NetworkAdapter:login(username, password, callback)
	if not self.on then 
	return end
	print("LOGGING IN")
	
	packet = {
		type="Login",
		username=username,
		password=password
	}
	self:sendData(packet)
	self:startRecv(function(res)
		print("Received Login Response")
		print_r(res)
		callback(res)
	end)
end

function NetworkAdapter:recvLogin(packet)

	if packet.success then
		print("LOGGED IN")
		--self:joinGame(1)
		--self:createGame()
	end
end

--[[
----------------------------------------------------------------------------------------------------------------
	Create Game (SR), Browse Game and Join Game	(SR)
]]


function NetworkAdapter:createGame()
	--[[if not self.on then 
	self.game = gameMod.CollectGame(self)
	self.game.gameSetup(self:getGameState("Collect"))
	self.game.show()
	return end 
	
	local packet = {type="Create Game", gametype="Collect", difficulty="Easy"}
	self:sendData(packet)
	
	local tf = TextField.new(nil, 'Waiting for Player')
	tf:setPosition(200, 200)
	tf:setScale(5, 5)
	stage:addChild(tf)
	self:startRecv()
	stage:removeChild(tf)
	]]
end


function NetworkAdapter:recvCreateGame(packet)
	print("CREATED GAME")
	if packet.success then
		print("SUCCESS")
		self.game = gameMod.CollectGame(self, true)
		self:startRecv()
	end
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
	print("JOINED GAME")
	if packet.success then
		self.game = gameMod.CollectGame(self, false)
		self:startRecv()
	else
		print('Join game unsuccessful')
		local tf = TextField.new(nil, 'Join Unsuccessful')
		tf:setPosition(200, 200)
		tf:setScale(5, 5)
		local back = TextField.new(nil, 'Back')
		back:setPosition(200, 300)
		back:setScale(7, 7)
		
		local backButton = Button.new(back, back, function() 
			stage:addChild(bg)
			stage:addChild(logo)
			stage:addChild(createGameButton)
			stage:addChild(joinGameButton)
		end)
		
		stage:addChild(tf)
		stage:addChild(backButton)
		stage:addChild(backButton)
	end
end

--[[
----------------------------------------------------------------------------------------------------------------
	Player Joined, Game Setup, Game Specifics
]]

function NetworkAdapter:playerJoined(packet)
	--get choice of accepting the player or not
	local outPacket = {type="Player Joined", accept=true}
	self:sendData(outPacket)
	self:startRecv()
end



function NetworkAdapter:gameSetup(packet)
	print("GAME SETUP")	

	self.game.gameSetup(packet)
	
	self:startGame()
	--pass setup to game object setup method
end

function NetworkAdapter:startGame()
	print("PINGING START GAME")
	local packet = {type="Start Game"}
	self:sendData(packet)
	self:startRecv()
	
	--show the game's stage
	--allow user to start interacting with game
end

function NetworkAdapter:recvStartGame(packet)
	print("STARTING GAME")
	self.game.show()
end

function NetworkAdapter:runEvents(packet)
	print("RUN EVENTS")
	self.game.runEvents(packet.events)
end

function NetworkAdapter:updateLocations(locations, scores)
	print("SENDING UPDATE LOCATIONS")
	local packet = {type="Update Locations", locations = locations, scores = scores}
	self:sendData(packet)
	self:startRecv()
	
end

function NetworkAdapter:recvUpdateLocations(packet)
	print("RECEIVING UPDATE LOCATIONS")
	self.game.recvUpdateLocations(packet.locations)
end

function NetworkAdapter:gameOver(packet)
	print("GAME OVER")
	print('Winner: ' .. packet.winner)
	self.game.gameOver(packet.winner)
end

function NetworkAdapter:endGame(rematch)
	print("SENDING REMATCH RESPONSE")
	local packet = {type='End Game', rematch=rematch}
	
	self:sendData(packet)
	if rematch then
		self:startRecv()
	end

	--if packet.rematch, reset game
	--else kick to main menu
	--self.game.destroy()
	--self.game = nil
end

function NetworkAdapter:rematch(packet)
	--TODO: need to handle rematch refusal?
	print("RECEIVED REMATCH RESPONSE")
	print_r(packet)
	if packet.rematch then
		self:startRecv()
	end

end





function NetworkAdapter:playerLeft(packet)
	print("OTHER PLAYER LEFT")
	--kick to main menu
	--self.game = nil
end

function NetworkAdapter:sendData(packet)
	if not self.on then return end
	local jsonString = JSON:encode(packet)
	self.sock:send(jsonString)
end

function NetworkAdapter:browseGames(choices, callback)
	local packet = {}
	packet.type = "Browse Games"
	packet.choices = choices
	self:sendData(packet)
	self:startRecv(callback)
end


function NetworkAdapter:connect()
	self.sock = socket.tcp()
	self.sock:connect(self.ip, self.port)
	self.sock:settimeout()
end


function NetworkAdapter:_init(multiplayerMode)
	self.on = multiplayerMode
	if self.on then
		local http = require("socket.http")
		local socket = require("socket")
		self.ip = serverIP
		self.port = 5005
	else
		--self.game = gameMod.CollectGame(self)
		--self.game.gameSetup(self:getGameState("Collect"))
		--self.game.show()
		--self.game.destroy()
		--moved into createGame and joinGame
	end
end

defaultMoves = {p2={"LeftMove", "UpMove", "UpMove", "LeftMove", "UpMove"}, alien={"LeftMove", "UpMove", "RightMove", "DownMove"}}

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
		return {gridsize=10, celldata = {alienStart={x=5, y=6}, goldLocations={{x=2, y=2}, {x=3,y=3}, {x=5,y=5}, {x=6,y=6}, {x=8,y=8}, {x=9,y=9}, {x=2,y=9}, {x=3,y=8}, {x=5,y=6}, {x=6,y=5}, {x=8,y=3}, {x=9,y=2}}, gemLocations={{x=4,y=4}, {x=7,y=7}, {x=4,y=7}, {x=7,y=4}}, treasureLocations={{x=1,y=10}, {x=10,y=1}}} }
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
["Player Left"] = NetworkAdapter.playerLeft,
["Game Over"] = NetworkAdapter.gameOver,
["Rematch"] = NetworkAdapter.rematch
}

function NetworkAdapter:recv(callback)
	
	local inPacket
	if pcall(function()
		local line, err, rBuf = self.sock:receive("*l", rBuf)
		inPacket = JSON:decode(line)
	end) then
		return inPacket
		
		
		--[[local type = inPacket.type
		print("TYPE: "..type)
		local method = packetRoute[type]
		print(method)
		--print_r(inPacket)
		
		if method ~= nil then
			method(self, inPacket)
		else
			print("METHOD MESS")
		end]]
	else
		print("Non-blocking recv got no data")
		return false
	end
end

-- intervalRate: milli
-- numAttempts: max number of attempts allowed on calling recv()
function NetworkAdapter:startRecv(callback, intervalRate, numAttempts)
	if not self.on then
		return
	end
	print("RECV")
	
	--ALWAYS USE CALLBACK, THIS IS ONLY FOR TESTING
	if not callback then callback = function(x)
	print(x) end end
	
	if not intervalRate then intervalRate = 50 end
	if not numAttempts then numAttempts = 100000 end
--	if not timeout then timeout = 10 end
	
	
	local timer = Timer.new(intervalRate, numAttempts)
	
	local recvCR = coroutine.create(function()
		print('h2')
		return self:recv(callback)
	end)
	
	local function onTimer(event)
		print('yo')
		local noErr, val = coroutine.resume(recvCR)
		if val then
			timer:stop()
			callback(val)
		end
	end
	timer:addEventListener(Event.TIMER, onTimer)

	timer:start()
	print('hello')
end
