local UIH = require 'lib.handler.ui'
local UI = UIH:newHandler()

local b = {
	{
		x = LGW/2-75,
		y = (LGH/5)*2,
		txt = 'Start',
		cb = function() Engine.scenes.switch('game') end
	},
	{
		x = LGW/2-75,
		y = (LGH/5)*3,
		txt = 'Quit',
		cb = function() Engine.onQuit() end
	}
}

local btns = {}
for i, obj in pairs(b) do
	UI:new(Button, obj.x, obj.y, 150, 50, obj.txt, obj.cb)
end



local state = {}

function state.onEnter()
	--TEsound.playLooping(Engine.assets.sound.Mountainside_Looping, "music")
end

function state.update(dt)
	UI.update(dt)
end

function state.draw() 
	LG.setColor(40,150,40)
	LG.rectangle('fill', 0, 0, LGW, LGH)
	UI.draw()
end

function state.keypressed(...) 
	UI.keypressed(...)
end

function state.mousepressed(...) 
	UI.mousepressed(...)
end

return state