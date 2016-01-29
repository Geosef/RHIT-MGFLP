--[[
	*
	*   note: word "bevel" is used in reference to the slider button 
	*	
	*
	*
]]
hSlider = Core.class(Sprite)

function hSlider:init(bevelimage,barimage)

	self.bar= Bitmap.new(Texture.new(barimage),true)
	self.bevel= Bitmap.new(Texture.new(bevelimage),true)

	self.barlength = self.bar:getWidth()			
	self.barwidth = self.bar:getHeight()
	self.x= 0		--position of controls within aSlider  (also position of the bevel)					
	self.y= 0		--position of controls within aSlider 

	self.bevelwidth = self.bevel:getWidth()		--button width
	self.bevelheight = self.bevel:getHeight()	--button height
	self.bary= self.y+math.floor((self.bevelheight-self.barwidth)/2	)	--position bar 
	self.barx= self.x+math.floor(self.bevelwidth/2)						--position bar

	self:addChild(self.bar)
	self.bar:setPosition (self.barx,self.bary)
	self:addChild(self.bevel)
	self.bevel:setPosition (self.x,self.y)
	
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown,self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove,self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp,self)
	
	
end




--this function deals with manipulation by touch events, x is touched coordinate,
function hSlider:SetPositionFromBar(x) 	

	local offset = self:getX()+self.barx
	local barpixel = x - offset		--0 to barlength 
	
	--check and limit bounds

	if x < offset then 
		barpixel = 0
	elseif x > offset+ self.barlength then 
		barpixel = self.barlength  
	end

	self.percent = barpixel/self.barlength
	print(self.name, "barpercentage",self.percent)
	self.bevel:setPosition (barpixel-self.x,self.y)	--set bevel position
	--bevel:setPosition (barpixel-self.bevelwidth/2,self.y)	--set bevel position
	--setTimeLabel()												--updateTime
end


function hSlider:setPositonbyPercentage(p)
	local offset = self:getX()+self.barx
	local x = p*self.barlength + offset
	self:SetPositionFromBar(x) 	

end

function hSlider:onMouseDown(event)
	if self.bevel:hitTestPoint(event.x, event.y) then
		self.bevel.isFocus = true
		event:stopPropagation()
	end
	
	--turn this on for quick surf (click bar and go)
	if self.bar:hitTestPoint(event.x, event.y) then
		self:SetPositionFromBar(event.x)
		event:stopPropagation()
	end
end

function hSlider:onMouseMove(event)
	if self.bevel.isFocus then

		self:SetPositionFromBar(event.x)
		event:stopPropagation()
	end
end

function hSlider:onMouseUp(event)
	if self.bevel.isFocus then
		self.bevel.isFocus = false
		VOLUME = self.percent
		MUSIC:setVolume(VOLUME)
		event:stopPropagation()
	end
end