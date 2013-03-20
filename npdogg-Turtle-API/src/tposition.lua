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

	this.x = x or 0
	this.y = y or 0
	this.z = z or 0
	this.f = f or 0

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

	function this.setX(x)
		this.x = x

		return this
	end

	function this.setY(y)
		this.y = y

		return this
	end

	function this.setZ(z)
		this.z = z

		return this
	end

	function this.setF(f)
		this.f = f

		return this
	end

	function this.set(x, y, z, f)
		this.x, this.y, this.z, this.f = x, y, z, f

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