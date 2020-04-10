my = require("my")
mm = require("manual-movement")
neu = require("neuron")


function love.load()
	f = -- field
		{
			width = 5, -- squares
			heigh = 3, -- squares
			pixel_size = 19, -- pixels
			shift = {x=50, y=50} -- pixels
		}
	f.step = f.pixel_size+1
	f.xmin = f.shift.x
	f.ymin = f.shift.y
	f.xmax = f.shift.x + (f.width-1)*f.step
	f.ymax = f.shift.y + (f.heigh-1)*f.step
	
	text_shift = f.xmax + 50
	
--	d=0.25 -- direcion: 0 to north, 0.25 to east, 0.5 to south, 0.75 to west; Factorio!
	p = {x=f.xmin, y=f.ymin, d=0.25, last = {x=f.xmin, y=f.ymin, d = 0.25}}

	
	
	fps = 0
	t = 0
	t2 = 0
	
	map = {}
	
	
	neu_input = {f.width, f.heigh}
	
--	slider = {x = }
	
end

function love.update (dt)

	t = t + dt
	if math.floor (t) > t2 then
		fps = (1/dt)
		t2 = math.floor (t)
	end
	
	-- neuron
	
	
	-- manual
	mm.move {f=f,p=p}
	
end

function love.draw()
	love.graphics.print ("fps:" .. string.format("%0.3f", fps), text_shift, 10)
	love.graphics.print ('x:' .. string.format("%0.2f", p.x) .. ' y:' .. string.format("%0.2f", p.y), text_shift, 25)
	local x = math.floor((p.x - f.xmin)/f.step +0.5) + 1
	local y = math.floor((p.y - f.xmin)/f.step +0.5) + 1
	love.graphics.print ('p x:' .. x .. ' y:' .. y .. ' d:' .. p.d, text_shift + 120, 25)
	
	love.graphics.print ('mouse x:' .. love.mouse.getX() .. ' y:' .. love.mouse.getY(), text_shift, 40)
	local m_x, m_y = love.mouse.getX(), love.mouse.getY()
	
	if 	(m_x >= (f.xmin-f.step/2)) and (m_x <= f.xmax+f.step/2) and 
		(m_y >= (f.ymin-f.step/2)) and (m_y <= f.ymax+f.step/2) then
		local x = math.floor((m_x - f.xmin)/f.step +0.5) + 1
		local y = math.floor((m_y - f.ymin)/f.step +0.5) + 1
		love.graphics.print ('c pos x:' .. x .. ' y:' .. y, text_shift + 120, 40)
	end
	
	
	
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
	my.rectangle {width = f.pixel_size-2, 
		heigh = f.pixel_size-2, 
		mode = "line",
		middle={x=p.x, y=p.y}, 
		color = {255,255,255}}
	my.line {x=p.x, y=p.y, length=(f.pixel_size-1)/2, direction=p.d}
end