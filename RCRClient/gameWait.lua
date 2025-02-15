-- program is being exported under the TSU exception

--[[
	The screen that pops up when a user has submitted their
	choices for games and is waiting for someone to match up with.
]]
gameWait = Core.class(BaseScreen)

-- Sprites for loading spinner.
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

--[[
	Initializes extra scene objects and variables for the loading
	spinner.
]]
function gameWait:init()
	self.sceneName = "Waiting for Opponent..."
	
	-- Add cancel button
	local cancelButtonUp = Bitmap.new(Texture.new("images/cancelButtonUp.png"))
	local cancelButtonDown = Bitmap.new(Texture.new("images/cancelButtonDown.png"))
	self.cancelButton = CustomButton.new(cancelButtonUp, cancelButtonDown, function() 
		NET_ADAPTER:registerCallback('Cancel Search', function(data)
			sceneManager:changeScene("mainMenu", 1, SceneManager.crossfade, easing.outBack)
		end)
		NET_ADAPTER:sendData({type='Cancel Search', cancel=true})
	end)
	self.cancelButton:setPosition((WINDOW_WIDTH / 2) - (self.cancelButton:getWidth() / 2) , WINDOW_HEIGHT - self.cancelButton:getHeight() - 70)
	self:addChild(self.cancelButton)
	
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
	
	self.sprite:setPosition((WINDOW_WIDTH / 2) - (self.sprite:getWidth() / 2), self.cancelButton:getY() - self.sprite:getHeight() - 70)
	self:addChild(self.sprite)
end

--[[

]]
function gameWait:onEnterEnd()
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	NET_ADAPTER:registerCallback('Game Setup', function(data)
		NET_ADAPTER:unregisterCallback('Game Setup')
		sceneManager:changeScene("gameScreen", 1, SceneManager.crossfade, easing.outBack, {userData=data})
	end)
	--[[NET_ADAPTER:startRecv(function(res)
		if res.type == 'Player Joined' then
			sceneManager:changeScene("joinGame", 1, SceneManager.crossfade, easing.outBack)
		end
	end)]]
end

--[[

]]
function gameWait:onExitBegin()
	self:removeEventListener("enterEnd", self.onEnterEnd)
	self:removeEventListener("exitBegin", self.onExitBegin)
end

--[[

]]
function gameWait:onEnterFrame()
	self.frameCounter = (self.frameCounter + 1) % 5
	if self.frameCounter == 0 then
		self:animate()
	end
end

--[[
	Animates the loading spinner.
]]
function gameWait:animate()
	if self.sprite and self:getChildAt(3) == self.sprite then
		self:removeChild(self.sprite)
		end
	self.spriteCounter = (self.spriteCounter + 1) % table.getn(loadingSprites)
	self.sprite = loadingSprites[self.spriteCounter]
	self.sprite:setPosition((WINDOW_WIDTH / 2) - (self.sprite:getWidth() / 2), self.cancelButton:getY() - self.sprite:getHeight() - 70)
	self:addChild(self.sprite)
end




