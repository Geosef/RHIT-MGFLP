-- program is being exported under the TSU exception

createAccount = Core.class(Sprite)

function createAccount:init()
	--local font = TTFont.new("fonts/arial-rounded.ttf", 20)

	-- Add background
	local titleBackground = Bitmap.new(Texture.new("images/background.png"))
	self:addChild(titleBackground)

	-- Add logo
	local logo = Bitmap.new(Texture.new("images/RcrLogo.png"))
	logo:setScale(2, 2)
	logo:setPosition(0, 50)
	self:addChild(logo)	

	-- Add email input box
	local emailTB = TextBox.new({fontSize = 60, width = 600, height = 100})
	emailTB:setPosition(200, 225)
	self:addChild(emailTB)
	
	-- Add password input box
	local passwordTB = TextBox.new({fontSize = 60, width = 600, height = 100})
	passwordTB:setPosition(200, 350)
	self:addChild(passwordTB)
	
	-- Add confirm password input box
	local confirmTB = TextBox.new({fontSize = 60, width = 600, height = 100})
	confirmTB:setPosition(200, 475)
	self:addChild(confirmTB)
	
	-- Create "create account" image
	local createButton = Bitmap.new(Texture.new("images/createButton.png"))
	createButton:setScale(.6, .6)
	createButton:setPosition(450, 600)
	
	-- Create "create account" button
	local createClick = Button.new(createButton, createButton, function() 
		sceneManager:changeScene("mainMenu", 1, SceneManager.crossfade, easing.outBack) 
	end)
	self:addChild(createClick)
	
end