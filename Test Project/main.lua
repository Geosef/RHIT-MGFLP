require('inputobj')
oldmain = require('oldmain')
--oldmain.run()
inobj = require('inputobj')
--require('inputobj')
playermod = require('player')

gridmod = require('grid')
grid = gridmod.Grid(5)
player = playermod.Player(grid)

function funcprint()
	print('HELLO')
end

function moveL()
	player:moveLeft(grid)
	print("Moved left")
	print("Player Score:", player.score)
end
function moveR()
	player:moveRight(grid)
	print("Moved right")
	print("Player Score:", player.score)
end
function moveU()
	player:moveUp(grid)
	print("Moved up")
	print("Player Score:", player.score)
end
function moveD()
	player:moveDown(grid)
	print("Moved down")
	print("Player Score:", player.score)
end



eventobj1 = inobj.EventObject(moveR)
eventobj2 = inobj.EventObject(moveR)
eventobj3 = inobj.EventObject(moveD)
eventobj4 = inobj.EventObject(moveR)
eventobj5 = inobj.EventObject(moveD)
eventobj6 = inobj.EventObject(moveL)
eventobj7 = inobj.EventObject(moveL)




clusterobj = inobj.ClusterObject({eventobj1, eventobj2, eventobj3, eventobj4, eventobj5, eventobj6, eventobj7})
loopobj = inobj.LoopObject(clusterobj, 2)
loopobj:execute()

