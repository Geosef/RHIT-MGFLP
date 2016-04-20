-- program is being exported under the TSU exception

about = Core.class(BasePopup)
local font = TTFont.new("fonts/arial-rounded.ttf", 15)
local padding = 10

local bgBox = Core.class(SceneObject)

function bgBox:init()
	self.boxImage = Bitmap.new(Texture.new("images/settingsBox.png"))
	self:addChild(self.boxImage)
	
	-- Add about text
	local line1 = TextField.new(font, "Run Coder Run is a fun and interactive game that")
	local line2 = TextField.new(font, "introduces children to the basics of computer")
	local line3 = TextField.new(font, "programming. Play this game with friends in")
	local line4 = TextField.new(font, "head-to-head battles. Teachers, use it in the")
	local line5 = TextField.new(font, "classroom to help teach programming. Run Coder")
	local line6 = TextField.new(font, "Run starts with the most basic gameplay and works")
	local line7 = TextField.new(font, "up to users creating their own methods to be used")
	local line8 = TextField.new(font, "in battles.")
	
	line1:setPosition(self.boxImage:getX() + padding, self.boxImage:getY() + line1:getHeight() + padding)
	line2:setPosition(line1:getX(), line1:getY() + line2:getHeight() + padding)
	line3:setPosition(line2:getX(), line2:getY() + line3:getHeight() + padding)
	line4:setPosition(line3:getX(), line3:getY() + line4:getHeight() + padding)
	line5:setPosition(line4:getX(), line4:getY() + line5:getHeight() + padding)
	line6:setPosition(line5:getX(), line5:getY() + line6:getHeight() + padding)
	line7:setPosition(line6:getX(), line6:getY() + line7:getHeight() + padding)
	line8:setPosition(line7:getX(), line7:getY() + line8:getHeight() + padding)
	
	self:addChild(line1)
	self:addChild(line2)
	self:addChild(line3)
	self:addChild(line4)
	self:addChild(line5)
	self:addChild(line6)
	self:addChild(line7)
	self:addChild(line8)
	
	-- Add close button
	local closeButtonUp = Bitmap.new(Texture.new("images/closeSettingsButtonUp.png"))
	local closeButtonDown = Bitmap.new(Texture.new("images/closeSettingsButtonDown.png"))
	dismissalFunction = function()
		popupManager:changeScene("blank", 1, SceneManager.crossfade, easing.outBack)
	end
	local closeButton = CustomButton.new(closeButtonUp, closeButtonDown, dismissalFunction)
	closeButton:setPosition((self.boxImage:getWidth() / 2) - (closeButton:getWidth() / 2), self.boxImage:getHeight() - closeButton:getHeight() - padding)
	self:addChild(closeButton)
	
	-- Add more info button above close button
	local moreInfoButtonUp = Bitmap.new(Texture.new("images/moreInfoButtonUp.png"))
	local moreInfoButtonDown = Bitmap.new(Texture.new("images/moreInfoButtonDown.png"))
	local moreInfoButton = CustomButton.new(moreInfoButtonUp, moreInfoButtonDown, function() 
		sceneManager:changeScene("aboutGameplay", 1, SceneManager.crossfade, easing.outBack)
		popupManager:changeScene("blank", 1, SceneManager.crossfade, easing.outBack)
	end)
	moreInfoButton:setPosition((self.boxImage:getWidth() / 2) - (moreInfoButton:getWidth() / 2), closeButton:getY() - moreInfoButton:getHeight() - padding)
	self:addChild(moreInfoButton)
end

function about:init()
	self.bgBox = bgBox.new()
	self.bgBox:setPosition((WINDOW_WIDTH / 2) - (self.bgBox:getWidth() / 2), 100)
	self:addChild(self.bgBox)
end

function about:dismiss()
	self:removeChild(self.bgBox)
	BasePopup.dismiss(self)
end
