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
--		love.graphics.setLineWidth(1)
		love.graphics.rectangle (mode, x, y, width, heigh)
	end
end


my.line = function (data)
	local x1 = data.position and data.position.x or data.x or 0
	local y1 = data.position and data.position.y or data.y or 0
	x1 = math.floor (x1) +.5
	y1 = math.floor (y1) +.5
	local length = data.length or 5
	local direction = data.direction or 0.25
	local alpha = data.alpha or (2*math.pi) * (direction+0.75)
	local x2 = (x1 + length * math.cos (alpha))
	local y2 = (y1 + length * math.sin (alpha))

--	love.graphics.setLineWidth(1)
	love.graphics.setLineStyle( "rough" ) -- or "smooth"
	love.graphics.line( x1, y1, x2, y2)
--	love.graphics.line (
end


my.pressed_button = function (buttons)
	if buttons and love.mouse.isDown(1) then
		local m_x, m_y = love.mouse.getX(), love.mouse.getY()
		for button_name, button in pairs (buttons) do
			if (m_x > button.x) and (m_x < (button.x + button.w)) and
			   (m_y > button.y) and (m_y < (button.y + button.h)) then
				button.clicked = true
				return button_name
			end
		end
	end
	return nil
end


--my.button_draw = function (data)
my.draw_buttons = function (buttons)
	for button_name, button in pairs (buttons) do
		local x, y = button.x, button.y
		local w, h = button.w, button.h
		local text = button.text or 'text'
		if button.clicked then 
			x=x+1
			y=y+1
			button.clicked = false
		end
		love.graphics.setColor(1, 1, 1)
		love.graphics.rectangle ('line', x, y, w, h)
		love.graphics.print(text, x+2, y)
	end
end


my.clicked_slider = function (sliders)
	if sliders and love.mouse.isDown(1) then
		local m_x, m_y = love.mouse.getX(), love.mouse.getY()
		for slider_name, slider in pairs (sliders) do
			if (m_x > slider.x) and (m_x < (slider.x + slider.w)) and
			   (m_y > slider.y) and (m_y < (slider.y + slider.h)) then
				
				if not slider.gap then slider.gap = 4 end
				local gap = slider.gap
				local xmin = slider.x + gap
				local xmax = slider.x + slider.w - gap
				local pos_x = love.mouse.getX()
				if pos_x < xmin then pos_x = xmin end
				if pos_x > xmax then pos_x = xmax end
				slider.slider_x = pos_x
				local value = pos_x - xmin
				slider.value = value
				slider.n_value = value / (xmax-xmin) -- normalized
				
				slider.clicked = true
				return slider_name, slider.n_value, slider.value
			end
		end
	end
end

my.draw_sliders = function (sliders)
	for slider_name, slider in pairs (sliders) do
		local x, y = slider.x, slider.y
		local w, h = slider.w, slider.h
		local gap = slider.gap or 4 -- gap
		local gap2 = gap
		if slider.clicked then
			gap2= gap2 - 2 
			slider.clicked = false
		end
		local slider_x = slider.slider_x
--		local slider_y = slider.slider_y
		love.graphics.setColor(1, 1, 1)
		love.graphics.rectangle ('line', x, y, w, h)
		if slider_x then
			love.graphics.line( x+gap, y+h/2, x+w-gap, y+h/2) -- long horizontal
			love.graphics.line( slider_x , y+gap2, slider_x, y+h-gap2) -- short vertical
			love.graphics.print(slider.value or "", x+w+2, y)
			love.graphics.print(slider.n_value and string.format("%0.2f", slider.n_value) or "", x+w+30, y)
--		elseif slider_y then
--			love.graphics.line( x+w/2, y+gap, x+w/2, y+h-gap) -- long vertical
--			love.graphics.line( x+gap2, slider_y , x+w-gap2, slider_y) -- short horizontal
		end
		
	end
end

my.map_clicked = function (data)
	local mouseButton = nil
	if love.mouse.isDown(1) then mouseButton = 1 end
	if love.mouse.isDown(2) then mouseButton = 2 end
	if mouseButton then
		local f = data.f -- field of map
		
		local m_x, m_y = love.mouse.getX(), love.mouse.getY()
		if (m_x > f.xmin) and (m_x < f.xmax) and
		   (m_y > f.ymin) and (m_y < f.ymax) then
--			local x = (m_x-f.xmin)/f.step + 1 -- cell [x, y]
--			local y = (m_y-f.ymin)/f.step + 1
			local x = math.floor((m_x - f.xmin)/f.step +0.5) + 1
			local y = math.floor((m_y - f.ymin)/f.step +0.5) + 1
			return {x=x, y=y, mouseButton = mouseButton}
		end
	end
end

return my
