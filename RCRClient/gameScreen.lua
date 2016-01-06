gameScreen = Core.class(BaseScreen)
local padding = 16
function gameScreen:init()
	--local titleBackground = Bitmap.new(Texture.new("images/background.png"))
	--self:addChild(titleBackground)
	local gameBoard = Bitmap.new(Texture.new("images/8x8-board.png"))
	gameBoard:setPosition(padding, (WINDOW_HEIGHT - padding) - gameBoard:getHeight())
	self:addChild(gameBoard)
	-- Eventually sceneName will be set by the type of game
	self.sceneName = "Game X"
	local statementBox = Bitmap.new(Texture.new("images/statement-box.png"))
	statementBox:setPosition(gameBoard:getX() + gameBoard:getWidth() + padding, (WINDOW_HEIGHT - padding) - statementBox:getHeight())
	self:addChild(statementBox)
	local commandBox = Bitmap.new(Texture.new("images/command-box.png"))
	commandBox:setPosition(statementBox:getX() + statementBox:getWidth() + padding, (WINDOW_HEIGHT - padding) - commandBox:getHeight())
	self:addChild(commandBox)
end

