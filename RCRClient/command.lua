-- program is being exported under the TSU exception

local M = {}

local movementMod = Core.class(movement)
local controlStatements = Core.class(controlstatements)

-- Movement Commands
M.LeftMove = movementMod.LeftMove
M.RightMove = movementMod.RightMove
M.UpMove = movementMod.UpMove
M.DownMove = movementMod.DownMove

-- Control Statement Commands
M.LoopStart = controlStatements.LoopStart
M.LoopEnd = controlStatements.LoopEnd

function getEvent(name)
	return M[name]
end

M.getEvent = getEvent

return M