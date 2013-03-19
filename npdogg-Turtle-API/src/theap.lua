BinaryHeap = {}

function BinaryHeap.new()

	local this = {}
	
	local heap = {}
	local values = {}
	local size = 0
	
	function this.min()
		return heap[1]
	end
	
	function this.key(index)
		return heap[index]
	end
	
	function this.value(key)
		return values[key]
	end
	
	function this.size()
		return size
	end
	
	function this.parent(index)
		local parent_index = parent_index(index)
		
		return values[parent_index]
	end
	
	function this.left_child(index)
		local left_child_index = left_child_index(index)
		
		return values[left_child_index]
	end
	
	function this.right_child(index)
		local right_child_index = right_child_index(index)
		
		return values[right_child_index]
	end
	
	local function bubble(index)
		while index > 1 do
			local parent_index = parent_index(index)
			local value = values[heap[index]]
			local parent_value = this.parent(index)
			
			if value <= parent_value then
				swap(parent_index, index)
				index = parent_index
			end
		end
	end
	
	local function swap(parent, child)
		local swap = heap[parent]
		
		heap[parent] = heap[child]
		heap[child] = swap
	end
	
	local function parent_index(index)
		return math.floor(index / 2)
	end
	
	local function left_child_index(index)
		return 2 * index
	end
	
	local function right_child_index(index)
		return 2 * index + 1
	end
		
	return this

end

heapy = BinaryHeap.new()
print(heapy.size())