CommandFactory = Core.class()

function CommandFactory:init()
	self.masterLibrary = {}
	self.masterLibrary["Move"] = function(params)
		return DoubleScriptObject.new(params.gameScreen, "Move", {"N", "E", "S", "W"}, {1, 2, 3, 4})
	end
	self.masterLibrary["Loop"] = function() end
	self.masterLibrary["Dig"] = function() end
	self.sublibs = {}
	self.sublibs["Space Collectors"] = self:initSpaceCollectorsGameCommands()
end

function CommandFactory:initSpaceCollectorsGameCommands()
	local sublib = {}
	sublib["Move"] = self.masterLibrary["Move"]
	return sublib
end

function CommandFactory:getSubLibrary(game)
	return self.sublibs[game]
end

