require "theap"
require "tposition"
require "tmap"
require "tpath"

local world = Map.new()
world.fill(Position.new(1, 0, 0))
world.fill(Position.new(0, -1, 0))
world.fill(Position.new(0, 1, 0))
world.fill(Position.new(-1, 0, 0))
world.fill(Position.new(0, 0, -1))
world.fill(Position.new(4, 0, 1))
local start = Position.new(0, 0, 0)
local goal = Position.new(16, 256, 16)
local start_time = os.clock()
local path = a_star(start, goal, world)
local end_time = os.clock()
	
for _, step in ipairs(path) do
	print(step.toString())
end

print("\n" .. end_time - start_time)