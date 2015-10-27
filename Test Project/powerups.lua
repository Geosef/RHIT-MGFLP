local M = {}


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



return M