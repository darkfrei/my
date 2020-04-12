local my = require("my")
local mm = require("manual-movement")
local neu = require("neuron")

local serialize = require 'ser'

--when saving a game:
--love.filesystem.write(filename, serialize(pretty_large_table))

--when loading a game:
--pretty_large_table = love.filesystem.load(filename)()


function love.load()
	f = -- field
		{
			width = 8, -- squares
			heigh = 8, -- squares
			pixel_size = 19, -- pixels
			shift = {x=50, y=50} -- pixels
		}
	f.step = f.pixel_size+1
	f.xmin = f.shift.x
	f.ymin = f.shift.y
	f.xmax = f.shift.x + (f.width-1)*f.step
	f.ymax = f.shift.y + (f.heigh-1)*f.step
	
	text_shift = f.xmax + 60
	
--	d=0.25 -- direcion: 0 to north, 0.25 to east, 0.5 to south, 0.75 to west; Factorio!
	p = {x=f.xmin, y=f.ymin, d=0.25, last = {x=f.xmin, y=f.ymin, d = 0.25}}

	
	
	fps = 0
	t = 0
	t2 = 0
	
	map = {}
	
	
	neu_input = {1, 0, -1, f.width, f.heigh, p.x, p.y, p.d, p.last.x, p.last.y, p.last.d}
	for y = 1, f.heigh do
		for x = 1, f.width do
			if not map[y] then map[y] = {} end
--			local dust = 0.5 + math.random()/2
			local dust = 1
			map[y][x] = dust
			table.insert (neu_input, dust)
		end
	end
	neuron = neu.new {input_amount=#neu_input}
	
	buttons = {}
	buttons['reset'] = {text = 'reset', x=text_shift + 120, y=20, w=35, h=15}
	
	sliders = {}
	sliders['ups'] = {x=30, y=5, w=180, h=20, slider_x = 50}
	
	
end

function love.update (dt)

	t = t + dt
	if math.floor (t) > t2 then
		fps = (1/dt)
		t2 = math.floor (t)
	end
	
--	buttons
	local pressed_button = my.pressed_button (buttons)
	if pressed_button and pressed_button == "reset" then
		p = {x=f.xmin, y=f.ymin, d=0.25, last = {x=f.xmin, y=f.ymin, d = 0.25}}
		for y = 1, f.heigh do
			for x = 1, f.width do
				if not map[y] then map[y] = {} end
				local dust = 1
				map[y][x] = dust
			end
		end
	end
	
	my.clicked_slider(sliders)
--	neuron
	
	
--	manual
	local cleaned = mm.move {f=f,p=p}
	
--	cleaning
--	print ('p.y' .. p.y .. ' p.x' .. p.x)
	if cleaned then
		local cy = (p.last.y-f.ymin)/f.step + 1
		local cx = (p.last.x-f.xmin)/f.step + 1
		if map[cy] and map[cy][cx] then
			map[cy][cx] = 0.8 * map[cy][cx]
		else
			print ('cy:' .. cy .. ' cx:' .. cx)
		end
	end
end

function love.draw()
	love.graphics.print ("fps:" .. string.format("%0.3f", fps), text_shift, 20)
	love.graphics.print ('x:' .. string.format("%0.2f", p.x) .. ' y:' .. string.format("%0.2f", p.y), text_shift, 40)
	local x = math.floor((p.x - f.xmin)/f.step +0.5) + 1
	local y = math.floor((p.y - f.xmin)/f.step +0.5) + 1
	local dust = map[y] and map[y][x] or 0
	love.graphics.print ('p x:' .. x .. ' y:' .. y .. ' d:' .. string.format("%0.2f", p.d) .. 
		' dust:' .. string.format("%0.2f", dust), text_shift + 120, 40)
	
	love.graphics.print ('mouse x:' .. love.mouse.getX() .. ' y:' .. love.mouse.getY(), text_shift, 60)
	local m_x, m_y = love.mouse.getX(), love.mouse.getY()
	
	if 	(m_x >= (f.xmin-f.step/2)) and (m_x <= f.xmax+f.step/2) and 
		(m_y >= (f.ymin-f.step/2)) and (m_y <= f.ymax+f.step/2) then
		local x = math.floor((m_x - f.xmin)/f.step +0.5) + 1
		local y = math.floor((m_y - f.ymin)/f.step +0.5) + 1
		local dust = map[y] and map[y][x] or 0
		love.graphics.print ('c pos x:' .. x .. ' y:' .. y .. ' dust:' .. string.format("%0.2f", dust), text_shift + 120, 60)
	end
	
	-- buttons
	my.draw_buttons (buttons)
	my.draw_sliders (sliders)
--	my.draw_sliders ({ups = {x=30, y=5, w=180, h=20, slider_x = 50}})
	
--	my.slider_draw{x=30, y=5, w=180, h=20, slider_x = 50}
	
-- background
	my.rectangle {x=(f.shift.x-f.pixel_size), y=(f.shift.y-f.pixel_size), 
		width = (f.width*(f.step)+f.pixel_size), 
		heigh = (f.heigh*(f.step)+f.pixel_size), color = {50,50,60}}
	
--	grid
	for y = f.ymin, f.ymax, f.step do
		for x = f.xmin, f.xmax, f.step do
			local cy = (y-f.ymin)/f.step + 1
			local cx = (x-f.xmin)/f.step + 1
			if map and map[cy] and map[cy][cx] then
				local dust = map[cy][cx]
				local color = 230 - dust*230
				my.rectangle {width = f.pixel_size, 
					heigh = f.pixel_size, 
					middle={x=x, y=y}, color = {color,color,color}}
			else
				-- gray
				my.rectangle {width = f.pixel_size-2, 
					heigh = f.pixel_size-2, 
					middle={x=x, y=y}, color = {127,127,127}}
			end
		end
	end
	
-- the white pointer
	my.rectangle {width = f.pixel_size-2, 
		heigh = f.pixel_size-2, 
		mode = "line",
		middle={x=p.x, y=p.y}, 
		color = {0,255,0}}
--	white direction pointer
	my.line {x=p.x, y=p.y, length=(f.pixel_size-1)/2, direction=p.d, color = {0,255,0}}
end