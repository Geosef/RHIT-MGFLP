local M = {}

local Character = {}
Character.__index = Character

setmetatable(Character, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Character:__init()
end

function Character:moveRight(param)
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

function Character:moveLeft(param)
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

function Character:moveUp(param)
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

function Character:moveDown(param)
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

function Character:initMoveBuffer()
	self.loadedMoves = {}
	self.maxMoves = maxMoves
	self.activeMove = nil
	self.action = false
end

function Character:enterGrid(grid, imagePath, testing)
	self.x = self.initX
	self.y = self.initY
	self.grid = grid
	if testing then
		return
	end
	local imageScale = WINDOW_WIDTH / self.grid.numRows
	local inc = 1 / self.grid.numRows
	local startY = WINDOW_HEIGHT / 4
	local playerImage = Bitmap.new(Texture.new(imagePath))
	local scaleX = imageScale / playerImage:getWidth()
	local scaleY = imageScale / playerImage:getHeight()
	playerImage:setScale(scaleX, scaleY)
	self.xPosStart = (inc * (self.x-1)) * WINDOW_WIDTH
	self.yPosStart = (inc * (self.y-1)) * WINDOW_WIDTH + startY
	playerImage:setPosition(self.xPosStart, self.yPosStart)
	stage:addChild(playerImage)
	self.playerImage = playerImage
end


local Player = {}
Player.__index = Player

setmetatable(Player, {
  __index = Character,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

EVENT_DURATION = 16

function Player:_init(grid, playerNum, imagePath, maxMoves, testing)
	self:initPlayerAttributes(grid, playerNum, maxMoves)
	self:initMoveBuffer()
	self:enterGrid(grid, imagePath, testing)
	self:setScoreField(playerNum, testing)
end

function Player:initPlayerAttributes(grid, playerNum, maxMoves)
	if playerNum == 1 then
		self.name = "Player 1"
		self.initX = 1
		self.initY = 1
	elseif playerNum == 2 then
		self.name = "Player 2"
		self.initX = grid.numRows
		self.initY = grid.numRows
	end
	self.velocity = (WINDOW_WIDTH / grid.numRows) / EVENT_DURATION
	self.xDirection = 0
	self.yDirection = 0
	self.xSpeed = 0
	self.ySpeed = 0
	self.maxMoves = maxMoves
end

function Player:setScoreField(playerNum, testing)
	self.score = 0
	local playerName = ""
	if testing then
		return
	end
	local textField = TextField.new(nil, self.name .. ": " .. self.score)
	if playerNum == 1 then
		textField:setX(10)
		textField:setY(10)
	elseif playerNum == 2 then
		textField:setX(10)
		textField:setY(20)
	end
	stage:addChild(textField)
	self.scoreField = textField
end

--implemented by subclass
function Player:setupPlayerGameRules(testing)
	print("Player Game rules not implemented")
end

--implemented by subclass
function Player:reset()
	print("Player reset not implemented")
end

--implemented by subclass
function Player:endTurn()
	print("Player endTurn not implemented")
end

-- implemented by subclass
function Player:finishMove()
	print("Player finishMove not implemented")
end

--implemented by subclass
function Player:update()
	print("Player update not implemented!")
end

-- implemented by subclass
function Player:destroy()
	print("Player destroy not implemented!")
end

function CollectPlayer(grid, isPlayer1, maxMoves, testing)
	local self = Player(grid, isPlayer1, "images/player.png", maxMoves, testing)
	
	local setupPlayerGameRules = function(testing)
		--Game specific
		self.metalDetect = 0
		
		-- dig stuff
		self.digs = 3
		if testing then
			return
		end
		self.shovelImage = Bitmap.new(Texture.new("images/shovel.png"))
		self.brokenShovelImage = Bitmap.new(Texture.new("images/brokenshovel.png"))
		self.shovelCount = TextField.new(nil, self.digs)
		local scaleX = WINDOW_WIDTH / self.shovelImage:getWidth() / 12
		local scaleY = WINDOW_HEIGHT / self.shovelImage:getHeight() / 15
		self.shovelCount:setScale(2.5)
		self.shovelCount:setAlpha(0.3)
		self.shovelImage:setScale(scaleX, scaleY)
		self.brokenShovelImage:setScale(scaleX, scaleY)
		
		--player 1 vs player 2 init
		if isPlayer1 then
			shovelImageXPos = 5
			shovelImageYPos = WINDOW_HEIGHT - 35
		else
			shovelImageXPos = WINDOW_WIDTH - 35
			shovelImageYPos = WINDOW_HEIGHT - 35
		end
		
		self.shovelImage:setPosition(shovelImageXPos, shovelImageYPos)
		self.brokenShovelImage:setPosition(shovelImageXPos, shovelImageYPos)
		self.shovelCount:setPosition(shovelImageXPos + 6, shovelImageYPos + 25)
		stage:addChild(self.shovelImage)
		stage:addChild(self.shovelCount)
	end
	
	setupPlayerGameRules(testing)
	
	local finishMove = function()
		local cell = self.grid.rows[self.y][self.x]
		self.xDirection = 0
		self.yDirection = 0
		self.xSpeed = 0
		self.ySpeed = 0
		if self.digging then
			if not testing then
				stage:removeChild(self.digImage)
			end
			self.digging = false
		end
		if self.x == self.initX and self.y == self.initY and self.digs ~= nil then
			self.digs = 3
			if not testing then 
				self.shovelCount:setText(self.digs)
			end
			
		end
		if cell.gold then
			print(self.name .. " picked up gold!")
			self.score = self.score + 1
			cell.gold = false
			if not testing then
				self.scoreField:setText("Score: " .. self.score)
				stage:removeChild(cell.goldImage)
			end
			
		end
		if cell.gem then
			print (self.name .. " picked up a gem!")
			self.score = self.score + 4
			cell.gem = false
			if not testing then
				self.scoreField:setText("Score: " .. self.score)
				stage:removeChild(cell.gemImage)
			end
			
		end
		if cell.collectible ~= nil then
			print(self.name .. " picked up a powerup!")
			collectible = cell:removeCollectible()
			collectible:doFunc(self)
		end
		self.grid:metalDetect(cell)
	end
	
	local endTurn = function()
		if self.metalDetect > 0 then
			self.metalDetect = self.metalDetect - 1
			if self.metalDetect == 0 then
				print("No more battery for metal detector!")
			end
		end	
	end
	
	local moveRight = function(param)
		self:moveRight(param)
	end
	
	local moveLeft = function(param)
		self:moveLeft(param)
	end
	
	local moveUp = function(param)
		self:moveUp(param)
	end
	
	local moveDown = function(param)
		self:moveDown(param)
	end
	
	local dig = function()
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
	
	local addDigs = function(numDigsToAdd)
		self.digs = self.digs + numDigsToAdd
		if self.digs > 0 then
			self.shovelCount:setText(self.digs)
		else
			stage:removeChild(self.shovelImage)
			stage:addChild(self.brokenShovelImage)
		end
	end
	
	local setMetalDetection = function()
		if self.metalDetect == 0 then
			self.metalDetect = 3
		end
	end
	
	local reset = function()
		self.score = 0
		self.scoreField:setText("Score: " .. self.score)
		self.playerImage:setPosition(self.x, self.y)
		self.action = true
		self.metalDetect = 0
		self.collectible = nil
	end
	
	local update = function()
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
			self.finishMove()
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
	end
	
	local destroy = function()
		stage:removeChild(self.playerImage)
		stage:removeChild(self.scoreField)
		if self.digImage ~= nil then
			stage:removeChild(self.digImage)
		end
	end
	
	local setAction = function(newActionSetting)
		self.action = newActionSetting
	end
	
	local getAction = function()
		return self.action
	end
	
	self.finishMove = finishMove
	self.setMetalDetection = setMetalDetection
	self.addDigs = addDigs
	return {
		loadedMoves = self.loadedMoves,
		moveRight = moveRight,
		moveLeft = moveLeft,
		moveUp = moveUp,
		moveDown = moveDown,
		dig = dig,
		endTurn = endTurn,
		reset = reset,
		update = update,
		destroy = destroy,
		setAction = setAction,
		getAction = getAction
	}
end

local ComputerControlled = {}
ComputerControlled.__index = ComputerControlled
setmetatable(ComputerControlled, {
  __index = Character,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})
function ComputerControlled:_init(grid, maxMoves, imagePath, name, init, testing)
	self:initComputerAttributes(grid, name, init, maxMoves)
	self:initMoveBuffer()
	print(imagePath)
	self:enterGrid(grid, imagePath, testing)
end

function ComputerControlled:initComputerAttributes(grid, name, init, maxMoves)
	self.initX = init[1]
	self.initY = init[2]
	self.name = name
	self.maxMoves = maxMoves
	self.velocity = (WINDOW_WIDTH / grid.numRows) / EVENT_DURATION
	self.xDirection = 0
	self.yDirection = 0
	self.xSpeed = 0
	self.ySpeed = 0
end

--implemented by subclass
function ComputerControlled:setupPlayerGameRules(testing)
	print("Computer Game rules not implemented")
end

--implemented by subclass
function ComputerControlled:reset()
	print("Computer reset not implemented")
end

--implemented by subclass
function ComputerControlled:endTurn()
	print("Computer endTurn not implemented")
end

-- implemented by subclass
function ComputerControlled:finishMove()
	print("Computer finishMove not implemented")
end

--implemented by subclass
function ComputerControlled:update()
	print("Computer update not implemented!")
end

-- implemented by subclass
function ComputerControlled:destroy()
	print("Computer destroy not implemented!")
end

function Leprechaun(grid, maxMoves, init, testing)
	local self = ComputerControlled(grid, maxMoves, "images/leprechaun.png", "Leprechaun", init, testing)
	
	local finishMove = function()
		self.xDirection = 0
		self.yDirection = 0
		self.xSpeed = 0
		self.ySpeed = 0
	end
	
	local update = function()
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
			self.finishMove()
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
	end
	
	local getAction = function()
		return self.action
	end
	
	local setAction = function(action)
		self.action = action
	end
	
	local moveRight = function(param)
		self:moveRight(param)
	end
	
	local moveLeft = function(param)
		self:moveLeft(param)
	end
	
	local moveUp = function(param)
		self:moveUp(param)
	end
	
	local moveDown = function(param)
		self:moveDown(param)
	end
	
	self.finishMove = finishMove
	return {
		loadedMoves = self.loadedMoves,
		moveRight = moveRight,
		moveLeft = moveLeft,
		moveUp = moveUp,
		moveDown = moveDown,
		getAction = getAction,
		setAction = setAction,
		update = update
	}
end

M.CollectPlayer = CollectPlayer
M.Leprechaun = Leprechaun

return M