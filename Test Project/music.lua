-- program is being exported under the TSU exception

M = {}
Music = Core.class(EventDispatcher)

function Music:init(music)
	--load main theme
	self.theme = Sound.new(music)
	self.eventOn = Event.new("onMusicOn")
	self.eventOff = Event.new("onMusicOff")
end

--turn music on
function Music:on()
	if not self.channel then
		self.channel = self.theme:play(0, true)
		self:dispatchEvent(self.eventOn)
	end
end

--turn music off
function Music:off()
	if self.channel then
		self.channel:stop()
		self.channel = nil
		self:dispatchEvent(self.eventOff)
	end
end

M.Music = Music
return M