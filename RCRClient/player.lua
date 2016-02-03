-- program is being exported under the TSU exception

Character = Core.class(Character)
function Character:init()
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

function Character:enterGrid(grid, imagePath)
	self.x = self.initX
	self.y = self.initY
	self.grid = grid
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
	self.playerImage = playerImage
end

function Character:show()
	stage:addChild(self.playerImage)
end

function Character:destroy()
	stage:removeChild(self.playerImage)
end


Player = Core.class(Player)

EVENT_DURATION = 16

function Player:init(grid, playerNum, imagePath, maxMoves)
	self:initPlayerAttributes(grid, playerNum, maxMoves)
	self:initMoveBuffer()
	self:enterGrid(grid, imagePath)
	self:setScoreField(playerNum)
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

function Player:setScoreField(playerNum)
	self.score = 0
	local playerName = ""
	local textField = TextField.new(nil, self.name .. ": " .. self.score)
	textField:setTextColor(0xff0000)
	if playerNum == 1 then
		textField:setX(10)
		textField:setY(10)
	elseif playerNum == 2 then
		textField:setX(10)
		textField:setY(20)
	end
	self.scoreField = textField
end

function Player:changeScore(points)
	self.score = self.score + points
	self.scoreField:setText(self.name .. ": " .. self.score)
end

--implemented by subclass
function Player:setupPlayerGameRules()
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

CollectPlayer = Core.class(CollectPlayer)
function CollectPlayer(grid, isPlayer1, maxMoves)
	local self = Player(grid, isPlayer1, "images/astronaut.png", maxMoves)
	
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
	
	local incrementScore = function(points)
		self:changeScore(points)
	end

	local reset = function()
		self.score = 0
		self.scoreField:setText("Score: " .. self.score)
		self.playerImage:setPosition(self.x, self.y)
		self.action = true
		self.collectible = nil
	end
	
	local update = function()
		if not self.action then return end
		
		if (self.xSpeed == 0 and self.ySpeed == 0) then
			if # self.loadedMoves ~= 0 then
				move = self.loadedMoves[1]
				table.remove(self.loadedMoves, 1)
				self.activeMove = move
				move:execute()
			else
				self.action = false
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
	
	self.lastCell = nil
	local finishMove = function()
		local cell = self.grid.rows[self.y][self.x]
		if self.lastCell ~= nil then
			self.grid.rows[self.lastCell.y][self.lastCell.x].currentChar = nil
		end
		if self.grid.rows[self.y][self.x].currentChar ~= nil then
			if self.grid.rows[self.y][self.x].currentChar.name == "Alien" then
				print(self.name .. " ran into an alien! Lost some coins!")
				self.incrementScore(-7)
			else 
				print(self.name .. " ran into " .. cell.currentChar.name .. "! Stole some coins!")
				self.grid.rows[self.y][self.x].currentChar.incrementScore(-3)
				self.incrementScore(3)
			end
		end
		self.grid.rows[self.y][self.x].currentChar = self
		self.lastCell = self.grid.rows[self.y][self.x]
		self.xDirection = 0
		self.yDirection = 0
		self.xSpeed = 0
		self.ySpeed = 0
		if cell.hasEnemy then
			
		end
		if cell.collectible ~= nil then
			print(self.name .. " passed over " .. cell.collectible.name)
			didCollect = cell.collectible.doFunc(self)
			if didCollect then
				collectible = cell:removeCollectible()
			end
		end
		
	end
	
	local setAction = function(newActionSetting)
		self.action = newActionSetting
	end
	
	local getAction = function()
		return self.action
	end
	
	local getX = function()
		return self.x
	end
	
	local getY = function()
		return self.y
	end
	
	local getXSpeed = function()
		return self.xSpeed
	end
	
	local getYSpeed = function()
		return self.ySpeed
	end
	
	local getXDirection = function()
		return self.xDirection
	end
	
	local getYDirection = function()
		return self.yDirection
	end
	
	local getScore = function()
		return self.score
	end
	
	local show = function()
		stage:addChild(self.playerImage)
		stage:addChild(self.scoreField)
	end
	
	local destroy = function()
		stage:removeChild(self.playerImage)
		stage:removeChild(self.scoreField)
	end
	
	self.finishMove = finishMove
	self.incrementScore = incrementScore
	return { 
		loadedMoves = self.loadedMoves,
		moveRight = moveRight,
		moveLeft = moveLeft,
		moveUp = moveUp,
		moveDown = moveDown,
		endTurn = endTurn,
		reset = reset,
		update = update,
		destroy = destroy,
		setAction = setAction,
		getAction = getAction,
		getX = getX,
		getY = getY,
		getXSpeed = getXSpeed,
		getYSpeed = getYSpeed,
		getXDirection = getXDirection,
		getYDirection = getYDirection,
		getScore = getScore,
		incrementScore = incrementScore,
		show = show
	}
end

ComputerControlled = Core.class(ComputerControlled)
function ComputerControlled:init(grid, maxMoves, imagePath, name, init)
	self:initComputerAttributes(grid, name, init, maxMoves)
	self:initMoveBuffer()
	self:enterGrid(grid, imagePath)
end

function ComputerControlled:initComputerAttributes(grid, name, init, maxMoves)
	self.initX = init.x
	self.initY = init.y
	self.name = name
	self.maxMoves = maxMoves
	self.velocity = (WINDOW_WIDTH / grid.numRows) / EVENT_DURATION
	self.xDirection = 0
	self.yDirection = 0
	self.xSpeed = 0
	self.ySpeed = 0
end

--implemented by subclass
function ComputerControlled:setupPlayerGameRules()
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