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

function InputEngine:_init(game)
	self.script = inputMod.ScriptObject({})
	self.game = game
	self.eventSprites = {}
end

function InputEngine:addEvent(button, param)
	if button.eventName == "LoopStart" and # self.script.list.objs > 0 then
		local previousEvent = self.script.list.objs[# self.script.list.objs]
		if previousEvent.name == "LoopStart" then
			local prevIter = previousEvent.iterations
			previousEvent.iterations = prevIter + 1
			return
		end
	end
	
	local eventNum = self.script:length() + 1
	if eventNum > self.game.maxPlayerMoves then
		print("Can't do anymore moves!")
		return
	end
	
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
	self.script.list:backwardsIterate(function(command) 
		local eventNum = command.objIndex
		self.script:remove(command)
		stage:removeChild(self.eventSprites[eventNum])
		table.remove(self.eventSprites, eventNum)
		end)
end

function InputEngine:runEvents()
	
	self.script:execute()
end

function InputEngine:getEvents()
	local events = {}
	local baseList = self.script.list.objs
	for i = 1, # baseList do
		local event = baseList[i]
		if event.name == "LoopStart" then
			--event.iterations = 2
			for looper = 1, event.iterations do
				for j = i + 1, # baseList do
					local innerEvent = baseList[j]
					if innerEvent.name == "LoopEnd" then
						if looper == event.iterations then
							i = j + 1
						end
						break
					end
					table.insert(events, innerEvent.name)
				end
			end
		else
			table.insert(events, event.name)
		end
	end
	
	return events
end


M.InputEngine = InputEngine
return M