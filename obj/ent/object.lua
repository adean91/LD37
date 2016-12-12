Object = class:extend()

function Object:update(dt, px, py)

end

function Object:draw(px, py) 
	love.graphics.setColor(255,255,255)
	local x, y = self.body:getPosition()
	love.graphics.draw(self.img, x, y, 0, self.scale, self.scale, (self.w*self.scale), (self.h*self.scale))


	if self.uid == 1 or self.health < 100 then
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle('fill', self.x-15, self.y-20, 30, 6)
		love.graphics.setColor(255,40,40)
		love.graphics.rectangle('fill', self.x-14, self.y-19, Engine.util.clamp(28*(self.health/100), 0, 28), 4)
	end

	if Engine.debug then
		love.graphics.setColor(255, 0, 0)
		if self.s == 'circle' then 
			love.graphics.circle("line", x, y, self.rad)
		else 
			love.graphics.rectangle("line", self.x-(self.w/2*self.scale), self.y-(self.h/2*self.scale), (self.w*self.scale), (self.h*self.scale)) 
		end

		if self.state then
			love.graphics.setColor(255,255,255)
			love.graphics.printf(self.state, self.x-15, self.y+10, 30, 'center')
			love.graphics.printf(string.format('{%s, %s}', math.floor(px), math.floor(py)), self.x-75, self.y+20, 150, 'center')
			
			local dist, _ = Engine.util.dist(self.x, self.y, px, py)
			local cdis, _ = Engine.util.dist(self.x, self.y, 650, 450)
			love.graphics.printf(string.format('%s, %s', math.floor(dist), math.floor(cdis)), self.x-75, self.y+30, 150, 'center')
		end
	end

end

function Object:isDead() return self.dead end

function Object:getPos() return self.x, self.y end
function Object:setPos(x, y) self.x, self.y = x, y end

function Object:getShape() return self.s end
function Object:setShape(s) self.s = s end

function Object:setSize(w, h)
	if self.s == 'circle' then self.rad = w
	else self.w, self.h = w, h end
end

function Object:getSize() 
	if self.s == 'circle' then return self.rad
	else return self.w, self.h end
end

function Object:setPhysics(world)
	self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
	self.body:setLinearDamping(5)
	self.body:setFixedRotation(true)

	if self.s == 'circle' then self.shape = love.physics.newCircleShape(self.rad)
 	else self.shape = love.physics.newRectangleShape(self.w/2, self.h/2) end

	self.fixture = love.physics.newFixture(self.body, self.shape)
end

function Object:hurt(amt) 
	self.health = self.health - amt
	if self.health <= 0 then self.dead = true end
	self.state = 'follow'
end
