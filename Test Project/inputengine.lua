local M = {}

local inputMod = require('inputobj')
local commandMod = require('command')


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
	self.script = inputMod.ScriptObject({})
	self.eventSprites = {}
end

function InputEngine:addEvent(button, param)
	local eventNum = self.script:length() + 1
	
	local eventObjConst = commandMod.getEvent(button.eventName)
	local eventObj = eventObjConst(nil, 1, eventNum)
	self.script:append(eventObj)
	
	
	local buttonImage = Bitmap.new(Texture.new(button.imagePath))
	local scaleX = width / buttonImage:getWidth() / 20
	local scaleY = height / buttonImage:getHeight() / 20
	
	local eventSprite = Button.new(buttonImage, buttonImage, function()
	self:removeEvent(eventObj)	end)
	eventSprite:setScale(scaleX, scaleY)
	local xPos = eventNum * (width / 15)
	local yPos = 3 * height / 20
	eventSprite:setPosition(xPos, yPos)
	stage:addChild(eventSprite)
	table.insert(self.eventSprites, eventSprite)
end

function InputEngine:removeEvent(eventObj)
	local eventNum = eventObj.objIndex
	self.script:remove(eventObj)
	stage:removeChild(self.eventSprites[eventNum])
	table.remove(self.eventSprites, eventNum)
	for i = eventNum, self.script:length() do
		local xPos = i * (width / 15)
		local yPos = 3 * height / 20
		self.eventSprites[i]:setPosition(xPos, yPos)
	end
end

function InputEngine:clearBuffer()
	self.script.list:backwardsIterate(function(command) self:removeEvent(command) end)
end

function InputEngine:runEvents()
	self.script:execute()
end

function InputEngine:getEvents()
	local events = {}
	self.script.list:iterate(function(elem)
		table.insert(events, elem.name)
	end)
	return events
end


M.InputEngine = InputEngine
return M