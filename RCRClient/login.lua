-- program is being exported under the TSU exception

loginScreen = Core.class(BaseScreen)

function loginScreen:init()
	self.sceneName = "Login"
	local font = TTFont.new("fonts/arial-rounded.ttf", 60)

	-- Add logo
	local logo = Bitmap.new(Texture.new("images/NewRcrLogo.png"))
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
	self.emailTB = emailTB
	
	-- Add passowrd text
	local emailText = TextField.new(font, "Password")
	emailText:setPosition(50, 460)
	self:addChild(emailText)
	
	-- Add password input box
	local passwordTB = TextBox.new({fontSize = 60, width = 600, height = 100, secure = true})
	passwordTB:setPosition(350, 400)
	self:addChild(passwordTB)
	self.passwordTB = passwordTB
	
	-- Create login image
	local loginButtonUp = Bitmap.new(Texture.new("images/loginButtonUp.png"))
	local loginButtonDown = Bitmap.new(Texture.new("images/loginButtonDown.png"))
	
	-- Create login button
	local loginClick = CustomButton.new(loginButtonUp, loginButtonDown, function() 
			self:login()
	end)
	loginClick:setPosition(347, 515)
	self:addChild(loginClick)
	
	-- Create "create account" image
	local createButtonUp = Bitmap.new(Texture.new("images/createAccountButtonUp.png"))
	local createButtonDown = Bitmap.new(Texture.new("images/createAccountButtonDown.png"))
	
	-- Create "create account" button
	local createClick = CustomButton.new(createButtonUp, createButtonDown, function() 
		sceneManager:changeScene("create", 1, SceneManager.crossfade, easing.outBack) 
	end)
	createClick:setPosition(700, 515)
	self:addChild(createClick)
	
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function loginScreen:login()
	if NET_ADAPTER.on then
		NET_ADAPTER:registerCallback('Login', function(data)
			if data.success then
				print('Logged in')
				NET_ADAPTER:unregisterCallback('Login')
				sceneManager:changeScene("mainMenu", 1, SceneManager.crossfade, easing.outBack,
				{userData = {email=self.emailTB:getText(), password=self.passwordTB:getText()}})
			else
				print('Login failed')
				self.emailTB:setText("")
				self.passwordTB:setText("")
			end
		end)
		
		local loginPacket = {}
		loginPacket.type = 'Login'
		loginPacket.username = self.emailTB:getText()
		loginPacket.password = self.passwordTB:getText()
		
		NET_ADAPTER:sendData(loginPacket)
		
	else
		sceneManager:changeScene("mainMenu", 1, SceneManager.crossfade, easing.outBack) 
	end
end

function loginScreen:onEnterEnd()
	
end

function loginScreen:onExitBegin()
	
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