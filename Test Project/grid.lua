local M = {}

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
end

function Cell:setGold()
	local imageScale = WINDOW_WIDTH / self.numRows
	if not self.gold then
		local goldImage = Bitmap.new(Texture.new("images/gold.png"))
		scaleX = imageScale / goldImage:getWidth() / 2
		scaleY = imageScale / goldImage:getHeight() / 2
		
		goldImage:setScale(scaleX, scaleY)
		xPos = (inc * (self.x-1)) * WINDOW_WIDTH + imageScale / 4
		yPos = (inc * (self.y-1)) * WINDOW_WIDTH + startY + (imageScale / 4)
		goldImage:setPosition(xPos, yPos)
		stage:addChild(goldImage)
		self.gold = true
		self.goldImage = goldImage
	else
		self.gold = false
	end
end

function Cell:setGem()
	local imageScale = WINDOW_WIDTH / self.numRows
	if not self.gem then
		local gemImage = Bitmap.new(Texture.new("images/gem.png"))
		scaleX = imageScale / gemImage:getWidth() / 2
		scaleY = imageScale / gemImage:getHeight() / 2
		
		gemImage:setScale(scaleX, scaleY)
		xPos = (inc * (self.x-1)) * WINDOW_WIDTH + imageScale / 4
		yPos = (inc * (self.y-1)) * WINDOW_WIDTH + startY + (imageScale / 4)
		gemImage:setPosition(xPos, yPos)
		stage:addChild(gemImage)
		self.gem = true
		self.gemImage = gemImage
	else
		self.gem = false
	end
end

function Cell:toggleHiddenTreasure()
	if self.hiddenTreasure then
		self.hiddenTreasure = false
	else
		self.hiddenTreasure = true
	end
end

function Cell:setPowerup(powerup)
	if self.powerup ~= nil then
		return
	end
	self.powerupImage = powerup.Image
	self.powerup = powerup
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

function Grid:_init(numRows, imagePath, goldLocations, gemLocations, treasureLocations)
	print("Grid Size" .. imagePath)
	imageScale = WINDOW_WIDTH / numRows
	inc = 1 / numRows
	startY = WINDOW_HEIGHT / 4	
	
	self.numRows = numRows
	rows = {}
	for i=1, numRows do
		
		row = {}
		for j=1, numRows do
			local cellImage = Bitmap.new(Texture.new(imagePath))
			scaleX = imageScale / cellImage:getWidth()
			scaleY = imageScale / cellImage:getHeight()
			
			cellImage:setScale(scaleX, scaleY)
			xPos = (inc *  (j-1)) * WINDOW_WIDTH
			yPos = (inc * (i-1)) * WINDOW_WIDTH + startY
			cellImage:setPosition(xPos, yPos)
			stage:addChild(cellImage)
			cellObj = Cell(j, i, cellImage, numRows)
			table.insert(row, cellObj)			
		end
		table.insert(rows, row)
	end
	self.rows = rows
	if goldLocations == nil or gemLocations == nil or treasureLocations == nil then
		print("unsupported grid setup")
		return
	end
	self:setGoldAt(goldLocations)
	self:setGemsAt(gemLocations)
	self:setHiddenTreasureAt(treasureLocations)
end

function Grid:setGoldAt(goldLocations)
	for index,value in ipairs(goldLocations) do
		cell = self.rows[value[2]][value[1]]
		cell:setGold()
	end
end

function Grid:setGemsAt(gemLocations)
	for index,value in ipairs(gemLocations) do
		cell = self.rows[value[2]][value[1]]
		cell:setGem()
	end
end

function Grid:setHiddenTreasureAt(treasureLocations) 
	for index,value in ipairs(treasureLocations) do
		cell = self.rows[value[2]][value[1]]
		cell:toggleHiddenTreasure()
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


M.Cell = Cell
M.Grid = Grid


return M