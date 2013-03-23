TurtleBase = {}

function TurtleBase.new()

	local this = {}

	this.position = tposition.Position.new()
	this.world = tmap.Map.new()
	this.items = 0

	---
	-- Writes a message to the turtle log file.
	-- Opens a file handle and appends the given message with a time stamp, then
	-- closes the handle.
	--
	-- @param message The message to be appended to the log file
	--
	-- @return void

	function this.log(message)
		local file_name = string.format("%s_log", os.getComputerLabel())
		local log_file = fs.open(file_name, "a")
		local log_message = string.format("%s %s", os.time(), tostring(message))

		log_file.write(log_message)
		log_file.close()
	end

	---
	-- Sets the value for the current location of the Turtle.
	-- Given X, Y, Z and F, the position is updated with the given values.
	--
	-- @param _x The X coordinate
	-- @param _y The Y coordinate
	-- @param _z The Z coordinate
	-- @param _f The heading
	--
	-- @return position The updated position object

	function this.setLocation(_x, _y, _z, _f)
		this.position.set(_x, _y, _z, _f)

		return this.position
	end
	
	---
	-- Detects in all possible directions and records the results in the world
	-- map. Also records the currently occupied position as free in the world map.
	--
	-- @return void
	
	function this.discover()
		local f, u, d = this.position.copy().forward(), this.position.copy().up(), this.position.copy().down()

		this.world.free(this.position)

		if turtle.detect() then
			this.world.fill(f)
		else
			this.world.free(f)
		end

		if turtle.detectUp() then
			this.world.fill(u)
		else
			this.world.free(u)
		end

		if turtle.detectDown() then
			this.world.fill(d)
		else
			this.world.free(d)
		end
	end

	---
	-- Turns the turtle left.
	-- The position of the turtle is updated and discover is called.
	--
	-- @return boolean "success"
	
	function this.turnLeft()
		if turtle.turnLeft() then
			this.position.turnLeft()
			this.discover()
			this.log("Turned left")

			return true
		end

		return false
	end

	---
	-- Turns the turtle right.
	-- The position of the turtle is updated and discover is called.
	--
	-- @return boolean "success"
	
	function this.turnRight()
		if turtle.turnRight() then
			this.position.turnRight()
			this.discover()
			this.log("Turned right")

			return true
		end

		return false
	end

	---
	-- Turns the turtle by 90 degrees.
	-- The position of the turtle is updated and discover is called.
	--
	-- @return boolean "success"
	
	function this.turnAround()
		return this.turnRight() and this.turnRight()
	end

	---
	-- Turns the turtle to the given direction.
	-- The position of the turtle is updated and discover is called.
	--
	-- @return boolean "success"
	
	function this.turnTo(direction)
		if this.position.getF() == direction then
			return true
		elseif (this.position.getF() - direction + 4) % 4 == 1 then
			return this.turnLeft()
		elseif (direction - this.position.getF() + 4) % 4 == 1 then
			return this.turnRight()
		else
			return this.turnAround()
		end
	end

	---
	-- Determines if the turtle has sufficient fuel supplies remaining to travel
	-- the given distance.
	-- 
	-- @param distance The distance to be traveled.
	-- 
	-- @return boolean True if the fuel level is greater than or equal to the
	-- distance, false otherwise.

	function this.sufficientFuel(distance)
		return turtle.getFuelLevel() - distance >= 0
	end

	---
	-- Attempts to move the turtle forward 1 block.
	-- The position of the turtle is updated and discover is called. If the
	-- movement is unsuccessful, the obstruction is recorded on the world map.
	--
	-- @return boolean "success"
	
	function this.forward()
		if this.sufficientFuel(1) then
			if turtle.forward() then
				this.position.forward()
				this.discover()
				this.log("Moved forward to " .. this.position.toString())
	
				return true
			else
				local discovered = this.position.copy().forward()
	
				this.world.fill(discovered)
			end
		end
		
		return false
	end

	---
	-- Attempts to move the turtle backward 1 block.
	-- The position of the turtle is updated and discover is called. If the
	-- movement is unsuccessful, the obstruction is recorded on the world map.
	--
	-- @return boolean "success"

	function this.back()
		if this.sufficientFuel(1) then
			if turtle.back() then
				this.position.back()
				this.discover()
				this.log("Moved back to " .. this.position.toString())
	
				return true
			else
				local discovered = this.position.copy().back()
	
				this.world.fill(discovered)
			end
		end

		return false
	end

	---
	-- Attempts to move the turtle up 1 block.
	-- The position of the turtle is updated and discover is called. If the
	-- movement is unsuccessful, the obstruction is recorded on the world map.
	--
	-- @return boolean "success"

	function this.up()
		if this.sufficientFuel(1) then
			if turtle.up() then
				this.position.up()
				this.discover()
				this.log("Moved up to " .. this.position.toString())
	
				return true
			else
				local discovered = this.position.copy().up()
	
				this.world.fill(discovered)
			end
		end
		
		return false
	end

	---
	-- Attempts to move the turtle down 1 block.
	-- The position of the turtle is updated and discover is called. If the
	-- movement is unsuccessful, the obstruction is recorded on the world map.
	--
	-- @return boolean "success"

	function this.down()
		if this.sufficientFuel(1) then
			if turtle.down() then
				this.position.down()
				this.discover()
				this.log("Moved down to " .. this.position.toString())
	
				return true
			else
				local discovered = this.position.copy().down()
	
				this.world.fill(discovered)
			end
		end
		
		return false
	end

	---
	-- Moves the turtle from the current position to the given position.
	-- Follows a path generated by the A* path-finding algorithm. The turtle will
	-- not attempt to dig through obstacles.
	--
	-- @param goal The position to which the turtle will move
	-- @param discover Whether the turtle should attempt to move to unknown nodes.
	--
	-- @return boolean "success"

	function this.goTo(goal, discover)
		while this.position.getX() ~= goal.getX() or this.position.getY() ~= goal.getY() or this.position.getZ() ~= goal.getZ() do
			local path = tpath.a_star(this.position, goal, this.world, discover)

			if tpath.empty(path) then
				return false
			end

			for _, f in ipairs(path) do
				if f == tposition.Position.UP() then
					if not this.up() then
						break
					end
				elseif f == tposition.Position.DOWN() then
					if not this.down() then
						break
					end
				else
					this.turnTo(f)

					if not this.forward() then
						break
					end
				end
			end
		end

		return true
	end

	return this

