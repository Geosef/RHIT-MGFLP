M = {}

gridmod = require('grid')
playermod = require('player')
enginemod = require('inputengine')
buttonmod = require('inputbutton')


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
	self.grid = gridmod.Grid(numrows)
	self.player = playermod.Player(self.grid)
	self.engine = enginemod.InputEngine()
	self:setupButtons()
end

function CollectGame:setupButtons()
	rightbutton = buttonmod.InputButton(self.engine, "images/arrow-right.png", function()
		print("right")
		--self.player:moveRight()
		table.insert(self.player.loadedmoves, function() self.player:moveRight() end)
		end, 1)
	downbutton = buttonmod.InputButton(self.engine, "images/arrow-down.png", function()
		--self.player:moveDown()
		print("down")
		table.insert(self.player.loadedmoves, function() self.player:moveDown() end)
		end, 2)
	leftbutton = buttonmod.InputButton(self.engine, "images/arrow-left.png", function()
		print("left")
		--self.player:moveLeft()
		table.insert(self.player.loadedmoves, function() self.player:moveLeft() end)
		end, 3)
	upbutton = buttonmod.InputButton(self.engine, "images/arrow-up.png", function()
		--self.player:moveUp()
		table.insert(self.player.loadedmoves, function() self.player:moveUp() end)
		print("up")
		end, 4)
		
	local buttonimage = Bitmap.new(Texture.new("images/go.png"))
	scalex = width / buttonimage:getWidth() / 7
	scaley = height / buttonimage:getHeight() / 10
	
	local button = Button.new(buttonimage, buttonimage, function()
		self:reset() end)
	button:setScale(scalex, scaley)
	xpos = 5 * (width / 6)
	ypos = height / 20
	button:setPosition(xpos, ypos)
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