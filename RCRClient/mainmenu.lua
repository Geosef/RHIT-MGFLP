-- program is being exported under the TSU exception

gameSelect = Core.class(Sprite)

function gameSelect:init(mainMenu)
	local font = TTFont.new("fonts/arial-rounded.ttf", 20)
	local game1Text = TextField.new(font, "Space Collectors")
	local easyDiffText = TextField.new(font, "Easy")
	game1Text:setPosition(0, game1Text:getHeight())
	easyDiffText:setPosition(0, easyDiffText:getHeight())
	self:addChild(game1Text)
	self:addChild(easyDiffText)
end

mainMenu = Core.class(Sprite)

local firstCol = 250
local firstRow = 384
local spacing = 50

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




