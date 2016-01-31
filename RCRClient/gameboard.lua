local padding = 12

Cell = Core.class(Sprite)

function Cell:init()
	
end

function Cell:addImage(imagePath)

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
			local cell = Cell.new()	
			table.insert(row, cell)
		end
	end
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

function setGoldAt(goldLocations, initial)

end

function setGemsAt(gemLocations, initial)

end

function setMapItems(locations, initial)

end

function show()

end

function destroy()

end
