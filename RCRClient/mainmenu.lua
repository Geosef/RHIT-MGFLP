-- program is being exported under the TSU exception

gameSelect = Core.class(SceneObject)

local spacing = 50
local buttonWidth = 35
local font = TTFont.new("fonts/arial-rounded.ttf", 20)

--[[
To add a new row of buttons for a game, just call self:addGame() and pass in the name of the game.
]]
function gameSelect:init(mainMenu)
	local game1Text = TextField.new(font, "Space Collectors")
	local easyDiffText = TextField.new(font, "Easy")
	local midDiffText = TextField.new(font, "Medium")
	local hardDiffText = TextField.new(font, "Hard")
	self.numRows = 1
	self.rowVals = {easyDiffText:getHeight() + (spacing / 2) + game1Text:getHeight()}
	self.firstCol = game1Text:getWidth() / 2
	self.secondCol = game1Text:getWidth() + spacing + (easyDiffText:getWidth() / 2)
	self.thirdCol = self.secondCol + (easyDiffText:getWidth() / 2) + spacing + (midDiffText:getWidth() / 2)
	self.fourthCol = self.thirdCol + (midDiffText:getWidth() / 2) + spacing + (hardDiffText:getWidth() / 2)
	--game1Text:setPosition(self.firstCol - (game1Text:getWidth() / 2), self.rowVals[self.numRows] - (game1Text:getHeight() / 2))
	easyDiffText:setPosition(self.secondCol - (easyDiffText:getWidth() / 2), 0)
	midDiffText:setPosition(self.thirdCol - (midDiffText:getWidth() / 2), 0)
	hardDiffText:setPosition(self.fourthCol - (hardDiffText:getWidth() / 2), 0)
	--self:addChild(game1Text)
	self:addChild(easyDiffText)
	self:addChild(midDiffText)
	self:addChild(hardDiffText)
	self.buttonList = {}
	self.checkedButtons = {}
	--self:addButtons(self.rowVals[self.numRows])
	self:addGame("Space Collectors")
	--self:addGame("Zombie Survivors")
	--self:addGame("Game 3")

end

function gameSelect:addGame(name)
	local gametext = TextField.new(font, name)
	local newRow = self.rowVals[self.numRows] + spacing + gametext:getHeight()
	table.insert(self.rowVals, newRow)
	gametext:setPosition(self.firstCol - (gametext:getWidth() / 2), self.rowVals[self.numRows] - (gametext:getHeight()/2))
	self:addChild(gametext)
	self:addButtons(self.rowVals[self.numRows], name)
	self.numRows = self.numRows + 1
end

function gameSelect:addButtons(rowVal, name)
	local uncheckedBox1 = Bitmap.new(Texture.new("images/unchecked.png"))
	local uncheckedBox2 = Bitmap.new(Texture.new("images/unchecked.png"))
	local uncheckedBox3 = Bitmap.new(Texture.new("images/unchecked.png"))
	local checkedBox1 = Bitmap.new(Texture.new("images/checked.png"))
	local checkedBox2 = Bitmap.new(Texture.new("images/checked.png"))
	local checkedBox3 = Bitmap.new(Texture.new("images/checked.png"))
	buttonFunc = function()
		for i,v in ipairs(self.buttonList) do
			buttonIndex = inTable(self.checkedButtons, v)
			if v.isChecked then
				if not buttonIndex then
					table.insert(self.checkedButtons, v)
					if table.getn(self.checkedButtons) == 3 then
						self:disableUnchecked()
					end
				end
			else
				if buttonIndex then
					table.remove(self.checkedButtons, buttonIndex)
					self:enableButtons()
				end
			end
		end
	end

	local easyButton = RadioButton.new(uncheckedBox1, checkedBox1, buttonFunc)
	local midButton = RadioButton.new(uncheckedBox2, checkedBox2, buttonFunc)
	local hardButton = RadioButton.new(uncheckedBox3, checkedBox3, buttonFunc)
	local adjRowVal = rowVal - buttonWidth
	easyButton.diff = "Easy"
	midButton.diff = "Medium"
	hardButton.diff = "Hard"
	easyButton.game = name
	midButton.game = name
	hardButton.game = name
	easyButton:setPosition(self.secondCol - (easyButton:getWidth() / 2), adjRowVal)
	midButton:setPosition(self.thirdCol - (midButton:getWidth() / 2), adjRowVal)
	hardButton:setPosition(self.fourthCol - (hardButton:getWidth() / 2), adjRowVal)
	self:addChild(easyButton)
	self:addChild(midButton)
	self:addChild(hardButton)
	table.insert(self.buttonList, easyButton)
	table.insert(self.buttonList, midButton)
	table.insert(self.buttonList, hardButton)
