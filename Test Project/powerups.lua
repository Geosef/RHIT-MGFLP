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

function Collectible:doFunc()
	print("Not implemented!")
end

function Collectible:destroy()
	stage:removeChild(self.image)
end

local Leprechaun = {}
Leprechaun.__index = Leprechaun
setmetatable(Leprechaun, {
  __index = Player,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

return M








