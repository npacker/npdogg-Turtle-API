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

function Position.new(_x, _y, _z, _f)

	local this = {}

	this.x = _x or 0
	this.y = _y or 0
	this.z = _z or 0
	this.f = _f or 0

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

	function this.setX(_x)
		this.x = _x

		return this
	end

	function this.setY(_y)
		this.y = _y

		return this
	end

	function this.setZ(_z)
		this.z = _z

		return this
	end

	function this.setF(_f)
		this.f = _f

		return this
	end

	function this.set(_x, _y, _z, _f)
		this.x, this.y, this.z, this.f = _x, _y, _z, _f

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

function a_star(start, goal)
	local open_set = {}
	local closed_set = {}
	local g_score = {}
	local f_score = {}
	local came_from = {}
	local start_idx = start.toString()
	
	open_set[start_idx] = start
	g_score[start_idx] = 0
	f_score[start_idx] = heuristic_cost_estimate(start, goal)

	while not empty(open_set) do
		local current
		local current_idx
		local current_f_score = 60000000

		for node_idx, node in pairs(open_set) do
			if f_score[node_idx] <= current_f_score then
				current = node.copy()
				current_idx = current.toString()
				current_f_score = f_score[node_idx]
			end
		end
		
		if current.equals(goal) then
			return reconstruct_path(came_from, goal)
		end

		open_set[current_idx] = nil
		closed_set[current_idx] = current

		for f = 0, 5 do
			local neighbor = current.copy().step(f)
			local neighbor_idx = neighbor.toString()
			local tentative_g_score = g_score[current_idx] + 1

			if open_set[neighbor_idx] ~= nil and tentative_g_score < g_score[neighbor_idx] then
				g_score[neighbor_idx] = tentative_g_score
				came_from[neighbor_idx] = current
			elseif closed_set[neighbor_idx] == nil and open_set[neighbor_idx] == nil then
				open_set[neighbor_idx] = neighbor
				g_score[neighbor_idx] = tentative_g_score
				f_score[neighbor_idx] = g_score[neighbor_idx] + heuristic_cost_estimate(neighbor, goal)
				came_from[neighbor_idx] = current
			end
		end
	end

	return {}
end

function test_astar()
	local start = Position.new(0, 0, 0)
	local goal = Position.new(10, 10, 10)
	local path = a_star(start, goal)
	
	for _, step in ipairs(path) do
		print(step.toString())
	end
end

test_astar()