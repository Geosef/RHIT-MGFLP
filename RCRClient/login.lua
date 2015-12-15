login = Core.class(Sprite)

function login:init()
	-- Add background
	local titleBackground = Bitmap.new(Texture.new("images/starsBackground.png"))
	titleBackground:setScale(.5, .5)
	self:addChild(titleBackground)

	-- Add logo
	local logo = Bitmap.new(Texture.new("images/RcrLogo.png"))
	logo:setPosition(0, 225)
	self:addChild(logo)	
	
	-- Create white background for email text input
	local rect = Shape.new()
	rect:setLineStyle(1, 0x000000, 1)
	rect:setFillStyle(Shape.SOLID, 0xffffff)
	rect:beginPath()
	rect:moveTo(0, 0)
	rect:lineTo(300, 0)
	rect:lineTo(300, 25)
	rect:lineTo(0, 25)
	rect:lineTo(0, 0)
	rect:endPath()
	rect:setPosition(50, 50)
	self:addChild(rect)
	
	-- Create email input text field
	local emailInput = TextField.new(font, "email")
	emailInput:setTextColor(0x000000)
	emailInput:setPosition(56, 70)
	emailInput:setScale(2, 2)
	self:addChild(emailInput)
	
	KEYBOARD:registerTextField(emailInput)
	
	-- Create white background for password text input
	local rect2 = Shape.new()
	rect2:setLineStyle(1, 0x000000, 1)
	rect2:setFillStyle(Shape.SOLID, 0xffffff)
	rect2:beginPath()
	rect2:moveTo(0, 0)
	rect2:lineTo(300, 0)
	rect2:lineTo(300, 25)
	rect2:lineTo(0, 25)
	rect2:lineTo(0, 0)
	rect2:endPath()
	rect2:setPosition(50, 85)
	self:addChild(rect2)
	
	-- Create password input text field
	local passwordInput = TextField.new(font, "password")
	passwordInput:setTextColor(0x000000)
	passwordInput:setPosition(56, 105)
	passwordInput:setScale(2, 2)
	self:addChild(passwordInput)
	
	KEYBOARD:registerTextField(passwordInput)
	
	-- Create login image
	local loginButton = Bitmap.new(Texture.new("images/loginButton.png"))
	loginButton:setScale(.5, .5)
	loginButton:setPosition(45, 110)
	
	-- Create login button
	local loginClick = Button.new(loginButton, loginButton, function() 
		sceneManager:changeScene("mainMenu", 1, SceneManager.crossfade, easing.outBack) 
	end)
	self:addChild(loginClick)
	
	-- Create "create account" image
	local createButton = Bitmap.new(Texture.new("images/createButton.png"))
	createButton:setScale(.4, .4)
	createButton:setPosition(390, 40)
	
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