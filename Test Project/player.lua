local M = {}


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

function Player:_init(grid, player1, maxMoves)
	self.score = 0
	self.loadedMoves = {}
	self.activeMove = nil
	self.digs = 3
	self.maxMoves = maxMoves
	local textField = TextField.new(nil, "Score: " .. self.score)
	self.velocity = (WINDOW_WIDTH / grid.numRows) / EVENT_DURATION
	print("Velocity " .. self.velocity)
	
	stage:addChild(textField)
	self.scoreField = textField
	self.action = false
	self.shovelImage = Bitmap.new(Texture.new("images/shovel.png"))
	self.brokenShovelImage = Bitmap.new(Texture.new("images/brokenshovel.png"))
	self.shovelCount = TextField.new(nil, self.digs)
	local scaleX = WINDOW_WIDTH / self.shovelImage:getWidth() / 12
	local scaleY = WINDOW_HEIGHT / self.shovelImage:getHeight() / 15
	self.shovelCount:setScale(2.5)
	self.shovelCount:setAlpha(0.3)
	self.shovelImage:setScale(scaleX, scaleY)
	self.brokenShovelImage:setScale(scaleX, scaleY)
	if player1 then
		self.initX = 1
		self.initY = 1
		self.name = "Player 1"
		textField:setX(10)
		textField:setY(10)
		shovelImageXPos = 5
		shovelImageYPos = WINDOW_HEIGHT - 35
	else
		self.initX = grid.numRows
		self.initY = grid.numRows
		self.name = "Player 2"
		textField:setX(10)
		textField:setY(20)
		shovelImageXPos = WINDOW_WIDTH - 35
		shovelImageYPos = WINDOW_HEIGHT - 35
	end
	self.shovelImage:setPosition(shovelImageXPos, shovelImageYPos)
	self.brokenShovelImage:setPosition(shovelImageXPos, shovelImageYPos)
	self.shovelCount:setPosition(shovelImageXPos + 6, shovelImageYPos + 25)
	stage:addChild(self.shovelImage)
	stage:addChild(self.shovelCount)
	self.x = self.initX
	self.y = self.initY
	self.grid = grid
	local imageScale = WINDOW_WIDTH / grid.numRows
	local inc = 1 / grid.numRows
	startY = WINDOW_HEIGHT / 4
	local playerImage = Bitmap.new(Texture.new("images/player.png"))
	local scaleX = imageScale / playerImage:getWidth()
	local scaleY = imageScale / playerImage:getHeight()
	
	playerImage:setScale(scaleX, scaleY)
	self.xPosStart = (inc * (self.x-1)) * WINDOW_WIDTH
	self.yPosStart = (inc * (self.y-1)) * WINDOW_WIDTH + startY
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
	if self.digging then
		stage:removeChild(self.digImage)
		self.digging = false
	end
	if self.x == self.initX and self.y == self.initY and self.digs ~= nil then
		self.digs = 3
		self.shovelCount:setText(self.digs)
		stage:removeChild(self.brokenShovelImage)
		stage:addChild(self.shovelImage)
	end
	if cell.gold then
		print(self.name .. " picked up gold!")
		self.score = self.score + 1
		self.scoreField:setText("Score: " .. self.score)
		cell.gold = false
		stage:removeChild(cell.goldImage)
	end
	if cell.gem then
		print (self.name .. " picked up a gem!")
		self.score = self.score + 4
		self.scoreField:setText("Score: " .. self.score)
		cell.gem = false
		stage:removeChild(cell.gemImage)
	end
	
end

function Player:moveRight(param)
	if self.x >= self.grid.numRows then
		return
	end
	self.x = self.x + 1
	self.xDirection = 1
	self.yDirection = 0
	self.xSpeed = self.velocity
	self.ySpeed = 0
	self.cellCheck = function(x, y)
		return x >= ((self.x - 1) / self.grid.numRows) * WINDOW_WIDTH
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
		return x <= ((self.x - 1) / self.grid.numRows) * WINDOW_WIDTH
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
		return y <= ((self.y - 1) / self.grid.numRows) * WINDOW_WIDTH + (WINDOW_HEIGHT / 4)
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
		return y >= ((self.y - 1) / self.grid.numRows) * WINDOW_WIDTH + (WINDOW_HEIGHT / 4)
	end
end

function Player:dig()
	if self.digs == 0 then
		print(self.name .. " out of digs!")
		return
	end
	local cell = self.grid.rows[self.y][self.x]
	if cell.hiddenTreasure then
		print(self.name .. " dug up treasure!")
		self.score = self.score + 8
		self.scoreField:setText("Score: " .. self.score)
		cell:toggleHiddenTreasure()
	else
		print(self.name .. " found nothing.")
	end
	self.digging = true
	local frameCounter = 30
	local imageScale = WINDOW_WIDTH / self.grid.numRows
	local startY = WINDOW_HEIGHT / 4
	local digImage = Bitmap.new(Texture.new("images/diggingActionCell.png"))
	local scaleX = imageScale / digImage:getWidth()
	local scaleY = imageScale / digImage:getHeight()
	digImage:setScale(scaleX, scaleY)
	local xPos = (inc * (self.x-1)) * WINDOW_WIDTH
	local yPos = (inc * (self.y-1)) * WINDOW_WIDTH + startY
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
	self.digs = self.digs - 1
	self.shovelCount:setText(self.digs)
	if self.digs == 0 then
		stage:removeChild(self.shovelImage)
		stage:addChild(self.brokenShovelImage)
	end
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
			self.activeMove = move
			move:execute()
		end
		return
	end
	
	local x,y = self.playerImage:getPosition()
	if self.activeMove:isFinished() then
		self:finishMove()
		if # self.loadedMoves == 0 then
			self.xSpeed = 0
			self.ySpeed = 0
			self.action = false
			self.activeMove = nil
		else
			move = self.loadedMoves[1]
			table.remove(self.loadedMoves, 1)
			self.activeMove = move
			move:execute()
		end
		return
	end
	self.activeMove:tick()
 
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
function Leprechaun:_init(grid, maxMoves, init)
	self.score = 0
	self.loadedMoves = {}
	self.maxMoves = maxMoves
	self.action = false
	self.initX = init[1]
	self.initY = init[2]
	self.name = "Leprechaun"
	self.velocity = (WINDOW_WIDTH / grid.numRows) / 16
	self.x = self.initX
	self.y = self.initY
	self.grid = grid
	imageScale = WINDOW_WIDTH / grid.numRows
	inc = 1 / grid.numRows
	startY = WINDOW_HEIGHT / 4
	local lepImage = Bitmap.new(Texture.new("images/leprechaun.png"))
	scaleX = imageScale / lepImage:getWidth()
	scaleY = imageScale / lepImage:getHeight()

	lepImage:setScale(scaleX, scaleY)
	self.xPosStart = (inc * (self.x-1)) * WINDOW_WIDTH
	self.yPosStart = (inc * (self.y-1)) * WINDOW_WIDTH + startY
	lepImage:setPosition(self.xPosStart, self.yPosStart)
	stage:addChild(lepImage)
	self.playerImage = lepImage
	self.xDirection = 0
	self.yDirection = 0
	self.xSpeed = 0
	self.ySpeed = 0
end

function Leprechaun:finishMove()
	self.xDirection = 0
	self.yDirection = 0
	self.xSpeed = 0
	self.ySpeed = 0
end

M.Player = Player
M.Leprechaun = Leprechaun

return M