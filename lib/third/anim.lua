anim = {}
anim.anims = {}

function anim.new(img, quadWidth, quadHeight, numberOfQuads, millis, style)
	if not img or not (quadWidth or quadHeight) or numberOfQuads < 1 then
		error("Error in anim.new(), wrong parameters!")
	end

	if type(img) == "string" then
		img = love.graphics.newImage(img)
	end

	if style and style == "rough" then
		img:setFilter("nearest", "nearest")
	end

	local imgW = img:getWidth()
	local imgH = img:getHeight()
	local automaticNumberOfQuads = (imgW / quadWidth) * (imgH / quadHeight)

	local self = {}
	self.numberOfQuads = numberOfQuads or automaticNumberOfQuads
	self.quads = {}
	self.millis = millis or 0.1 -- Milliseconds for each frame.
	self.mode = "repeat"

	-- Generate frames (quads):
	local x, y = 0, 0
	for i = 1, self.numberOfQuads do
		table.insert(self.quads, love.graphics.newQuad(
			x, y, quadWidth, quadHeight, imgW, imgH
		))
		x = x + quadWidth
		if x >= imgW then
			y = y + quadHeight
			x = 0
		end
	end

	self.timer = 0
	self.index = 1
	self.sense = 1
	self.finished = false
	function self:update(dt)
		if not self.finished then
			self.timer = self.timer + dt
			if self.timer >= self.millis then
				self.timer = 0
				self.index = self.index + 1 * self.sense

				if self.index > #self.quads or self.index < 1 then
					if self.mode == "repeat" then
						self.index = 1
					elseif self.mode == "rewind" then
						self.sense = self.sense * -1
						if self.sense < 0 then
							self.index = self.index - 1
						end
						if self.sense > 0 then
							self.index = self.index + 1
						end
					elseif self.mode == "once" then
						self.finished = true
						self.index = self.index - 1
					end
				end
			end
		end
	end

	function self:rewind()
		self.mode = "rewind"
		return self
	end

	function self:once()
		self.mode = "once"
		return self
	end

	function self:draw(...)
		local q = self.quads[self.index]
		love.graphics.draw(img, q, ...)
	end

	table.insert(anim.anims, self)
	return self
end

function anim.update(dt)
	for i = 1, #anim.anims do
		anim.anims[i]:update(dt)
	end
end

function anim.draw()
	for i = 1, #anim.anims do
		anim.anims[i]:draw()
	end
end

return anim