require('inputobj')
oldmain = require('oldmain')
--oldmain.run()
inobj = require('inputobj')
--require('inputobj')

gridmod = require('grid')
grid = gridmod.Grid(5)

function funcprint()
	print('HELLO')
end


eventobj = inobj.EventObject(funcprint)
clusterobj = inobj.ClusterObject({eventobj})
loopobj = inobj.LoopObject(clusterobj, 3)
--loopobj:execute()

