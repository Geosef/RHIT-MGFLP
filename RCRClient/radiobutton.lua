-- program is being exported under the TSU exception

RadioButton = Core.class(CustomButton)

function RadioButton:onMouseDown(event)
	if not self.enabled then
		return
	end
	if self.hitArea:hitTestPoint(event.x, event.y) then
		self.focus = true
		self:toggle()
		event:stopPropagation()
	end
end

function RadioButton:onMouseUp(event)
	if not self.enabled then
		return
	end
	if self.focus then
		self.focus = false
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
		if self.func ~= nil then
			self.func()
		end
	end
end

function RadioButton:toggle()
	self.isChecked = not self.isChecked
	self:updateVisualState(self.isChecked)
end

