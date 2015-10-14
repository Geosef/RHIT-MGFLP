local M = {}

local width = application:getLogicalWidth()
local height = application:getLogicalHeight()


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
	self:setGold()	
end

function Cell:setGold()
	imageScale = width / self.numRows
	if ((self.x + self.y) % 2) == 0 and (self.x ~= 1 or self.y ~= 1) then
		local goldImage = Bitmap.new(Texture.new("images/gold.png"))
		scaleX = imageScale / goldImage:getWidth() / 2
		scaleY = imageScale / goldImage:getHeight() / 2
		
		goldImage:setScale(scaleX, scaleY)
		xPos = (inc * (self.x-1)) * width + imageScale / 4
		yPos = (inc * (self.y-1)) * width + startY + (imageScale / 4)
		goldImage:setPosition(xPos, yPos)
		stage:addChild(goldImage)
		self.gold = true
		self.goldImage = goldImage
	else
		self.gold = false
	end
end

function Cell:reset()
	if self.gold then
		self.gold = false
		stage:removeChild(self.goldImage)
	end
	self:setGold()
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

function Grid:_init(numRows)
	imageScale = width / numRows
	inc = 1 / numRows
	startY = height / 4	
	
	self.numRows = numRows
	rows = {}
	for i=1, numRows do
		
		row = {}
		for j=1, numRows do
			local cellImage = Bitmap.new(Texture.new("images/square.png"))
			scaleX = imageScale / cellImage:getWidth()
			scaleY = imageScale / cellImage:getHeight()
			
			cellImage:setScale(scaleX, scaleY)
			xPos = (inc *  (j-1)) * width
			yPos = (inc * (i-1)) * width + startY
			cellImage:setPosition(xPos, yPos)
			stage:addChild(cellImage)
			cellObj = Cell(j, i, cellImage, numRows)
			table.insert(row, cellObj)			
		end
		table.insert(rows, row)
	end
	self.rows = rows
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

M.Cell = Cell
M.Grid = Grid


return M