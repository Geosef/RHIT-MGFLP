-- program is being exported under the TSU exception

splash = Core.class(BaseScreen)

function splash:init()
	local titleBackground = Bitmap.new(Texture.new("images/background.png"))
	local titleClick = CustomButton.new(titleBackground, titleBackground, function() 
		sceneManager:changeScene("login", 1, SceneManager.crossfade, easing.outBack)
	end)
	self:addChild(titleClick)
	local logo = Bitmap.new(Texture.new("images/RcrLogoLarge.png"))
	logo:setPosition(70, 100)
	self:addChild(logo)
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
	self.noBar = true
end

function splash:onEnterEnd()
	if pcall(NET_ADAPTER.connect) then
		sceneManager:changeScene("login", 1, SceneManager.crossfade, easing.outBack)
	else
		print("Not Connected")
	end
	self:dispatchEventToChildren()
end

function splash:onExitBegin()
	self:removeEventListener("enterEnd", self.onEnterEnd)
	self:removeEventListener("exitBegin", self.onExitBegin)
end
