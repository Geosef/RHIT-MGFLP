-- program is being exported under the TSU exception

createAccount = Core.class(BaseScreen)

function createAccount:init()
	self.sceneName = "Create Account"
	local font = TTFont.new("fonts/arial-rounded.ttf", 60)

	-- Add logo
	local logo = Bitmap.new(Texture.new("images/NewRcrLogo.png"))
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
	local passwordTB = TextBox.new({fontSize = 60, width = 600, height = 100, secure = true})
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
	local confirmTB = TextBox.new({fontSize = 60, width = 600, height = 100, secure = true})
	confirmTB:setPosition(350, 475)
	self:addChild(confirmTB)
	
	-- Create "create account" images
	local createButtonUp = Bitmap.new(Texture.new("images/createAccountButtonUp.png"))
	local createButtonDown = Bitmap.new(Texture.new("images/createAccountButtonDown.png"))
	
	-- Create "create account" button
	local createClick = CustomButton.new(createButtonUp, createButtonDown, function()
		local pass = passwordTB:getText()
		local conf = confirmTB:getText()
		if (pass == conf) then
			NET_ADAPTER:registerCallback('Create Account', function(data)
				
				if data.success then
					sceneManager:changeScene("mainMenu", 1, SceneManager.crossfade, easing.outBack)
				end
			end,
			{type='Create Account', success=true})
		end
		local toSend = {type='Create Account'}
		toSend.email = emailTB:getText()
		toSend.password = passwordTB:getText()
		NET_ADAPTER:sendData(toSend)
		print_r(toSend)
	end)
	createClick:setPosition(525, 600)
	self:addChild(createClick)
	
end