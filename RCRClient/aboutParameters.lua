-- program is being exported under the TSU exception

aboutParameters = Core.class(BaseScreen)

function aboutParameters:init()
	self:addAboutObjects()
	local titleFont = TTFont.new("fonts/arial-rounded.ttf", 60)
	local font = TTFont.new("fonts/arial-rounded.ttf", 20)

	-- Add title
	local titleText = TextField.new(titleFont, "About Parameters")
	titleText:setPosition((WINDOW_WIDTH / 2) - (titleText:getWidth() / 2), 125)
	self:addChild(titleText)

	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function aboutParameters:onEnterEnd()
	
end

function aboutParameters:onExitBegin()
	
end