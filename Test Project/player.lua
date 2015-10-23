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

EVENT_DURATION = 16

function Player:_init(grid, player1)
	self.score = 0
	self.loadedMoves = {}
	local textField = TextField.new(nil, "Score: " .. self.score)
	self.velocity = (width / grid.numRows) / 16
	print("Velocity " .. self.velocity)
	
	stage:addChild(textField)
	self.scoreField = textField
	self.action = false
	
	if player1 then
		self.initX = 1
		self.initY = 1
		self.name = "Player 1"
		textField:setX(10)
		textField:setY(10)
	else
		self.initX = grid.numRows
		self.initY = grid.numRows
		self.name = "Player 2"
		textField:setX(10)
		textField:setY(20)
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
	self.xDirection = 0
	self.yDirection = 0
	self.xSpeed = 0
	self.ySpeed = 0
end

function Player:reset()
	self.score = 0
	self.scoreField:setText("Score: " .. self.score)
	self.playerImage:setPosition(self.x, self.y)
	self.action = true
end

function Player:finishMove()
	cell = self.grid.rows[self.y][self.x]
	self.xDirection = 0
	self.yDirection = 0
	self.xSpeed = 0
	self.ySpeed = 0
	if cell.gold then
		print(self.name .. " picked up gold!")
		self.score = self.score + 1
		self.scoreField:setText("Score: " .. self.score)
		cell.gold = false
		stage:removeChild(cell.goldImage)
	end
end

function Player:moveRight(param)
	print("MOVE RIGHT")
	if self.x >= self.grid.numRows then
		return
	end
	self.x = self.x + 1
	self.xDirection = 1
	self.yDirection = 0
	self.xSpeed = self.velocity
	self.ySpeed = 0
	self.cellCheck = function(x, y)
		return x >= ((self.x - 1) / self.grid.numRows) * width
	end
end

function Player:moveLeft(param)
	if self.x <= 1 then
		return
	end
	self.x = self.x - 1
	self.xDirection = -1
	self.yDirection = 0
	self.xSpeed = self.velocity
	self.ySpeed = 0
	self.cellCheck = function(x, y)
		return x <= ((self.x - 1) / self.grid.numRows) * width
	end
end

function Player:moveUp(param)
	if self.y <= 1 then
		return
	end
	self.y = self.y - 1
	self.xDirection = 0
	self.yDirection = -1
	self.xSpeed = 0
	self.ySpeed = self.velocity
	self.cellCheck = function(x, y)
		return y <= ((self.y - 1) / self.grid.numRows) * width + (height / 4)
	end
end

function Player:moveDown(param)
	if self.y >= self.grid.numRows then
		return
	end
	self.y = self.y + 1
	self.xDirection = 0
	self.yDirection = 1
	self.xSpeed = 0
	self.ySpeed = self.velocity
	self.cellCheck = function(x, y)
		return y >= ((self.y - 1) / self.grid.numRows) * width + (height / 4)
	end
end

function Player:dig()
	local cell = self.grid.rows[self.y][self.x]
	if cell.hiddenTreasure then
		print(self.name .. " dug up treasure!")
		self.score = self.score + 5
		self.scoreField:setText("Score: " .. self.score)
		cell:toggleHiddenTreasure()
	else
		print(self.name .. " found nothing.")
	end
	self.digging = true
	local frameCounter = 30
	local imageScale = width / self.grid.numRows
	local startY = height / 4
	local digImage = Bitmap.new(Texture.new("images/diggingActionCell.png"))
	local scaleX = imageScale / digImage:getWidth()
	local scaleY = imageScale / digImage:getHeight()
	digImage:setScale(scaleX, scaleY)
	local xPos = (inc * (self.x-1)) * width
	local yPos = (inc * (self.y-1)) * width + startY
	digImage:setPosition(xPos, yPos)
	print(digImage:getWidth())
	stage:addChild(digImage)
	self.cellCheck = function(x, y)
		if frameCounter == 0 then
			stage:removeChild(digImage)
			self.digging = false
			return true
		else 
			frameCounter = frameCounter - 1
			return false
		end
	end
	self.digImage = digImage
end

function Player:loopStart()
	print("Loop started")
end

function Player:loopEnd()
	print("Loop ended")
end

function Player:update()
	if not self.action then return end
	
	if (self.xSpeed == 0 and self.ySpeed == 0) and not self.digging then
		if # self.loadedMoves ~= 0 then
			move = self.loadedMoves[1]
			table.remove(self.loadedMoves, 1)
			move:execute()
		end
		return
	end
	
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
 
	x = x + (self.xSpeed * self.xDirection)
	y = y + (self.ySpeed * self.yDirection)
 
	self.playerImage:setPosition(x, y)
--	print(x .. " " .. y)
end

function Player:destroy()
	stage:removeChild(self.playerImage)
	stage:removeChild(self.scoreField)
	if self.digImage ~= nil then
		stage:removeChild(self.digImage)
	end
	
end

local Leprechaun = {}
Leprechaun.__index = Leprechaun
setmetatable(Leprechaun, {
  __index = Player,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})
function Leprechaun:_init(grid)
	self.score = 0
	self.loadedMoves = {}
	self.action = false
	self.initX = 5
	self.initY = 6
	self.name = "Leprechaun"
	self.velocity = (width / grid.numRows) / 16
	self.x = self.initX
	self.y = self.initY
	self.grid = grid
	imageScale = width / grid.numRows
	inc = 1 / grid.numRows
	startY = height / 4
	local lepImage = Bitmap.new(Texture.new("images/leprechaun.png"))
	scaleX = imageScale / lepImage:getWidth()
	scaleY = imageScale / lepImage:getHeight()

	lepImage:setScale(scaleX, scaleY)
	self.xPosStart = (inc * (self.x-1)) * width
	self.yPosStart = (inc * (self.y-1)) * width + startY
	lepImage:setPosition(self.xPosStart, self.yPosStart)
	stage:addChild(lepImage)
	self.playerImage = lepImage
	self.xDirection = 0
	self.yDirection = 0
	self.xSpeed = 0
	self.ySpeed = 0
end

M.Player = Player
M.Leprechaun = Leprechaun

return M