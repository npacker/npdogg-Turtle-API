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

	function this.distance(position)
		return math.abs(position.getX() - x) + math.abs(position.getY() - y) + math.abs(position.getZ() - z)
	end
	
	function this.equals(position)
		if x ~= position.getX() or y ~= position.getY() or z ~= position.getZ() then
			return false
		end

		return true
	end

	function this.copy()
		return Position.new(x, y, z, f)
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