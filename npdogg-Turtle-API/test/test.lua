require "theap"
require "tvector"
require "tmap"
require "tpath"

local world = Map.new()
world.fill(Vector.new(1, 0, 0))
local start = Vector.new(0, 0, 0)
local goal = Vector.new(64, 64, 64)
local start_time = os.clock()
local path = a_star(start, goal, world)
local end_time = os.clock()
	
for _, waypoint in ipairs(path) do
	print(waypoint.toString())
end

print("\n" .. end_time - start_time)