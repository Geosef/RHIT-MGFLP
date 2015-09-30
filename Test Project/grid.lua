M = {}

width = application:getLogicalWidth()
height = application:getLogicalHeight()


local Cell = {}
Cell.__index = Cell

setmetatable(Cell, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Cell:_init(x, y, sprite, numrows)
	self.x = x
	self.y = y
	self.sprite = sprite
	self.numrows = numrows
	self:setGold()	
end

function Cell:setGold()
	imagescale = width / self.numrows
	if ((self.x + self.y) % 2) == 0 and (self.x ~= 1 or self.y ~= 1) then
		local goldimage = Bitmap.new(Texture.new("images/gold.png"))
		scalex = imagescale / goldimage:getWidth() / 2
		scaley = imagescale / goldimage:getHeight() / 2
		
		goldimage:setScale(scalex, scaley)
		xpos = (inc * (self.x-1)) * width + imagescale / 4
		ypos = (inc * (self.y-1)) * width + startY + (imagescale / 4)
		goldimage:setPosition(xpos, ypos)
		stage:addChild(goldimage)
		self.gold = true
		self.goldimage = goldimage
	else
		self.gold = false
	end
end

function Cell:reset()
	if self.gold then
		self.gold = false
		stage:removeChild(self.goldimage)
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

function Grid:_init(numrows)
	imagescale = width / numrows
	inc = 1 / numrows
	startY = height / 4	
	
	self.numrows = numrows
	rows = {}
	for i=1, numrows do
		
		row = {}
		for j=1, numrows do
			local cellimage = Bitmap.new(Texture.new("images/square.png"))
			scalex = imagescale / cellimage:getWidth()
			scaley = imagescale / cellimage:getHeight()
			
			cellimage:setScale(scalex, scaley)
			xpos = (inc *  (j-1)) * width
			ypos = (inc * (i-1)) * width + startY
			cellimage:setPosition(xpos, ypos)
			stage:addChild(cellimage)
			cellobj = Cell(j, i, cellimage, numrows)
			table.insert(row, cellobj)			
		end
		table.insert(rows, row)
	end
	self.rows = rows
end

function Grid:reset()
	for i = 1,self.numrows do
		row = self.rows[i]
		for j = 1,self.numrows do
			cell = row[j]
			cell:reset()
		end
	end
end

M.Cell = Cell
M.Grid = Grid


return M