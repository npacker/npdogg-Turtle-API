---
-- A* module.
-- 
-- @module astar

---
-- Calls the distance method on a node, returning the distance between that
-- node and the node provided in the parameter.
--
-- @function [parent=#astar] heuristic_cost_estimate
-- @param start
-- @param goal
-- @return #number The Manhattan distance between two points.
local function heuristic_cost_estimate(start, goal)
	return start.distance(goal)
end

---
-- Constructs a complete path from the results of the A* function.
-- 
-- @function [parent=#astar] reconstruct_path
-- @param came_from
-- @param current
-- @return #table 
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
-- A* algorithm.
-- Finds the shortest path between two points, given a start node, end node and
-- a list of known obstacles in the world.
-- 
-- @function [parent=#astar] a_star
-- 
-- @param start 
-- @param goal
-- @param world
-- 
-- @return #table Complete list of nodes in the path on success, empty set on failure.
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
