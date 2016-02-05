local padding = 12

Cell = Core.class(Sprite)

function Cell:init(x, y, cellImage)
	self.x = x
	self.y = y

	--cellImage:setPosition(100, 100)
	
	--self:addChild(cellImage)
end

function Cell:addImage(imagePath)
	--[[if self.image == nil then
		xPos = (inc * (self.x-1)) * WINDOW_WIDTH + imageScale / 4 - 4
		yPos = (inc * (self.y-1)) * WINDOW_WIDTH + startY + (imageScale / 4) - 4
		image:setPosition(xPos, yPos)
	end]]--
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
