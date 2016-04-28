TrapGameboard = Core.class(Gameboard)

function TrapGameboard:init(gameInit)
	self.cellImagePath = "images/board-cell-120.png"
	self.host = gameInit.host
end

function TrapGameboard:calculateGridSize(diff)
	print("Diff " .. diff)
	if diff == "Easy" then
		return 12
	elseif diff == "Medium" then
		return 16
	elseif diff == "Hard" then
		return 20
	else
		return 16
	end
end

function TrapGameboard:drawPlayers(gridSize, enemyStart)
	self.player1 = Player.new(self, "images/board-cat-icon.png", 1, 1, 1)
	self.grid:drawCharacterAtGridPosition(self.player1)
	
	self.player2 = Player.new(self, "images/board-rat-icon.png", gridSize, gridSize, 2)
	self.grid:drawCharacterAtGridPosition(self.player2)
	
	--self.enemy = CollectEnemy.new(self, "images/bulldog-icon.png", enemyStart.x, enemyStart.y)
	--self.grid:drawCharacterAtGridPosition(self.enemy)
end

function TrapGameboard:performNextTurn(moves)
	if not moves.p1 then
		print("p1 has no moves!")
	else
		self.player1:setEventQueue(moves.p1)
	end
	if not moves.p2	then
		print("p2 has no moves!")
	else
		self.player2:setEventQueue(moves.p2)
	end
	--[[if not moves.enemy then
		print("enemy has no moves!")
	else
		self.enemy:setEventQueue(moves.enemy)
	end]]
	
	self.animating = true
end

function TrapGameboard:updateLocations(newGrid)
	print('TrapGameboard:updateLocations()')
	if newGrid then
		if self.animating then
			print('here1 updateLocations')
			self.nextGrid = newGrid
		else
			print('here2 updateLocations')
			local locations = {}
			local x, y = self.player1:getGridPosition()
			table.insert(locations, {x=x, y=y})
			x, y = self.player2:getGridPosition()
			table.insert(locations, {x=x, y=y})
			--x, y = self.enemy:getGridPosition()
			--table.insert(locations, {x=x, y=y})
			self.grid:updateGrid(newGrid, locations)
			self.nextGrid = nil
		end
	else
		print('here3 updateLocations')
		self.nextGrid = nil
	end
	
end

local frameCounter = 1
function TrapGameboard:update()
	if self.animating then
		--print(frameCounter)
		self.player1:update(frameCounter)
		self.player2:update(frameCounter)
		--self.enemy:update(frameCounter)
		if frameCounter == self.moveDuration then
			frameCounter = 0
			self:triggerCollects()
			if not self.player1.animating and not self.player2.animating-- and not self.enemy.animating
			then
				self.animating = false
				self:endTurn()
			end
		end
		frameCounter = frameCounter + 1
	end
end

local goldScoreAmount = 4
function TrapGameboard:processCellForCollect(player)
	local px, py = player:getGridPosition()
	local cell = self.grid.cells[px][py]
	if cell.gold then
		player:incrementScore(goldScoreAmount)
		cell:setGold(false)
	end
end


function TrapGameboard:triggerCollects()
	--print('trigger collects')
	local p1x, p1y = self.player1:getGridPosition()
	local p2x, p2y = self.player2:getGridPosition()
	--local enemyX, enemyY = self.enemy:getGridPosition()
	
	if p1x == p2x and p1y == p2y then
		local cell = self.grid.cells[p1x][p1y]
		if cell.gold then
			self.player1:incrementScore(goldScoreAmount / 2)
			self.player2:incrementScore(goldScoreAmount / 2)
			cell:setGold(false)	
		end
	else
		self:processCellForCollect(self.player1)
		self:processCellForCollect(self.player2)
	end
end

function TrapGameboard:endTurn()
	if self.nextGrid then
		print('here endTurn()')
		local nextGrid = self.nextGrid
		self.nextGrid = nil
		local locations = {}
		local x, y = self.player1:getGridPosition()
		table.insert(locations, {x=x, y=y})
		x, y = self.player2:getGridPosition()
		table.insert(locations, {x=x, y=y})
		--x, y = self.enemy:getGridPosition()
		--table.insert(locations, {x=x, y=y})
		self.grid:updateGrid(nextGrid, locations)
	end
	if self.host then
		local packet = {}
		packet.type = 'Update Locations'
		packet.locations = {
			p1={x=self.player1.x, y=self.player1.y},
			p2={x=self.player2.x, y=self.player2.y},
			enemy={x=1, y=1}
		}
		packet.scores = {self.player1.score, self.player2.score}
		NET_ADAPTER:sendData(packet)
	end
end
