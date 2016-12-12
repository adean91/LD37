Player = Object:extend()

function Player:init(uid, x, y)
	self.dead 	= false
	self.uid = uid
	self.health = 100
	self.armor = 0
	
	self.speed = 250
	self:setPos(x, y)

	self.img = Engine.assets.image.pieceGreen
	self.scale = .5
	local w, h = self.img:getWidth(), self.img:getHeight()

	self:setSize(w, h)
	self:setShape('circle')
	self:setSize(8)

	self:setPhysics(world)

	self.hurtTimer = 0
end

local down = love.keyboard.isDown

function Player:update(dt) 
	if self.hurtTimer > 0 then self.hurtTimer = self.hurtTimer - dt end
	local x, y = 0, 0
	if down("w") or down("up")		then y = y - self.speed end
	if down("s") or down("down")	then y = y + self.speed end
	if down("a") or down("left")	then x = x - self.speed end
	if down("d") or down("right")	then x = x + self.speed end
	self.body:applyForce(x, y)
	self.x, self.y = self.body:getWorldCenter()
end

function Player:hurt(amt)
	if self.hurtTimer <= 0 then
		local dmg = amt
		if self.armor > 0 then
			if self.armor >= amt then
				self.armor = self.armor - amt
			else
				dmg = amt - self.armor
				self.health = self.health - dmg
			end
		else
			self.health = self.health - amt
		end

		if self.health <= 0 then self.dead = true end
		self.hurtTimer = .25
	end
end