-- program is being exported under the TSU exception

RadioButton = gideros.class(Button)

function RadioButton:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) then
		self.focus = true
		self.isChecked = not self.isChecked
		self:updateVisualState(self.isChecked)
		event:stopPropagation()
		--print(self.name)
	end
end

function RadioButton:onMouseUp(event)

	print("done")
	if self.focus then
		self.focus = false
		self:dispatchEvent(Event.new("click"))	-- button is clicked, dispatch "click" event
		event:stopPropagation()
	end
end


