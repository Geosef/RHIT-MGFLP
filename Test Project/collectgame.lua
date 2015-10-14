local M = {}

local gridMod = require('grid')
local playerMod = require('player')
local engineMod = require('inputengine')
local buttonMod = require('inputbutton')


local CollectGame = {}
CollectGame.__index = CollectGame

setmetatable(CollectGame, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function CollectGame:_init(numrows)
	self.grid = gridMod.Grid(numrows)
	self.player = playerMod.Player(self.grid)
	self.engine = engineMod.InputEngine()
	self:setupButtons()
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
		self:reset() end)
	button:setScale(scaleX, scaleY)
	xPos = 5 * (width / 6)
	yPos = height / 20
	button:setPosition(xPos, yPos)
	stage:addChild(button)
end

function CollectGame:reset()
	self.grid:reset()
	self.player:reset()
	self.engine:runEvents()
end

function CollectGame:update()
	self.player:update()
end
function CollectGame:exit()
	self.grid:destroy()
	self.player:destroy()
	
end

M.CollectGame = CollectGame
return M