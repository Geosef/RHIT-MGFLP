-- program is being exported under the TSU exception
Character = Core.class(SceneObject)
function Character:init(parent, playerImagePath, startX, startY)
	self.parent = parent
	self.playerImage = Bitmap.new(Texture.new(playerImagePath))
	self:addChild(self.playerImage)
	self.x = startX
	self.y = startY
	self.animating = false
	self.eventIndex = 1
end

function Character:postInit()
	self:initAttributes(self.parent.grid)
end

function Character:initAttributes()
	print("initAttributes() not implemented!")
end

function Character:getGridPosition()
	return self.x, self.y
end

function Character:nextMove()
	print(self.name)
	if self.eventQueue then
		if self.animating then
			self.eventIndex = self.eventIndex + 1
		else
			self.animating = true
			self.eventIndex = 1
		end
		self:runEvent(self.eventQueue[self.eventIndex])
		print("X: " .. self.x .. "Y: " .. self.y)
	end
	--[[
	if keyFrame then
		if self.animating then
			-- next event in turn
			self.eventIndex = self.eventIndex + 1
			self:runEvent(self.eventQueue[self.eventIndex])
			print("X: " .. self.x .. "Y: " .. self.y)
		else
			print("not animating")
			-- start list of events
			self.animating = true
			self.eventIndex = 1
			local event = nil
			if self.eventQueue then
				event = self.eventQueue[self.eventIndex]
			else
				return
			end
			self:runEvent(event)
			print("X: " .. self.x .. "Y: " .. self.y)
		end
	else
		-- continue running event
		
	end
	]]
end

function Character:setEventQueue(queue)
	self.eventQueue = queue
end

function Character:runEvent(event)
	if not event then
		self.animating = false
		return
	end
	if event.params then
		local nParams = table.getn(event.params)
		if nParams == 1 then
			CommandLib[event.name](self, event.params[1])
		elseif nParams == 2 then
			CommandLib[event.name](self, event.params[1], event.params[2])
		end
	else
		CommandLib[event.name](self)
	end
end

function Character:endTurn()
	print("endTurn() not implemented!")
end

Player = Core.class(Character)

function Player:init(parent, playerImagePath, startX, startY, playerNum)
	self.playerNum = playerNum
	--self:initMoveBuffer()
	--self:setScoreField(playerNum)
end

function Player:initAttributes(grid)
	if self.playerNum == 1 then
		self.name = "Player 1"
	elseif self.playerNum == 2 then
		self.name = "Player 2"
	else
		print("Invalid Player Number")
		return
	end
	--self.parent.grid:drawPlayer(self.playerNum, self.x, self.y)
	--self.velocity = (WINDOW_WIDTH / grid.gridSize) / EVENT_DURATION
	self.xDirection = 0
	self.yDirection = 0
	self.xSpeed = 0
	self.ySpeed = 0
end

function Player:endTurn()
	
end


CollectEnemy = Core.class(Character)

function CollectEnemy:init(parent, playerImagePath, startX, startY)
	
end

function CollectEnemy:initAttributes(grid)
	self.name = "Collect Enemy"
	self.xDirection = 0
	self.yDirection = 0
	self.xSpeed = 0
	self.ySpeed = 0
end

--[[
Character = Core.class(SceneObject)
function Character:init()
	
end

function Character:moveRight(param)
	if self.x >= self.grid.gridSize then
		return
	end
	self.x = self.x + 1
	self.xDirection = 1
	self.yDirection = 0
	self.xSpeed = self.velocity
	self.ySpeed = 0
	self.cellCheck = function(x, y)
		return x >= ((self.x - 1) / self.grid.gridSize) * WINDOW_WIDTH
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
		return x <= ((self.x - 1) / self.grid.gridSize) * WINDOW_WIDTH
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
		return y <= ((self.y - 1) / self.grid.gridSize) * WINDOW_WIDTH + (WINDOW_HEIGHT / 4)
	end
end

function Character:moveDown(param)
	if self.y >= self.grid.gridSize then
		return
	end
	self.y = self.y + 1
	self.xDirection = 0
	self.yDirection = 1
	self.xSpeed = 0
	self.ySpeed = self.velocity
	self.cellCheck = function(x, y)
		return y >= ((self.y - 1) / self.grid.gridSize) * WINDOW_WIDTH + (WINDOW_HEIGHT / 4)
	end
end

function Character:update(nextMoveFlag)
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
end

function Character:nextEvent()
end

function Character:initMoveBuffer()
	self.loadedMoves = {}
	self.maxMoves = maxMoves
	self.activeMove = nil
	self.action = false
end

function Character:enterGrid(grid, initX, initY)
	self.x = initX
	self.y = initY
	self.grid = grid
	local imageScale = self.grid:getWidth() / self.grid.gridSize
	local inc = 1 / self.grid.gridSize
	local scaleX = imageScale / self:getWidth()
	local scaleY = imageScale / self:getHeight()
	self:setScale(scaleX, scaleY)
	local xPosStart = (inc * (self.x-1)) * self.grid:getWidth()
	local yPosStart = (inc * (self.y-1)) * self.grid:getHeight()
	self:setPosition(xPosStart, yPosStart)
end

Player = Core.class(Character)

EVENT_DURATION = 16

function Player:init()
	self:initMoveBuffer()
	--self:setScoreField(playerNum)
end

function Player:initPlayerAttributes(grid, playerNum, maxMoves)
	if playerNum == 1 then
		self.name = "Player 1"
		self.initX = 1
		self.initY = 1
	elseif playerNum == 2 then
		self.name = "Player 2"
		self.initX = grid.gridSize
		self.initY = grid.gridSize
	end
	self:enterGrid(grid, self.initX, self.initY)
	self.velocity = (WINDOW_WIDTH / grid.gridSize) / EVENT_DURATION
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

ComputerControlled = Core.class(Player)
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
	self.velocity = (WINDOW_WIDTH / grid.gridSize) / EVENT_DURATION
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
]]