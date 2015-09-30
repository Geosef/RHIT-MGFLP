M = {}

width = application:getLogicalWidth()
height = application:getLogicalHeight()

local Button = {}
Button.__index = Button

setmetatable(Button, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Button:_init(engine, imagepath, func, buttonnum)
	self.engine = engine
	self.func = func
	local buttonimage = Bitmap.new(Texture.new(imagepath))
	scalex = width / buttonimage:getWidth()
	scaley = height / buttonimage:getHeight()
	
	buttonimage:setScale(scalex, scaley)
	xpos = buttonnum * (width / 6)
	ypos = height / 10
	buttonimage:setPosition(xpos, ypos)
	stage:addChild(buttonimage)
	buttomimage:addEventListener("touch", self:click)
end

function Button:click()
	self.engine:addEvent(self.func)
end

M.Button = Button
return M