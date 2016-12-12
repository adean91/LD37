local util = {logs={}}

function util.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5, math.atan2(y2-y1, x2-x1) end
function util.round(x, places) local pow = 10 ^ (places or 0) return math.floor(x * pow + .5) / pow end
function util.clamp(x, min, max) return x < min and min or (x > max and max or x) end


function util.print(msg, prefix, override)
	local p = prefix or ' '
	local d = string.format("%.1f", util.round(Engine.delta, 1))
	table.insert(util.logs, {d=d, p=p, m=msg})

	if Engine.debug or override then 
		print(d, p, msg)
	end
end

function util.flush()
	local fileName = 'log.txt'

	local buffer = "\n\n"..INTRO..'\n'
	local lines = 0
	for _, v in ipairs(util.logs) do
		buffer = buffer..v.d..'\t'..v.p..'\t'..v.m.. "\n"
		lines = lines + 1
		if lines >= 2048 then
			love.filesystem.append(fileName, buffer)
			lines = 0
			buffer = ''
		end
	end
	love.filesystem.append(fileName, buffer)

	util.logs = {}
	util.print(string.format('Successfully flushed logs to "%s".', love.filesystem.getSaveDirectory()..'/'..fileName), '**', true)
end

local ser = require 'lib.third.ser'

function util.save(file, contents, apnd, ovr) -- apnd = append file, ovr = override()
	if not file or not contents or type(contents) ~= 'table' then return end
	
	if love.filesystem.exists(file..'.lua') and (apnd or not ovr) then
		util.print(string.format('Error! Save game "%s" already exists, try again.', file), '**', true)
		love.window.showMessageBox('Error!', string.format('Save game "%s" already exists, try again.', file))
		return
	end

	local str = ser(contents)
	if apnd then love.filesystem.append(file..'.lua', str)
	else love.filesystem.write(file..'.lua', str)
	end
end

function util.load(file)
	if not file or not love.filesystem.exists(file..'.lua') then
		util.print(string.format('Error! Save game "%s" doesn\'t exist, try again.', file or ''), '**', true)
		love.window.showMessageBox('Error!', string.format('Save game "%s" doesn\'t exist, try again.', file or ''))
		return false
	end

	local saveGame = require(file)
	return saveGame
end


local dfault = {
	date = 'nil',

	firstPlay = true,
	debug = true,
	delta = 0,

	px = 0,
	py = 0,
	phealth = 100,

	wave = 0,
	numZ = 0
}

function util.init()
	local txt = '\tInitialize ['..os.date() ..']\n'..INTRO
	print(txt)
	if not love.filesystem.exists('pref.lua') then
		-- Create
		util.save('pref', dfault)
	else
		-- Load
	end
end

return util, util.init()