--[[
	neu = {
		header = {input_amount=3, layers_amount=2, layer_breadth=2, output_amount=3},
		input_nodes = {12, 24, 0.5} -- from your data
		hidden_layers = {
			{	-- first layer
				nods = {
					{ -- first node, amount of weigths is the same as input_amount 
						weights = {0.24, 0.9, -0.11}, -- random [-1; 1]
						bias = 0.9 -- random [-1; 1]
					},
					{ -- second node in first layer, amount weigths is from input_amount 
						weights = {0.3, -0.4, -0.5}, -- random [-1; 1]
						bias = -0.7 -- random [-1; 1]
					}
				},
			},
			{	-- second layer
				nods = {
					{ -- first node, amount of weigths is the same as layer_breadth 
						weights = {0.17, 0.8}, -- random [-1; 1]
						bias = 0.1 -- random [-1; 1]
					},
					{ -- second node in second layer, amount weigths is from layer_breadth 
						weights = {0.2, 0.2}, -- random [-1; 1]
						bias = -0.6 -- random [-1; 1]
					}
				},
				
			},
			
		},
		output_nodes = {
			{ -- first node, amount of weigths is the same as layer_breadth 
				weights = {0.17, 0.8}, -- random [-1; 1]
				bias = bias = -0.6 -- random [-1; 1]
			},
			{ -- second node, amount of weigths is the same as layer_breadth 
				weights = {0.27, 0.28}, -- random [-1; 1]
				bias = bias = 0.6 -- random [-1; 1]
			},
			{ -- third node, amount of weigths is the same as layer_breadth 
				weights = {0.37, 0.18}, -- random [-1; 1]
				bias = bias = 0.8 -- random [-1; 1]
			},
		}
	}
]]


local neu = {} -- neuron functions

neu.complex_random = function (complex)
	if complex then
		local c = {}
		c.n = 2*math.random()-1
		c.i = 2*math.random()-1
		c.j = 2*math.random()-1
		c.k = 2*math.random()-1
		return c
	else
		return 2*math.random()-1
	end
end

neu.create_nod = function ()
	local nod = {}
	nod.weights = {}
	nod.bias = neu.complex_random(true)
	return nod
end

neu.new = function (data)
	
	local input_nodes = data.input_nodes
	local input_amount = #data.input_nodes
	
	local layers_amount = data.layers_amount or 4
	local layer_breadth = data.breadth or 4
	
	local output_amount = data.output_amount or 4
	
	
	local header = {input_amount=input_amount, -- input nodes
		
		layers_amount=layers_amount, -- how many hidden layers do we have
		layer_breadth=layer_breadth, -- amount nodes in the hidden layer
		output_amount=output_amount} -- output nodes
	
	local hidden_layers = {}
	for i = 1, layers_amount do
		local nodes = {}
		for j = 1, layer_breadth do
			local weights = {}
			local connections_amount = (i==1) and input_amount or layer_breadth
			for k = 1, connections_amount do
				table.insert(weights, neu.random_weight())
			end
			table.insert(nodes, {weights=weights})
			nodes.bias = neu.random_weight()
		end
		table.insert (layers, {nodes = nodes})
	end
	
	local output_nodes = {}
	for i = 1, output_amount do
		local weights = {}
		for k = 1, layer_breadth do
			table.insert(weights, neu.random_weight())
		end
		table.insert (output_nodes, {weights=weights})
		output_nodes.bias = neu.random_weight()
	end
	return layers, output_nodes
end


neu.activation = function (a) -- from -inf to +inf
	if type (a) == "table" then
		-- activation for table
		for letter, value in pairs (a) do
			local n = a[letter] or 0
			local result = math.sin(math.pi * n)
			if (result > 2) or (result < -2) then
				result = 0
			end
			a[letter] = result
		end
		return a
	else
		local result = math.sin(math.pi * a)
		if (result > 2) or (result < -2) then
			result = 0
		end
		return result
	end
end


--derivative
neu.derivative = function (a) -- from -inf to +inf
	if type (a) == "table" then
		-- activation for table
		for letter, value in pairs (a) do
			local n = a[letter] or 0
			local result = (math.pi/2) * math.cos(math.pi * n)
			if (result > 2) or (result < -2) then
				result = -(math.pi/2)
			end
			a[letter] = result
		end
		return a
	else
		local result = (math.pi/2) * math.cos(math.pi * a)
		if (result > 2) or (result < -2) then
			result = -(math.pi/2)
		end
		return result
	end
end


