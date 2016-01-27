-- program is being exported under the TSU exception

local M = {}

local gridMod = require('grid')
local playerMod = require('player')
local engineMod = require('inputengine')
--local buttonMod = require('inputbutton')
--local commandMod = require('command')
--local collectibleMod = require('collectible')

local Game = {}
Game.__index = Game

setmetatable(Game, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Game:_init(netAdapter, imagePath, testing)
	self.netAdapter = netAdapter
	self:setBackground(imagePath, testing)
end

function Game:setBackground(imagePath, testing)
	if not testing then
		self.background = Bitmap.new(Texture.new(imagePath))
	end
end

function Game:setupGrid(imagePath, gameState, testing)
	print("Grid setup not implemented!")
end

function Game:setupPlayers(gameState, testing)
	print("Player setup not implemented!")
end

function Game:setupEngine(numButtons, testing)
	self.engine = engineMod.InputEngine(self)
	if testing then
		return
	end
	self.setupPanel(numButtons)
end

function Game:setupPanel()
	print("Game panel not implemented!")
end

function Game:sendMoves()
	if not self.idle then return end
	if self.engine == nil then
		print("Engine hasn't been set!")
		return
	end
	local events = self.engine:getEvents()
	if # events > self.maxPlayerMoves then
		print("That's too many moves! Check your loops to see how many instructions are being run.")
		return
	end
	self.netAdapter:sendMoves(self, events)
end

function Game:runEvents(events)
	print("runEvents not implemented!")
end

function Game:resetTurn()
	print ("resetTurn not implemented!")
end

function Game:reset()
	print("Reset not implemented!")
end

function Game:update()
	print("Update not implemented!")
end

function Game:exit()
	print("Exit not implemented")
end

function CollectGame(netAdapter, hostBool)
	local self = Game(netAdapter, "images/moonbackground.png", false)
	self.host = hostBool
	self.idle = true
	local setupGrid = function(imagePath, gameState, testing)
		if testing then
			print("testing")
			return
		end
		self.grid = gridMod.CollectGrid(imagePath, self.gameType, gameState)
	end
	
	local setupPlayers = function(gameState, testing)
		self.maxPlayerMoves = 8
		self.player1 = playerMod.CollectPlayer(self.grid, 1, self.maxPlayerMoves, testing)
		self.player2 = playerMod.CollectPlayer(self.grid, 2, self.maxPlayerMoves, testing)
	end
	
	local setupPanel = function(numButtons)
		--move this stuff into panel object
		
		self.rightButton = buttonMod.InputButton(self.engine, "images/arrow-right.png",
		"RightMove", 1, numButtons)
		self.downButton = buttonMod.InputButton(self.engine, "images/arrow-down.png", 
		"DownMove", 2, numButtons)
		self.leftButton = buttonMod.InputButton(self.engine, "images/arrow-left.png", 
		"LeftMove", 3, numButtons)
		self.upButton = buttonMod.InputButton(self.engine, "images/arrow-up.png", 
		"UpMove", 4, numButtons)
		self.digButton = buttonMod.InputButton(self.engine, "images/shovel.png", 
		"Dig", 5, numButtons)
		self.loopStart = buttonMod.InputButton(self.engine, "images/loop-start.png", 
		"LoopStart", 6, numButtons)
		self.loopEnd = buttonMod.InputButton(self.engine, "images/loop-end.png", 
		"LoopEnd", 7, numButtons)
		
		local buttonImage = Bitmap.new(Texture.new("images/go.png"))
		local scaleX = WINDOW_WIDTH / buttonImage:getWidth() / 10.5
		local scaleY = WINDOW_HEIGHT / buttonImage:getHeight() / 15
		
		self.goButton = Button.new(buttonImage, buttonImage, function()
			--self:reset() 
			if not (self.player1.getAction() or self.player2.getAction() then
				self:sendMoves()
			end
			self.engine:clearBuffer()
			end)
		self.goButton:setScale(scaleX, scaleY)
		local xPos = numButtons * (WINDOW_WIDTH / (numButtons + 1))
		local yPos = WINDOW_HEIGHT / 20
		self.goButton:setPosition(xPos, yPos)	
		
	end
	
	
	local runEvents = function(events)
		self.idle = false
		--print_r(events)
		if events.p1 == nil or events.p2 == nil then
			print("unsupported event format")
			return
		end
		for index,value in ipairs(events.p1) do
			local eventObjConst = commandMod.getEvent(value)
			local eventObj = eventObjConst(self.player1, 1, index)
			table.insert(self.player1.loadedMoves, eventObj)
		end
		for index,value in ipairs(events.p2) do
			local eventObjConst = commandMod.getEvent(value)
			local eventObj = eventObjConst(self.player2, 1, index)
			table.insert(self.player2.loadedMoves, eventObj)
		end
		self.resetTurn()
	end
	
	local resetTurn = function()
		self.player1.setAction(true)
		self.player2.setAction(true)
		self.player1.endTurn()
		self.player2.endTurn()
	end
	
	local finished = {false, false, false}
	local update = function()
		
		local p1ActionBefore = self.player1.getAction()
		self.player1.update()
		local p1ActionAfter = self.player1.getAction()
		if p1ActionBefore and not p1ActionAfter then
			finished[1] = true
		end
		local p2ActionBefore = self.player2.getAction()
		self.player2.update()
		local p2ActionAfter = self.player2.getAction()
		if p2ActionBefore and not p2ActionAfter then
			finished[2] = true
		end
		if finished[1] and finished[2] and finished[3] then
			finished = {false, false, false}
			self.idle = true
			if self.host then
				self.updateLocations()
			else
				self.netAdapter:startRecv()
			end
		end
	end
	
	local destroy = function()
		stage:removeChild(self.background)
		self.grid.destroy()
		self.player1.destroy()
		self.player2.destroy()
		
		
		self.rightButton:destroy()
		self.downButton:destroy()
		self.leftButton:destroy()
		self.upButton:destroy()
		self.digButton:destroy()
		self.loopStart:destroy()
		self.loopEnd:destroy()
		
		stage:removeChild(self.goButton)
		
		stage:removeEventListener(Event.ENTER_FRAME, self.update)
	end
	
	local show = function()
		stage:addChild(self.background)
		self.background:setScale(2.5, 2)
		self.grid.show()
		self.player1.show()
		self.player2.show()
		
		self.rightButton:show()
		self.downButton:show()
		self.leftButton:show()
		self.upButton:show()
		self.digButton:show()
		self.loopStart:show()
		self.loopEnd:show()
		
		stage:addChild(self.goButton)
		
		stage:addEventListener(Event.ENTER_FRAME, self.update)
		
		--stage:addChild(Bitmap.new(Texture.new("images/moonbg.png", true)))
	end
	
	local gameSetup = function(gameState)
	--print_r(gameState)
		self.setupGrid("images/mooncell.png", gameState, false)
		self.setupPlayers(gameState, false)
	end
	
	local updateLocations = function()
		local locations = {
		p1={x=self.player1.getX(), y=self.player1.getY()},
		p2={x=self.player2.getX(), y=self.player2.getY()}
		}
		local scores = {self.player1.getScore(), self.player2.getScore()}
		self.netAdapter:updateLocations(locations, scores)
		
	end
	
	local recvUpdateLocations = function(locations)
		--print_r(locations)
		self.grid.setMapItems(locations, false)
	end
	
	local gameOver = function(winner)
		--display winner
		--display rematch and quit buttons
		
		local winnerField = TextField.new(nil, 'Winner: '  .. winner)
		winnerField:setX(WINDOW_WIDTH / 2 - 10)
		winnerField:setY(WINDOW_HEIGHT / 3 - 20)
		stage:addChild(winnerField)
		
		local rematchButtonImage = Bitmap.new(Texture.new('images/rematch.png'))
		local rematchButton = Button.new(rematchButtonImage, rematchButtonImage, function()
			self.netAdapter:endGame(true)
		end)
		
		local scaleX = WINDOW_WIDTH / rematchButtonImage:getWidth() / 4
		local scaleY = WINDOW_HEIGHT / rematchButtonImage:getHeight() / 7
		rematchButton:setScale(scaleX, scaleY)
		local xPos = WINDOW_WIDTH / 3 - rematchButtonImage:getWidth()
		local yPos = WINDOW_HEIGHT / 3 - 20
		rematchButton:setPosition(xPos, yPos)
		
		stage:addChild(rematchButton)
		
		local quitButtonImage = Bitmap.new(Texture.new('images/quit.png'))
		local quitButton = Button.new(quitButtonImage, quitButtonImage, function()
			self.netAdapter:endGame(false)
			destroy()
			stage:removeChild(self.rematchButton)
			stage:removeChild(self.quitButton)
			stage:removeChild(self.winnerField)
			self.netAdapter:startRecv()
			
			stage:addChild(bg)
			stage:addChild(logo)
			stage:addChild(createGameButton)
			stage:addChild(joinGameButton)
			
		end)
		
		local scaleX = WINDOW_WIDTH / quitButtonImage:getWidth() / 4
		local scaleY = WINDOW_HEIGHT / quitButtonImage:getHeight() / 7
		quitButton:setScale(scaleX, scaleY)
		local xPos = 2 * WINDOW_WIDTH / 3
		local yPos = WINDOW_HEIGHT / 3 - 20
		quitButton:setPosition(xPos, yPos)
		
		
		stage:addChild(quitButton)
		self.winnerField = winnerField
		self.rematchButton = rematchButton
		self.quitButton = quitButton
		
		
	end
	
	self.gameType = "Collect"
	local gameState = self.netAdapter:getGameState(self.gameType)
	
	self.setupPanel = setupPanel
	--setupGrid("images/dirtcell.png", gameState, false)
	--setupPlayers(gameState, false)
	self:setupEngine(8, false)
	
	self.updateLocations = updateLocations
	self.recvUpdateLocations = recvUpdateLocations
	self.runEvents = runEvents
	self.resetTurn = resetTurn
	self.setupGrid = setupGrid
	self.setupPlayers = setupPlayers
	self.update = update
	
	return {
		runEvents = runEvents,
		update = update,
		exit = exit,
		show = show,
		destroy = destroy,
		gameSetup = gameSetup,
		updateLocations = updateLocations,
		recvUpdateLocations = recvUpdateLocations,
		gameOver = gameOver
	}

end

M.CollectGame = CollectGame
return M
