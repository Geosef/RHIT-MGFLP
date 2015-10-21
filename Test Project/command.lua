local M = {}

local movementMod = require("movement")
local specialMoves = require("specialmoves")
local controlStatements = require("controlstatements")

-- Movement Commands
M.LeftMove = movementMod.LeftMove
M.RightMove = movementMod.RightMove
M.UpMove = movementMod.UpMove
M.DownMove = movementMod.DownMove

-- Special Move Commands
M.Dig = specialMoves.Dig

-- Control Statement Commands
M.LoopStart = controlStatements.LoopStart
M.LoopEnd = controlStatements.LoopEnd

function getEvent(name)
	return M[name]
end

M.getEvent = getEvent

return M