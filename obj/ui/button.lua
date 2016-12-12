Button = class:extend(Element)

local color = {
	text = {0,0,0},
	back = {150,150,40},
	hover = {255,255,255, 100}
}

function Button:init(x, y, w, h, txt, cb)
	if not x or not y or not w or not h or not txt then return end
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.txt = txt
	self.cb = cb or function() print('No callback on Button: ', txt) end

	self.isHover = false
end

function Button:draw()
	LG.setColor(color.back)
	LG.rectangle('fill', self.x, self.y, self.w, self.h)
	LG.setFont(Engine.assets.font.bignoodle24)
	LG.setColor(color.text)
	LG.printf(self.txt, self.x, self.y+self.h/2-10, self.w, 'center')
end

function Button:hover()
	LG.setColor(color.hover)
	LG.rectangle('fill', self.x, self.y, self.w, self.h)
end

function Button:mousepressed()
	print('Click: '.. self.txt)
	return self.cb()
end
