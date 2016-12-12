local guns = { 
	-- PISTOL ---------------
	{ 
		name 	= 'P226',
		rate 	= 'semi',
		magSize = 16,
		vel		= 350,	-- Muzzle velocity
		rpm 	= 400,	-- Rounds/min
		spread 	= .2,	-- Spread modifier
		reload 	= 1.4,	-- Reload time
		damage 	= 27
	},

	-- SMG ------------------
	{ 
		name 	= 'P90',
		rate 	= 'auto',
		magSize = 51,
		vel		= 460,	-- Muzzle velocity
		rpm 	= 900,	-- Rounds/min
		spread 	= .094,	-- Spread modifier
		reload 	= 3.55,	-- Reload time
		damage 	= 21
	},

	-- CARBINE --------------
	{
		name 	= 'ACE 52 CQB',
		rate 	= 'auto',
		magSize = 26,
		vel		= 400,	-- Muzzle velocity
		rpm 	= 650,	-- Rounds/min
		spread 	= .15,	-- Spread modifier
		reload 	= 3.4,	-- Reload time
		damage 	= 33
	},
	{
		name 	= 'M416',
		rate 	= 'auto',
		magSize = 31,
		vel		= 600,	-- Muzzle velocity
		rpm 	= 750,	-- Rounds/min
		spread 	= .098,	-- Spread modifier
		reload 	= 2.4,	-- Reload time
		damage 	= 24.5
	},

	-- LMG ------------------
	{
		name 	= 'Type-88 LMG',
		rate 	= 'auto',
		magSize = 200,
		vel		= 670,	-- Muzzle velocity
		rpm 	= 700,	-- Rounds/min
		spread 	= .091,	-- Spread modifier
		reload 	= 7.3,	-- Reload time
		damage 	= 24.5
	},

	-- DMR ------------------
	{
		name 	= 'SKS',
		rate 	= 'semi',
		magSize = 21,
		vel		= 490,	-- Muzzle velocity
		rpm 	= 333,	-- Rounds/min
		spread 	= .1,	-- Spread modifier
		reload 	= 3.5,	-- Reload time
		damage 	= 43
	},

	-- SNIPER ---------------
	{
		name 	= 'M82A3',
		rate 	= 'semi',
		magSize = 11,
		vel		= 560,	-- Muzzle velocity
		rpm 	= 125,	-- Rounds/min
		spread 	= .1,	-- Spread modifier
		reload 	= 1.8,	-- Reload time
		damage 	= 110
	},
	{
		name 	= '338-Recon',
		rate 	= 'semi',
		magSize = 6,
		vel		= 330,	-- Muzzle velocity
		rpm 	= 42,	-- Rounds/min
		spread 	= 0,	-- Spread modifier
		reload 	= 4.5,	-- Reload time
		damage 	= 100
	}
}

Weapons = {
	bullets = {},
	gun = {},
	cur = 5,
	mode = 1,

	isReload = false,
	canShoot = false,
	timer = 0
}

for i, g in pairs(guns) do
	Weapons.gun[i] = {
		total = guns[i].magSize*3,
		curMag = guns[i].magSize
	}
end

function Weapons.current()
	return guns[Weapons.cur]
end

function Weapons.reload()
	Weapons.isReload = true
	Weapons.canShoot = false
	Weapons.timer = guns[Weapons.cur].reload
end

function Weapons.switch(w)
	if w and guns[w] then
		Weapons.cur = w
	elseif not w then
		local nextg = Weapons.cur + 1
		if guns[nextg] then
			Weapons.cur = nextg
		end
	end
end

local isDown = love.mouse.isDown

function Weapons.update(dt, entities)
	for i = #Weapons.bullets, 1, -1 do
		local b = Weapons.bullets[i]
		b.life = b.life - dt

		if b.life > 0 then
			b.x = b.x + math.cos(b.dir) * b.speed * dt
			b.y = b.y + math.sin(b.dir) * b.speed * dt

			for e = 1, #entities do
				if Engine.util.dist(b.x, b.y, entities[e].x, entities[e].y) < 20 then
					if e ~= 1 then
						entities[e]:hurt(b.damage)
						table.remove(Weapons.bullets, i)
					end
				end
			end
		else
			table.remove(Weapons.bullets, i)
		end
	end

	-------------------------

	local weap = Weapons.gun[Weapons.cur]

	if Weapons.timer <= 0 then 
		Weapons.canShoot = true

		if Weapons.isReload then
			local newBlts = guns[Weapons.cur].magSize - weap.curMag
			weap.curMag = guns[Weapons.cur].magSize
			weap.total = weap.total - newBlts
			Weapons.isReload = false
		else
			if weap.curMag == 0 then
				Weapons.reload()
			end
		end
	else 
		Weapons.canShoot = false 
	end

	if isDown(1) or isDown('l') then
		if Weapons.canShoot then
			Weapons.shoot(entities[1], tx, ty)
			Weapons.canShoot = false
			Weapons.timer = 1/(guns[Weapons.cur].rpm/60)
			weap.curMag = weap.curMag - 1
		else
			if guns[Weapons.cur].mode == 'semi' then
				Weapons.canShoot = false
				Weapons.timer = 1/(guns[Weapons.cur].rpm/60)
				return
			end
		end
	end

	Weapons.timer = Weapons.timer - dt
end

function Weapons.draw()
	love.graphics.setColor(0,0,0)

	local mx, my = love.mouse.getPosition()
	local wx, wy = toWorld(mx, my)

	love.graphics.circle('fill', wx, wy, 5)

	for i = 1, #Weapons.bullets do
		local b = Weapons.bullets[i]
		love.graphics.circle('fill', b.x, b.y, 2)
	end
end

function Weapons.shoot(p)
	local mx, my = love.mouse.getPosition()
	local wx, wy = toWorld(mx, my)

	local dist, angle = Engine.util.dist(p.x, p.y, wx, wy)
	Weapons.bullets[#Weapons.bullets+1] = {
		x = p.x,
		y = p.y,
		dir = angle,
		speed = guns[Weapons.cur].vel,
		damage = guns[Weapons.cur].damage,
		life = 5
	}
end