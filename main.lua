INTRO = [[
	Survive
	v0.1.4

	Made for LD37 - One Room

	LÖVE 
	v0.9.2

	Copyright(c) 2016
	Andrew Dean
]]

io.stdout:setvbuf('no')

-- Globals
LG = love.graphics
LGW, LGH = LG.getDimensions()
love.math.setRandomSeed(os.time())
love.audio.setVolume(.5)

Engine = {
	delta = 0,
	debug = false
}

Engine.util 	= require 'lib.util'
Engine.pref		= require 'pref'
Engine.assets	= require 'lib.handler.assets'
Engine.scenes 	= require 'lib.handler.scenes'

require 'lib.third.TEsound'

function love.load()
	-- Engine.scenes.switch('splash')
	Engine.scenes.switch('menu')
	-- Engine.scenes.switch('game')
end

function love.update(dt)
	Engine.delta = Engine.delta + dt
	TEsound.cleanup()
	Engine.scenes.update(dt)
end

function Engine.onQuit(p, w, z)
	if not p then return end

	local save = {
		date 	= os.date(),
		delta 	= Engine.delta,
		debug 	= Engine.debug,

		wave 	= w or 0,
		px 		= math.floor(p.x),
		py 		= math.floor(p.y),
		ph 		= p.health
	}

	Engine.util.save('autosave', save, false, true)
	Engine.util.flush()
	love.event.quit()
end

function love.draw() Engine.scenes.draw() end
function love.mousepressed(...) Engine.scenes.mousepressed(...) end
function love.mousereleased(...) Engine.scenes.mousereleased(...) end
function love.mousemoved(...) Engine.scenes.mousemoved(...) end
function love.keypressed(...) Engine.scenes.keypressed(...) end
function love.keyreleased(...) Engine.scenes.keyreleased(...) end
function love.textinput(...) Engine.scenes.textinput(...) end
function love.gamepadpressed(...) Engine.scenes.gamepadpressed(...) end
function love.gamepadreleased(...) Engine.scenes.gamepadreleased(...) end
function love.gamepadaxis(...) Engine.scenes.gamepadaxis(...) end
