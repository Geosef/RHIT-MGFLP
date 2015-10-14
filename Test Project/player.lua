local M = {}

local width = application:getLogicalWidth()
local height = application:getLogicalHeight()

local Player = {}
Player.__index = Player

setmetatable(Player, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Player:_init(grid, player1)
	self.score = 0
	self.loadedMoves = {}
	local textField = TextField.new(nil, "Score: " .. self.score)
	textField:setX(10)
	textField:setY(10)
	stage:addChild(textField)
	self.scoreField = textField
	self.action = false
	
	if player1 then
		self.initX = 1
		self.initY = 1
		self.name = "Player 1"
	else
		self.initX = grid.numRows
		self.initY = grid.numRows
		self.name = "Player 2"
	end
	self.x = self.initX
	self.y = self.initY
	self.grid = grid
	imageScale = width / grid.numRows
	inc = 1 / grid.numRows
	startY = height / 4
	local playerImage = Bitmap.new(Texture.new("images/player.jpg"))
	scaleX = imageScale / playerImage:getWidth()
	scaleY = imageScale / playerImage:getHeight()
			
	playerImage:setScale(scaleX, scaleY)
	self.xPosStart = (inc * (self.x-1)) * width
	self.yPosStart = (inc * (self.y-1)) * width + startY
	playerImage:setPosition(self.xPosStart, self.yPosStart)
	stage:addChild(playerImage)
	self.playerImage = playerImage
	self.playerImage.xDirection = 0
	self.playerImage.yDirection = 0
	self.playerImage.xSpeed = 0
	self.playerImage.ySpeed = 0
end

function Player:reset()
	self.score = 0
	self.scoreField:setText("Score: " .. self.score)
	self.playerImage:setPosition(self.xPosStart, self.yPosStart)
	self.x = self.initX
	self.y = self.initY
	self.action = true
end



function Player:finishMove()
	cell = self.grid.rows[self.y][self.x]
	if cell.gold then
		print(self.name .. " picked up gold!")
		self.score = self.score + 1
		self.scoreField:setText("Score: " .. self.score)
		cell.gold = false
		stage:removeChild(cell.goldImage)
	end
end

function Player:moveRight(param)
	if self.x >= self.grid.numRows then
		return
	end
	self.x = self.x + 1
	self.playerImage.xDirection = 1
	self.playerImage.yDirection = 0
	self.playerImage.xSpeed = 2
	self.playerImage.ySpeed = 0
	--self:finishmove()
	self.cellCheck = function(x, y)
		return x >= ((self.x - 1) / self.grid.numRows) * width
	end
end

function Player:moveLeft(param)
	if self.x <= 1 then
		return
	end
	self.x = self.x - 1
	self.playerImage.xDirection = -1
	self.playerImage.yDirection = 0
	self.playerImage.xSpeed = 2
	self.playerImage.ySpeed = 0
	self.cellCheck = function(x, y)
		return x <= ((self.x - 1) / self.grid.numRows) * width
	end
	self:finishMove()
end

function Player:moveUp(param)
	if self.y <= 1 then
		return
	end
	self.y = self.y - 1
	self.playerImage.xDirection = 0
	self.playerImage.yDirection = -1
	self.playerImage.xSpeed = 0
	self.playerImage.ySpeed = 2
	--self:finishmove()
	self.cellCheck = function(x, y)
		return y <= ((self.y - 1) / self.grid.numRows) * width + (height / 4)
	end
end

function Player:moveDown(param)
	if self.y >= self.grid.numRows then
		return
	end
	self.y = self.y + 1
	self.playerImage.xDirection = 0
	self.playerImage.yDirection = 1
	self.playerImage.xSpeed = 0
	self.playerImage.ySpeed = 2
--	self:finishmove()
	self.cellCheck = function(x, y)
		return y >= ((self.y - 1) / self.grid.numRows) * width + (height / 4)
	end
end

function Player:update()
	if not self.action then return end
	
	if self.playerImage.xSpeed == 0 and self.playerImage.ySpeed == 0 then
		if # self.loadedMoves ~= 0 then
			move = self.loadedMoves[1]
			table.remove(self.loadedMoves, 1)
			move:execute()
		end
		return
	end
		
	
	--print(self.playerimage.xspeed .. " " .. self.playerimage.yspeed)
	
	local x,y = self.playerImage:getPosition()
	if self.cellCheck(x, y) then
		self:finishMove()
		if # self.loadedMoves == 0 then
			self.xSpeed = 0
			self.ySpeed = 0
			self.action = false
		else
			move = self.loadedMoves[1]
			table.remove(self.loadedMoves, 1)
			move:execute()
		end
		return
	end
 
	x = x + (self.playerImage.xSpeed * self.playerImage.xDirection)
	y = y + (self.playerImage.ySpeed * self.playerImage.yDirection)
 
 
	if x < 0 then
		self.playerImage.xDirection = 1
	end
 
	if x > width - self.playerImage:getWidth() then
		self.playerImage.xDirection = -1
	end
 
	if y < 0 then
		self.playerImage.yDirection = 1
	end
 
	if y > height - self.playerImage:getHeight() then
		self.playerImage.yDirection = -1
	end
 
	self.playerImage:setPosition(x, y)
--	print(x .. " " .. y)
end

M.Player = Player

return M