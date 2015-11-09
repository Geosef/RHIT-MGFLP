M = {}


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
	local scaleX = WINDOW_WIDTH / buttonImage:getWidth() / 15
	local scaleY = WINDOW_HEIGHT / buttonImage:getHeight() / 15
	
	self.button = Button.new(buttonImage, buttonImage, function() self:click() end)
	self.button:setScale(scaleX, scaleY)
	local xPos = buttonNum * (WINDOW_WIDTH / (numButtons + 1))
	local yPos = WINDOW_HEIGHT / 20
	self.button:setPosition(xPos, yPos)
	
	self.imagePath = imagePath
	--button:addEventListener("click", function()
		--self.engine:addEvent(self.func)
	--	self.func()
	--end)
end

function InputButton:show()
	stage:addChild(self.button)
end

function InputButton:destroy()
	stage:removeChild(self.button)
end




function InputButton:click()
	self.engine:addEvent(self, 1)
end

M.InputButton = InputButton
return M






