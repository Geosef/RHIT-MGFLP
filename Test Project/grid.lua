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
			cellobj = Cell(j, i, cellimage)
			table.insert(row, cellobj)
			
			if ((i + j) % 2) == 0 and (i ~= 1 or j ~= 1) then
				local goldimage = Bitmap.new(Texture.new("images/gold.png"))
				scalex = imagescale / goldimage:getWidth() / 2
				scaley = imagescale / goldimage:getHeight() / 2
				
				goldimage:setScale(scalex, scaley)
				xpos = (inc * (j-1)) * width + imagescale / 4
				ypos = (inc * (i-1)) * width + startY + (imagescale / 4)
				goldimage:setPosition(xpos, ypos)
				stage:addChild(goldimage)
				cellobj.gold = true
				cellobj.goldimage = goldimage
			else
				cellobj.gold = false
			end
		end
		table.insert(rows, row)
	end
	self.rows = rows
end

M.Cell = Cell
M.Grid = Grid


return M