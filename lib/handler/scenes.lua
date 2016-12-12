local sceneHandler = {scenes = {}}
local cur = nil

local scenes = love.filesystem.getDirectoryItems('src/scenes')

Engine.util.print('Scenes:', '++\t')
for k, file in ipairs(scenes) do
	local name = string.sub(file, 1, string.len(file) - 4)
	sceneHandler.scenes[name] = require('src.scenes.'..name)
	Engine.util.print(name, '\t\t')
end

function sceneHandler.switch(scn)
	if sceneHandler.scenes[scn] then
		if cur and sceneHandler.scenes[cur].onExit then 
			sceneHandler.scenes[cur].onExit() 
		end

		cur = scn

		if sceneHandler.scenes[cur].onEnter then 
			sceneHandler.scenes[cur].onEnter() 
		end
	end
end

-----------------------------

function sceneHandler.draw()
	if sceneHandler.scenes[cur].draw then 
		sceneHandler.scenes[cur].draw() 
	end 

	love.graphics.setFont(Engine.assets.font.handyandy12)
	love.graphics.setColor(255,255,255)
	love.graphics.print(cur)
end

function sceneHandler.update(...) 
	if sceneHandler.scenes[cur].update then sceneHandler.scenes[cur].update(...) end 
end

function sceneHandler.keypressed(...) 
	if sceneHandler.scenes[cur].keypressed then sceneHandler.scenes[cur].keypressed(...) end 
end

function sceneHandler.keyreleased(...) 
	if sceneHandler.scenes[cur].keyreleased then sceneHandler.scenes[cur].keyreleased(...) end
end

function sceneHandler.textinput(...) 
	if sceneHandler.scenes[cur].textinput then sceneHandler.scenes[cur].textinput(...) end
end

function sceneHandler.mousepressed(...) 
	if sceneHandler.scenes[cur].mousepressed then sceneHandler.scenes[cur].mousepressed(...) end 
end

function sceneHandler.mousereleased(...) 
	if sceneHandler.scenes[cur].mousereleased then sceneHandler.scenes[cur].mousereleased(...) end 
end

function sceneHandler.mousemoved(...) 
	if sceneHandler.scenes[cur].mousemoved then sceneHandler.scenes[cur].mousemoved(...) end 
end

function sceneHandler.gamepadpressed(...) 
	if sceneHandler.scenes[cur].gamepadpressed then sceneHandler.scenes[cur].gamepadpressed(...) end 
end

function sceneHandler.gamepadreleased(...) 
	if sceneHandler.scenes[cur].gamepadreleased then sceneHandler.scenes[cur].gamepadreleased(...) end 
end

function sceneHandler.gamepadaxis(...) 
	if sceneHandler.scenes[cur].gamepadaxis then sceneHandler.scenes[cur].gamepadaxis(...) end 
end

return sceneHandler