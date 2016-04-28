local padding = 12

Gameboard = Core.class(SceneObject)

function Gameboard:init(gameInit)
	self.moveDuration = 20
	NET_ADAPTER:registerCallback('Game Over', function(data)
		sceneManager:changeScene("gameOver", 1, SceneManager.crossfade, easing.outBack,
		{userData=data})
	end)
	self.maxMoves = 6
end

function Gameboard:displayGameOver()
	
	print('GAME OVER BRO')
end

function Gameboard:onEnterEnd()
	self:addEventListener(Event.ENTER_FRAME, self.update, self)
end

function Gameboard:onExitBegin()
	self:removeEventListener(Event.ENTER_FRAME, self.update)
	self:removeEventListener("enterEnd", self.onEnterEnd)
	self:removeEventListener("exitBegin", self.onExitBegin)
end

function Gameboard:postInit(gameInit)
	if not self.cellImage then
		self.cellImagePath = "images/board-cell-120.png"
	end
	local gridSize = self:calculateGridSize(gameInit.diff) --TODO: Evaluate whether this should be calculated by server, right now it is sent within Game Setup packet
	self.grid = Grid.new(self, gameInit, self.cellImagePath)
	self:addChild(self.grid)
	self.characterMoveDistance = self.grid.cellWidth
	self:drawPlayers(gridSize, gameInit.cellData.enemyStart)
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

function Gameboard:getPlayerImagePaths()
	local pImages = {}
	local pImagesIndex = 1
	if self.player1 then
		pImages[pImagesIndex] = self.player1.playerImagePath
		pImagesIndex = pImagesIndex + 1
	end
	if self.player2 then
		pImages[pImagesIndex] = self.player2.playerImagePath
	end
	return pImages
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

function CollectGrid:setGemsAt(gemgLocations, initial)

end

function CollectGrid:setMapItems(locations, initial)

end

function CollectGrid:show()

end

function CollectGrid:destroy()

end
]]