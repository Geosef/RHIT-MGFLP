textBoxScene = Core.class(Sprite)

function textBoxScene:init()
	local tb = TextBox.new({fontSize = 40, width = 400, height = 100})
	tb:setPosition(100, 200)
	self:addChild(tb)
end