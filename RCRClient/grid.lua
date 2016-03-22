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

function Grid:removeCollectibles()
	-- walls, goldLocations, treasureLocations
	for i, row in ipairs(self.cells) do
		for j, cell in ipairs(row) do
			cell:setWall(false)
			cell:setGold(false)
			cell:setTreasure(false)
		end
	end
end

function Grid:updateGrid(grid, playerLocations)
	--print_r(locations)
	self:removeCollectibles()
	self:setCellData(grid, playerLocations)
	--self:drawGrid()
end

local function isOnPlayerCell(x, y, playerLocations)
	if not playerLocations then return false end
	for i, v in ipairs(playerLocations) do
		if v.x == x and v.y == y then
			return true
		end
	end
	return false
end

function Grid:setCellData(cellData, playerLocations)
	-- walls, goldLocations, treasureLocations
	for index,value in ipairs(cellData.wallLocations) do
		local x = value.x
		local y = value.y
		if not isOnPlayerCell(x, y, playerLocations) then
			local cell = self.cells[x][y]
			cell:setWall(true)
		end
	end
	for index,value in ipairs(cellData.goldLocations) do
		local x = value.x
		local y = value.y
		if not isOnPlayerCell(x, y, playerLocations) then
			local cell = self.cells[x][y]
			cell:setGold(true)		
		end
	end
	for index,value in ipairs(cellData.treasureLocations) do
		local x = value.x
		local y = value.y
		if not isOnPlayerCell(x, y, playerLocations) then		
			local cell = self.cells[x][y]
			cell:setTreasure(true)		
		end
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

function Grid:getCellAt(x,y)
	return self.cells[x][y]
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
	pcall(function()
	if bool then
		self:addChild(self.goldImage)
	else
		self:removeChild(self.goldImage)
	end
	end)
end

function Cell:getGold()
	return self.gold
end


function Cell:setWall(bool)
	self.wall = bool
	pcall(function()
	if bool then
		self:addChild(self.wallImage)
	else
		self:removeChild(self.wallImage)
	end
	end)
end

function Cell:getWall()
	if self.wall ~= nil then
		return self.wall
	else
		return false
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
