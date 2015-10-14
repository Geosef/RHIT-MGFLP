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

function InputButton:_init(engine, imagePath, func, buttonNum)
	self.engine = engine
	self.func = func
	local buttonImage = Bitmap.new(Texture.new(imagePath))
	scaleX = width / buttonImage:getWidth() / 10
	scaleY = height / buttonImage:getHeight() / 10
	
	local button = Button.new(buttonImage, buttonImage, function() self:click() end)
	button:setScale(scalex, scaley)
	xPos = buttonNum * (width / 6)
	yPos = height / 20
	button:setPosition(xPos, yPos)
	stage:addChild(button)
	self.imagePath = imagePath
	--button:addEventListener("click", function()
		--self.engine:addEvent(self.func)
	--	self.func()
	--end)
end

function InputButton:click()
	self.engine:addEvent(self, 1)
end

M.InputButton = InputButton
return M