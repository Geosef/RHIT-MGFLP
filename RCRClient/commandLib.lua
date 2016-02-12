-- program is being exported under the TSU exception

CommandLib = {}
CommandLib["Move"] = function(player, direction, magnitude)
	-- change these to call player move functions
	if direction == "N" then
		--player.y = player.y - magnitude
		player:moveUp(magnitude)
	end
	if direction == "S" then
		player:moveDown(magnitude)
	end
	if direction == "E" then
		player:moveRight(magnitude)
	end
	if direction == "W" then
		player:moveLeft(magnitude)
	end
	return player
end
