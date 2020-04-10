local mm = {}

mm.move = function (data)
	local p = data.p
	local f = data.f

	local round_x = math.floor((p.x-f.shift.x)/(f.step)+0.5)*f.step + f.shift.x
--	print ('p.x: ' .. p.x .. ' round_x:' .. round_x)
	local round_y = math.floor((p.y-f.shift.y)/(f.step)+0.5)*f.step + f.shift.y
--	print ('p.y: ' .. p.y .. ' round_y:' .. round_y)
	
	if love.keyboard.isDown ('d') then
		p.x=p.x+f.step/4
		if p.x > f.xmax then p.x = f.xmax end
	elseif love.keyboard.isDown ('a') then
		p.x=p.x-f.step/4
		if p.x < f.xmin then p.x = f.xmin end
	else
		p.x = round_x
	end
	
	if love.keyboard.isDown ('s') then
		p.y=p.y+f.step/4
		if p.y > f.ymax then p.y = f.ymax end
		
	elseif love.keyboard.isDown ('w') then 
		p.y=p.y-f.step/4 
		if p.y < f.ymin then p.y = f.ymin end
	else
		p.y = round_y
	end
	local last_pos = p.last
	if not (last_pos.x == round_x) or not (last_pos.y == round_y) then
		
		local alpha = math.atan2(last_pos.y-round_y, last_pos.x-round_x)
--		print ('last_pos.y:' .. last_pos.y .. ' round_y:' .. round_y)
--		print ('last_pos.x:' .. last_pos.x .. ' round_x:' .. round_x)
		last_pos.x = round_x
		last_pos.y = round_y
		last_pos.direcion = p.d
		local direcion = (1 + (alpha/(2*math.pi)) - 0.25)%1
		p.d = direcion
	end
end

return mm
