M = {}

inputmod = require('inputobj')

width = application:getLogicalWidth()
height = application:getLogicalHeight()

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
	self.topcluster = ClusterObject({})
	self.eventsprites = {}
end

function InputEngine:addEvent(button)
	local eventnum = # self.topcluster.objs + 1
	
	local eventobj = inputmod.EventObject(button.func, eventnum)
	self.topcluster:append(eventobj)
	
	local buttonimage = Bitmap.new(Texture.new(button.imagepath))
	scalex = width / buttonimage:getWidth() / 20
	scaley = height / buttonimage:getHeight() / 20
	
	local eventsprite = Button.new(buttonimage, buttonimage, function()
	self:removeEvent(eventobj)	end)
	eventsprite:setScale(scalex, scaley)
	xpos = eventnum * (width / 15)
	ypos = 3 * height / 20
	eventsprite:setPosition(xpos, ypos)
	stage:addChild(eventsprite)
	table.insert(self.eventsprites, eventsprite)
end

function InputEngine:removeEvent(eventobj)
	local eventnum = eventobj.objindex
	
	self.topcluster:remove(eventobj)
	stage:removeChild(self.eventsprites[eventnum])
	table.remove(self.eventsprites, eventnum)
	for i = eventnum, # self.topcluster.objs do
		xpos = i * (width / 15)
		ypos = 3 * height / 20
		self.eventsprites[i]:setPosition(xpos, ypos)
	end
end

function InputEngine:runEvents()
	self.topcluster:execute()
end


M.InputEngine = InputEngine
return M