require 'obj.ui.element'
require 'obj.ui.button'

local items = {
	Button = Button
}

local uiHandler = {}

function uiHandler:newHandler()
	local sys = {list={}}

	function sys:new(t, ...)
		sys.list[#sys.list+1] = t:new(...)
	end

	function sys:update(dt)
		local mx, my = love.mouse.getPosition()

		for i = 1, #sys.list do
			if sys.list[i].update then sys.list[i]:update(dt, mx, my) end
		end
	end

	function sys:draw()
		for i = 1, #sys.list do
			local item = sys.list[i]
			if item.draw then 
				item:draw()
				if item.isHover and item.hover then item:hover() end
			end
		end
	end

	function sys:mousepressed(...)
		for i = #sys.list, 1, -1 do
			local item = sys.list[i]
			if item.isHover and item.mousepressed and item:mousepressed(...) then
				return
			end
		end
	end

	function sys:keypressed(...)
		for i = #sys.list, 1, -1 do
			if sys.list[i].keypressed and sys.list[i]:keypressed(...) then
				return
			end
		end
	end

	return sys
end

return uiHandler