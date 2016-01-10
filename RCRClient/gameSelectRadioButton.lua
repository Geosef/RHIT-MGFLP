GameSelectRadioButton = Core.class(RadioButton)

function GameSelectRadioButton:init(upState, downState, func, canSelect)
	self.canSelect = canSelect
end

function GameSelectRadioButton:onMouseDown(event)
	if self.hitArea:hitTestPoint(event.x, event.y) then
		if not self.canSelect() then
			return
		end	
		self.focus = true
		self:toggle()
		event:stopPropagation()
		--print(self.name)
	end
end

function GameSelectRadioButton:onMouseUp(event)
	
	if self.focus then
		if not self.canSelect() then
			return
		end	
		self.focus = false
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		self.func()
	end
end