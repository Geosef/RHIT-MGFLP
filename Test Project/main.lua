function my_super_function( arg1, arg2 ) return arg1 + arg2 end

require('runtests')



local background = Bitmap.new(Texture.new("field.png"))
stage:addChild(background)

local ball = Bitmap.new(Texture.new("ball.png"))

ball.xdirection = 1
ball.ydirection = 1
ball.xspeed = 2.5
ball.yspeed = 4.3

stage:addChild(ball)

function onEnterFrame(event)
    local x = ball:getX()
    local y = ball:getY()

    x = x + (ball.xspeed * ball.xdirection)
    y = y + (ball.yspeed * ball.ydirection)

    if x < 0 then
        ball.xdirection = 1
    end

    if x > 320 - ball:getWidth() then
        ball.xdirection = -1
    end

    if y < 0 then
        ball.ydirection = 1
    end

    if y > 480 - ball:getHeight() then
        ball.ydirection = -1
    end

    ball:setX(x)
    ball:setY(y)
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)