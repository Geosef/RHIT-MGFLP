-- program is being exported under the TSU exception

CommandLibrary = Core.class()

function CommandLibrary:init()
	self.masterLibrary = {}
	self.masterLibrary["Move"] = function(player, direction, magnitude)
		if direction == "N" then
			player.y = player.y - magnitude
		end
		if direction == "S" then
			player.y = player.y + magnitude
		end
		if direction == "E" then
			player.x = player.x + magnitude
		end
		if direction == "W" then
			player.x = player.x - magnitude
		end
		return player
	end
end