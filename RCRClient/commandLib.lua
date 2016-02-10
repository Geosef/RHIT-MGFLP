-- program is being exported under the TSU exception

CommandLibrary = Core.class()

function CommandLibrary:init()
	self.masterLibrary = {}
	self.masterLibrary["Move"] = function(player, direction, magnitude)
		if direction == "N"
			player.y = player.y - magnitude
		if direction == "S"
			player.y = player.y + magnitude
		if direction == "E"
			player.x = player.x + magnitude
		if direction == "W"
			player.x = player.x - magnitude
		return player
	end
end