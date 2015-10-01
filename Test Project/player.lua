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
	self.loadedmoves = {}
	local textfield = TextField.new(nil, "Score: " .. self.score)
	textfield:setX(10)
	textfield:setY(10)
	stage:addChild(textfield)
	self.scorefield = textfield
	
	
	self.x = 1
	self.y = 1
	self.grid = grid
	imagescale = width / grid.numrows
	inc = 1 / grid.numrows
	startY = height / 4
	local playerimage = Bitmap.new(Texture.new("images/player.jpg"))
	scalex = imagescale / playerimage:getWidth()
	scaley = imagescale / playerimage:getHeight()
			
	playerimage:setScale(scalex, scaley)
	self.xposStart = (inc * (self.x-1)) * width
	self.yposStart = (inc * (self.y-1)) * width + startY
	playerimage:setPosition(self.xposStart, self.yposStart)
	stage:addChild(playerimage)
	self.playerimage = playerimage
	self.playerimage.xdirection = 0
	self.playerimage.ydirection = 0
	self.playerimage.xspeed = 0
	self.playerimage.yspeed = 0
end

function Player:reset()
	self.score = 0
	self.playerimage:setPosition(self.xposStart, self.yposStart)
	self.x = 1
	self.y = 1
end



function Player:finishmove()
	cell = self.grid.rows[self.y][self.x]
	if cell.gold then
		print("Player picked up gold!")
		self.score = self.score + 1
		self.scorefield:setText("Score: " .. self.score)
		cell.gold = false
		stage:removeChild(cell.goldimage)
	end
end

function Player:moveRight()
	if self.x >= self.grid.numrows then
		return
	end
	self.x = self.x + 1
	self.playerimage.xdirection = 1
	self.playerimage.ydirection = 0
	self.playerimage.xspeed = 2
	self.playerimage.yspeed = 0
	--self:finishmove()
	self.cellcheck = function(x, y)
		return x >= ((self.x - 1) / self.grid.numrows) * width
	end
end

function Player:moveLeft()
	if self.x <= 1 then
		return
	end
	self.x = self.x - 1
	self.playerimage.xdirection = -1
	self.playerimage.ydirection = 0
	self.playerimage.xspeed = 2
	self.playerimage.yspeed = 0
	self.cellcheck = function(x, y)
		return x <= ((self.x - 1) / self.grid.numrows) * width
	end
	self:finishmove()
end

function Player:moveUp()
	if self.y <= 1 then
		return
	end
	self.y = self.y - 1
	self.playerimage.xdirection = 0
	self.playerimage.ydirection = -1
	self.playerimage.xspeed = 0
	self.playerimage.yspeed = 2
	--self:finishmove()
	self.cellcheck = function(x, y)
		return y <= ((self.y - 1) / self.grid.numrows) * width + (height / 4)
	end
end



function Player:moveDown()
	if self.y >= self.grid.numrows then
		return
	end
	self.y = self.y + 1
	self.playerimage.xdirection = 0
	self.playerimage.ydirection = 1
	self.playerimage.xspeed = 0
	self.playerimage.yspeed = 2
--	self:finishmove()
	self.cellcheck = function(x, y)
		return y >= ((self.y - 1) / self.grid.numrows) * width + (height / 4)
	end
end

function Player:update()
	
	if self.playerimage.xspeed == 0 and self.playerimage.yspeed == 0 then
		if # self.loadedmoves ~= 0 then
			move = self.loadedmoves[1]
			table.remove(self.loadedmoves, 1)
			move()
		end
		return
	end
		
	
	--print(self.playerimage.xspeed .. " " .. self.playerimage.yspeed)
	
	local x,y = self.playerimage:getPosition()
	if self.cellcheck(x, y) then
		self:finishmove()
		if # self.loadedmoves == 0 then
			self.xspeed = 0
			self.yspeed = 0
		else
			move = self.loadedmoves[1]
			table.remove(self.loadedmoves, 1)
			move()
		end
		return
	end
 
	x = x + (self.playerimage.xspeed * self.playerimage.xdirection)
	y = y + (self.playerimage.yspeed * self.playerimage.ydirection)
 
 
	if x < 0 then
		self.playerimage.xdirection = 1
	end
 
	if x > width - self.playerimage:getWidth() then
		self.playerimage.xdirection = -1
	end
 
	if y < 0 then
		self.playerimage.ydirection = 1
	end
 
	if y > height - self.playerimage:getHeight() then
		self.playerimage.ydirection = -1
	end
 
	self.playerimage:setPosition(x, y)
--	print(x .. " " .. y)
end

M.Player = Player

return M