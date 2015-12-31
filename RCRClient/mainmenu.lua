-- program is being exported under the TSU exception

gameSelect = Core.class(Sprite)

local firstCol = 250
local firstRow = 384
local spacing = 50
local buttonWidth = 35
local font = TTFont.new("fonts/arial-rounded.ttf", 20)

--[[
To add a new row of buttons for a game:
- Create new text field
- Assign new row value for buttons using this formula:
	newRow = previousRow + spacing + textfield:getHeight()
- Set the position of the text field to:
	X: self.firstCol - (textfield:getWidth() / 2)
	Y: newRow - (textfield:getHeight() / 2)
- Add textfield as child to the gameSelect box
- Call addButtons and pass in the newRow value calculated above
]]
function gameSelect:init(mainMenu)
	local game1Text = TextField.new(font, "Space Collectors")
	local easyDiffText = TextField.new(font, "Easy")
	local midDiffText = TextField.new(font, "Normal")
	local hardDiffText = TextField.new(font, "Hard")
	self.firstRow = easyDiffText:getHeight() + (spacing / 2) + game1Text:getHeight()
	self.firstCol = game1Text:getWidth() / 2
	self.secondCol = game1Text:getWidth() + spacing + (easyDiffText:getWidth() / 2)
	self.thirdCol = self.secondCol + (easyDiffText:getWidth() / 2) + spacing + (midDiffText:getWidth() / 2)
	self.fourthCol = self.thirdCol + (midDiffText:getWidth() / 2) + spacing + (hardDiffText:getWidth() / 2)
	game1Text:setPosition(self.firstCol - (game1Text:getWidth() / 2), self.firstRow - (game1Text:getHeight() / 2))
	easyDiffText:setPosition(self.secondCol - (easyDiffText:getWidth() / 2), 0)
	midDiffText:setPosition(self.thirdCol - (midDiffText:getWidth() / 2), 0)
	hardDiffText:setPosition(self.fourthCol - (hardDiffText:getWidth() / 2), 0)
	print(game1Text:getY())
	self:addChild(game1Text)
	self:addChild(easyDiffText)
	self:addChild(midDiffText)
	self:addChild(hardDiffText)
	self.game1buttonList = self:addButtons(self.firstRow)
	local game2Text = TextField.new(font, "Zombie Survivors")
	self.secondRow = self.firstRow + spacing + game2Text:getHeight()
	game2Text:setPosition(self.firstCol - (game2Text:getWidth() / 2), self.secondRow - (game2Text:getHeight()/2))
	self:addChild(game2Text)
	self.game2buttonList = self:addButtons(self.secondRow)
	local game3Text = TextField.new(font, "Game 3")
	self.thirdRow = self.secondRow + spacing + game3Text:getHeight()
	game3Text:setPosition(self.firstCol - (game3Text:getWidth() / 2), self.thirdRow - (game3Text:getHeight()/2))
	self:addChild(game3Text)
	self.game3buttonList = self:addButtons(self.thirdRow)
end

function gameSelect:addButtons(rowVal)
	buttonList = {}
	local uncheckedBox1 = Bitmap.new(Texture.new("images/unchecked.png"))
	local uncheckedBox2 = Bitmap.new(Texture.new("images/unchecked.png"))
	local uncheckedBox3 = Bitmap.new(Texture.new("images/unchecked.png"))
	local checkedBox1 = Bitmap.new(Texture.new("images/checked.png"))
	local checkedBox2 = Bitmap.new(Texture.new("images/checked.png"))
	local checkedBox3 = Bitmap.new(Texture.new("images/checked.png"))
	local easyButton = RadioButton.new(uncheckedBox1, checkedBox1)
	local midButton = RadioButton.new(uncheckedBox2, checkedBox2)
	local hardButton = RadioButton.new(uncheckedBox3, checkedBox3)
	local adjRowVal = rowVal - buttonWidth
	print(rowVal)
	easyButton:setPosition(self.secondCol - (easyButton:getWidth() / 2), adjRowVal)
	midButton:setPosition(self.thirdCol - (midButton:getWidth() / 2), adjRowVal)
	hardButton:setPosition(self.fourthCol - (hardButton:getWidth() / 2), adjRowVal)
	self:addChild(easyButton)
	self:addChild(midButton)
	self:addChild(hardButton)
	return {game1EasyButton, game1MidButton, game1HardButton}
end

mainMenu = Core.class(Sprite)

function mainMenu:init(params)	
	local font = TTFont.new("fonts/arial-rounded.ttf", 20)
	
	local titleBackground = Bitmap.new(Texture.new("images/background.png"))
	self:addChild(titleBackground)
	if params ~= nill then
		self.email = params.email
		self.password = params.password
		local emailText = TextField.new(font, self.email)
		emailText:setPosition(0, 50)
		self:addChild(emailText)
		local passwordText = TextField.new(font, self.password)
		passwordText:setPosition(0, 100)
		self:addChild(passwordText)
	else
		self.fail = "failed"
		local failedText = TextField.new(font, self.fail)
		self:addChild(failedText)
	end
	
	--[[local game1Text = TextField.new(font, "Space Collectors")
	local easyDiffText = TextField.new(font, "Easy")
	local midDiffText = TextField.new(font, "Moderate")
	local highDiffText = TextField.new(font, "Hard")
	
	game1Text:setPosition(firstCol - (game1Text:getWidth() / 2), firstRow)
	local zeroRow = self:getPreviousRow(firstRow, game1Text, easyDiffText)
	local secondCol = self:getNextCol(firstCol, game1Text, easyDiffText)
	easyDiffText:setPosition(secondCol - (easyDiffText:getWidth() / 2), zeroRow)
	local thirdCol = self:getNextCol(secondCol, easyDiffText, midDiffText)
	midDiffText:setPosition(thirdCol - (midDiffText:getWidth() / 2), zeroRow)
	local fourthCol = self:getNextCol(thirdCol, midDiffText, highDiffText)
	highDiffText:setPosition(fourthCol - (highDiffText:getWidth() / 2), zeroRow)
	self:addChild(game1Text)
	self:addChild(easyDiffText)
	self:addChild(midDiffText)
	self:addChild(highDiffText)
	-- Add buttons
	self.buttonList = self:addButtons(secondCol, thirdCol, fourthCol)]]
	local gameSelectBox = gameSelect.new()
	gameSelectBox:setPosition((WINDOW_WIDTH / 2) - (gameSelectBox:getWidth() / 2), (WINDOW_HEIGHT / 2) - (gameSelectBox:getHeight() / 2))
	self:addChild(gameSelectBox)
end



function mainMenu:getPreviousRow(rowVal, currentObj, newObj)
	return rowVal - (currentObj:getHeight()/2) - (spacing / 2) - (newObj:getHeight()/2) 
end

function mainMenu:getNextRow(rowVal, currentObj, newObj)
	return rowVal + (currentObj:getHeight()/2) + (spacing / 2) + (newObj:getHeight()/2)
end

function mainMenu:getNextCol(colVal, currentObj, newObj)
	return colVal + (currentObj:getWidth() / 2) + spacing + (newObj:getWidth() / 2)
end

function mainMenu:getPrevCol(colVal, currentObj, newObj)
	return colVal - (currentObj:getWidth() / 2) - spacing - (newObj:getWidth()/2)
end




