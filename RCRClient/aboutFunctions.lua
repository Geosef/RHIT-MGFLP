-- program is being exported under the TSU exception

aboutFunctions = Core.class(BaseScreen)

function aboutFunctions:init()
	self:addAboutObjects()
	local titleFont = TTFont.new("fonts/arial-rounded.ttf", 60)
	local font = TTFont.new("fonts/arial-rounded.ttf", 20)

	-- Add title
	local titleText = TextField.new(titleFont, "About Functions")
	titleText:setPosition((WINDOW_WIDTH / 2) - (titleText:getWidth() / 2), 125)
	self:addChild(titleText)

	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function aboutFunctions:onEnterEnd()
	
end

function aboutFunctions:onExitBegin()
	
end