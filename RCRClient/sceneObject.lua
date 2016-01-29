SceneObject = Core.class(Sprite)

function SceneObject:init()
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function SceneObject:onEnterEnd()
	self:dispatchEventToChildren("enterEnd")
end

function SceneObject:onExitBegin()
	self:dispatchEventToChildren("exitBegin")
end

local function dispatchEvent(dispatcher, name)
	if dispatcher:hasEventListener(name) then
		dispatcher:dispatchEvent(Event.new(name))
	end
end

function SceneObject:dispatchEventToChildren(event)
	for i = self:getNumChildren(), 1, -1 do
		local sprite = self:getChildAt(i)
		dispatchEvent(sprite, event)
	end
end
