---
-- Node.
-- 
-- @module Node
Node = {}

---
-- Node.
-- 
-- @type Node

---
-- Constructor.
-- 
-- @function [parent=#Node] new
-- @return #Node
function Node.new(x, y, z, f)

	local this = {}
	
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
	
	x = x or 0
	y = y or 0
	z = z or 0
	f = f or 0

	function this.step(direction)
		local delta = deltas[direction]

		x, y, z = x + delta["x"], y + delta["y"], z + delta["z"]

		return this
	end

	function this.back()
		local delta = deltas[f]

		x, y, z = x - delta["x"], y - delta["y"], z - delta["z"]

		return this
	end

	function this.forward()
		this.step(f)

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
		f = (f + 3) % 4

		return this
	end

	function this.turnRight()
		f = (f + 1) % 4

		return this
	end

	function this.distance(node)
		return math.abs(node.getX() - x) + math.abs(node.getY() - y) + math.abs(node.getZ() - z)
	end
	
	function this.equals(node)
		if x ~= node.getX() or y ~= node.getY() or z ~= node.getZ() then
			return false
		end

		return true
	end

	function this.copy()
		return Node.new(x, y, z, f)
	end

	function this.toString()
		return string.format("%d,%d,%d", x, y, z)
	end

	function this.getX()
		return x
	end

	function this.getY()
		return y
	end

	function this.getZ()
		return z
	end

	function this.getF()
		return f
	end

	function this.getAll()
		return x, y, z, f
	end

	return this

end