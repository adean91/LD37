Element = class:extend()

function Element:init()

end

function Element:update(dt, mx, my)
	if mx >= self.x and mx <= self.x + self.w and
	my >= self.y and my <= self.y + self.h then
		self.isHover = true
	else 
		self.isHover = false
	end
end

function Element:draw()

end

