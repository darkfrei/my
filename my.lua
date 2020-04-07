local my = {}

my.rectangle = function (data)
--	love.graphics.rectangle ()
	local mode = data.mode
	local x = data.x
	local y = data.y
	local width = data.width
	local heigh = data.heigh
	love.graphics.rectangle (mode, x, y, width, heigh)
end

return my