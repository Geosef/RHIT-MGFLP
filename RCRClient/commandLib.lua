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
end

CommandLib["Dig"] = function(player)
	player:dig()
end

CommandLib["Loop"] = function(player, iters)
	local newLoop = LoopObject.new(iters)
	table.insert(player.loopStack, newLoop)
end

CommandLib["Loop End"] = function(player)
	local completedLoop = table.remove(player.loopStack)
	local expandedLoop = completedLoop:expand()
	for i=table.getn(expandedLoop), 1, -1 do
		table.insert(player.eventQueue, player.eventIndex + 1, expandedLoop[i])
	end
end

CommandLib["Jump"] = function(player, direction)
	
end

