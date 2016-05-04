-- program is being exported under the TSU exception

aboutTraps = Core.class(BaseScreen)

function aboutTraps:init()
	self:addAboutObjects()
	local titleFont = TTFont.new("fonts/arial-rounded.ttf", 60)
	local font = TTFont.new("fonts/arial-rounded.ttf", 20)

	-- Add title
	local titleText = TextField.new(titleFont, "Traps Gameplay")
	titleText:setPosition((WINDOW_WIDTH / 2) - (titleText:getWidth() / 2), 125)
	self:addChild(titleText)

	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function aboutTraps:onEnterEnd()
	
end

function aboutTraps:onExitBegin()
	
end