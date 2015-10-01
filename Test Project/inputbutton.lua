M = {}

width = application:getLogicalWidth()
height = application:getLogicalHeight()

local InputButton = {}
InputButton.__index = InputButton

setmetatable(InputButton, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function InputButton:_init(engine, imagepath, func, buttonnum)
	self.engine = engine
	self.func = func
	local buttonimage = Bitmap.new(Texture.new(imagepath))
	scalex = width / buttonimage:getWidth() / 10
	scaley = height / buttonimage:getHeight() / 10
	
	local button = Button.new(buttonimage, buttonimage, function() self:click() end)
	button:setScale(scalex, scaley)
	xpos = buttonnum * (width / 6)
	ypos = height / 20
	button:setPosition(xpos, ypos)
	stage:addChild(button)
	self.imagepath = imagepath
	--button:addEventListener("click", function()
		--self.engine:addEvent(self.func)
	--	self.func()
	--end)
end

function InputButton:click()
	self.engine:addEvent(self)
end

M.InputButton = InputButton
return M