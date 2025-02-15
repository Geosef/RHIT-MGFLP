-- program is being exported under the TSU exception
Character = Core.class(SceneObject)
function Character:init(parent, playerImagePath, startX, startY)
	self.parent = parent
	self.grid = self.parent.grid
	self.playerImagePath = playerImagePath 
	self:addChild(Bitmap.new(Texture.new(self.playerImagePath)))
	self.x = startX
	self.y = startY
	self.animating = false
	self.frameAction = nil
	self.eventIndex = 1
	self.xVelocity = 0
	self.yVelocity = 0
	self.xDist = 0
	self.yDist = 0
	self.digging = false
	self.loopStack = {}
end

function Character:postInit()
	self:initAttributes()
end

function Character:initAttributes()
	print("initAttributes() not implemented!")
end

function Character:getGridPosition()
	return self.x, self.y
end

function Character:update(frame)
	if frame == self.parent.moveDuration then
		local moveEnded = self:endMove()
		-- keyFrame
		if self.eventQueue then
			if not moveEnded then
				return
			end
			if self.animating then
				self.eventIndex = self.eventIndex + 1
			else
				self.animating = true
			end
			local currEvent = self.eventQueue[self.eventIndex]
			self:runEvent(currEvent)
			local currLoop = self.loopStack[table.getn(self.loopStack)]
			if currLoop and currEvent then
				currLoop:addCommand(currEvent)
			end
		end
	else
		-- Just updating
		if self.eventQueue then
			if self.animating and self.frameAction then
				self:frameAction(frame)
			end
		end
	end
end

function Character:setEventQueue(queue)
	self.eventQueue = queue
end

function Character:runEvent(event)
	if not event then
		self.animating = false
		self:endTurn()
		return
	end
	local command = CommandLib[event.name]
	if not command then print('no command found') end
	if event.params then
		local nParams = table.getn(event.params)
		if nParams == 1 then
			command(self, event.params[1])
		elseif nParams == 2 then
			command(self, event.params[1], event.params[2])
		end
	else
		command(self)
	end
end

function Character:endTurn()
	print("endTurn() not implemented!")
end

function Character:move(frame)
	self:setPosition(self:getX() + ((self.xVelocity / self.parent.moveDuration) * self.parent.characterMoveDistance), 
	self:getY() + ((self.yVelocity / self.parent.moveDuration) * self.parent.characterMoveDistance))
	--print("X: " .. self:getX())
	--print("Y: " .. self:getY())
end

function Character:wrapAroundMove(frame)
	if frame ~= self.parent.moveDuration / 2 then
		self:setPosition(self:getX() + ((self.xVelocity / self.parent.moveDuration) * self.parent.characterMoveDistance), 
			self:getY() + ((self.yVelocity / self.parent.moveDuration) * self.parent.characterMoveDistance))
	else
		local xCoord
		local yCoord
		if self.xVelocity == 1 then
			xCoord = -(self.parent.characterMoveDistance / 2)
			yCoord = self:getY()			
		elseif self.xVelocity == -1 then
			xCoord = (self.parent.grid.gridSize - 1/2) * self.parent.characterMoveDistance
			yCoord = self:getY()	
		elseif self.yVelocity == 1 then
			xCoord = self:getX()
			yCoord = -(self.parent.characterMoveDistance / 2)
		elseif self.yVelocity == -1 then
			xCoord = self:getX()
			yCoord = (self.parent.grid.gridSize - 1/2) * self.parent.characterMoveDistance
		end
		self:setPosition(xCoord, yCoord)	
	end
	
end

function Character:moveRight(magnitude)
	local moveType = nil
	if self.x < self.grid.gridSize then
		moveType = self.move
	else
		moveType = self.wrapAroundMove
	end
	
	local nextX = self.x
	local maxMag = magnitude
	for i=1, magnitude do
		nextX = nextX + 1
		if not (nextX < self.grid.gridSize + 1) then
			nextX = 1
		end
		local nextCell = self.grid:getCellAt(nextX, self.y)
		if nextCell:getWall() then
			maxMag = i - 1
			break
		end
	end
	if maxMag == 0 then
		self:xMovePrep(0, maxMag, nil)
	else
		self:xMovePrep(1, maxMag, moveType)
	end
end

function Character:moveLeft(magnitude)
	local moveType = nil
	if self.x > 1 then
		moveType = self.move
	else
		moveType = self.wrapAroundMove
	end
	
	local nextX = self.x
	local maxMag = magnitude
	for i=1, magnitude do
		nextX = nextX - 1
		if not (nextX > 0) then
			nextX = self.grid.gridSize
		end
		local nextCell = self.grid:getCellAt(nextX, self.y)
		if nextCell:getWall() then
			maxMag = i - 1
			break
		end
	end
	if maxMag == 0 then
		self:xMovePrep(0, maxMag, nil)
	else
		self:xMovePrep(-1, maxMag, moveType)
	end
end

function Character:xMovePrep(velo, dist, action)
	self.xVelocity = velo
	self.xDist = dist
	self.frameAction = action
end

function Character:moveUp(magnitude)	
	local moveType = nil
	if self.y > 1 then
		moveType = self.move
	else
		moveType = self.wrapAroundMove
	end
	
	local nextY = self.y
	local maxMag = magnitude
	for i=1, magnitude do
		nextY = nextY - 1
		if not (nextY > 0) then
			nextY = self.grid.gridSize
		end
		local nextCell = self.grid:getCellAt(self.x, nextY)
		print('Next cell x: ' .. nextCell.x)
		print('Next cell y: ' .. nextCell.y)
		if nextCell:getWall() then
			maxMag = i - 1
			break
		end
	end
	if maxMag == 0 then
		self:yMovePrep(0, maxMag, nil)
	else
		self:yMovePrep(-1, maxMag, moveType)
	end
