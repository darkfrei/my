
--[[
nn =
{
	input_nodes = {1, 2, 4, 30}, -- any
	--input_size = #input_nodes
	
	length = [0; inf?],
	middle_layers = 
	{
		-- middle layer 1
		{
			size = [1; inf?],
			nodes =
			{
				bias = [-1;1],
				bias_gradient = 0,
				bias_mutation = 0,
				rodes = 
				{
					{weight = [-1;1], delta = 0, mutation = 0},
					{weight = [-1;1], delta = 0, mutation = 0},
					{weight = [-1;1], delta = 0, mutation = 0}
				},
				
				summ = 0,
				result = 0,
				last_result = nil,
				--
				error = 0,
				gradient = 0
			}
		}
	}
	output_layer =
	{
		output_nodes = {}
	}
}
]]
activation = {}
activation[1] = function (value)
	-- changed double logarithm 1
	local a = math.exp(1)-1
	if value > 0 then
		
		return math.log (1+value*a)
	else
		return (-1*math.log (1-value))
	end
end

function generate_rode ()
	local rode = 
	{
		weight = math.random(-10,10)/10,
		delta = 0,
		weight_mutation = 0
	}
	return rode
end

function generate_node ()
	local node = 
	{
		bias = math.random(-10,10)/10,
		bias_gradient = 0,
		bias_mutation = 0,
		rodes = {},
		summ = 0,
		result = 0,
		
		error = 0,
		gradient = 0
	}
	return node
end

function generate_layer (nodes_amount)
	nodes_amount = nodes_amount or 4
	local layer = 
	{
		size = nodes_amount,
		nodes = {}
	}
	for n_node = 1, nodes_amount do
		local node = generate_node ()
		table.insert (layer.nodes, node)
	end
	return layer
end

local neu = {}

neu.feedForward = function (nn) -- neural network
	local input_nodes = nn.input_nodes
--	local input_size = #input_layer.nodes
	local input_size = #input_nodes
	local input_layer = {size=input_size, nodes = {}}
	for i, input_value in pairs (input_nodes) do
		table.insert (input_layer.nodes, {result = input_value})
	end
	
	local layers = {}
	table.insert(layers, input_layer)
	
	local length = nn.length or 4
	local middle_layers = nn.middle_layers or {}
	if not middle_layers then 
		middle_layers = {}
		nn.middle_layers = middle_layers
	end
	for n = 1, length do -- number of middle leyer
		local middle_layer = middle_layers[n]
		if not middle_layer then 
			local nodes_amount = nn.width or 4
			middle_layer = generate_layer (nodes_amount)
			middle_layers[n] = middle_layer
		end
		table.insert(layers, middle_layer)
	end
	
	local output_size = nn.output_nodes and #nn.output_nodes or nn.output_size
	local output_layer = nn.output_layer
	if not output_layer then
		output_layer = generate_layer (output_size)
		nn.output_layer = output_layer
		nn.output_size = output_size
	end
	table.insert(layers, output_layer)
	
	-- all layers are prepared
	for n_layer = 2, (#layers) do
		local prev_layer = layers[n_layer-1]
		local prev_nodes = prev_layer.nodes
		local layer = layers[n_layer]
		local prev_layer_size = prev_layer.size
		for n_node = 1, layer.size do
			local node = layer.nodes[n_node]
			if not node then 
				node = generate_node ()
				layer.nodes[n_node] = node
			end
			local bias = node.bias + node.bias_gradient + node.bias_mutation
			local summ = bias
			
			local rodes = node.rodes
			for j = 1, prev_layer_size do
				local prev_result = prev_nodes[j].result
				
				local rode = rodes[j]
				if not rode then
					rode = generate_rode ()
					rodes[j] = rode
				end
				
				local weight = (rode.weight + rode.delta + rode.weight_mutation)
				summ = summ + prev_result*weight
			end
			node.summ = summ
			local n_activation = node.n_activation or 1 -- it can be added later
			node.result = activation[n_activation] (summ)
		end
	end
	local results = {}
	local n_max, result_max
	
	for n_nod = 1, output_size do
		local result = nn.output_layer.nodes[n_nod].result
		if not result_max then result_max = result end
		if result_max < result then 
			n_max = n_nod
			result_max = result 
		end
		table.insert (results, result)
	end
	print ('n_max:' .. n_max .. ' result_max:' .. result_max)
	return results
end

return neu

