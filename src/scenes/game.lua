local state = {}

local zWaves = {
	{num=20, speed=60},	-- 1
	{num=30, speed=60},	-- 2
	{num=40, speed=60},	-- 3
	{num=50, speed=60},	-- 4
	{num=60, speed=80}, -- 5
	{num=70, speed=80}, -- 6
	{num=80, speed=80}, -- 7
	{num=90, speed=80}, -- 8
	{num=100, speed=100}-- 9
}

local game = {wave = 1, curZ = 0}

love.physics.setMeter(32)
world = love.physics.newWorld(0, 0)

local sti = require 'lib.third.sti'
local map = sti.new('src/levels/ld37map2.lua', { 'box2d' })
map:box2d_init(world)

Camera = {
	x = 0,
	y = 0
}

-----------------------------

local entities = {}
class = require 'lib.class'
require 'obj.ent.object'
require 'obj.ent.player'
require 'obj.ent.zombie'

require 'obj.ent.weapons'


entities[1] = Player:new(1, 300, 300)
local nextuid = 2

local function spawn()
	for i = 1, zWaves[game.wave].num do
		local x, y = love.math.random(1500), love.math.random(1500)
		entities[#entities+1] = Zombie:new(nextuid, x, y, zWaves[game.wave].speed)
		nextuid = nextuid + 1
		game.curZ = game.curZ + 1
	end
end

local function startGame()
	game.wave = 1
	spawn()
end

local function nextRound()
	if not zWaves[game.wave+1] then
		print('WINNER!')
		-- YOU WIN!
		return
	end
	game.wave = game.wave + 1
	spawn()
end

function endGame()
	Engine.scenes.switch('menu')
end

startGame()

function toWorld(x, y)
  local nx = x + -Camera.x
  local ny = y + -Camera.y
  return nx, ny
end

---------------------------------------

function state.update(dt) 
	world:update(dt)
	local p = entities[1]
	if p:isDead() then endGame() end

	if game.curZ == 0 and game.wave > 0 then nextRound() end

	Weapons.update(dt, entities)

	for i = #entities, 1, -1 do
		local e = entities[i]
		if e:isDead() and e.uid ~= 1 then
			table.remove(entities, i)
			game.curZ = game.curZ - 1
		else
			e:update(dt, p)
		end
	end
	map:update(dt)


	Camera.x = math.floor(-entities[1].x + LGW / 2)
	Camera.y = math.floor(-entities[1].y + LGH / 2)
end

function state.draw() 
	local player = entities[1]

	love.graphics.push()
	love.graphics.translate(Camera.x, Camera.y)
	map:setDrawRange(-Camera.x, -Camera.y, LGW, LGH)
	map:draw()

	-- love.graphics.setColor(255, 255, 0)
	-- map:box2d_draw()

	Weapons.draw()

	local p = entities[1]
	for i = #entities, 1, -1 do
		entities[i]:draw(p.x, p.y)
	end

	love.graphics.pop()

	love.graphics.setFont(Engine.assets.font.bignoodle24)
	love.graphics.setColor(255,255,255)
	love.graphics.print('Wave:    '..game.wave, 10, 10)
	love.graphics.print('Zombies: '..game.curZ, 10, 30)

	local cur = Weapons.current()
	love.graphics.print('Gun:     '..cur.name, 10, 60)

	local blt = string.format('%s/%s', Weapons.gun[Weapons.cur].curMag, cur.magSize)
	love.graphics.print('Bullets: '..blt, 10, 80)

	if Weapons.isReload then
		love.graphics.print('Reloading...', 10, 100)
	end
	--love.graphics.print('RPM:     '.. 1/(cur.rpm/60), 10, 100)
end

function state.keypressed(k) 
	if k == 'escape' then Engine.onQuit(entities[1], game.wave, game.numZ) 
	elseif k == 'f12' then Engine.debug = not Engine.debug 
	elseif k == 'f11' then 
		nextRound()
	end

	if k == '1' or k == '2' or k == '3' or k == '4' or k == '5' or k == '6' or k == '7' or k == '8' then
		Weapons.switch(tonumber(k))
	elseif k == 'r' then
		Weapons.reload()
	end
end

return state