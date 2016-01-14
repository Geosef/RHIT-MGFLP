-- program is being exported under the TSU exception

settings = Core.class(BasePopup)
local padding = 10

function settings:init()
	self.bgBox = Bitmap.new(Texture.new("images/settingsBox.png"))
	self.bgBox:setPosition((WINDOW_WIDTH / 2) - (self.bgBox:getWidth() / 2), 100)
	local closeButtonUp = Bitmap.new(Texture.new("images/closeSettingsButtonUp.png"))
	local closeButtonDown = Bitmap.new(Texture.new("images/closeSettingsButtonDown.png"))
	local acctSettingsButtonUp = Bitmap.new(Texture.new("images/acctSettingsUp.png"))
	local acctSettingButtonDown = Bitmap.new(Texture.new("images/acctSettingsDown.png"))
	dismissalFunction = function()
		popupManager:changeScene("blank", 1, SceneManager.crossfade, easing.outBack)
	end
	acctSettingsFunction = function()
		popupManager:changeScene("blank", 1, SceneManager.crossfade, easing.outBack)
		sceneManager:changeScene("acctSettings", 1, SceneManager.crossfade, easing.outBack)
	end
	local closeButton = CustomButton.new(closeButtonUp, closeButtonDown, dismissalFunction)
	closeButton:setPosition((self.bgBox:getWidth() / 2) - (closeButton:getWidth() / 2), padding)
	local acctSettingsButton = CustomButton.new(acctSettingsButtonUp, acctSettingButtonDown, acctSettingsFunction)
	acctSettingsButton:setPosition((self.bgBox:getWidth() / 2) - (acctSettingsButton:getWidth() / 2), 2 * padding + closeButton:getHeight())
	self.bgBox:addChild(acctSettingsButton)
	self.bgBox:addChild(closeButton)
	self:addChild(self.bgBox)
end

function settings:dismiss()
	self:removeChild(self.bgBox)
	BasePopup.dismiss(self)
end
