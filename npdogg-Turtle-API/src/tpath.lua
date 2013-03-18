--- Determines if a Lua table is empty.
-- The table cannot contain null values
--
-- @param lua_table The table to be checked
--
-- @return True if the table is empty, false otherwise

function empty(lua_table)
	if next(lua_table) == nil then
		return true
	end

	return false
end

--- A* heuristic estimate of the cost to travel between two nodes.
-- Calculates the Manhattan distance between the start and goal.
--
-- @param start The node from which the distance will be calculated
-- @param goal The destination of simulated travel from start
--
-- @return Integer value of the Manhattan distance between start and goal

function heuristic_cost_estimate(start, goal)
	return start.distance(goal)
end

--- A* path reconstruction.
-- Given a list of nodes and the current node, it will build a path
--
-- @param came_from The list of nodes. Expects a list of Position objects.
-- @param current_node The current node in the path iteration. Expects a
-- Position object.
--
-- @return A list of the nodes in the reconstructed path

function reconstruct_path(came_from, current)
	local path = {}

	if came_from[current.toString()] ~= nil then
		path = reconstruct_path(came_from, came_from[current.toString()])
		table.insert(path, current) 
	end

	return path
end

--- Implements the A* path-finding algorithm.
-- Given a starting point and a goal, it will determine the shortest path
-- between the two points.
--
-- @param start The starting node. Expects a Position object.
-- @param goal The goal node. Expects a Position object.
-- @param world The map object containing the known geography of the world
-- @param discover Whether unknown geography should be explored
--
-- @return The output of reconstruct_path on success or an empty set on failure

function a_star(start, goal, world, discover)
	local start_idx = start.toString()
	local open_set = {}
	local closed_set = {}
	local came_from = {}
	local g_score = {}
	local f_score = {}
	discover = discover or 0

	open_set[start_idx] = start
	g_score[start_idx] = 0
	f_score[start_idx] = heuristic_cost_estimate(start, goal)

	while not empty(open_set) do
		local current
		local current_idx = current.toString()
		local current_f_score = 600000000

		for node_idx, node in pairs(open_set) do
			if node ~= nil and f_score[node_idx] <= current_f_score then
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
			local neighbor_state = world.get(neighbor)

			if (neighbor_state or 0) == 0 and closed_set[neighbor_idx] == nil then
				local tentative_g_score = g_score[current_idx] + ((neighbor_state == nil) and discover or 1)

				if open_set[neighbor_idx] == nil or tentative_g_score <= g_score[current_idx] then
					came_from[neighbor_idx] = current.setF(f)
					g_score[neighbor_idx] = tentative_g_score
					f_score[neighbor_idx] = g_score[neighbor_idx] + heuristic_cost_estimate(neighbor, goal)

					if open_set[neighbor_idx] == nil then
						open_set[neighbor_idx] = neighbor
					end
				end
			end
		end
	end

	return {}
end