end


Turtle = {}

function Turtle.extend(this)

	---
	-- Finds the total items currently in inventory.
	-- Given a range of slots over which to iterate, the item count of each slot
	-- is added together. By default the entire inventory is counted. An error is
	-- triggered if the arguments are not numbers or are not within the accepted
	-- range.
	--
	-- @param start_slot The slot at which to begin counting inventory
	-- @param end_slot The slot at which to stop counting inventory
	--
	-- @return number The total items in inventory

	function this.count(start_slot, end_slot)
		start_slot = start_slot or 1
		end_slot = end_slot or 16
		local count = 0

		for i = start_slot, end_slot do
			turtle.select(i)
			count = count + turtle.getItemCount(i)
		end

		return count
	end

	---
	-- Determines whether the Turtle has sucked up items.
	-- Calls count to determine the number of items in inventory, and compares it
	-- to items, the stored value of items in inventory.
	--
	-- @return boolean True if count is greater than the recorded value, false
	-- otherwise

	function this.sucked()
		local count = this.count()

		if count > this.items then
			this.items = count
			return true
		end

		return false
	end

	---
	-- Drops all items from the given range of inventory slots.
	-- All inventory slots are emptied by default.
	--
	-- @param start_slot The first slot from which to drop items
	-- @param end_slot The last slot from which to drop items
	--
	-- @return boolean "success"

	function this.drop(start_slot, end_slot)
		start_slot = start_slot or 1
		end_slot = end_slot or 16

		for slot = start_slot, end_slot do
			turtle.select(slot)

			if not turtle.drop() then
				return false
			end
		end

		return true
	end

	--- 
	-- Scans inventory for fuel items and attempts to refuel up to the given
	-- quantity.
	--
	-- @param quantity The amount of fuel items to consume
	--
	-- @return boolean "success"

	function this.refuel(amount)
		amount = amount or 64

		for slot = 1, 16 do
			turtle.select(slot)

			if turtle.refuel(amount) then
				return true
			end
		end

		return false
	end

	return this

