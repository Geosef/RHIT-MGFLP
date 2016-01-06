BaseScreen = Core.class(Sprite)

function BaseScreen:init()
	local titleBackground = Bitmap.new(Texture.new("images/background.png"))
	self:addChild(titleBackground)
	local topBar = Bitmap.new(Texture.new("images/RCRTopBar.png"))
	self:addChild(topBar)
end

