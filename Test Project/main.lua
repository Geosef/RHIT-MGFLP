require('inputobj')
oldmain = require('oldmain')
--oldmain.run()
gameMod = require('collectgame')

game = gameMod.CollectGame(6)

--need functionality to remove objects from stage by having them remove their children
--eg remove grid should call remove cell which should call remove gold
--also need a global loadmodule func to avoid running top level module code every time we import

function onEnterFrame(event)
    game:update()
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)