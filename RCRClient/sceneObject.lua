SceneObject = Core.class(Sprite)

function SceneObject:dispatchEventToChildren()
	for i = self:getNumChildren(), 1, -1 do
		local sprite = self:getChildAt(i)
		dispatchEvent(sprite, "enterEnd")
	end
end

