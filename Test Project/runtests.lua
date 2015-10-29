-- Unit testing starts
M = {}
luaUnit = require('test/luaunit')
local playerMod = require('player')
local gridMod = require('grid')
local netMod = require('networkadapter')

WINDOW_WIDTH = 320
WINDOW_HEIGHT = 480




TestPlayer = {} --test class
	local net = netMod.NetworkAdapter(false)
	local col = "Collect"
	local gameData = net.getGameState(col)
	local grid = gridMod.Grid(gameData.gridSize, "images/dirtcell.png", gameData.goldLocations, gameData.gemLocations, gameData.treasureLocations)
	print(gameData['goldLocations'])
	
	
	function TestPlayer:testMoveLeft()
		local player = playerMod.Player(grid, true)
		luaUnit.assertEquals(player.x, 1)
		luaUnit.assertEquals(player.y, 1)
		luaUnit.assertEquals(player.xSpeed, 0)
		luaUnit.assertEquals(player.ySpeed, 0)
		luaUnit.assertEquals(player.xDirection, 0)
		luaUnit.assertEquals(player.yDirection, 0)
		
		player:moveLeft()
		
		luaUnit.assertEquals(player.x, 1)
		luaUnit.assertEquals(player.y, 1)
		luaUnit.assertEquals(player.xSpeed, 0)
		luaUnit.assertEquals(player.ySpeed, 0)
		luaUnit.assertEquals(player.xDirection, 0)
		luaUnit.assertEquals(player.yDirection, 0)
		player:destroy()
		
		player = playerMod.Player(grid, false)
		luaUnit.assertEquals(player.x, 10)
		luaUnit.assertEquals(player.y, 10)
		luaUnit.assertEquals(player.xSpeed, 0)
		luaUnit.assertEquals(player.ySpeed, 0)
		luaUnit.assertEquals(player.xDirection, 0)
		luaUnit.assertEquals(player.yDirection, 0)
		
		player:moveLeft()
		
		luaUnit.assertEquals(player.x, 9)
		luaUnit.assertEquals(player.y, 10)
		luaUnit.assertEquals(player.xSpeed, 2)
		luaUnit.assertEquals(player.ySpeed, 0)
		luaUnit.assertEquals(player.xDirection, -1)
		luaUnit.assertEquals(player.yDirection, 0)
		player:destroy()
	end

	function TestPlayer:testMoveRight()
		local player = playerMod.Player(grid, true)
		luaUnit.assertEquals(player.x, 1)
		luaUnit.assertEquals(player.y, 1)
		luaUnit.assertEquals(player.xSpeed, 0)
		luaUnit.assertEquals(player.ySpeed, 0)
		luaUnit.assertEquals(player.xDirection, 0)
		luaUnit.assertEquals(player.yDirection, 0)
		
		player:moveRight()
		
		luaUnit.assertEquals(player.x, 2)
		luaUnit.assertEquals(player.y, 1)
		luaUnit.assertEquals(player.xSpeed, 2)
		luaUnit.assertEquals(player.ySpeed, 0)
		luaUnit.assertEquals(player.xDirection, 1)
		luaUnit.assertEquals(player.yDirection, 0)
		player:destroy()
		
		player = playerMod.Player(grid, false)
		luaUnit.assertEquals(player.x, 10)
		luaUnit.assertEquals(player.y, 10)
		luaUnit.assertEquals(player.xSpeed, 0)
		luaUnit.assertEquals(player.ySpeed, 0)
		luaUnit.assertEquals(player.xDirection, 0)
		luaUnit.assertEquals(player.yDirection, 0)
		
		player:moveRight()
		
		luaUnit.assertEquals(player.x, 10)
		luaUnit.assertEquals(player.y, 10)
		luaUnit.assertEquals(player.xSpeed, 0)
		luaUnit.assertEquals(player.ySpeed, 0)
		luaUnit.assertEquals(player.xDirection, 0)
		luaUnit.assertEquals(player.yDirection, 0)
		player:destroy()
	end
	
	function TestPlayer:testMoveUp()
		local player = playerMod.Player(grid, true)
		luaUnit.assertEquals(player.x, 1)
		luaUnit.assertEquals(player.y, 1)
		luaUnit.assertEquals(player.xSpeed, 0)
		luaUnit.assertEquals(player.ySpeed, 0)
		luaUnit.assertEquals(player.xDirection, 0)
		luaUnit.assertEquals(player.yDirection, 0)
		
		player:moveUp()
		
		luaUnit.assertEquals(player.x, 1)
		luaUnit.assertEquals(player.y, 1)
		luaUnit.assertEquals(player.xSpeed, 0)
		luaUnit.assertEquals(player.ySpeed, 0)
		luaUnit.assertEquals(player.xDirection, 0)
		luaUnit.assertEquals(player.yDirection, 0)
		player:destroy()
		
		player = playerMod.Player(grid, false)
		luaUnit.assertEquals(player.x, 10)
		luaUnit.assertEquals(player.y, 10)
		luaUnit.assertEquals(player.xSpeed, 0)
		luaUnit.assertEquals(player.ySpeed, 0)
		luaUnit.assertEquals(player.xDirection, 0)
		luaUnit.assertEquals(player.yDirection, 0)
		
		player:moveUp()
		
		luaUnit.assertEquals(player.x, 10)
		luaUnit.assertEquals(player.y, 9)
		luaUnit.assertEquals(player.xSpeed, 0)
		luaUnit.assertEquals(player.ySpeed, 2)
		luaUnit.assertEquals(player.xDirection, 0)
		luaUnit.assertEquals(player.yDirection, -1)
		player:destroy()
	end
	
	function TestPlayer:testMoveDown()
		local player = playerMod.Player(grid, true)
		luaUnit.assertEquals(player.x, 1)
		luaUnit.assertEquals(player.y, 1)
		luaUnit.assertEquals(player.xSpeed, 0)
		luaUnit.assertEquals(player.ySpeed, 0)
		luaUnit.assertEquals(player.xDirection, 0)
		luaUnit.assertEquals(player.yDirection, 0)
		
		player:moveDown()
		
		luaUnit.assertEquals(player.x, 1)
		luaUnit.assertEquals(player.y, 2)
		luaUnit.assertEquals(player.xSpeed, 0)
		luaUnit.assertEquals(player.ySpeed, 2)
		luaUnit.assertEquals(player.xDirection, 0)
		luaUnit.assertEquals(player.yDirection, 1)
		player:destroy()
		
		player = playerMod.Player(grid, false)
		luaUnit.assertEquals(player.x, 10)
		luaUnit.assertEquals(player.y, 10)
		luaUnit.assertEquals(player.xSpeed, 0)
		luaUnit.assertEquals(player.ySpeed, 0)
		luaUnit.assertEquals(player.xDirection, 0)
		luaUnit.assertEquals(player.yDirection, 0)
		
		player:moveDown()
		
		luaUnit.assertEquals(player.x, 10)
		luaUnit.assertEquals(player.y, 10)
		luaUnit.assertEquals(player.xSpeed, 0)
		luaUnit.assertEquals(player.ySpeed, 0)
		luaUnit.assertEquals(player.xDirection, 0)
		luaUnit.assertEquals(player.yDirection, 0)
		player:destroy()
	end
	
	function TestPlayer:testDig()
		local player = playerMod.Player(grid, true)
		local cell = grid.rows[1][1]
		cell.hiddenTreasure = false
		
		luaUnit.assertEquals(player.score, 0)
		
		player:dig()
		luaUnit.assertEquals(player.score, 0)
		
		cell.hiddenTreasure = true
		player:dig()
		luaUnit.assertEquals(player.score, 8)
		player:destroy()
		grid:destroy()
	end

function M.run()
	luaUnit.LuaUnit.run()
end

M.run()
--TestPlayer:testMoveLeft()

return M