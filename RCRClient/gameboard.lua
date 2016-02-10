local padding = 12
Gameboard = Core.class(SceneObject)

function Gameboard:init(diff)
	
end

function Gameboard:onEnterEnd()
	self:addEventListener(Event.ENTER_FRAME, self.update, self)
end

function Gameboard:onExitBegin()
	self:removeEventListener(Event.ENTER_FRAME, self.update)
	self:removeEventListener("enterEnd", self.onEnterEnd)
	self:removeEventListener("exitBegin", self.onExitBegin)
end

function Gameboard:postInit(diff)
	if not self.cellImage then
		self.cellImagePath = "images/board-cell-120.png"
	end
	local gridSize = self:calculateGridSize(diff)
	self.grid = Grid.new(self, gridSize, self.cellImagePath)
	self:addChild(self.grid)
	self:drawPlayers(gridSize)
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function Gameboard:calculateGridSize(diff)
	print("calculateGridSize() not implemented!")
end

function Gameboard:drawPlayers(gridSize)
	print("drawPlayers() not implemented!")
end

function Gameboard:performNextTurn(moves)
	print("performNextTurn() not implemented!")
end

function Gameboard:update()
	print("update() not implemented!")
end

CollectGameboard = Core.class(Gameboard)

function CollectGameboard:init(diff)
	self.cellImagePath = "images/board-cell-120.png"
end

function CollectGameboard:calculateGridSize(diff)
	print("Diff " .. diff)
	if diff == "Easy" then
		return 6
	elseif diff == "Medium" then
		return 8
	elseif diff == "Hard" then
		return 10
	else
		return 8
	end
end

function CollectGameboard:drawPlayers(gridSize)
	self.player1 = Player.new(self, "images/board-cat-icon.png", 1, 1, 1)
	self.grid:drawCharacter(self.player1)
	
	self.player2 = Player.new(self, "images/board-rat-icon.png", gridSize, gridSize, 2)
	self.grid:drawCharacter(self.player2)
	
	self.enemy = CollectEnemy.new(self, "images/bulldog-icon.png", gridSize/2, gridSize/2)
	self.grid:drawCharacter(self.enemy)
end

function CollectGameboard:performNextTurn(moves)
	if not moves.p1 then
		print("p1 has no moves!")
	end
	if not moves.p2	then
		print("p2 has no moves!")
	end
	if not moves.enemy then
		print("enemy has no moves!")
	end
	self.player1:setEventQueue(moves.p1)
	self.player2:setEventQueue(moves.p2)
	self.enemy:setEventQueue(moves.enemy)
	
	self.animating = true
end

local frameCounter = 0
function CollectGameboard:update()
	local keyFrame = false
	if self.animating then
		if frameCounter == 40 then
			frameCounter = 0
			keyFrame = true
			self.player1:nextMove()
			self.player2:nextMove()
			self.enemy:nextMove()
			if not self.player1.animating and not self.player2.animating and not self.enemy.animating then
				self.animating = false
				self.player1:endTurn()
				self.player2:endTurn()
				self.enemy:endTurn()
				self:endTurn()
			end
		end
		frameCounter = frameCounter + 1
		print(self.player1.animating)
	end
end

function CollectGameboard:endTurn()
	self.grid:redraw()
end

--[[
Cell = Core.class(Sprite)

function Cell:init(x, y, cellImage)
	self.x = x
	self.y = y

	--cellImage:setPosition(100, 100)
	
	--self:addChild(cellImage)
end

function Cell:addImage(imagePath)
	if self.image == nil then
		xPos = (inc * (self.x-1)) * WINDOW_WIDTH + imageScale / 4 - 4
		yPos = (inc * (self.y-1)) * WINDOW_WIDTH + startY + (imageScale / 4) - 4
		image:setPosition(xPos, yPos)
	end
	return
end

function Cell:removeImage()

end

function Cell:setCollectible(collectible, initial)

end

function Cell:removeCollectible()

end

function Cell:reset()

end

function Cell:destroy()

end

function Cell:show(initial)

end



Grid = Core.class(Bitmap)

function Grid:init(img)
	local gridSize = 8
	
	self:setPosition(padding, (WINDOW_HEIGHT - padding) - self:getHeight())
	self.cells = {}
	self.gridSize = gridSize
	
	for i=1, gridSize do
		local row = {}
		table.insert(self.cells, row)
		for j=1, gridSize do
			local cellWidth = self:getWidth()/gridSize
			local scale = cellWidth/120
			local cellImage = Bitmap.new(Texture.new("images/board-cell-120.png"))
			cellImage:setScale(scale, scale)
			cellImage:setPosition((i-1)*cellWidth, (j-1)*cellWidth)
			local cell = Cell.new(i, j, cellImage)
			self:addChild(cellImage)
			table.insert(row, cell)
			--print("Cell X: " .. cell.x .. " Cell Y: " .. cell.y)
		end
	end
end

function Grid:runScript()
	
end

function Grid:initializeMapItems(gameState)

end

function Grid:setCollectibleAt(x, y, collectible, initial)

end

function Grid:reset()

end

function Grid:destroy()

end

function Grid:show()

end



CollectGrid = Core.class(Grid)

function CollectGrid:init(imagePath, gameType, gameState)
	self.setMapItems(gameState.cellData, true)
end

function CollectGrid:setGoldAt(goldLocations, initial)

end

function CollectGrid:setGemsAt(gemLocations, initial)

end

function CollectGrid:setMapItems(locations, initial)

end

function CollectGrid:show()

end

function CollectGrid:destroy()

end
]]