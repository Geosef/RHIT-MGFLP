LoadingScreen = Core.class(RCRBasePopup)

local font = TTFont.new("fonts/arial-rounded.ttf", 20)

function LoadingScreen:init()
	local loadingText = TextField.new(font, "Loading...")
	loadingText:setPosition(WINDOW_WIDTH/2, WINDOW_HEIGHT/2)
	self:addChild(loadingText)
end

