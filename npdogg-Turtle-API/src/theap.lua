---
-- Binary heap.
-- 
-- @module BinaryHeap
BinaryHeap = {}

---
-- Binary heap.
-- 
-- @type BinaryHeap

---
-- Constructor.
-- 
-- @function [parent=#BinaryHeap] new
-- @return #BinaryHeap
function BinaryHeap.new()

	local this = {}
	
	local heap = {}
	local values = {}
	local positions = {}
	local base = 0
	
	local function swap(a, b)
		local temp = heap[a]
		heap[a] = heap[b]
		heap[b] = temp
		positions[heap[a]] = a
		positions[heap[b]] = b
	end
	
	local function bubble(index)
		local value = values[heap[index]]
		local floor = math.floor
		
		while index > 1 do
			local parent_index = floor(index / 2)
			local parent_value = values[heap[parent_index]]
			
			if value <= parent_value then
				swap(parent_index, index)
				index = parent_index
			else
				break
			end
		end
		
		return index
	end
	
	local function sift(index)
		local value = values[heap[index]]
		local left_child_index = index * 2
		local left_child_value = values[heap[left_child_index]]
		local right_child_index = index * 2 + 1
		local right_child_value = values[heap[right_child_index]]
		local min_child_index = index
		local min_child_value
		
		if right_child_value == nil then
			if left_child_value ~= nil then
				min_child_index = left_child_index
			end
		else
			min_child_index = (left_child_value <= right_child_value) and left_child_index or right_child_index
		end
				
		min_child_value = values[heap[min_child_index]]
		
		if value > min_child_value then
			swap(index, min_child_index)
			index = sift(min_child_index)
		end
		
		return index
	end
	
	function this.pop()
		local min = heap[1]
		
		if base > 1 then
			local old_key, new_key
			
			old_key = heap[1]
			swap(1, base)
			values[old_key] = nil
			positions[old_key] = nil
			old_key = nil
			heap[base] = nil
			base = base - 1
			new_key = heap[1]
			positions[new_key] = sift(1)
		elseif base == 1 then
			values[heap[1]] = nil
			positions[heap[1]] = nil
			heap[1] = nil
			base = 0
		end
		
		return min
	end
	
	function this.insert(key, value)
		base = base + 1
		heap[base] = key
		values[key] = value
		positions[key] = bubble(base)
	end
	
	function this.update(key, value)
		local index = positions[key]
		values[key] = value
		positions[key] = bubble(index)
	end

	return this

end