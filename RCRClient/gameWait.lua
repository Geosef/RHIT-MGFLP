gameWait = Core.class(Sprite)

function gameWait:init()
	local titleBackground = Bitmap.new(Texture.new("images/background.png"))
	self:addChild(titleBackground)
	local logo = Bitmap.new(Texture.new("images/RcrLogoLarge.png"))
	logo:setPosition(70, 100)
	self:addChild(logo)
end




