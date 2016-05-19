-- program is being exported under the TSU exception

GameLib = {}
GameLib["Collectors"] = function(gameInit)
	return CollectGameboard.new(gameInit)
end

GameLib["Trap"] = function(player)
	return TrapGameboard.new(gameInit)
end


