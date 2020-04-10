local neu = {} -- neuron functions


neu.new = function (data)
	
	local input_amount = data.input_amount or 20
	local output_amount = data.output_amount or 4
	local layers_amount = data.layers_amount or 4
	local layer_breadth = data.breadth or 4
	
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
		end
		table.insert (layers, {nodes = nodes})
	end
	local output_nodes = {}
	for i = 1, output_amount do
		local node = {}
		local weights = {}
		for k = 1, layer_breadth do
			table.insert(weights, {n=2*math.random()-1, -- real from -1 to 1
					ii=2*math.random()-1, 
					ij=2*math.random()-1, 
					ik=2*math.random()-1})
		end
		table.insert(nodes, {weights=weights})
		table.insert (output_nodes, node)
	end
	return layers, output_nodes
end


return neu