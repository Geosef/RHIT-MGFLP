gameOver = Core.class(BaseScreen)

function gameOver:init(endGameData)
	if not endGameData then endGameData = SERVER_MOCKS['Game Over'] end
	self.sceneName = "Game Over        Winner: " .. endGameData.winner
	
	-- Add cancel button
	local closeButtonUp = Bitmap.new(Texture.new("images/closeSettingsButtonUp.png"))
	local closeButtonDown = Bitmap.new(Texture.new("images/closeSettingsButtonDown.png"))
	self.closeButton = CustomButton.new(closeButtonUp, closeButtonDown, function() 
		sceneManager:changeScene("mainMenu", 1, SceneManager.crossfade, easing.outBack)
	end)
	self.closeButton:setPosition((WINDOW_WIDTH / 2) - (self.closeButton:getWidth() / 2) , WINDOW_HEIGHT - self.closeButton:getHeight() - 70)
	self:addChild(self.closeButton)
	
	-- Add waiting text
	
	-- Add listeners
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
	
end

function gameOver:onEnterEnd()
	--[[NET_ADAPTER:startRecv(function(res)
		if res.type == 'Player Joined' then
			sceneManager:changeScene("joinGame", 1, SceneManager.crossfade, easing.outBack)
		end
	end)]]
end

function gameOver:onExitBegin()
	self:removeEventListener("enterEnd", self.onEnterEnd)
	self:removeEventListener("exitBegin", self.onExitBegin)
end