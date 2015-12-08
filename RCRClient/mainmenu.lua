mainMenu = gideros.class(Sprite)

function mainMenu:init()
	local titleBackground = Bitmap.new(Texture.new("images/moonbackground.png"))
	titleBackground:setScale(1.5, 1)
	--self:addChild(titleBackground)
	
	local tf = TextField.new(font, "Main Menu")
	tf:setTextColor(0xfb9900) -- Gideros logo orange
	tf:setPosition(56, 26)
	tf:setScale(2, 2)
	stage:addChild(tf)
	
	KEYBOARD:registerTextField(tf)
	
	
end



