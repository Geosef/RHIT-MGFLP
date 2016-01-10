ModdedSceneManager = Core.class(SceneManager)

function ModdedSceneManager:init(scenes)
	
end

function ModdedSceneManager:onEnterFrame(event)
	if not self.tweening then
		return
	end

	if self.time == 0 then
		self:onTransitionBegin()
		self.scene2:setVisible(true)
		dispatchEvent(self, "transitionBegin")
		dispatchEvent(self.scene1, "exitBegin")
		dispatchEvent(self.scene2, "enterBegin")
	end

	local timer = os.timer()
	local deltaTime = timer - self.currentTimer
	self.currentTimer = timer

	local t = (self.duration == 0) and 1 or (self.time / self.duration)

	self.transition(self.scene1, self.scene2, self.ease(t), t)

	if self.time == self.duration then
		dispatchEvent(self, "transitionEnd")
		dispatchEvent(self.scene1, "exitEnd")
		dispatchEvent(self.scene2, "enterEnd")
		self:onTransitionEnd()

		--self:removeChild(self.scene1)
		self.scene1 = self.scene2
		self.scene2 = nil
		self.tweening = false

		collectgarbage()
	end

	self.time = self.time + deltaTime

	if self.time > self.duration then
		self.time = self.duration
	end

end


