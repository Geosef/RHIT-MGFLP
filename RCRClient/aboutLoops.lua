-- program is being exported under the TSU exception

aboutLoops = Core.class(BaseScreen)

function aboutLoops:init()
	self:addAboutObjects()
	local titleFont = TTFont.new("fonts/arial-rounded.ttf", 60)
	local font = TTFont.new("fonts/arial-rounded.ttf", 20)

	-- Add title
	local titleText = TextField.new(titleFont, "About Loops")
	titleText:setPosition((WINDOW_WIDTH / 2) - (titleText:getWidth() / 2), 125)
	self:addChild(titleText)

	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function aboutLoops:onEnterEnd()
	
end

function aboutLoops:onExitBegin()
	
end