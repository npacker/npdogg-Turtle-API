BinaryHeap = {}

function BinaryHeap.new()

	local this = {}
	
	local heap = {}
	local values = {}
	local base = 0
	
	local function swap(parent_index, child_index)
		local swap = heap[parent_index]
		heap[parent_index] = heap[child_index]
		heap[child_index] = swap
	end
	
	local function bubble(index)
		local value = values[heap[index]]
		
		while index > 1 do
			local parent_index = math.floor(index / 2)
			local parent_value = values[heap[parent_index]]
			
			if value <= parent_value then
				swap(parent_index, index)
				index = parent_index
			else
				break
			end
		end
	end
	
	local function index(key)
		for index, stored_key in ipairs(heap) do
			if stored_key == key then return index end
		end
	end
	
	function this.size()
		return base
	end
	
	function this.min()
		return heap[1]
	end
	
	function this.value(key)
		return values[key]
	end
	
	function this.insert(key, value)
		base = base + 1
		values[key] = value
		heap[base] = key
		bubble(base)
	end
	
	function this.update(key, value)
		local index = index(key)
		values[key] = value
		bubble(index)
	end
		
	return this

end