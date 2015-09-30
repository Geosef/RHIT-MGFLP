require('inputobj')
oldmain = require('oldmain')
--oldmain.run()
inobj = require('inputobj')
--require('inputobj')
playermod = require('player')

gridmod = require('grid')
grid = gridmod.Grid(6)
player = playermod.Player(grid)

function funcprint()
	print('HELLO')
end

function moveL()
	player:moveLeft()
	print("Moved left")
	print("Player Score:", player.score)
end
function moveR()
	player:moveRight()
	print("Moved right")
	print("Player Score:", player.score)
end
function moveU()
	player:moveUp()
	print("Moved up")
	print("Player Score:", player.score)
end
function moveD()
	player:moveDown()
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

grid:reset()

--need functionality to remove objects from stage by having them remove their children
--eg remove grid should call remove cell which should call remove gold