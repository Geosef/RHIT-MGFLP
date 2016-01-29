-- program is being exported under the TSU exception

M = {}
Music = Core.class(EventDispatcher)

function Music:init(music)
	--load main theme
	self.theme = Sound.new(music)
	self.eventOn = Event.new("onMusicOn")
	self.eventOff = Event.new("onMusicOff")
	self.muted = false
end

--turn music on
function Music:on()
	if not self.channel then
		self.channel = self.theme:play(0, true)
		self.channel:setVolume(VOLUME)
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

--set volume
function Music:setVolume(volume)
	if self.channel then
		self.channel:setVolume(volume)
	end
end

--mute
function Music:mute()
	if self.channel and not self.muted then
		self.muted = true
		self.channel:setVolume(0.0)
	end
end

--unmute
function Music:unmute()
	if self.channel and self.muted then
		self.muted = false
		self.channel:setVolume(VOLUME)
	end
end

M.Music = Music
return M