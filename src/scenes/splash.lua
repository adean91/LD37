local splash = {}

local time = 0
local alpha = 0
local mode = 1

local font = Engine.assets.font.bignoodle72
local img = Engine.assets.image.loveSplash
local w, h = img:getWidth(), img:getHeight()

local sx, sy = LGW/w, LGH/h
local scale = sx >= sy and sx or sy
scale = Engine.util.round(scale, 2)

local function inc(dt) alpha = Engine.util.clamp(alpha + (255/2)*dt, 0, 255) end
local function dec(dt) alpha = Engine.util.clamp(alpha - (255/2)*dt, 0, 255) end

function splash.update(dt)
	time = time + dt
    if time > 12.5 then
			Engine.scenes.switch('menu')
	elseif time > 10 then
		dec(dt)
	elseif time > 6.5 then
    	inc(dt)
	elseif time > 4 then
		dec(dt)
	elseif time < 2 then
		inc(dt)
	end
end

function splash.draw()
	love.graphics.setColor(255,255,255, alpha)
	love.graphics.setFont(font)
	if time > 6 then
		love.graphics.draw(img, LGW/2, LGH/2, 0, scale, scale, w/2, h/2)
	else
		love.graphics.printf('Apocolypse', 0, LGH/2-30, LGW, 'center')
	end
end


function splash.keypressed(k) 
	if time > 6 then 
		Engine.scenes.switch('menu')
	else
		alpha = 0
		time = 6
	end
end

return splash
