local my = {}

my.rectangle = function (data)
--	love.graphics.rectangle ()
	
	local mode = data.mode or "fill"
	local width = data.width or 7
	local heigh = data.heigh or 7

	local sx = data.sx or width/2
	local sy = data.sy or heigh/2
	local x = data.middle and data.middle.x-sx or data.x
	local y = data.middle and data.middle.y-sy or data.y
	
	local color = data.color
	if color then
		local r = color.r and color.r/255 or color[1] and color[1]/255
		local g = color.g and color.g/255 or color[2] and color[2]/255
		local b = color.b and color.b/255 or color[3] and color[3]/255
		local a = color.a and color.a/255 or color[4] and color[4]/255
		
		love.graphics.setColor(r, g, b, a)
	end
	
	local angle = data.angle or data.angle_grad and math.rad(data.angle_grad) or nil
	if angle then

		love.graphics.translate (x+sx, y+sy)
		love.graphics.rotate (-angle)
		love.graphics.rectangle (mode, -sx, -sy, width, heigh)
		love.graphics.rotate(angle)
		love.graphics.translate (-(x+sx), -(y+sy))
	else
		love.graphics.rectangle (mode, x, y, width, heigh)
	end
	
end

my.line = function (data)
	local x1 = data.position and data.position.x or data.x or 0
	local y1 = data.position and data.position.y or data.y or 0
	local length = data.length or 5
	local direction = data.direction or 0.25
	local alpha = data.alpha or (2*math.pi) * (direction+0.75)
	local x2 = x1 + length * math.cos (alpha)
	local y2 = y1 + length * math.sin (alpha)

	love.graphics.line( x1, y1, x2, y2)
--	love.graphics.line (
end

return my