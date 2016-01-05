-- program is being exported under the TSU exception

TextBox = Core.class(Shape)

--[[
	width: width of TextBox
	height: height of TextBox
	fontSize: size of text
	color: color of TextBox
	defaultText: text for TextBox
	dialogTitle: title of dialog
	dialogMessage: message in dialog 
	dialogNo: negative dialog action, e.g. "Cancel"
	dialogYes: positive dialog action, e.g. "OK"
	}
]]

local defaultParams = {
	width = 100,
	height = 20,
	fontSize = 20,
	color = 0xffffff,
	defaultText = "",
	dialogTitle = "Dialog",
	dialogMessage = "",
	dialogNo = "Cancel",
	dialogYes = "OK",
	secure = false
}

local function filterParams(params)
	if not params then return defaultParams end
	
	for key,value in pairs(defaultParams) do
		if not params[key] then
			params[key] = value
		end
	end	
end


function TextBox:init(params)
	filterParams(params)
	self.params = params
	
	self:createBox(params)
	
	self:createTextField(params)
	
	self:addDialogListener(params)
	self.currentText = ""
end

function TextBox:setText(str)
	self.currentText = str
	if not self.params.secure then
		self.tf:setText(str)
	else
		local len = string.len(str)
		local stars = ""
		for i = 1,len do
			stars = stars .. "*"
		end
		self.tf:setText(stars)
	end
end

function TextBox:getText()
	return self.currentText
end

function TextBox:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) then
		local textInputDialog = TextInputDialog.new(self.params.dialogTitle, self.params.dialogMessage, self:getText(), self.params.dialogNo, self.params.dialogYes)
		textInputDialog:setSecureInput(self.params.secure)
		local onComplete
		local function onComplete(event)
			if event.buttonIndex == 1 then
				self:setText(event.text)
			end
			textInputDialog:removeEventListener(Event.COMPLETE, onComplete)
		end

		textInputDialog:addEventListener(Event.COMPLETE, onComplete)
		textInputDialog:show()
		event:stopPropagation()
	end
	
end

function TextBox:addDialogListener(params)
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
end

function TextBox:removeListener()
	self:removeEventListener(Event.MOUSE_DOWN, self.onMouseDown)
end

function TextBox:createTextField(params)
	local myfont = TTFont.new("fonts/arial-rounded.ttf", params.fontSize)
	local tf = TextField.new(myfont, params.defaultText)
	self.tf = tf
	tf:setPosition(10, 2 * params.height / 3)
	self:addChild(tf)
end

function TextBox:createBox(params)
	self:setLineStyle(3, 0x000000)
	self:setFillStyle(Shape.SOLID, params.color, 0.5)
	self:beginPath()
	self:moveTo(0, 0)
	self:lineTo(params.width, 0)
	self:lineTo(params.width, params.height)
	self:lineTo(0, params.height)
	self:closePath()
	self:endPath()
end
