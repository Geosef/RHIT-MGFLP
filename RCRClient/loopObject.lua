LoopObject = Core.class()

function LoopObject:init(iters)
	self.iterations = iters - 1
	self.commandList = {}
end

function LoopObject:addCommand(command)
	if command.name == "Loop End" then
		return
	end
	table.insert(self.commandList, command)
end

function LoopObject:expand()
	local expandedLoop = {}
	for i=1, self.iterations, 1 do 
		for i, v in ipairs(self.commandList) do
			table.insert(expandedLoop, v)
		end
	end
	return expandedLoop
end

