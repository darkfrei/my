my = require("my")



function love.load()
	f = -- field
		{
			width = 9, -- squares
			heigh = 9, -- squares
			pixel_size = 19, -- pixels
			shift = {x=50, y=50} -- pixels
		}
	f.step = f.pixel_size+1
	f.xmin = f.shift.x
	f.ymin = f.shift.y
	f.xmax = f.shift.x + (f.width-1)*f.step
	f.ymax = f.shift.y + (f.heigh-1)*f.step
	
	text_shift = f.ymax + 50
	
	xa=f.xmin
	ya=f.ymin
	va=4
	vmax=24
	aa=1.01
	fps = 0
	t = 0
	t2 = 0
	
end

function love.update (dt)
	t = t + dt
	if math.floor (t) > t2 then
		fps = (1/dt)
		t2 = math.floor (t)
	end
	local pressed = false
	if love.keyboard.isDown ('d') then
		pressed = true
		if va < 16 then va = 1.01*va*(dt*60) end
		
		xa=xa+va
		if xa > f.xmax then xa = f.xmax end
		
	elseif love.keyboard.isDown ('a') then
		pressed = true
		if va < 16 then va = 1.01*va*(dt*60) end
		
		xa=xa-va
		if xa < f.xmin then xa = f.xmin end
		
	else
		xa = math.floor((xa-f.shift.x)/(f.step)+0.5)*f.step + f.shift.x
	end
	
	if love.keyboard.isDown ('s') then
		pressed = true
		if va < 16 then va = 1.01*va*(dt*60) end
		
		ya=ya+va
		if ya > f.ymax then ya = f.ymax end
		
	elseif love.keyboard.isDown ('w') then 
		pressed = true
		if va < 16 then va = 1.01*va*(dt*60) end
		
		ya=ya-va 
		if ya < f.ymin then ya = f.ymin end
		
	else
		ya = math.floor((ya-f.shift.y)/(f.step)+0.5)*f.step + f.shift.y
	end
	if not pressed then
		va = 4
	end
end

function love.draw()
	love.graphics.print ("fps:" .. string.format("%0.3f", fps), text_shift, 10)
	love.graphics.print ('x:' .. string.format("%0.2f", xa) .. ' y:' .. string.format("%0.2f", ya), text_shift, 25)
	
	local step = 8

--	local shift = 16
	my.rectangle {x=(f.shift.x-f.pixel_size), y=(f.shift.y-f.pixel_size), 
		width = (f.width*(f.step)+f.pixel_size), 
		heigh = (f.heigh*(f.step)+f.pixel_size), color = {50,50,60}}
	

	for y = f.ymin, f.ymax, f.step do
		for x = f.xmin, f.xmax, f.step do
			if map and map.y and map.y.x then
				
			else
				-- gray
				my.rectangle {width = f.pixel_size, 
					heigh = f.pixel_size, 
					middle={x=x, y=y}, color = {127,127,127}}
			end
		end
	end
	-- the white one
	my.rectangle {width = f.pixel_size, 
		heigh = f.pixel_size,  
		middle={x=xa, y=ya}, 
		color = {255,255,255}}
end