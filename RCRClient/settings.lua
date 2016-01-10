-- program is being exported under the TSU exception

settings = Core.class(BasePopup)
local padding = 10

function settings:init()
	self.bgBox = Bitmap.new(Texture.new("images/settingsBox.png"))
	self.bgBox:setPosition((WINDOW_WIDTH / 2) - (self.bgBox:getWidth() / 2), 100)
	local closeButtonUp = Bitmap.new(Texture.new("images/closeSettingsButtonUp.png"))
	local closeButtonDown = Bitmap.new(Texture.new("images/closeSettingsButtonDown.png"))
	dismissalFunction = function()
		popupManager:removeChild(self)
	end
	local closeButton = CustomButton.new(closeButtonUp, closeButtonDown, dismissalFunction)
	closeButton:setPosition((self.bgBox:getWidth() / 2) - (closeButton:getWidth() / 2), padding)
	self.bgBox:addChild(closeButton)
	self:addChild(self.bgBox)
end

function settings:dismiss()
	self:removeChild(self.bgBox)
	BasePopup.dismiss(self)
end
