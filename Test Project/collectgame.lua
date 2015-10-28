local M = {}

local gridMod = require('grid')
local playerMod = require('player')
local engineMod = require('inputengine')
local buttonMod = require('inputbutton')
local commandMod = require('command')
local collectibleMod = require('collectible')
local musicMod = require('music')

local CollectGame = {}
CollectGame.__index = CollectGame

setmetatable(CollectGame, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function CollectGame:_init(numRows, playerIndex, netAdapter)
	self.background = Bitmap.new(Texture.new("images/grassbackground.png"))
	stage:addChild(self.background)
	self.netAdapter = netAdapter
	local gameState = self.netAdapter:getGameState("Collect")
	self.grid = gridMod.Grid(gameState.gridSize, "images/dirtcell.png", gameState.goldLocations, gameState.gemLocations, gameState.treasureLocations)
	self.maxPlayerMoves = 8
	self.player1 = playerMod.Player(self.grid, true, self.maxPlayerMoves)
	self.player2 = playerMod.Player(self.grid, false, self.maxPlayerMoves)
	self.leprechaun = playerMod.Leprechaun(self.grid, self.maxPlayerMoves + 1, gameState.lepStart)
	self.engine = engineMod.InputEngine(self)
	self.numButtons = 8
	self:setupButtons()
	self.grid:setCollectibleAt(1, 4,  collectibleMod.MetalDetectorPowerUp())
	local music = musicMod.Music.new("audio/music.mp3")
	music:on()
end

function CollectGame:sendMoves()
	local packet = {type="events"}
	packet.events = self.engine:getEvents()
	if # packet.events > self.maxPlayerMoves then
		print("That's too many moves! Check your loops to see how many instructions are being run.")
		return
	end
	self.netAdapter:sendMoves(self, packet)
end

function CollectGame:runEvents(events)
	if events.p1 == nil or events.p2 == nil then
		print("unsupported event format")
		return
	end
	for index,value in ipairs(events.p1) do
		local eventObjConst = commandMod.getEvent(value)
		local eventObj = eventObjConst(self.player1, 1, index)
		table.insert(self.player1.loadedMoves, eventObj)
	end
	for index,value in ipairs(events.p2) do
		local eventObjConst = commandMod.getEvent(value)
		local eventObj = eventObjConst(self.player2, 1, index)
		table.insert(self.player2.loadedMoves, eventObj)
	end
	for index,value in ipairs(events.lep) do
		local eventObjConst = commandMod.getEvent(value)
		local eventObj = eventObjConst(self.leprechaun, 1, index)
		table.insert(self.leprechaun.loadedMoves, eventObj)
	end
	self:reset()
end

function CollectGame:setupButtons()
	rightButton = buttonMod.InputButton(self.engine, "images/arrow-right.png",
	"RightMove", 1, self.numButtons)
	downButton = buttonMod.InputButton(self.engine, "images/arrow-down.png", 
	"DownMove", 2, self.numButtons)
	leftButton = buttonMod.InputButton(self.engine, "images/arrow-left.png", 
	"LeftMove", 3, self.numButtons)
	upButton = buttonMod.InputButton(self.engine, "images/arrow-up.png", 
	"UpMove", 4, self.numButtons)
	digButton = buttonMod.InputButton(self.engine, "images/shovel.png", 
	"Dig", 5, self.numButtons)
	loopStart = buttonMod.InputButton(self.engine, "images/loop-start.png", 
	"LoopStart", 6, self.numButtons)
	loopEnd = buttonMod.InputButton(self.engine, "images/loop-end.png", 
	"LoopEnd", 7, self.numButtons)
	
	local buttonImage = Bitmap.new(Texture.new("images/go.png"))
	scaleX = WINDOW_WIDTH / buttonImage:getWidth() / 10.5
	scaleY = WINDOW_HEIGHT / buttonImage:getHeight() / 15
	
	local button = Button.new(buttonImage, buttonImage, function()
		--self:reset() 
		self:sendMoves()
		self.engine:clearBuffer()
		end)
	button:setScale(scaleX, scaleY)
	xPos = self.numButtons * (WINDOW_WIDTH / (self.numButtons + 1))
	yPos = WINDOW_HEIGHT / 20
	button:setPosition(xPos, yPos)
	stage:addChild(button)
end

function CollectGame:reset()
	--self.grid:reset()
	--self.player1:reset()
	self.player1.action = true
	self.player2.action = true
	self.leprechaun.action = true
	self.player1:endTurn()
	self.player2:endTurn()
	--self.player2:reset()
	--self.engine:runEvents()
end

function CollectGame:update()
	self.player1:update()
	self.player2:update()
	self.leprechaun:update()
end
function CollectGame:exit()
	stage:removeChild(self.background)
	self.grid:destroy()
	self.player1:destroy()
	self.player2:destroy()
	self.leprechaun:destroy()
end

M.CollectGame = CollectGame
return M



