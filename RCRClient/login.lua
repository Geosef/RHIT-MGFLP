login = gideros.class(Sprite)

function login:init()
	local titleBackground = Bitmap.new(Texture.new("images/moonbackground.png"))
	titleBackground:setScale(1.5, 1)
	self:addChild(titleBackground)
	
	local emailInputDialog = TextInputDialog.new("Login", 
		"Enter your email and password",
		"", "Cancel", "Login")
	local function onComplete(event)
		sceneManager:changeScene("splash", 1, SceneManager.crossfade, easing.outBack) 
	end
	
	emailInputDialog:addEventListener(Event.COMPLETE, onComplete)
	emailInputDialog:show()	
end