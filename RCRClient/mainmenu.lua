mainMenu = gideros.class(Sprite)

local firstCol = 300
local firstRow = 384
local spacing = 50

function mainMenu:init()
	local font = TTFont.new("fonts/arial-rounded.ttf", 20)
	local titleBackground = Bitmap.new(Texture.new("images/moonbackground.png"))
	titleBackground:setScale(1.5, 1)
	--self:addChild(titleBackground)
	
	--[[local tf = TextField.new(font, "Main Menu")
	tf:setTextColor(0xfb9900) -- Gideros logo orange
	tf:setPosition(56, 26)
	tf:setScale(2, 2)
	stage:addChild(tf)
	
	KEYBOARD:registerTextField(tf)]]
	-- Add text stuff
	local game1Text = TextField.new(font, "Space Collectors")
	local easyDiffText = TextField.new(font, "Easy")
	local midDiffText = TextField.new(font, "Moderate")
	local highDiffText = TextField.new(font, "Hard")
	local uncheckedBox1 = Bitmap.new(Texture.new("images/unchecked.png"))
	local uncheckedBox2 = Bitmap.new(Texture.new("images/unchecked.png"))
	local uncheckedBox3 = Bitmap.new(Texture.new("images/unchecked.png"))
	local checkedBox = Bitmap.new(Texture.new("images/checked.png"))
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
	print(game1Text:getY())
	-- Add buttons
	local game1EasyButton = RadioButton.new(uncheckedBox1, checkedBox, function() return end)
	local game1MidButton = Button.new(uncheckedBox2, checkedBox, function() return end)
	local game1HardButton = Button.new(uncheckedBox3, checkedBox, function() return end)
	local buttonRow1Val = firstRow - 30
	game1EasyButton:setPosition(secondCol - (game1EasyButton:getWidth() / 2), buttonRow1Val)
	game1MidButton:setPosition(thirdCol - (game1MidButton:getWidth() / 2), buttonRow1Val)
	game1HardButton:setPosition(fourthCol - (game1HardButton:getWidth() / 2), buttonRow1Val)
	self:addChild(game1EasyButton)
	self:addChild(game1MidButton)
	self:addChild(game1HardButton)
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









