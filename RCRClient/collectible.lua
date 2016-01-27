-- program is being exported under the TSU exception

local M = {}

local width = application:getLogicalWidth()
local height = application:getLogicalHeight()

local Collectible = {}
Collectible.__index = Collectible

setmetatable(Collectible, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})
--[[
	This class defines collectibles in the game. Extend this class to add collectibles.
	- image is the image object for the collectible
	- func is the function that is run when the collectible is in the same cell as the player. This function
	must return a boolean that determines whether the collectible was collected or not.
]]
function Collectible:_init(name, image, func)
	self.name = name
	self.image = image
	self.func = func
end

function Collectible:doFunc(player)
	if self.func == nil then
		print("Not implemented!")
		return false
	end
	return self.func(player)
end

function Collectible:destroy()
	stage:removeChild(self.image)
end

function GoldCoin()
	local collectGold = function(player)
		player.incrementScore(1) 
		return true
	end
	local self = Collectible("Gold", Bitmap.new(Texture.new("images/gold.png")), collectGold)
	local doFunc = function(player)
		return self:doFunc(player)
	end
	return {
		name = self.name,
		image = self.image,
		doFunc = doFunc
	}
end

function Gem()
	local collectGem = function(player)
		player.incrementScore(4)
		return true
	end
	local self = Collectible("Gem", Bitmap.new(Texture.new("images/gem.png")), collectGem)
	local doFunc = function(player)
		return self:doFunc(player)
	end
	return {
		name = self.name,
		image = self.image,
		doFunc = doFunc
	}
end

M.GoldCoin = GoldCoin
M.Gem = Gem
return M

