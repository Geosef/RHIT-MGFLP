local M = {}

local inputMod = require('inputobj')

local width = application:getLogicalWidth()
local height = application:getLogicalHeight()

local InputEngine = {}
InputEngine.__index = InputEngine

setmetatable(InputEngine, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function InputEngine:_init()
	self.topCluster = ScriptObject({})
	self.eventSprites = {}
end

function InputEngine:addEvent(button, param)
	local eventNum = # self.topCluster.objs + 1
	
	local eventObj = inputMod.EventObject(button.func, 1, eventNum)
	self.topCluster:append(eventObj)
	
	local buttonImage = Bitmap.new(Texture.new(button.imagePath))
	scaleX = width / buttonImage:getWidth() / 20
	scaleY = height / buttonImage:getHeight() / 20
	
	local eventSprite = Button.new(buttonImage, buttonImage, function()
	self:removeEvent(eventobj)	end)
	eventSprite:setScale(scaleX, scaleY)
	xPos = eventnum * (width / 15)
	yPos = 3 * height / 20
	eventSprite:setPosition(xPos, yPos)
	stage:addChild(eventSprite)
	table.insert(self.eventSprites, eventSprite)
end

function InputEngine:removeEvent(eventObj)
	local eventNum = eventObj.objIndex
	
	self.topCluster:remove(eventObj)
	stage:removeChild(self.eventSprites[eventNum])
	table.remove(self.eventSprites, eventNum)
	for i = eventNum, # self.topCluster.objs do
		xPos = i * (width / 15)
		yPos = 3 * height / 20
		self.eventSprites[i]:setPosition(xPos, yPos)
	end
end

function InputEngine:runEvents()
	self.topCluster:execute()
end


M.InputEngine = InputEngine
return M