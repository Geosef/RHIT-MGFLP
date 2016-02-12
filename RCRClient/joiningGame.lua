-- program is being exported under the TSU exception

joiningGame = Core.class(BaseScreen)

function joiningGame:init()
	self.sceneName = "Joining Game"
	local logo = Bitmap.new(Texture.new("images/joinGameText.png"))
	logo:setPosition((WINDOW_WIDTH / 2) - (logo:getWidth() / 2), (WINDOW_HEIGHT / 2) - (logo:getHeight() / 2))
	self:addChild(logo)
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function joiningGame:onEnterEnd()
	NET_ADAPTER:registerCallback('Game Setup', function(data)
		print('goto game')
		NET_ADAPTER:unregisterCallback('Game Setup')
		sceneManager:changeScene("gameScreen", 1, SceneManager.crossfade, easing.outBack,
		{userData=data})
	end,
	{type='Game Setup', game='Space Collectors', diff='Hard'})
end

function joiningGame:onExitBegin()
	self:removeEventListener("enterEnd", self.onEnterEnd)
	self:removeEventListener("exitBegin", self.onExitBegin)
end