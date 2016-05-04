-- program is being exported under the TSU exception

aboutCollector = Core.class(BaseScreen)

function aboutCollector:init()
	self:addAboutObjects()
	local titleFont = TTFont.new("fonts/arial-rounded.ttf", 60)
	local font = TTFont.new("fonts/arial-rounded.ttf", 20)

	-- Add title
	local titleText = TextField.new(titleFont, "Collector Gameplay")
	titleText:setPosition((WINDOW_WIDTH / 2) - (titleText:getWidth() / 2), 125)
	self:addChild(titleText)
	
	self:addContent()

	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function aboutCollector:addContent()
	local font = TTFont.new("fonts/arial-rounded.ttf", 20)
	
	-- Add text (NOTE: Must be added line-by-line since Lua TextFields don't support newline characters.
	local line1 = TextField.new(font, "Objective: There are coins and burried treasure")
	local line2 = TextField.new(font, "scattered throught the game board. Your objective")
	local line3 = TextField.new(font, "is to move around and collect enough gold to earn")
	local line4 = TextField.new(font, "30 points. Coins are worth 4 points and burried")
	local line5 = TextField.new(font, "treasure is worth x points.")
	local line6 = TextField.new(font, "Finding Burried Treasure: In order to get burried")
	local line7 = TextField.new(font, "treasure, you must use the Dig command. In your")
	local line8 = TextField.new(font, "script, use moves to get to where you think the")
	local line9 = TextField.new(font, "treasure is burried and then use a dig command.")
	local line10 = TextField.new(font, "If there is treasure there you will get x points.")
	local line11 = TextField.new(font, "Coins Spawning: At the beginning of the game there")
	local line12 = TextField.new(font, "will be coins placed randomly throughout the board.")
	local line13 = TextField.new(font, "During the game, based on the difficulty, new coins")
	local line14 = TextField.new(font, "will spawn every few rounds.")
	local line15 = TextField.new(font, "Wall Spawning: At the beginning of the game the")
	local line16 = TextField.new(font, "walls will also be randomly placed throughout the")
	local line17 = TextField.new(font, "board. And, just like the coins, the walls will move")
	local line18 = TextField.new(font, "around every few rounds based on the difficulty of")
	local line19 = TextField.new(font, "the game.")
	
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
	line11:setPosition(15, 475)
	line12:setPosition(15, 500)
	line13:setPosition(15, 525)
	line14:setPosition(15, 550)
	line15:setPosition((WINDOW_WIDTH / 2) + 15, 175)
	line16:setPosition((WINDOW_WIDTH / 2) + 15, 200)
	line17:setPosition((WINDOW_WIDTH / 2) + 15, 225)
	line18:setPosition((WINDOW_WIDTH / 2) + 15, 250)
	line19:setPosition((WINDOW_WIDTH / 2) + 15, 275)
	
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
	self:addChild(line18)
	self:addChild(line19)
end

function aboutCollector:onEnterEnd()
	
end

function aboutCollector:onExitBegin()
	
end