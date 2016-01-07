GameSelectRadioButton = Core.class(CustomButton)

function GameSelectRadioButton:onMouseDown(event)
	if self.hitArea:hitTestPoint(event.x, event.y) then
		if not self.func() then
			return
		end
		RadioButton.onMouseDown(self, event)
	end
end

function GameSelectRadioButton:onMouseUp(event)
	if self.focus then
		if not self.func() then
			return
		end	
		RadioButton.onMouseUp(self, event)
	end
end