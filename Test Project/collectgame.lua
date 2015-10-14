M = {}

gridMod = require('grid')
playerMod = require('player')
engineMod = require('inputengine')
buttonMod = require('inputbutton')


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
	rightButton = buttonMod.InputButton(self.engine, "images/arrow-right.png", function()
		print("right")
		--self.player:moveRight()
		table.insert(self.player.loadedMoves, function() self.player:moveRight() end)
		end, 1)
	downButton = buttonMod.InputButton(self.engine, "images/arrow-down.png", function()
		--self.player:moveDown()
		print("down")
		table.insert(self.player.loadedMoves, function() self.player:moveDown() end)
		end, 2)
	leftButton = buttonMod.InputButton(self.engine, "images/arrow-left.png", function()
		print("left")
		--self.player:moveLeft()
		table.insert(self.player.loadedMoves, function() self.player:moveLeft() end)
		end, 3)
	upButton = buttonmod.InputButton(self.engine, "images/arrow-up.png", function()
		--self.player:moveUp()
		table.insert(self.player.loadedMoves, function() self.player:moveUp() end)
		print("up")
		end, 4)
		
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