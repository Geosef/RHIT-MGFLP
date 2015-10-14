local M = {}

local gridMod = require('grid')
local playerMod = require('player')
local engineMod = require('inputengine')
local buttonMod = require('inputbutton')
local movementMod = require('movement')


local CollectGame = {}
CollectGame.__index = CollectGame

setmetatable(CollectGame, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function CollectGame:_init(numRows, playerIndex, socket)
	self.grid = gridMod.Grid(numRows)
	self.player1 = playerMod.Player(self.grid, true)
	self.player2 = playerMod.Player(self.grid, false)
	self.engine = engineMod.InputEngine()
	self:setupButtons()
	self.socket = socket
end

function CollectGame:sendMoves()
	local packet = {type="events"}
	packet.events = self.engine:getEvents()
	local jsonstring = JSON:encode(packet)
	self.socket:send(jsonstring)
	local rBuf = ""
	local line, err, rBuf = self.socket:receive("*l", rBuf)
	--local line, err = self.socket:receive()
	local inPacket = JSON:decode(line)
	if inPacket.valid == true then
		print('MOVE VALID')
		line, err, rBuf = self.socket:receive("*l", rBuf)
		inPacket = JSON:decode(line)
		self:runEvents(inPacket)
	else
		print('MOVE INVALID')
	end
end

function CollectGame:runEvents(events)
	if events.p1 == nil or events.p2 == nil then
		print("unsupported event format")
		return
	end
	for index,value in ipairs(events.p1) do
		local eventObjConst = movementMod.getEvent(value)
		local eventObj = eventObjConst(self.player1, 1, index)
		table.insert(self.player1.loadedMoves, eventObj)
	end
	for index,value in ipairs(events.p2) do
		local eventObjConst = movementMod.getEvent(value)
		local eventObj = eventObjConst(self.player2, 1, index)
		table.insert(self.player2.loadedMoves, eventObj)
	end
	self:reset()
end

function CollectGame:setupButtons()
	rightButton = buttonMod.InputButton(self.engine, "images/arrow-right.png",
	"RightMove", 1)
	downButton = buttonMod.InputButton(self.engine, "images/arrow-down.png", 
	"DownMove", 2)
	leftButton = buttonMod.InputButton(self.engine, "images/arrow-left.png", 
	"LeftMove", 3)
	upButton = buttonMod.InputButton(self.engine, "images/arrow-up.png", 
	"UpMove", 4)

	local buttonImage = Bitmap.new(Texture.new("images/go.png"))
	scaleX = width / buttonImage:getWidth() / 7
	scaleY = height / buttonImage:getHeight() / 10
	
	local button = Button.new(buttonImage, buttonImage, function()
		--self:reset() 
		self:sendMoves()
		end)
	button:setScale(scaleX, scaleY)
	xPos = 5 * (width / 6)
	yPos = height / 20
	button:setPosition(xPos, yPos)
	stage:addChild(button)
end

function CollectGame:reset()
	self.grid:reset()
	self.player1:reset()
	self.player2:reset()
	--self.engine:runEvents()
end

function CollectGame:update()
	self.player1:update()
	self.player2:update()
end
function CollectGame:exit()
	self.grid:destroy()
	self.player1:destroy()
	self.player2:destroy()
end

M.CollectGame = CollectGame
return M