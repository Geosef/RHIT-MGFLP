--[[
*************************************************************
 * This script is developed by Arturs Sosins aka ar2rsawseen, http://appcodingeasy.com
 * Feel free to distribute and modify code, but keep reference to its creator
 *
 * Gideros Game Template for developing games. Includes: 
 * Start scene, pack select, level select, settings, score system and much more
 *
 * For more information, examples and online documentation visit: 
 * http://appcodingeasy.com/Gideros-Mobile/Gideros-Mobile-Game-Template
**************************************************************
]]--
local networkModule = require('networkadapter')
require('printer')
local gameMod = require('game')

local multiplayerMode = false

JSON = (loadfile "JSON.lua")()
local netAdapter = networkModule.NetworkAdapter(multiplayerMode)

local function setGlobals()
	WINDOW_WIDTH = application:getLogicalWidth()
	WINDOW_HEIGHT = application:getLogicalHeight()
end

setGlobals()

local collectGame = gameMod.CollectGame(netAdapter)


level = gideros.class(Sprite)

function level:init()
	--self.addChild(collectGame)
    collectGame.update()
end


function onEnterFrame(event)

end

--stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)

function routePacket(jsonObject)
	if jsonObject.type == "events" then
		collectGame.runEvents(jsonObject)
	else
		print("unsupported packet from server")
		print_r(jsonObject)
	end
end

--removing event on exiting scene
function level:onExitBegin()
  self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end