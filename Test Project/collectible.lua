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

function Collectible:_init()
end

function Collectible:doFunc(player)
	if self.func == nil then
		print("Not implemented!")
		return
	end
	self.func(player)
end

function Collectible:destroy()
	stage:removeChild(self.image)
end

local ShovelRepairPowerUp = {}
ShovelRepairPowerUp.__index = ShovelRepairPowerUp
setmetatable(ShovelRepairPowerUp, {
  __index = Collectible,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function ShovelRepairPowerUp:_init()
	self.image = Bitmap.new(Texture.new("images/shovelrepair.png"))
	self.func = function(player) player:addDigs(2) end
end

local MetalDetectorPowerUp = {}
MetalDetectorPowerUp.__index = MetalDetectorPowerUp
setmetatable(MetalDetectorPowerUp, {
  __index = Collectible,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function MetalDetectorPowerUp:_init()
	self.image = Bitmap.new(Texture.new("images/metaldetector.png"))
	self.func = function(player) player:setMetalDetection() end
end

local SmallMoveBoostPowerUp = {}
SmallMoveBoostPowerUp.__index = SmallMoveBoostPowerUp
setmetatable(SmallMoveBoostPowerUp, {
  __index = Collectible,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function SmallMoveBoostPowerUp:_init()
	self.image = Bitmap.new(Texture.new("images/jetpack.png"))
	self.func = nil
end

M.ShovelRepairPowerUp = ShovelRepairPowerUp
M.MetalDetectorPowerUp = MetalDetectorPowerUp
M.SmallMoveBoostPowerUp = SmallMoveBoostPowerUp
return M

