Zombie = Object:extend()

function Zombie:init(uid, x, y, speed)
	self.dead 	= false
	self.uid = uid
	self.health = 100
	self.armor = 0

	self.speed = speed
	self:setPos(x, y)

	self.img = Engine.assets.image.pieceRed
	self.scale = .5
	local w, h = self.img:getWidth(), self.img:getHeight()

	self:setSize(w, h)
	self:setShape('circle')
	self:setSize(8)

	self:setPhysics(world)

	-- Stateful AI
	self.state = 'idle'
	self.timer = 0
	self.dir = 0 
	self.hurtTimer = 0

end

function Zombie:update(dt, p) 
	if self.hurtTimer > 0 then self.hurtTimer = self.hurtTimer - dt end

	local dist, angle = Engine.util.dist(self.x, self.y, p.x, p.y)
	local centerDist, centerAngle = Engine.util.dist(self.x, self.y, 650, 450)
	angle = angle * (love.math.random(7, 12)/10)
	
	if dist < (love.math.random(7, 13)/10)*150 then
		self.state 	= 'follow'
		self.dir 	= angle
	end

	self.timer = self.timer - dt

	if self.state == 'idle' then
		if self.timer <= 0 then
			if love.math.random() > .5 then
				self.state = 'wander'

				if centerDist > 300 then
					self.dir = centerAngle + math.rad(love.math.random(-30, 30))
					self.timer = love.math.random(2)
				else
					self.dir = centerAngle + love.math.random()*math.pi
					self.timer = love.math.random(3)
				end
			else
				self.state = 'idle'
				self.timer = love.math.random(3)
			end
		end

	elseif self.state == 'wander' then
		local fx = math.cos(self.dir) * self.speed
		local fy = math.sin(self.dir) * self.speed
		self.body:applyForce(fx, fy)

		if self.timer <= 0 then
			if love.math.random(10) > 5 then
				self.state = 'wander'
				self.dir = self.dir * (love.math.random(5, 15)/10)
				self.timer = love.math.random(1, 3)
			else
				self.state = 'idle'
				self.timer = love.math.random(1, 3)
			end
		end

	elseif self.state == 'follow' then
		if dist < 16 then
			p:hurt(25)
			local _, backAngle = Engine.util.dist(p.x, p.y, self.x, self.y)
			local nx = self.x + math.cos(backAngle) * 1000
			local ny = self.y + math.sin(backAngle) * 1000
			self.body:applyForce(nx, ny)
			return
		end

		self.timer = 0
		local fx = math.cos(self.dir) * self.speed
		local fy = math.sin(self.dir) * self.speed
		if dist > 300 then
			if love.math.random() > .5 then
				self.state = 'wander'
				self.dir = self.dir + math.rad(love.math.random(-10, 10))
				self.timer = love.math.random(1, 5)
			end
		else		
			self.body:applyForce(fx, fy)
		end
	end

	self.x, self.y = self.body:getWorldCenter()
end
