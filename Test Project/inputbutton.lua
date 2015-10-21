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

function InputButton:_init(engine, imagePath, eventName, buttonNum, numButtons)
	self.engine = engine
	self.eventName = eventName
	local buttonImage = Bitmap.new(Texture.new(imagePath))
	local scaleX = width / buttonImage:getWidth() / 10
	local scaleY = height / buttonImage:getHeight() / 10
	
	local button = Button.new(buttonImage, buttonImage, function() self:click() end)
	button:setScale(scaleX, scaleY)
	xPos = buttonNum * (width / (numButtons + 1))
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






