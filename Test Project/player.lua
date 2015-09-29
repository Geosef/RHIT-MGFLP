M = {}

width = application:getLogicalWidth()
height = application:getLogicalHeight()

local Player = {}
Player.__index = Player

setmetatable(Player, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Player:_init(grid)
	self.score = 0
	self.x = 1
	self.y = 1
	self.grid = grid
	imagescale = width / grid.numrows
	inc = 1 / grid.numrows
	startY = height / 4
	local playerimage = Bitmap.new(Texture.new("player.jpg"))
	scalex = imagescale / playerimage:getWidth()
	scaley = imagescale / playerimage:getHeight()
			
	playerimage:setScale(scalex, scaley)
	xpos = (inc * (self.x-1)) * width
	ypos = (inc * (self.y-1)) * width + startY
	playerimage:setPosition(xpos, ypos)
	stage:addChild(playerimage)
	self.playerimage = playerimage
end

function Player:finishmove()
	imagescale = width / self.grid.numrows
	inc = 1 / self.grid.numrows
	startY = height / 4
	cell = self.grid.rows[self.y][self.x]
	xpos = (inc * (self.x-1)) * width
	ypos = (inc * (self.y-1)) * width + startY
	self.playerimage:setPosition(xpos, ypos)
	if cell.gold then
		print("Player picked up gold!")
		self.score = self.score + 1
		cell.gold = false
		stage:removeChild(cell.goldimage)
	end	
end

function Player:moveRight()
	if self.x >= self.grid.numrows then
		return
	end
	self.x = self.x + 1
	self:finishmove()
end

function Player:moveLeft()
	if self.x <= 1 then
		return
	end
	self.x = self.x - 1
	self:finishmove()
end

function Player:moveUp()
	if self.x <= 1 then
		return
	end
	self.y = self.y - 1
	self:finishmove()
end

function Player:moveDown()
	if self.y >= self.grid.numrows then
		return
	end
	self.y = self.y + 1
	self:finishmove()
end

M.Player = Player

return M