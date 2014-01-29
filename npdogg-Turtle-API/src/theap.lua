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
-- Binary heap constructor.
-- 
-- @function [parent=#BinaryHeap] new
-- @return #BinaryHeap
function BinaryHeap.new()

	local this = {}
	
	local heap = {}
	local values = {}
	local positions = {}
	local base = 0
	
	---
	-- Swaps the position of two values in the heap.
	-- 
	-- @function [parent=#BinaryHeap] swap
	-- @param #string a The key of the first value to be swapped
	-- @param #string b The key of the second vaue to be swapped
	-- @return #nil
	local function swap(a, b)
		heap[a], heap[b] = heap[b], heap[a]
		positions[heap[a]], positions[heap[b]] = a, b
	end
	
	---
	-- Preserves the heap state by moving a value up through the heap as long as
	-- its value is less than or equal to the value of its parent.
	-- 
	-- @function [parent=#BinaryHeap] bubble
	-- @param #number index The initial position of the value in the heap
	-- @return #number index The index of the value after the bubble operation is
	-- complete
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
	
	--- 
	-- Moves a value down through the heap as long as it is greater than the
	-- values of either of its children. Used to assist with the deletion of
	-- the root of the heap.
	-- 
	-- @function [parent=#BinaryHeap] sift
	-- @param #number index
	-- @return #number index
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
	
	---
	-- Returns the root of the heap and deletes the value.
	-- 
	-- @function [parent=#BinaryHeap] pop
	-- @return #string
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
	
	---
	-- Inserts a new value onto the heap.
	-- 
	-- @function [parent=#BinaryHeap] insert
	-- @param #string key
	-- @param #number value
	-- @return #nil
	function this.insert(key, value)
		base = base + 1
		heap[base] = key
		values[key] = value
		positions[key] = bubble(base)
	end
	
	---
	-- Updates the value of an item on the heap.
	-- 
	-- @function [parent=#BinaryHeap] update
	-- @param #string key
	-- @param #number value
	-- @return @nil
	function this.update(key, value)
		local index = positions[key]
		values[key] = value
		positions[key] = bubble(index)
	end

	return this

end
