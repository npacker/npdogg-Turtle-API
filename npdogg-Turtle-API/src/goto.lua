require 'src.tnode'
require 'src.tmap'
require 'src.theap'
require 'src.tpath'
-- os.loadAPI("turtlei")

local input, x, y ,z, start, goal, world, path
local coords = {}

repeat
	print("Enter the target coordiates in the form x y z:")
	input = io.read()
until string.match(input, '^%d* %d* %d*$') ~= nil

for w in string.gmatch(input, '%d*') do
	w = tonumber(w)

	if w ~= nil then
		table.insert(coords, w)
	end
end

world = Map.new()
start = Node.new()
goal = Node.new(coords[1], coords[2], coords[3])
path = a_star(start, goal, world)
print("start: " .. start.toString())
print("goal: " .. goal.toString())

for _, node in ipairs(path) do
	print(node.toString())
end