end

function Character:moveDown(magnitude)
	local moveType = nil
	if self.y < self.grid.gridSize then
		moveType = self.move
	else
		moveType = self.wrapAroundMove
	end
	
	local nextY = self.y
	local maxMag = magnitude
	for i=1, magnitude do
		nextY = nextY + 1
		if not (nextY < self.grid.gridSize + 1) then
			nextY = 1
		end
		local nextCell = self.grid:getCellAt(self.x, nextY)
		if nextCell:getWall() then
			maxMag = i - 1
			break
		end
	end
	if maxMag == 0 then
		self:yMovePrep(0, maxMag, nil)
	else
		self:yMovePrep(1, maxMag, moveType)
	end
end

function Character:yMovePrep(velo, dist, action)
	self.yVelocity = velo
	self.yDist = dist
	self.frameAction = action
end

function Character:jump(direction)
	local maxMag = 2
	local nextX = self.x
	local nextY = self.y
	
	if direction == "N" then
		local moveType = nil
		if self.y > 1 then
			moveType = self.move
		else
			moveType = self.wrapAroundMove
		end
		
		nextY = nextY - 2
		if nextY == 0 then
			nextY = self.grid.gridSize
		elseif nextY == -1 then
			nextY = self.grid.gridSize - 1
		end
		local nextCell = self.grid:getCellAt(nextX, nextY)
		if nextCell:getWall() then
			self:yMovePrep(0, maxMag, nil)
		else
			self:yMovePrep(-1, maxMag, moveType)
		end
	elseif direction == "S" then
		local moveType = nil
		if self.y < self.grid.gridSize then
			moveType = self.move
		else
			moveType = self.wrapAroundMove
		end
		
		nextY = nextY + 2
		if nextY == (self.grid.gridSize + 1) then
			nextY = 1
		elseif nextY == (self.grid.gridSize + 2) then
			nextY = 2
		end
		local nextCell = self.grid:getCellAt(nextX, nextY)
		if nextCell:getWall() then
			self:yMovePrep(0, maxMag, nil)
		else
			self:yMovePrep(1, maxMag, moveType)
		end
	elseif direction == "E" then
		local moveType = nil
		if self.x < self.grid.gridSize then
			moveType = self.move
		else
			moveType = self.wrapAroundMove
		end
		
		nextX = nextX + 2
		if nextX == (self.grid.gridSize + 1) then
			nextX = 1
		elseif nextX == -(self.grid.gridSize + 2) then
			nextX = 2
		end
		local nextCell = self.grid:getCellAt(nextX, nextY)
		if nextCell:getWall() then
			self:xMovePrep(0, maxMag, nil)
		else
			self:xMovePrep(1, maxMag, moveType)
		end
	elseif direction == "W" then
		local moveType = nil
		if self.x > 1 then
			moveType = self.move
		else
			moveType = self.wrapAroundMove
		end
		
		nextX = nextX - 2
		if nextX == 0 then
			nextX = self.grid.gridSize
		elseif nextX == -1 then
			nextX = self.grid.gridSize - 1
		end
		local nextCell = self.grid:getCellAt(nextX, nextY)
		if nextCell:getWall() then
			self:xMovePrep(0, maxMag, nil)
		else
			self:xMovePrep(-1, maxMag, moveType)
		end
	else
		print("Jump error")
	end
end

-- CALLS BETWEEN EVENTS
function Character:endMove()
	self.digging = false
	
	local potentialX = self.x + self.xVelocity
	local potentialY = self.y + self.yVelocity
	if potentialX < 1 then
		potentialX = self.grid.gridSize
	elseif potentialX > self.grid.gridSize then
		potentialX = 1
	end
	if potentialY < 1 then
		potentialY = self.grid.gridSize
	elseif potentialY > self.grid.gridSize then
		potentialY = 1
	end
	
	if self.xDist > 0 then
		self.xDist = self.xDist - 1
	elseif self.yDist > 0 then
		self.yDist = self.yDist - 1
	end
	
	self.x = potentialX
	self.y = potentialY
	self.grid:drawCharacterAtGridPosition(self)
	
	if self.xDist == 0 and self.yDist == 0 then
		self.xVelocity = 0
		self.yVelocity = 0
		self.frameAction = nil
		return true
	end
	return false
end

Player = Core.class(Character)

function Player:init(parent, playerImagePath, startX, startY, playerNum)
	self.playerNum = playerNum
	self.score = 0
	--self:initMoveBuffer()
	--self:setScoreField(playerNum)
end

function Player:initAttributes()
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

function Player:dig()
	local x, y = self:getGridPosition()
	print('player:dig()')
	self.digging = true
end

function Player:endTurn()
	clearArray(self.eventQueue)
	self.eventIndex = 1
	print('player:endTurn()')
end

function Player:incrementScore(amount)
	self.score = self.score + amount
	self.scoreField:setText("Score: " .. self.score)
	--print('Incrementing score ' .. self.score)
	--update view of score
end

CollectEnemy = Core.class(Character)

function CollectEnemy:init(parent, playerImagePath, startX, startY)
	
end

function CollectEnemy:initAttributes()
	self.name = "Collect Enemy"
	self.xDirection = 0
	self.yDirection = 0
	self.xSpeed = 0
	self.ySpeed = 0
end
