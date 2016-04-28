local gameCommandButtonHeight = 65
CommandBox = Core.class(SceneObject)

function CommandBox:init(parent)
	self.headerBottom = 49
	self.parent = parent
	self.boxImage = Bitmap.new(Texture.new("images/command-box.png"))
	self:addChild(self.boxImage)
	-- eventually, this will query the game for the buttons to add
	self:initButtons()
end

function CommandBox:initButtons()
	local commandSet = COMMAND_FACTORY:getSubLibrary(self.parent.sceneName)
	self.commandTypes = {}
	--ERROR CHECKING IF STATEMENTS!!! YAY!!!
	if commandSet then
		for i,v in pairs(commandSet) do
			local gameButtonUp = Bitmap.new(Texture.new("images/game-button.png"))
			local gameButtonDown = Bitmap.new(Texture.new("images/game-button-down.png"))
			local addButton = function(name)
				self.parent.statementBox:addCommand(v(self.parent.statementBox.scriptArea))
				--self.parentScreen.statementBox:scriptCountCheck(false)
			end
			local gameButton = GameButton.new(gameButtonUp, gameButtonDown, addButton, i)
			table.insert(self.commandTypes, gameButton)
		end
	end
	local numCommands = # self.commandTypes
	local buttonYPadding = self:calculateYPadding(numCommands)
	local yLoc = self.headerBottom + buttonYPadding
	if self.commandTypes then
		for i,v in ipairs(self.commandTypes) do
			v:setPosition((self:getWidth() / 2) - (v:getWidth() / 2), yLoc)
			self:addChild(v)
			yLoc = yLoc + v:getHeight() + buttonYPadding
		end
	end
end

function CommandBox:calculateYPadding(numCommands)
	local boxHeight = self:getHeight() - self.headerBottom
	local buttonYSpace = gameCommandButtonHeight * numCommands
	local yPadding = (boxHeight - buttonYSpace) / (numCommands + 1)
	return yPadding
end	
