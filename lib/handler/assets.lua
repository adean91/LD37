local asset = { font={}, image={}, sound={} }
local baseDir = 'src/assets/'

function asset.init()
	Engine.util.print('Load assets:', '>>')
	-- FONT
	local fonts = love.filesystem.getDirectoryItems(baseDir..'font')
	Engine.util.print('Fonts:', '++\t')

	for k, file in ipairs(fonts) do
		local name = string.sub(file, 1, string.len(file) - 4)
		Engine.util.print(name, '\t\t')

		for i = 12, 72, 12 do
			-- i = 12, 24, 36, 48, 60, 72
			asset.font[name..i] = LG.newFont(baseDir..'font/'..file, i)
		end
	end

	-- IMAGE
	local images = love.filesystem.getDirectoryItems(baseDir..'image')
	Engine.util.print('Images:', '++\t')

	for k, file in ipairs(images) do
		local ext = string.sub(file, string.len(file)-3, string.len(file))

		if ext == '.png' or ext == '.jpg' then
			local name = string.sub(file, 1, string.len(file) - 4)
			asset.image[name] = LG.newImage(baseDir..'image/'..file)
			Engine.util.print(name, '\t\t')
		end
	end

	-- SOUND
	local sounds = love.filesystem.getDirectoryItems(baseDir..'sound')
	Engine.util.print('Sounds:', '++\t')

	for k, file in ipairs(sounds) do
		local ext = string.sub(file, string.len(file)-3, string.len(file))
		local name = string.sub(file, 1, string.len(file) - 4)

		if ext == '.ogg' or ext == '.mp3' then
			-- Changed to be compatable with TESound
			asset.sound[name] = baseDir..'sound/'..file--love.audio.newSource(baseDir..'sound/'..file)
			Engine.util.print(name, '\t\t')
		end
	end
end

return asset, asset.init()