end

function gameSelect:disableUnchecked()
	for i,v in ipairs(self.buttonList) do
		if not inTable(self.checkedButtons, v) then
			v:disable()
		end
	end
end

function gameSelect:enableButtons()
	for i,v in ipairs(self.buttonList) do
		v:enable()
	end
end

mainMenu = Core.class(BaseScreen)

function mainMenu:init(params)
	local font = TTFont.new("fonts/arial-rounded.ttf", 20)
	self.sceneName = "Main Menu - Select Game"
	local gameSelectBox = gameSelect.new()
	gameSelectBox:setPosition((WINDOW_WIDTH / 2) - (gameSelectBox:getWidth() / 2), (WINDOW_HEIGHT / 2) - (gameSelectBox:getHeight() / 2))
	self:addChild(gameSelectBox)
	local helpText = TextField.new(font, "Select your top 3 games and hit submit.")
	helpText:setPosition((WINDOW_WIDTH / 2) - (helpText:getWidth() / 2), gameSelectBox:getPosition() - helpText:getHeight() - 20)
	self:addChild(helpText)

	-- Add submit button
	local submitButtonUp = Bitmap.new(Texture.new("images/submitButtonUp.png"))
	local submitButtonDown = Bitmap.new(Texture.new("images/submitButtonDown.png"))
	submitFunc = function()
		mainMenu:sendSelected(gameSelectBox.checkedButtons)
		--sceneManager:changeScene("gameWait", 1, SceneManager.crossfade, easing.outBack)
	end
	local submitButton = CustomButton.new(submitButtonUp, submitButtonDown, submitFunc)
	submitButton:setPosition((WINDOW_WIDTH / 2) - (submitButton:getWidth() / 2) , WINDOW_HEIGHT - submitButton:getHeight() - 70)
	self:addChild(submitButton)
end

function mainMenu:sendSelected(checkedButtons)
	local choices = {}
	for i,v in ipairs(checkedButtons) do
		local choice = {}
		choice.game = v.game
		choice.diff = v.diff
		table.insert(choices, choice)
	end
	print_r(choices)
	local packet = {}
	packet.type = 'Browse Games'
	packet.choices = choices

	NET_ADAPTER:registerCallback('Browse Games', function(data)
		NET_ADAPTER:unregisterCallback('Browse Games')
		if data.match then
			print('here1')
			sceneManager:changeScene("joinGame", 1, SceneManager.crossfade, easing.outBack)
		else
			print('here2')
			sceneManager:changeScene("gameWait", 1, SceneManager.crossfade, easing.outBack)
		end
	end,
	{type='Browse Games', match=true})
	
	NET_ADAPTER:registerCallback('Player Joined', function(data)
		NET_ADAPTER:unregisterCallback('Player Joined')
		print('Player Joined packet received')
		sceneManager:changeScene("joinGame", 1, SceneManager.crossfade, easing.outBack)
	end)

	NET_ADAPTER:sendData(packet)
	--[[NET_ADAPTER:browseGames(choices, function(res)
		self:receiveBrowseResponse(res)
	end)]]
end

function mainMenu:receiveBrowseResponse(response)
	print_r(response)
	if response.match then --joining game
		--goToJoiningGame()
		--switch to joining game screen while server processes game setup and removal from joinable games
		--then show initial game screen
		sceneManager:changeScene("joinGame", 1, SceneManager.crossfade, easing.outBack)
	else	--put in waitlist on server,
		--goToSearchingScreen()
		--stay in searching for game, cancel if want to back out.
		--if press cancel during game join too bad
		--have lock on clienthandler for knowing whether you are joining a game or cancelling
		sceneManager:changeScene("gameWait", 1, SceneManager.crossfade, easing.outBack)
	end
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




