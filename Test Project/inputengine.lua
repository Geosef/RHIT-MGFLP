local M = {}

local inputMod = require('inputobj')
local commandMod = require('command')

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
	local loopCount = nil
	if button.eventName == "LoopStart" then
		if # self.script.list.objs > 0 then
			local previousEvent = self.script.list.objs[# self.script.list.objs]
			if previousEvent.name == "LoopStart" then
				local prevIter = previousEvent.iterations
				previousEvent.iterations = prevIter + 1
				previousEvent.sprite.loopCount:setText(previousEvent.iterations)
				return
			end
		end
		-- Loop Counter Text Field
		loopCount = TextField.new(nil, 0)
	end
	
	local eventNum = self.script:length() + 1
	if eventNum > self.game.maxPlayerMoves then
		print("Can't do anymore moves!")
		return
	end
	
	local eventObjConst = commandMod.getEvent(button.eventName)
	local eventObj = eventObjConst(nil, 1, eventNum)
	
	local buttonImage = Bitmap.new(Texture.new(button.imagePath))
	local scaleX = WINDOW_WIDTH / buttonImage:getWidth() / 20
	local scaleY = WINDOW_HEIGHT / buttonImage:getHeight() / 20
	
	local eventSprite = Button.new(buttonImage, buttonImage, function()
	self:removeEvent(eventObj)	end)
	eventSprite:setScale(scaleX, scaleY)
	local xPos = eventNum * (WINDOW_WIDTH / 15)
	local yPos = 3 * WINDOW_HEIGHT / 20
	eventSprite:setPosition(xPos, yPos)
	if loopCount ~= nil then
		loopCount:setScale(2.0)
		loopCount:setAlpha(0.4)
		loopCount:setText(1)
		loopCount:setPosition(xPos + 5, yPos + 20)
		eventSprite.loopCount = loopCount
		stage:addChild(eventSprite.loopCount)
	end
	eventObj.sprite = eventSprite
	stage:addChild(eventObj.sprite)
	self.script:append(eventObj)
	
	
	--table.insert(self.eventSprites, eventSprite)
end

function InputEngine:removeEvent(eventObj)
	local eventNum = eventObj.objIndex
	local eventSprite = eventObj.sprite
	if eventObj.name == "LoopStart" then
		if eventObj.iterations > 1 then
			eventObj.iterations = eventObj.iterations - 1
			eventSprite.loopCount:setText(eventObj.iterations)
			return
		else
			stage:removeChild(eventSprite.loopCount)
		end
	end
	self.script:remove(eventObj)
	stage:removeChild(eventSprite)
	
	--table.remove(self.eventSprites, eventNum)
	local count = eventNum
	self.script.list:iterate(function(command)
		local xPos = count * (WINDOW_WIDTH / 15)
		local yPos = 3 * WINDOW_HEIGHT / 20
		command.sprite:setPosition(xPos, yPos)
		count = count + 1
		end)
	--[[
	for i = eventNum, self.script:length() do
		local xPos = i * (WINDOW_WIDTH / 15)
		local yPos = 3 * WINDOW_HEIGHT / 20
		self.eventSprites[i]:setPosition(xPos, yPos)
	end]]
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
			if event.name ~= "LoopEnd" then
				table.insert(events, event.name)
			end
		end
	end
	
	return events
end


M.InputEngine = InputEngine
return M