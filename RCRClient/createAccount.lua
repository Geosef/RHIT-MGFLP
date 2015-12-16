-- program is being exported under the TSU exception

createAccount = Core.class(Sprite)

function createAccount:init()
	local font = TTFont.new("fonts/arial-rounded.ttf", 60)

	-- Add background
	local titleBackground = Bitmap.new(Texture.new("images/background.png"))
	self:addChild(titleBackground)

	-- Add logo
	local logo = Bitmap.new(Texture.new("images/RcrLogo.png"))
	logo:setScale(2, 2)
	logo:setPosition(0, 50)
	self:addChild(logo)	

	-- Add email text
	local emailText = TextField.new(font, "Email")
	emailText:setPosition(50, 285)
	self:addChild(emailText)

	-- Add email input box
	local emailTB = TextBox.new({fontSize = 60, width = 600, height = 100})
	emailTB:setPosition(350, 225)
	self:addChild(emailTB)
	
	-- Add password text
	local passwordText = TextField.new(font, "Password")
	passwordText:setPosition(50, 410)
	self:addChild(passwordText)

	-- Add password input box
	local passwordTB = TextBox.new({fontSize = 60, width = 600, height = 100})
	passwordTB:setPosition(350, 350)
	self:addChild(passwordTB)
	
	-- Add confirm password text
	local confirmText = TextField.new(font, "Confirm")
	confirmText:setPosition(50, 535)
	self:addChild(confirmText)

	local secondLine = TextField.new(font, "Password")
	secondLine:setPosition(50, 605)
	self:addChild(secondLine)
	
	-- Add confirm password input box
	local confirmTB = TextBox.new({fontSize = 60, width = 600, height = 100})
	confirmTB:setPosition(350, 475)
	self:addChild(confirmTB)
	
	-- Create "create account" image
	local createButton = Bitmap.new(Texture.new("images/createButton.png"))
	createButton:setScale(.6, .6)
	createButton:setPosition(575, 600)
	
	-- Create "create account" button
	local createClick = Button.new(createButton, createButton, function() 
		sceneManager:changeScene("mainMenu", 1, SceneManager.crossfade, easing.outBack,
			{userData = {email=emailTB.tf:getText(), password=passwordTB.tf:getText()}}) 
	end)
	self:addChild(createClick)
	
end