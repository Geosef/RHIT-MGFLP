-- program is being exported under the TSU exception

aboutGameplay = Core.class(BaseScreen)

function aboutGameplay:init()
	self:addAboutObjects()
	local titleFont = TTFont.new("fonts/arial-rounded.ttf", 60)

	-- Add title
	local titleText = TextField.new(titleFont, "Basic Gameplay")
	titleText:setPosition((WINDOW_WIDTH / 2) - (titleText:getWidth() / 2), 125)
	self:addChild(titleText)
	
	self:addContent()
	
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function aboutGameplay:addContent()
	local font = TTFont.new("fonts/arial-rounded.ttf", 20)
	
	-- Add text (NOTE: Must be added line-by-line since Lua TextFields don't support newline characters.
	local line1 = TextField.new(font, "Starting a Game: In order to start a game,")
	local line2 = TextField.new(font, "choose your top 3 choices for games and")
	local line3 = TextField.new(font, "difficulties from the Main Menu then click")
	local line4 = TextField.new(font, "the Submit button. You will be matched up")
	local line5 = TextField.new(font, "according to your preferences.")
	local line6 = TextField.new(font, "Setting Up a Script: Each turn, players")
	local line7 = TextField.new(font, "will submit a scripts in order to move and")
	local line8 = TextField.new(font, "accomplish various tasks. To do this, click")
	local line9 = TextField.new(font, "on the elements from the Statements Box to")
	local line10 = TextField.new(font, "put them into your script. Put them in")
	local line11 = TextField.new(font, "whatever order you like by dragging and")
	local line12 = TextField.new(font, "dropping them around the Script Area. Once")
	local line13 = TextField.new(font, "you are finished hit the submit button and")
	local line14 = TextField.new(font, "wait for your opponent to do the same. Once")
	local line15 = TextField.new(font, "both are done, the characters will start to")
	local line16 = TextField.new(font, "move around the Game Board based on what")
	local line17 = TextField.new(font, "your script says.")
	
	-- Set line positions
	line1:setPosition(15, 175)
	line2:setPosition(15, 200)
	line3:setPosition(15, 225)
	line4:setPosition(15, 250)
	line5:setPosition(15, 275)
	line6:setPosition(15, 325)
	line7:setPosition(15, 350)
	line8:setPosition(15, 375)
	line9:setPosition(15, 400)
	line10:setPosition(15, 425)
	line11:setPosition(15, 450)
	line12:setPosition(15, 475)
	line13:setPosition(15, 500)
	line14:setPosition(15, 525)
	line15:setPosition(15, 550)
	line16:setPosition(15, 575)
	line17:setPosition(15, 600)
	
	-- Add to scene
	self:addChild(line1)
	self:addChild(line2)
	self:addChild(line3)
	self:addChild(line4)
	self:addChild(line5)
	self:addChild(line6)
	self:addChild(line7)
	self:addChild(line8)
	self:addChild(line9)
	self:addChild(line10)
	self:addChild(line11)
	self:addChild(line12)
	self:addChild(line13)
	self:addChild(line14)
	self:addChild(line15)
	self:addChild(line16)
	self:addChild(line17)
end

function aboutGameplay:onEnterEnd()
	
end

function aboutGameplay:onExitBegin()
	
end