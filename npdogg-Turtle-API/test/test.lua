require "theap"
require "tnode"
require "tmap"
require "tpath"

local world = Map.new()
local start = Node.new(0, 0, 0)
local goal = Node.new(1024, 1024, 1024)
local start_time
local end_time
local time = 0
for i = 0, 20 do
	start_time = os.clock()
	a_star(start, goal, world)
	end_time = os.clock()
	time = time + (end_time - start_time)
end
time = time / 20
print("\n" .. time)