gameWait = Core.class(BaseScreen)

local loadingSprites = {}
loadingSprites[0] = Bitmap.new(Texture.new("images/LoadingSpinner/Spinner 1.png"))
loadingSprites[1] = Bitmap.new(Texture.new("images/LoadingSpinner/Spinner 2.png"))
loadingSprites[2] = Bitmap.new(Texture.new("images/LoadingSpinner/Spinner 3.png"))
loadingSprites[3] = Bitmap.new(Texture.new("images/LoadingSpinner/Spinner 4.png"))
loadingSprites[4] = Bitmap.new(Texture.new("images/LoadingSpinner/Spinner 5.png"))
loadingSprites[5] = Bitmap.new(Texture.new("images/LoadingSpinner/Spinner 6.png"))
loadingSprites[6] = Bitmap.new(Texture.new("images/LoadingSpinner/Spinner 7.png"))
loadingSprites[7] = Bitmap.new(Texture.new("images/LoadingSpinner/Spinner 8.png"))
loadingSprites[8] = Bitmap.new(Texture.new("images/LoadingSpinner/Spinner 9.png"))
loadingSprites[9] = Bitmap.new(Texture.new("images/LoadingSpinner/Spinner 10.png"))
loadingSprites[10] = Bitmap.new(Texture.new("images/LoadingSpinner/Spinner 11.png"))
loadingSprites[11] = Bitmap.new(Texture.new("images/LoadingSpinner/Spinner 12.png"))

function gameWait:init()
	self.sceneName = "Waiting for Opponent..."
	
	-- Add cancel button
	local submitButtonUp = Bitmap.new(Texture.new("images/submitButtonUp.png"))
	local submitButtonDown = Bitmap.new(Texture.new("images/submitButtonDown.png"))
	local submitButton = CustomButton.new(submitButtonUp, submitButtonDown, function() 
		sceneManager:changeScene("mainMenu", 1, SceneManager.crossfade, easing.outBack)
	end)
	submitButton:setPosition((WINDOW_WIDTH / 2) - (submitButton:getWidth() / 2) , WINDOW_HEIGHT - submitButton:getHeight() - 70)
	self:addChild(submitButton)
	
	-- Add waiting text
	local logo = Bitmap.new(Texture.new("images/waitingForOppText.png"))
	logo:setPosition(0, 100)
	self:addChild(logo)
	
	-- Add listeners
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
	
	-- Set up instance variables
	self.frameCounter = 0
	self.spriteCounter = 0
	self.sprite = loadingSprites[self.spriteCounter]
	
	self.sprite:setPosition((WINDOW_WIDTH / 2) - (self.sprite:getWidth() / 2), submitButton:getY() - self.sprite:getHeight() - 20)	
end

function gameWait:onEnterEnd()
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function gameWait:onExitBegin()
	self:removeEventListener("enterEnd", self.onEnterEnd)
	self:removeEventListener("exitBegin", self.onExitBegin)
end

function gameWait:onEnterFrame()
	self.frameCounter = (self.frameCounter + 1) % 5
	if self.frameCounter == 0 then
		self:animate()
	end
end

function gameWait:animate()
	self.spriteCounter = (self.spriteCounter + 1) % 12
	sprite = loadingSprites[self.spriteCounter]
	--sprite:setPosition((WINDOW_WIDTH / 2) - (sprite:getWidth() / 2), submitButton:getY() - sprite:getHeight() - 20)	
end




