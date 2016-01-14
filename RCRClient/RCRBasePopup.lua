-- program is being exported under the TSU exception

BasePopup = Core.class(SceneObject)
local font = TTFont.new("fonts/arial-rounded.ttf", 20)

function BasePopup:init()
	local fadedBG = Bitmap.new(Texture.new("images/fadeoutOverlay.png"))
	self:addChild(fadedBG)
end

-- When extending this class, this function must be extended and written in the subclass as:
-- function subclass:dismiss()
--		stage:remove(self)
--		BasePopup.dismiss(self)
-- end
function BasePopup:dismiss()
	self:removeChild(fadedBG)
end

function BasePopup:onEnterEnd()
	print("works")
	--self:dispatchEventToChildren()
end