-- Unit testing starts
M = {}
luaUnit = require('test/luaunit')
local playerMod = require('player')
local gridMod = require('grid')
local netMod = require('networkadapter')
require('mockobjects')
require('printer')
--setMocks()

WINDOW_WIDTH = 320
WINDOW_HEIGHT = 480

require('mockobjects')


TestPlayer = {} --test class
	local net = netMod.NetworkAdapter(false)
	local col = "Collect"
	local gameData = net.getGameState(col)
	local grid = gridMod.Grid("images/dirtcell.png", "Collect", gameData, false)
	print(gameData['goldLocations'])
	
	
	function TestPlayer:testMoveLeft()
		local player = playerMod.CollectPlayer(grid, 1, 8, false)
		luaUnit.assertEquals(player.getX(), 1)
		luaUnit.assertEquals(player.getY(), 1)
		luaUnit.assertEquals(player.getXSpeed(), 0)
		luaUnit.assertEquals(player.getYSpeed(), 0)
		luaUnit.assertEquals(player.getXDirection(), 0)
		luaUnit.assertEquals(player.getYDirection(), 0)
		
		player.moveLeft()
		
		luaUnit.assertEquals(player.getX(), 1)
		luaUnit.assertEquals(player.getY(), 1)
		luaUnit.assertEquals(player.getXSpeed(), 0)
		luaUnit.assertEquals(player.getYSpeed(), 0)
		luaUnit.assertEquals(player.getXDirection(), 0)
		luaUnit.assertEquals(player.getYDirection(), 0)
		player:destroy()
		
		player = playerMod.CollectPlayer(grid, 2, 8, false)
		luaUnit.assertEquals(player.getX(), 10)
		luaUnit.assertEquals(player.getY(), 10)
		luaUnit.assertEquals(player.getXSpeed(), 0)
		luaUnit.assertEquals(player.getYSpeed(), 0)
		luaUnit.assertEquals(player.getXDirection(), 0)
		luaUnit.assertEquals(player.getYDirection(), 0)
		
		player:moveLeft()
		
		luaUnit.assertEquals(player.getX(), 9)
		luaUnit.assertEquals(player.getY(), 10)
		luaUnit.assertEquals(player.getXSpeed(), 2)
		luaUnit.assertEquals(player.getYSpeed(), 0)
		luaUnit.assertEquals(player.getXDirection(), -1)
		luaUnit.assertEquals(player.getYDirection(), 0)
		player:destroy()
	end

	function TestPlayer:testMoveRight()
		local player = playerMod.CollectPlayer(grid, 1, 8, false)
		luaUnit.assertEquals(player.getX(), 1)
		luaUnit.assertEquals(player.getY(), 1)
		luaUnit.assertEquals(player.getXSpeed(), 0)
		luaUnit.assertEquals(player.getYSpeed(), 0)
		luaUnit.assertEquals(player.getXDirection(), 0)
		luaUnit.assertEquals(player.getYDirection(), 0)
		
		player:moveRight()
		
		luaUnit.assertEquals(player.getX(), 2)
		luaUnit.assertEquals(player.getY(), 1)
		luaUnit.assertEquals(player.getXSpeed(), 2)
		luaUnit.assertEquals(player.getYSpeed(), 0)
		luaUnit.assertEquals(player.getXDirection(), 1)
		luaUnit.assertEquals(player.getYDirection(), 0)
		player:destroy()
		
		player = playerMod.CollectPlayer(grid, 2, 8, false)
		luaUnit.assertEquals(player.getX(), 10)
		luaUnit.assertEquals(player.getY(), 10)
		luaUnit.assertEquals(player.getXSpeed(), 0)
		luaUnit.assertEquals(player.getYSpeed(), 0)
		luaUnit.assertEquals(player.getXDirection(), 0)
		luaUnit.assertEquals(player.getYDirection(), 0)
		
		player:moveRight()
		
		luaUnit.assertEquals(player.getX(), 10)
		luaUnit.assertEquals(player.getY(), 10)
		luaUnit.assertEquals(player.getXSpeed(), 0)
		luaUnit.assertEquals(player.getYSpeed(), 0)
		luaUnit.assertEquals(player.getXDirection(), 0)
		luaUnit.assertEquals(player.getYDirection(), 0)
		player:destroy()
	end
	
	function TestPlayer:testMoveUp()
		local player = playerMod.CollectPlayer(grid, 1, 8, false)
		luaUnit.assertEquals(player.getX(), 1)
		luaUnit.assertEquals(player.getY(), 1)
		luaUnit.assertEquals(player.getXSpeed(), 0)
		luaUnit.assertEquals(player.getYSpeed(), 0)
		luaUnit.assertEquals(player.getXDirection(), 0)
		luaUnit.assertEquals(player.getYDirection(), 0)
		
		player:moveUp()
		
		luaUnit.assertEquals(player.getX(), 1)
		luaUnit.assertEquals(player.getY(), 1)
		luaUnit.assertEquals(player.getXSpeed(), 0)
		luaUnit.assertEquals(player.getYSpeed(), 0)
		luaUnit.assertEquals(player.getXDirection(), 0)
		luaUnit.assertEquals(player.getYDirection(), 0)
		player:destroy()
		
		player = playerMod.CollectPlayer(grid, 2, 8, false)
		luaUnit.assertEquals(player.getX(), 10)
		luaUnit.assertEquals(player.getY(), 10)
		luaUnit.assertEquals(player.getXSpeed(), 0)
		luaUnit.assertEquals(player.getYSpeed(), 0)
		luaUnit.assertEquals(player.getXDirection(), 0)
		luaUnit.assertEquals(player.getYDirection(), 0)
		
		player:moveUp()
		
		luaUnit.assertEquals(player.getX(), 10)
		luaUnit.assertEquals(player.getY(), 9)
		luaUnit.assertEquals(player.getXSpeed(), 0)
		luaUnit.assertEquals(player.getYSpeed(), 2)
		luaUnit.assertEquals(player.getXDirection(), 0)
		luaUnit.assertEquals(player.getYDirection(), -1)
		player:destroy()
	end
	
	function TestPlayer:testMoveDown()
		local player = playerMod.CollectPlayer(grid, 1, 8, false)
		luaUnit.assertEquals(player.getX(), 1)
		luaUnit.assertEquals(player.getY(), 1)
		luaUnit.assertEquals(player.getXSpeed(), 0)
		luaUnit.assertEquals(player.getYSpeed(), 0)
		luaUnit.assertEquals(player.getXDirection(), 0)
		luaUnit.assertEquals(player.getYDirection(), 0)
		
		player:moveDown()
		
		luaUnit.assertEquals(player.getX(), 1)
		luaUnit.assertEquals(player.getY(), 2)
		luaUnit.assertEquals(player.getXSpeed(), 0)
		luaUnit.assertEquals(player.getYSpeed(), 2)
		luaUnit.assertEquals(player.getXDirection(), 0)
		luaUnit.assertEquals(player.getYDirection(), 1)
		player:destroy()
		
		player = playerMod.CollectPlayer(grid, 2, 8, false)
		luaUnit.assertEquals(player.getX(), 10)
		luaUnit.assertEquals(player.getY(), 10)
		luaUnit.assertEquals(player.getXSpeed(), 0)
		luaUnit.assertEquals(player.getYSpeed(), 0)
		luaUnit.assertEquals(player.getXDirection(), 0)
		luaUnit.assertEquals(player.getYDirection(), 0)
		
		player:moveDown()
		
		luaUnit.assertEquals(player.getX(), 10)
		luaUnit.assertEquals(player.getY(), 10)
		luaUnit.assertEquals(player.getXSpeed(), 0)
		luaUnit.assertEquals(player.getYSpeed(), 0)
		luaUnit.assertEquals(player.getXDirection(), 0)
		luaUnit.assertEquals(player.getYDirection(), 0)
		player:destroy()
	end
	
	function TestPlayer:testDig()
		local player = playerMod.CollectPlayer(grid, 1, 8, false)
		local cell = grid.rows[1][1]
		cell.hiddenTreasure = false
		
		luaUnit.assertEquals(player.getScore(), 0)
		
		player:dig()
		luaUnit.assertEquals(player.getScore(), 0)
		
		cell.hiddenTreasure = true
		player:dig()
		luaUnit.assertEquals(player.getScore(), 8)
		player:destroy()
		grid:destroy()
	end

function M.run()
	luaUnit.LuaUnit.run()
end

M.run()
--TestPlayer:testMoveLeft()

return M