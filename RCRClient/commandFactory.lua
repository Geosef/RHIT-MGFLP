CommandFactory = Core.class()

function CommandFactory:init()
	self.masterLibrary = {}
	self.masterLibrary["Move"] = function(gameScreen)
		return DoubleScriptObject.new(gameScreen, "Move", {"N", "E", "S", "W"}, gameScreen.statementBox.resourceBox:getResources())
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

