local neu = {} -- neuron functions


neu.new = function (data)
	
	local input_amount = data.input_amount or 25
	local output_amount = data.output_amount or 4
	local layers_amount = data.layers_amount or 4
	local layer_breadth = data.breadth or 4
	
	local header = {input_amount=input_amount, -- input nodes
		output_amount=output_amount, -- output nodes
		layers_amount=layers_amount, -- how many hidden layers do we have
		layer_breadth=layer_breadth} -- amount nodes in the hidden layer
	
	local layers = {}
	for i = 1, layers_amount do
		local nodes = {}
		for j = 1, layer_breadth do
			local weights = {}
			local connections_amount = (i==1) and input_amount or layer_breadth
			for k = 1, connections_amount do
				table.insert(weights, {n=2*math.random()-1, -- real from -1 to 1
						ii=2*math.random()-1, 
						ij=2*math.random()-1, 
						ik=2*math.random()-1})
			end
			table.insert(nodes, {weights=weights})
			
			nodes.bias = {n=2*math.random()-1, -- real from -1 to 1
				ii=2*math.random()-1, 
				ij=2*math.random()-1, 
				ik=2*math.random()-1}
		end
		table.insert (layers, {nodes = nodes})
	end
	
	
	local output_nodes = {}
	for i = 1, output_amount do
--		local node = {}
		local weights = {}
		for k = 1, layer_breadth do
			table.insert(weights, {n=2*math.random()-1, -- real from -1 to 1
					ii=2*math.random()-1, 
					ij=2*math.random()-1, 
					ik=2*math.random()-1})
		end
--		table.insert(node, {weights=weights})
		table.insert (output_nodes, {weights=weights})
	
		output_nodes.bias = {n=2*math.random()-1, -- real from -1 to 1
			ii=2*math.random()-1, 
			ij=2*math.random()-1, 
			ik=2*math.random()-1}
	end
	return layers, output_nodes
end


neu.activation = function (a) -- from -inf to +inf
	if type (a) == "table" then
		-- activation for table
		for letter, value in pairs (a) do
			local n = a[letter] or 0
			local result = 2 * math.sin(math.pi * n)
			if (result > 2) or (result < -2) then
				result = 0
			end
			a[letter] = result
		end
		return a
	else
		local result = 2 * math.sin(math.pi * a)
		if (result > 2) or (result < -2) then
			result = 0
		end
		return result
	end
end


neu.complex_multiplicate = function (a, b, bool) 
	-- complex numbers: a = {n, i, j, k}, b = {n, i, j, k}
	-- n is real part of real number
	-- i, j, k imaginary parts of real number
	if not type (a) == "table" then a = {n=a, i=0, j=0, k=0} end
	if not type (b) == "table" then b = {n=b, i=0, j=0, k=0} end
	
	local c = {}
	
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
	if not type (a) == "table" then a = {n=a, i=0, j=0, k=0} end
	if not type (b) == "table" then b = {n=b, i=0, j=0, k=0} end
	local c = {}
	for letter, v in pairs (a) do
		local s = b[letter] or 0
		c[letter] = v-s
	end
	return c
end


neu.complex_subtraction = function (a)
	if not type (a) == "table" then a = {n=a, i=0, j=0, k=0} end
	return neu.complex_multiplicate (a, a)
end


neu.get_cost = function (output_must, output_is)
	local cost = 0
	for output_node, output_value in pairs (output_is) do
		cost = cost + neu.complex_square(neu.complex_subtraction(output_is, output_must)).n
	end
end



return neu