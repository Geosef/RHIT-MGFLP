--[[
function Sprite:setSize(newWidth, newHeight)
  self:setScale(1, 1)  -- to get original width and height without scaling
  local originalWidth = self:getWidth()
  local originalHeight = self:getHeight()
  self:setScale(newWidth / originalWidth, newHeight / originalHeight)
end
]]

