-- program is being exported under the TSU exception
local padding = 12
local boardDimensions = 480
local cellImageDimension = 120
local playerImageDimension = 100

Grid = Core.class(SceneObject)

function Grid:init(parent, gameInit, cellImagePath)
	self.cells = {}
	self.gridSize = gameInit.gridSize
	self.parent = parent
	self:initGrid(gameInit, cellImagePath)
end

function Grid:initGrid(gameInit, cellImagePath)
	for i=1, self.gridSize do
		local row = {}
		for j=1, self.gridSize do
			self.cellWidth = boardDimensions/self.gridSize
			local scale = self.cellWidth/cellImageDimension
			local cell = Cell.new(i, j, cellImagePath)
			cell:setScale(scale, scale)
			cell:setPosition((i-1)*self.cellWidth, (j-1)*self.cellWidth)
			table.insert(row, cell)
			--print("Cell X: " .. cell.x .. " Cell Y: " .. cell.y)
		end
		table.insert(self.cells, row)
	end
	self:setCellData(gameInit.cellData)
	self:drawGrid()
end

function Grid:setCellData(cellData)
	-- walls, goldLocations, treasureLocations
	for index,value in ipairs(cellData.wallLocations) do
		local x = value.x
		local y = value.y
		local cell = self.cells[x][y]
		cell:setWall(true)		
	end
	for index,value in ipairs(cellData.goldLocations) do
		local x = value.x
		local y = value.y
		local cell = self.cells[x][y]
		cell:setGold(true)		
	end
	for index,value in ipairs(cellData.treasureLocations) do
		local x = value.x
		local y = value.y
		local cell = self.cells[x][y]
		cell:setTreasure(true)		
	end	
end


function Grid:drawGrid()
	for i, row in ipairs(self.cells) do
		for j, cell in ipairs(row) do
			if self:contains(cell) then
				self:removeChild(cell)
			end
			-- need to redraw characters here
			self:addChild(cell)
		end
	end
end

function Grid:drawCharacterAtGridPosition(character)
	local charX, charY = character:getGridPosition()
	local cell = self.cells[charX][charY]
	if not self:contains(character) then
		local scale = cell:getWidth()/cellImageDimension
		character:setScale(scale, scale)
	end
	character:setPosition((cell:getX() + (cell:getWidth() / 2)) - (character:getWidth() / 2), (cell:getY() + (cell:getHeight() / 2)) - (character:getHeight() / 2))
	self:addChild(character)
end

--[[
	For this function, gameState should be formatted as follows:
	gameState {
		[
			{ 
				x = *some num*,
				y = *some num*,
				object = *some SceneObject*
			},
			...
		]
	}
]]
function Grid:initializeMapItems(gameState)
	for i, v in ipairs(gameState) do
		self:addCollectible(v.x, v.y, v.object)
	end
end

function Grid:addCollectible(x, y, collectible)
	self.cells[x][y]:addCollectible(collectible)
	self:drawGrid()
end

function Grid:reset()
	for i, row in ipairs(self.cells) do
		for j, cell in ipairs(row) do
			cell:reset()
		end
	end
end

Cell = Core.class(SceneObject)

function Cell:init(x, y, cellImagePath)
	self.x = x
	self.y = y
	self.cellImage = Bitmap.new(Texture.new(cellImagePath))
	--cellImage:setPosition(100, 100)
	
	self:addChild(self.cellImage)
	
	--image setup for gold
	self.goldImage = Bitmap.new(Texture.new('images/coin.png'))
	self.goldImage:setPosition((self.cellImage:getWidth() - self.goldImage:getWidth()) / 2, (self.cellImage:getHeight() - self.goldImage:getHeight()) / 2)
	
	--image setup for wall
	self.wallImage = Bitmap.new(Texture.new('images/wall-cell.png'))
	self.wallImage:setPosition((self.cellImage:getWidth() - self.wallImage:getWidth()) / 2, (self.cellImage:getHeight() - self.wallImage:getHeight()) / 2)
end

function Cell:setGold(bool)
	self.gold = bool
	if bool then
		self:addChild(self.goldImage)
	else
		self:removeChild(self.goldImage)
	end
end

function Cell:getGold()
	return self.gold
end


function Cell:setWall(bool)
	self.wall = bool
	if bool then
		self:addChild(self.wallImage)
	else
		self:removeChild(self.wallImage)
	end
end

function Cell:setTreasure(bool)
	self.treasure = bool
end

function Cell:getTreasure()
	return self.treasure
end

function Cell:addCollectible(collectible)
	if self.collectible ~= nil then
		return false
	end
	self.collectible = collectible
	local imageScale = WINDOW_WIDTH / self.numRows
	local scaleX = imageScale / self.collectible:getWidth() / 1.25
	local scaleY = imageScale / self.collectible:getHeight()/ 1.25
	
	self.collectible:setScale(scaleX, scaleY)
	self.collectible:setPosition((self:getWidth() / 2) - (self.collectible:getWidth() / 2), (self:getHeight() / 2) - (self.collectible:getHeight() / 2))
	self:addChild(self.collectible)
	return true
end

function Cell:removeCollectible()
	if self.collectible == nil then
		return nil
	end
	stage:removeChild(self.collectible)
	temp = self.collectible
	self.collectible = nil
	return temp
end

function Cell:reset()
	if self.collectible then
		self:removeCollectible()
	end
	if self.character then
		self:removeCharacter()
	end
end

--[[
local M = {}
local listMod = Core.class(list)
local collectibleMod = Core.class(collectible)

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
		for index,value in ipairs(goldLocations) do
			self:setCollectibleAt(value.x, value.y, collectibleMod.GoldCoin(), initial)
		end
	end

	local setGemsAt = function(gemLocations, initial)
		for index,value in ipairs(gemLocations) do
			self:setCollectibleAt(value.x, value.y, collectibleMod.Gem(), initial)
		end
	end
	
	self.setGoldAt = setGoldAt
	self.setGemsAt = setGemsAt
	
	local setMapItems = function(locations, initial)
		goldLocations = locations.goldLocations
		gemLocations = locations.gemLocations
		self.setGoldAt(goldLocations, initial)
		self.setGemsAt(gemLocations, initial)
	end
	setMapItems(gameState.celldata, true)
	
	local show = function()
		self:show()
	end
	
	local destroy = function()
		self:destroy()
	end
	
	return {
		setGoldAt = setGoldAt,
		setGemsAt = setGemsAt,
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
]]