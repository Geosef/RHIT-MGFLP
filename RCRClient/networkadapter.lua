-- program is being exported under the TSU exception

local serverIP = '137.112.226.24';
local port = 5005

NetworkAdapter = {}
NetworkAdapter.__index = NetworkAdapter

setmetatable(NetworkAdapter, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function NetworkAdapter:sendData(packet)
	if not self.on then return end
	local jsonString = JSON:encode(packet)
	self.sock:send(jsonString)
end

local registeredCallbacks = {}

function NetworkAdapter:registerCallback(key, callback, data)
	if not data then
		registeredCallbacks[key] = callback
	else
		local timer = Timer.new(1000)
		timer:addEventListener(Event.TIMER, function()
			timer:stop()
			callback(data)
		end)
		timer:start()
	end
end

function NetworkAdapter:unregisterCallback(key)
	registeredCallbacks[key] = nil
end

function NetworkAdapter:connect()
	local timer = Timer.new(100)

	local sock = socket.tcp()
	sock:connect(serverIP, port)

	sock:settimeout(0)
	self.sock = sock
	
	timer:addEventListener(Event.TIMER, function()
		--to ensure responsiveness of our application
		--we should better loop through all available information at one timer call
		repeat
			local data, err = sock:receive("*l")
			if data then
				local inPacket = JSON:decode(data)
				local packetType = inPacket.type
				local callback = registeredCallbacks[packetType]
				if callback then
					callback(inPacket)
				else
					print('Received packet from server with no associated registered callback')
				end
				print_r(inPacket)
			end
			--repeat until there is no data to receive
		until not data
	end)
  
	--start the timer
	timer:start()
end

function NetworkAdapter:_init(multiplayerMode)
	self.on = multiplayerMode
	if self.on then
		self.ip = serverIP
		self.port = 5005
	end
end