end

function Turtle.new()
	return Turtle.extend(TurtleBase.new())
end


MiningTurtle = {}

function MiningTurtle.extend(this)

	--- 
	-- Attempts to dig the block in front of the Turtle.
	-- The number of attempts can be increased by the passed argument, such that
	-- if a block is detected after the digging operation complete, the Turtle
	-- will continue to dig until it made the given number of attempts.
	--
	-- @param max_tries The number of attempts the Turtle should make to dig a
	-- block.
	--
	-- @return boolean "success"

	function this.dig(max_tries)
		max_tries = max_tries or 1

		while max_tries > 0 do
			if turtle.dig() and not turtle.detect() then
				return true
			end

			max_tries = max_tries - 1
		end

		return false
	end

	--- 
	-- Attempts to dig the block above the Turtle.
	-- The number of attempts can be increased by the passed argument, such that
	-- if a block is detected after the digging operation complete, the Turtle
	-- will continue to dig until it made the given number of attempts.
	--
	-- @param max_tries The number of attempts the Turtle should make to dig a
	-- block.
	--
	-- @return boolean "success"

	function this.digUp(max_tries)
		max_tries = max_tries or 1

		while max_tries > 0 do
			if turtle.digUp() and not turtle.detectUp() then
				return true
			end

			max_tries = max_tries - 1
		end

		return false
	end

	--- 
	-- Attempts to dig the block below the Turtle.
	-- The number of attempts can be increased by the passed argument, such that
	-- if a block is detected after the digging operation complete, the Turtle
	-- will continue to dig until it made the given number of attempts.
	--
	-- @param max_tries The number of attempts the Turtle should make to dig a
	-- block.
	--
	-- @return boolean "success"

	function this.digDown(max_tries)
		max_tries = max_tries or 1

		while max_tries > 0 do
			if turtle.digDown() and not turtle.detectDown() then
				return true
			end

			max_tries = max_tries - 1
		end

		return false
	end

	--- 
	-- Attempts to place a block in front of the Turtle.
	-- If the space where the block will be placed is occupied, the Turtle will
	-- attempt to clear the space by digging.
	--
	-- @param slot The slot containing the item to be placed.
	--
	-- @return boolean "success"

	function this.place(slot)
		turtle.select(slot)

		if turtle.detect() then
			this.dig(8)
		end

		return turtle.place() and turtle.detect()
	end

	--- 
	-- Attempts to retrieve a block from directly in front of the Turtle and
	-- place it in the given slot. The operation will fail if the target slot is
	-- not empty.
	--
	-- @param target_slot The slot into which the retrieved item will be placed.
	--
	-- @return boolean "success"

	function this.retrieve(target_slot)
		target_slot = target_slot or 1
		turtle.select(target_slot)

		if turtle.getItemCount(target_slot) ~= 0 then
			return false
		elseif not turtle.dig() or turtle.getItemCount(target_slot) ~= 1 then
			return false
		end

		return true
	end

	--- 
	-- Attempts to deposit the contents of the given inventory slots into a
	-- storage container placed from inventory. The Turtle will attempt to find
	-- and empty space around it in which to place the storage container. The
	-- Turtle will log an error and go to sleep if the storage container cannot
	-- be retrieved.
	--
	-- @param container_slot The inventory slot holding the storage container
	-- @param start_slot The first inventory slot from which items should be
	-- deposited
	-- @param end_slot The last inventory slot from which items should be
	-- deposited
	--
	-- @return boolean "success"

	function this.deposit(container_slot, start_slot, end_slot)
		container_slot = container_slot or 1
		start_slot = start_slot or 1
		end_slot = end_slot or 16
		local cached_f = this.position.getF()
		local result

		for f = 0, 3 do
			this.turnTo(f)

			if this.place(container_slot) then
				result = this.drop(start_slot, end_slot)
				break
			end
		end

		if result and not this.retrieve() then
			this.log("The storage container could not be retrieved")
			os.sleep()
		end

		this.turnTo(cached_f)

		return result
	end

	return this

end

function MiningTurtle.new()
	return MiningTurtle.extend(Turtle.new())
end