neu.complex_multiplicate = function (a, b, bool) 
	-- complex numbers: a = {n, i, j, k}, b = {n, i, j, k}
	-- n is real part of real number
	-- i, j, k imaginary parts of real number
	if not (type (a) == "table") then a = {n=a, i=0, j=0, k=0} end
	if not (type (b) == "table") then b = {n=b, i=0, j=0, k=0} end
	
	local c = {}
	local an = a.n
	local bn = b.n
	c.n = 		a.n * b.n -- 1
	
	if bool then -- experimental
		c.n = 		a.n * b.n -- 1
		
		c.n = c.n - a.i * b.i -- 9
		c.n = c.n - a.i * b.j
		c.n = c.n - a.i * b.k
		
		c.n = c.n - a.j * b.i
		c.n = c.n - a.j * b.j
		c.n = c.n - a.j * b.k
		
		c.n = c.n - a.k * b.i
		c.n = c.n - a.k * b.j
		c.n = c.n - a.k * b.k
		
		--
		c.i = 		a.n * b.i -- 6
		c.i = c.i + a.i * b.n
		
		c.j = 		a.n * b.j
		c.j = c.j + a.j * b.n
		
		c.k = 		a.n * b.k
		c.k = c.k + a.k * b.n
	else -- real Quaternion
		c.n = 		a.n * b.n -- 1
		
		c.n = c.n - a.i * b.i -- 3
		c.n = c.n - a.j * b.j
		c.n = c.n - a.k * b.k
		
		c.i = 		a.n * b.i -- 12
		c.i = c.i + a.i * b.n
		c.i = c.i + a.j * b.k
		c.i = c.i - a.k * b.j
		
		c.j = 		a.n * b.j
		c.j = c.j + a.j * b.n
		c.j = c.j + a.k * b.i
		c.j = c.j - a.i * b.k
		
		
		c.k = 		a.n * b.k
		c.k = c.k + a.k * b.n
		c.k = c.k + a.i * b.j
		c.k = c.k - a.j * b.i
	end
	return c
end


neu.complex_subtraction = function (a, b)
	if not (type (a) == "table") then a = {n=a, i=0, j=0, k=0} end
	if not (type (b) == "table") then b = {n=b, i=0, j=0, k=0} end
	local c = {}
	for letter, value in pairs (a) do
		local second_value = b[letter] or 0
		c[letter] = value-second_value
	end
	return c
end


neu.complex_addition = function (a, b)
	if not (type (a) == "table") then a = {n=a, i=0, j=0, k=0} end
	if not (type (b) == "table") then b = {n=b, i=0, j=0, k=0} end
	local c = {}
	for letter, value in pairs (a) do
		local second_value = b[letter] or 0
		c[letter] = value+second_value
	end
	return c
end


neu.complex_square = function (a)
	if not (type (a) == "table") then a = {n=a, i=0, j=0, k=0} end
	return neu.complex_multiplicate (a, a)
end


neu.get_cost = function (output_must, output_is)
	local cost = 0
	for output_node, output_value in pairs (output_is) do
		cost = cost + neu.complex_square(neu.complex_subtraction(output_is, output_must)).n
	end
	return cost
end


neu.main = function (data)
	if not data then data = {} end
	local input_nodes = data.input_nodes or {1, 2, 4, 8} -- why not just four?
	local input_amount = #input_nodes

	local target = data.target or {1, 0}
	local output_amount = #target
	
	local length = data.length or 4 -- hidden layers only
	local width  = data.width or 4  -- hidden layers only
	
	local layers = data.layers -- hidden layers only
	if not layers then
		layers = {}
		data.layers = layers -- sync between them
	end
	for i = 1, length do -- all layers
		if not layers[i] then layers[i] = {} end
		for j = 1, width do -- all nods in this layer
--			local prev_layer = (i == 1) and input_nodes or layers[i-1]
			local prev_layer = layers[i-1]
			if not prev_layer then prev_layer = input_nodes end
--			print ('prev_layer' .. unpack(prev_layer))
			if not layers[i][j] then layers[i][j] = neu.create_nod () end
			local connections_amount = (i == 1) and input_amount or width -- first layer's nods have input_amount connections
			local w_summ = layers[i][j].bias -- w_summ = bias + [summ of all x*w], x - prev. nod result; w - weight
			
			for k = 1, connections_amount do -- connections b. this nod and every non on prev. layer
--				local prev_nod_result = prev_layer[k] and prev_layer[k].result or prev_layer[k] -- complex or not
				local prev_nod_result = prev_layer[k]
				if type (prev_nod_result) == "table" then prev_nod_result = prev_nod_result.result end
				local weight = layers[i][j].weights[k]
				if not weight then 
					weight = neu.complex_random(true) -- 
					layers[i][j].weights[k] = weight
				end
				local subresult = neu.complex_multiplicate (prev_nod_result, weight)
				w_summ = neu.complex_addition (w_summ, subresult)
			end
			layers[i][j].result = neu.activation (w_summ) -- activated summ of bias+[all x*w]
		end
	end
	-- output nodes
	local output_nodes = data.output_nodes
	if not output_nodes then
		output_nodes = {}
		data.output_nodes = output_nodes
	end
	for j = 1, output_amount do -- for all nodes in the output layer
		local prev_layer = layers[length] -- yeah, I can make this net shorter
		if not output_nodes[j] then output_nodes[j] = neu.create_nod () end -- it contains bias and weights
		local w_summ = output_nodes[j].bias
		for k = 1, width do
			local prev_nod_result = prev_layer[k].result
			local weight = output_nodes[j].weights[k]
			if not weight then
				weight = neu.complex_random(true)
				output_nodes[j].weights[k] = weight
			end
			local subresult = neu.complex_multiplicate (prev_nod_result, weight)
			w_summ = neu.complex_addition (w_summ, subresult)
		end
		output_nodes[j].result = w_summ
		
		local cost = neu.get_cost (target[j], w_summ)
		if (type(cost) == "table") then cost = cost.n end
		output_nodes[j].cost = cost
		print ('cost: ' .. cost)
	end
	--
	
end


return neu