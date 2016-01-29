GameCell = Core.class(Sprite)
local padding = 12
function GameCell:init()

end

GameBoard = Core.class(Bitmap)

function GameBoard:init()
	--local gameBoard = Bitmap.new(Texture.new("images/8x8-board.png"))
	print(self:getWidth())
	--self:setScale(480/self:getWidth(), 480/self:getHeight())
	self:setPosition(padding, (WINDOW_HEIGHT - padding) - self:getHeight())
	--self:addChild(gameBoard)
	print(self:getWidth())
end

