-- program is being exported under the TSU exception

local mockstage = {}

function mockstage:addChild(elem)

end

function mockstage:removeChild(elem)

end

function mockstage:addEventListener(ev, func)

end




local mocksprite = {}
mocksprite.__index = mocksprite


function mocksprite.new(init)
  local self = setmetatable({}, mocksprite)
  return self
end

function mocksprite:setText(text)
end
function mocksprite:setX(text)
end
function mocksprite:setY(text)
end
function mocksprite:getWidth(text)
return 1
end
function mocksprite:getHeight(text)
return 1
end
function mocksprite:setScale(scale)
end
function mocksprite:setPosition(pos)
end
function mocksprite:setAlpha(alpha)
end


function setMocks()
	stage = mockstage

	TextField = mocksprite
	Bitmap = mocksprite
	Texture = mocksprite
	Button = mocksprite
end

--setMocks()
