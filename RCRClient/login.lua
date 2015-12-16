-- program is being exported under the TSU exception

login = Core.class(Sprite)

function login:init()
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
	emailText:setPosition(50, 335)
	self:addChild(emailText)
	
	-- Add email input box
	local emailTB = TextBox.new({fontSize = 60, width = 600, height = 100})
	emailTB:setPosition(350, 275)
	self:addChild(emailTB)
	
	-- Add passowrd text
	local emailText = TextField.new(font, "Password")
	emailText:setPosition(50, 460)
	self:addChild(emailText)
	
	-- Add password input box
	local passwordTB = TextBox.new({fontSize = 60, width = 600, height = 100})
	passwordTB:setPosition(350, 400)
	self:addChild(passwordTB)
	
	-- Create login image
	local loginButton = Bitmap.new(Texture.new("images/loginButton.png"))
	loginButton:setScale(1, 1)
	loginButton:setPosition(340, 515)
	
	-- Create login button
	local loginClick = Button.new(loginButton, loginButton, function() 
		sceneManager:changeScene("mainMenu", 1, SceneManager.crossfade, easing.outBack,
			{userData = {email=emailTB.tf:getText(), password=passwordTB.tf:getText()}}) 
	end)
	self:addChild(loginClick)
	
	-- Create "create account" image
	local createButton = Bitmap.new(Texture.new("images/createButton.png"))
	createButton:setScale(.6, .6)
	createButton:setPosition(700, 525)
	
	-- Create "create account" button
	local createClick = Button.new(createButton, createButton, function() 
		sceneManager:changeScene("create", 1, SceneManager.crossfade, easing.outBack) 
	end)
	self:addChild(createClick)
	
end

--[[
***Old code for input dialog***

local emailInputDialog = TextInputDialog.new("Login", 
	"Enter your email and password",
	"", "Cancel", "Login")
local function onComplete(event)
	sceneManager:changeScene("splash", 1, SceneManager.crossfade, easing.outBack) 
end

emailInputDialog:addEventListener(Event.COMPLETE, onComplete)
emailInputDialog:show()	
]]

--[[
***Old code for custom keyboard input***

	-- Create white background for email text input
	local rect = Shape.new()
	rect:setLineStyle(1, 0x000000, 1)
	rect:setFillStyle(Shape.SOLID, 0xffffff)
	rect:beginPath()
	rect:moveTo(0, 0)
	rect:lineTo(600, 0)
	rect:lineTo(600, 75)
	rect:lineTo(0, 75)
	rect:lineTo(0, 0)
	rect:endPath()
	rect:setPosition(200, 300)
	self:addChild(rect)
	
	-- Create email input text field
	local emailInput = TextField.new(font, "email")
	emailInput:setTextColor(0x000000)
	emailInput:setPosition(206, 350)
	emailInput:setScale(5, 5)
	self:addChild(emailInput)
	
	KEYBOARD:registerTextField(emailInput)
]]