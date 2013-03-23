BinaryHeap = {}

function BinaryHeap.new()

	local this = {}
	
	local heap = {}
	local values = {}
	local positions = {}
	local base = 0
	
	local function getLeftChildIndex(index)
		return index * 2
	end
	
	local function getRightChildIndex(index)
		return index * 2 + 1
	end
	
	local function getParentIndex(index)
		return math.floor(index / 2)
	end
	
	local function swap(a, b)
		local swap = heap[a]
		heap[a] = heap[b]
		heap[b] = swap
	end
	
	local function bubble(index)
		local value = values[heap[index]]
		
		while index > 1 do
			local parent_index = getParentIndex(index)
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
		local left_child_index = getLeftChildIndex(index)
		local right_child_index = getRightChildIndex(index)
		local left_child_value = values[heap[left_child_index]]
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
	
	local function deleteMin()
		local old_key, new_key, old_base
		
		old_base = base
		old_key = heap[1]
		
		heap[1] = heap[base]
		new_key = heap[1]
		base = base - 1
		
		positions[new_key] = sift(1)
		
		heap[old_base] = nil
		values[old_key] = nil
		positions[old_key] = nil
	end
	
	function this.min()
		local min = heap[1]
		deleteMin()
		
		return min
	end
	
	function this.insert(key, value)
		base = base + 1
		values[key] = value
		heap[base] = key
		positions[key] = bubble(base)
	end
	
	function this.update(key, value)
		local index = positions[key]
		values[key] = value
		positions[key] = bubble(index)
	end

	return this

end

Position = {}

local SOUTH, WEST, NORTH, EAST, UP, DOWN = 0, 1, 2, 3, 4, 5

local deltas =
{
	[SOUTH] = { x =	 0, y =	 0, z =	 1 },
	[WEST]	= { x = -1, y =	 0, z =	 0 },
	[NORTH] = { x =	 0, y =	 0, z = -1 },
	[EAST]	= { x =	 1, y =	 0, z =	 0 },
	[UP]		= { x =	 0, y =	 1, z =	 0 },
	[DOWN]	= { x =	 0, y = -1, z =	 0 }
}

function Position.SOUTH()
	return SOUTH
end

function Position.WEST()
	return WEST
end

function Position.NORTH()
	return NORTH
end

function Position.EAST()
	return EAST
end

function Position.UP()
	return UP
end

function Position.DOWN()
	return DOWN
end

function Position.new(x, y, z, f)

	local this = {}

	this.x = x or 0
	this.y = y or 0
	this.z = z or 0
	this.f = f or 0

	function this.step(direction)
		local delta = deltas[direction]

		this.x, this.y, this.z = this.x + delta["x"], this.y + delta["y"], this.z + delta["z"]

		return this
	end

	function this.back()
		local delta = deltas[this.f]

		this.x, this.y, this.z = this.x - delta["x"], this.y - delta["y"], this.z - delta["z"]

		return this
	end

	function this.forward()
		this.step(this.f)

		return this
	end

	function this.up()
		this.step(UP)

		return this
	end

	function this.down()
		this.step(DOWN)

		return this
	end

	function this.turnLeft()
		this.f = (this.f + 3) % 4

		return this
	end

	function this.turnRight()
		this.f = (this.f + 1) % 4

		return this
	end

	function this.distance(position)
		return math.abs(position.getX() - this.x) + math.abs(position.getY() - this.y) + math.abs(position.getZ() - this.z)
	end
	
	function this.equals(position)
		if this.x ~= position.getX() or this.y ~= position.getY() or this.z ~= position.getZ() then
			return false
		end

		return true
	end

	function this.copy()
		return Position.new(this.x, this.y, this.z, this.f)
	end

	function this.toString()
		return string.format("%d:%d:%d", this.x, this.y, this.z)
	end

	function this.setX(x)
		this.x = x

		return this
	end

	function this.setY(y)
		this.y = y

		return this
	end

	function this.setZ(z)
		this.z = z

		return this
	end

	function this.setF(f)
		this.f = f

		return this
	end

	function this.set(x, y, z, f)
		this.x, this.y, this.z, this.f = x, y, z, f

		return this
	end

	function this.getX()
		return this.x
	end

	function this.getY()
		return this.y
	end

	function this.getZ()
		return this.z
	end

	function this.getF()
		return this.f
	end

	function this.get()
		return this.x, this.y, this.z, this.f
	end

	return this

end

Map = {}

function Map.new()

  local this = {}

  local map = {}
  local size = 0

  function this.size()
    return size
  end

  function this.exists(location)
    return map[location.toString()] ~= nil
  end

  function this.get(location)
    return map[location.toString()]
  end

  function this.fill(location)
  	size = this.exists(location) and size or (size + 1)
    map[location.toString()] = 1
  end

  function this.free(location)
  	size = this.exists(location) and size or (size - 1)
    map[location.toString()] = nil
  end

  function this.clear()
    map = {}
    size = 0
  end

  return this

end

function empty(lua_table)
	if next(lua_table) == nil then
		return true
	end

	return false
end

function heuristic_cost_estimate(start, goal)
	return start.distance(goal)
end

function reconstruct_path(came_from, current)
	local path = {}

	if came_from[current.toString()] ~= nil then
		local next = came_from[current.toString()]
		path = reconstruct_path(came_from, next)
		table.insert(path, current)
	end

	return path
end

function a_star(start, goal, world)
	local path = {}
	local open_set = {}
	local closed_set = {}
	local g_scores = {}
	local f_scores = BinaryHeap.new()
	local came_from = {}
	local start_idx = start.toString()
	
	open_set[start_idx] = start
	g_scores[start_idx] = 0
	f_scores.insert(start_idx, heuristic_cost_estimate(start, goal)) 

	while not empty(open_set) do
		local current_idx = f_scores.min()
		local current = open_set[current_idx]
		
		open_set[current_idx] = nil
		closed_set[current_idx] = current
		
		if current.equals(goal) then
			path = reconstruct_path(came_from, current)
			break
		end

		for f = 0, 5 do
			local neighbor = current.copy().step(f)
			local neighbor_idx = neighbor.toString()
			local neighbor_state = world.get(neighbor)
			local tentative_g_score = g_scores[current_idx] + 1

			if open_set[neighbor_idx] ~= nil and tentative_g_score < g_scores[neighbor_idx] then
				g_scores[neighbor_idx] = tentative_g_score
				f_scores.update(neighbor_idx, g_scores[neighbor_idx] + heuristic_cost_estimate(neighbor, goal))
				came_from[neighbor_idx] = current
			elseif (neighbor_state or 0) == 0 and closed_set[neighbor_idx] == nil and open_set[neighbor_idx] == nil then
				open_set[neighbor_idx] = neighbor
				g_scores[neighbor_idx] = tentative_g_score
				f_scores.insert(neighbor_idx, g_scores[neighbor_idx] + heuristic_cost_estimate(neighbor, goal))
				came_from[neighbor_idx] = current
			end
		end
	end

	return path
end

function test_astar()
	local world = Map.new()
	local p1 = Position.new(1, 0, 0)
	local p2 = Position.new(0, -1, 0)
	local p3 = Position.new(0, 1, 0)
	local p4 = Position.new(-1, 0, 0)
	local p5 = Position.new(0, 0, -1)
	world.fill(p1)
	world.fill(p2)
	world.fill(p3)
	world.fill(p4)
	world.fill(p5)
	local start = Position.new(0, 0, 0)
	local goal = Position.new(2, 0, 0)
	local path = a_star(start, goal, world)
	
	for _, step in ipairs(path) do
		print(step.toString())
	end
end

test_astar()