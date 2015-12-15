mainMenu = Core.class(Sprite)

local firstCol = 300
local firstRow = 384
local spacing = 50

function mainMenu:init()
	local font = TTFont.new("fonts/arial-rounded.ttf", 20)
	local titleBackground = Bitmap.new(Texture.new("images/moonbackground.png"))
	titleBackground:setScale(1.5, 1)
	local game1Text = TextField.new(font, "Space Collectors")
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
	self.buttonList = self:addButtons(secondCol, thirdCol, fourthCol)
end

function mainMenu:addButtons(secondCol, thirdCol, fourthCol)
	local uncheckedBox1 = Bitmap.new(Texture.new("images/unchecked.png"))
	local uncheckedBox2 = Bitmap.new(Texture.new("images/unchecked.png"))
	local uncheckedBox3 = Bitmap.new(Texture.new("images/unchecked.png"))
	local checkedBox1 = Bitmap.new(Texture.new("images/checked.png"))
	local checkedBox2 = Bitmap.new(Texture.new("images/checked.png"))
	local checkedBox3 = Bitmap.new(Texture.new("images/checked.png"))
	local game1EasyButton = RadioButton.new(uncheckedBox1, checkedBox1)
	local game1MidButton = RadioButton.new(uncheckedBox2, checkedBox2)
	local game1HardButton = RadioButton.new(uncheckedBox3, checkedBox3)
	local buttonRow1Val = firstRow - 25
	game1EasyButton:setPosition(secondCol - (game1EasyButton:getWidth() / 2), buttonRow1Val)
	game1MidButton:setPosition(thirdCol - (game1MidButton:getWidth() / 2), buttonRow1Val)
	game1HardButton:setPosition(fourthCol - (game1HardButton:getWidth() / 2), buttonRow1Val)
	self:addChild(game1EasyButton)
	self:addChild(game1MidButton)
	self:addChild(game1HardButton)
	return {game1EasyButton, game1MidButton, game1HardButton}
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









