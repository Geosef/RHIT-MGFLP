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

function Collectible:_init(imagePath)
	self.image = Bitmap.new(Texture.new(imagePath))
	
end

return M