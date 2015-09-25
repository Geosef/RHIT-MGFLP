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

function Cell:_init(x, y, sprite)
	self.x = x
	self.y = y
	self.sprite = sprite
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
	starty = height / 4	
	
	self.numrows = numrows
	rows = {}
	for i=1, numrows do
		row = {}
		for j=1, numrows do
			local cellimage = Bitmap.new(Texture.new("square.png"))
			scalex = imagescale / cellimage:getWidth()
			scaley = imagescale / cellimage:getHeight()
			
			cellimage:setScale(scalex, scaley)
			xpos = (inc *  (j-1)) * width
			ypos = (inc * (i-1)) * width + starty 
			cellimage:setPosition(xpos, ypos)
			stage:addChild(cellimage)
			cellobj = Cell(j, i, cellimage)
			table.insert(row, cellobj)
		end
		table.insert(rows, row)
	end
	self.rows = rows
end

M.Cell = Cell
M.Grid = Grid


return M