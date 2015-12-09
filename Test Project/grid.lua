-- program is being exported under the TSU exception

local M = {}
local listMod = require('list')
local collectibleMod = require('collectible')

local Cell = {}
Cell.__index = Cell

setmetatable(Cell, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Cell:_init(x, y, sprite, numRows)
	self.x = x
	self.y = y
	self.sprite = sprite
	self.numRows = numRows
	self.hiddenTreasure = false
	self.collectible = nil
	self.image = nil
	self.currentChar = nil
end

function Cell:addImage(imagePath)
	if self.image == nil then
		local image = Bitmap.new(Texture.new(imagePath))
		scaleX = imageScale / image:getWidth() / 1.33
		scaleY = imageScale / image:getHeight() / 1.33
		
		image:setScale(scaleX, scaleY)
		xPos = (inc * (self.x-1)) * WINDOW_WIDTH + imageScale / 4 - 4
		yPos = (inc * (self.y-1)) * WINDOW_WIDTH + startY + (imageScale / 4) - 4
		image:setPosition(xPos, yPos)
		self.image = image
	end
	return
end

function Cell:removeImage()
	if self.image == nil then
		return
	end
	stage:removeChild(self.image)
	self.image = nil
end

function Cell:setCollectible(collectible, initial)
	if self.collectible ~= nil then
		return false
	end
	self.collectible = collectible
	if self.collectible.image == nil then
		return true
	end
	local imageScale = WINDOW_WIDTH / self.numRows
	scaleX = imageScale / self.collectible.image:getWidth() / 1.25
	scaleY = imageScale / self.collectible.image:getHeight()/ 1.25
	
	self.collectible.image:setScale(scaleX, scaleY)
	xPos = (inc * (self.x-1)) * WINDOW_WIDTH + imageScale / 4 - 5
	yPos = (inc * (self.y-1)) * WINDOW_WIDTH + startY + (imageScale / 4) - 4
	self.collectible.image:setPosition(xPos, yPos)
	return true
end

function Cell:removeCollectible()
	if self.collectible == nil then
		return nil
	end
	stage:removeChild(self.collectible.image)
	temp = self.collectible
	self.collectible = nil
	return temp
end

function Cell:reset()
	if self.gold then
		self.gold = false
		stage:removeChild(self.goldImage)
	end
	if self.gem then
		self.gem = false
	end
	if self.hiddenTreasure then
		self:toggleHiddenTreasure()
	end
end

function Cell:destroy()
	stage:removeChild(self.sprite)
	if self.collectible ~= nil and self.collectible.image ~= nil then
		stage:removeChild(self.collectible.image)
	end
	if self.image ~= nil then
		
	end
	--destroy others
end

function Cell:show(initial)
	if initial then
		stage:addChild(self.sprite)
	end
	
	if self.collectible ~= nil and self.collectible.image ~= nil then
		stage:addChild(self.collectible.image)
	end
	--show others
end

local Grid = {}
Grid.__index = Grid

setmetatable(Grid, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Grid:_init(imagePath, gameType, numRows)
	self.numRows = numRows
	imageScale = WINDOW_WIDTH / self.numRows
	inc = 1 / self.numRows
	startY = WINDOW_HEIGHT / 4	
	
	
	rows = {}
	for i=1, self.numRows do
		
		row = {}
		for j=1, self.numRows do
			local cellImage = Bitmap.new(Texture.new(imagePath))
			scaleX = imageScale / cellImage:getWidth()
			scaleY = imageScale / cellImage:getHeight()
			
			cellImage:setScale(scaleX, scaleY)
			xPos = (inc *  (j-1)) * WINDOW_WIDTH
			yPos = (inc * (i-1)) * WINDOW_WIDTH + startY
			cellImage:setPosition(xPos, yPos)
			--stage:addChild(cellImage)
			cellObj = Cell(j, i, cellImage, self.numRows)
			table.insert(row, cellObj)			
		end
		table.insert(rows, row)
	end
	self.rows = rows
	print("Grid Size " .. self.numRows)
	
end

function Grid:initializeMapItems(gameState)
	print("Map item initialization not implemented yet!")
end

function Grid:setCollectibleAt(x, y, collectible, initial)
	local cell = self.rows[y][x]
	cell:setCollectible(collectible)
	if not initial then
		cell:show(false)
	end
		
end

function Grid:reset()
	for i = 1,self.numRows do
		row = self.rows[i]
		for j = 1,self.numRows do
			cell = row[j]
			cell:reset()
		end
	end
end

function Grid:destroy()
	for i = 1,self.numRows do
		row = self.rows[i]
		for j = 1,self.numRows do
			cell = row[j]
			cell:destroy()
		end
	end
end

function Grid:show()
	for i = 1,self.numRows do
		row = self.rows[i]
		for j = 1,self.numRows do
			cell = row[j]
			cell:show(true)
		end
	end
end



function CollectGrid(imagePath, gameType, gameState)
	local self = Grid(imagePath, gameType, gameState.gridsize)
	
	local setGoldAt = function(goldLocations, initial)
		--print_r(goldLocations)
		for index,value in ipairs(goldLocations) do
			self:setCollectibleAt(value.x, value.y, collectibleMod.GoldCoin(), initial)
		end
	end

	local setGemsAt = function(gemLocations, initial)
		for index,value in ipairs(gemLocations) do
			self:setCollectibleAt(value.x, value.y, collectibleMod.Gem(), initial)
		end
	end

	local setHiddenTreasureAt = function(treasureLocations, initial)
		for index,value in ipairs(treasureLocations) do
			self:setCollectibleAt(value.x, value.y, collectibleMod.BuriedTreasure(), initial)
		end
	end
	
	self.setGoldAt = setGoldAt
	self.setGemsAt = setGemsAt
	self.setHiddenTreasureAt = setHiddenTreasureAt
	
	local setMapItems = function(locations, initial)
		goldLocations = locations.goldLocations
		gemLocations = locations.gemLocations
		treasureLocations = locations.treasureLocations
		self.setGoldAt(goldLocations, initial)
		self.setGemsAt(gemLocations, initial)
		self.setHiddenTreasureAt(treasureLocations, initial)
	end
	setMapItems(gameState.celldata, true)
	

	local metalDetect = function(cell, player)
		self.resetHiddenTreasureImages()
		local treasureCells = listMod.List(nil)
		for i = -1, 1 do
			for j = -1, 1 do
				local newX = cell.x + i
				local newY = cell.y + j
				if newX > 0 and newX < self.numRows + 1 and newY > 0 and newY < self.numRows + 1 then
					local checkCell = self.rows[newY][newX]
					if checkCell.collectible then
						if checkCell.collectible.isBuriedTreasure then
							treasureCells:append(checkCell)
						end
					end
				end
			end
		end
		self.treasureCells = treasureCells
		self.treasureCells:iterate(function(cell) cell:addImage("images/treasure1.png") end)
		return true
		
	end

	local resetHiddenTreasureImages = function()
		if self.treasureCells == nil then
			return
		end
		self.treasureCells:iterate(function(cell) cell:removeImage() end)
		self.treasureCells = nil
	end
	
	local show = function()
		self:show()
	end
	
	local destroy = function()
		self:destroy()
	end
	
	self.resetHiddenTreasureImages = resetHiddenTreasureImages
	
	return {
		metalDetect = metalDetect,
		setGoldAt = setGoldAt,
		setGemsAt = setGemsAt,
		setHiddenTreasureAt = setHiddenTreasureAt,
		setMapItems = setMapItems,
		numRows = self.numRows,
		rows = self.rows,
		show = show,
		destroy = destroy
	}
end

M.Cell = Cell
M.CollectGrid = CollectGrid

return M

