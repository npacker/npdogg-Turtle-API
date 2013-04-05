--- 
-- A* heuristic estimate of the cost to travel between two nodes.
-- Calculates the Manhattan distance between the start and goal.
--
-- @param start The node from which the distance will be calculated. Expects a
-- Node object.
-- @param goal The destination of simulated travel from start. Expects a Node
-- object.
--
-- @return Integer value of the Manhattan distance between start and goal.

local function heuristic_cost_estimate(start, goal)
	return start.distance(goal)
end

---
-- A* path reconstruction.
-- Given a hash map of nodes where the keys are the children of the node stored
-- at each index, the nodes in the final path will be returned in an array.
--
-- @param came_from The list of nodes. Expects a list of Node objects.
-- @param current_node The current node in the path iteration. Expects a
-- Node object.
--
-- @return A list of the nodes in the reconstructed path.

local function reconstruct_path(came_from, current)
	local path = {}
	local current_idx = current.toString()
	local next = came_from[current_idx]

	if next ~= nil then
		path = reconstruct_path(came_from, next)
		table.insert(path, current)
	end

	return path
end

---
-- Implements the A* path-finding algorithm.
-- Given a starting point and a goal, it will determine the shortest path
-- between the two points.
--
-- @param start The starting node. Expects a Node object.
-- @param goal The goal node. Expects a Node object.
-- @param world The map object containing the known geography of the world
--
-- @return The output of reconstruct_path on success or an empty set on failure.

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

	while next(open_set) do
		local current_idx = f_scores.pop()
		local current = open_set[current_idx]
		
		open_set[current_idx] = nil
		closed_set[current_idx] = current
		
		if world.get(goal) == 1 or current.equals(goal) then
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
			elseif neighbor_state == nil and closed_set[neighbor_idx] == nil and open_set[neighbor_idx] == nil then
				open_set[neighbor_idx] = neighbor
				g_scores[neighbor_idx] = tentative_g_score
				f_scores.insert(neighbor_idx, g_scores[neighbor_idx] + heuristic_cost_estimate(neighbor, goal))
				came_from[neighbor_idx] = current
			end
		end
	end

	return path
end
