acctSettings = Core.class(BaseScreen)

local font = TTFont.new("fonts/arial-rounded.ttf", 40)
local padding = 30
function acctSettings:init()
	-- need to change this probably
	self.sceneName = "Account Settings"
		
	-- Add logo
	local logo = Bitmap.new(Texture.new("images/NewRcrLogo.png"))
	logo:setPosition(0, 50)
	self:addChild(logo)	
	
	-- Images for checkBoxes
	local uncheckedBox1 = Bitmap.new(Texture.new("images/unchecked.png"))
	local uncheckedBox2 = Bitmap.new(Texture.new("images/unchecked.png"))
	local uncheckedBox3 = Bitmap.new(Texture.new("images/unchecked.png"))
	local checkedBox1 = Bitmap.new(Texture.new("images/checked.png"))
	local checkedBox2 = Bitmap.new(Texture.new("images/checked.png"))
	local checkedBox3 = Bitmap.new(Texture.new("images/checked.png"))

	-- Create and add buttons
	local notificationButton = RadioButton.new(checkedBox1, uncheckedBox1)
	local vibrationButton = RadioButton.new(checkedBox2, uncheckedBox2)
	local privacyButton = RadioButton.new(checkedBox3, uncheckedBox3)
	
	notificationButton:setPosition(5 * padding, logo:getY() + logo:getHeight() + padding)
	vibrationButton:setPosition(5 * padding, notificationButton:getY() + vibrationButton:getHeight() + padding)
	privacyButton:setPosition(5 * padding, vibrationButton:getY() + privacyButton:getHeight() + padding)
	
	self:addChild(notificationButton)
	self:addChild(vibrationButton)
	self:addChild(privacyButton)
	
	-- Create and add text for settings buttons
	local notificationText = TextField.new(font, "Notifications")
	local vibrationText = TextField.new(font, "Vibration")
	local privacyText = TextField.new(font, "Allow private invites")
	
	notificationText:setPosition(notificationButton:getX() + notificationButton:getWidth() + padding, notificationButton:getY() + notificationText:getHeight())
	vibrationText:setPosition(vibrationButton:getX() + vibrationButton:getWidth() + padding, vibrationButton:getY() + vibrationText:getHeight())
	privacyText:setPosition(privacyButton:getX()+ privacyButton:getWidth() + padding, privacyButton:getY() + privacyText:getHeight())
	
	self:addChild(notificationText)
	self:addChild(vibrationText)
	self:addChild(privacyText)
	
	-- Add password change boxes
	local changePasswordText = TextField.new(font, "Change Password")
	changePasswordText:setPosition(5 * padding, privacyButton:getY() + privacyText:getHeight() + changePasswordText:getHeight() + padding)
	self:addChild(changePasswordText)

	local newPasswordText = TextField.new(font, "New Password")
	newPasswordText:setPosition(changePasswordText:getX(), changePasswordText:getY() + changePasswordText:getHeight() + padding)
	self:addChild(newPasswordText)

	local passwordTB = TextBox.new({fontSize = 30, width = 300, height = 50, secure = true})
	
	local confirmPasswordText = TextField.new(font, "Confirm Password")
	confirmPasswordText:setPosition(newPasswordText:getX(), newPasswordText:getY() + newPasswordText:getHeight() + padding)
	self:addChild(confirmPasswordText)

	local confirmPasswordTB = TextBox.new({fontSize = 30, width = 300, height = 50, secure = true})
	confirmPasswordTB:setPosition(confirmPasswordText:getX() + confirmPasswordText:getWidth() + padding, confirmPasswordText:getY() - confirmPasswordTB:getHeight() + 10)
	self:addChild(confirmPasswordTB)
	passwordTB:setPosition(confirmPasswordTB:getX(), newPasswordText:getY() - passwordTB:getHeight() + 10)
	self:addChild(passwordTB)
	
	-- Add temporary text for clarification
	local helpText = TextField.new(font, "Hit submit to go to the main menu.")
	helpText:setPosition((WINDOW_WIDTH / 2) - (helpText:getWidth() / 2), confirmPasswordText:getY() + helpText:getHeight() + padding)
	self:addChild(helpText)
	
	-- Add button for exiting the settings menu.
	local submitButtonUp = Bitmap.new(Texture.new("images/submitButtonUp.png"))
	local submitButtonDown = Bitmap.new(Texture.new("images/submitButtonDown.png"))
	local submitButton = CustomButton.new(submitButtonUp, submitButtonDown, function() 
		sceneManager:changeScene("mainMenu", 1, SceneManager.crossfade, easing.outBack)
	end)
	submitButton:setPosition((WINDOW_WIDTH / 2) - (submitButton:getWidth() / 2) , helpText:getY() + submitButton:getHeight() - padding)
	self:addChild(submitButton)

	
end