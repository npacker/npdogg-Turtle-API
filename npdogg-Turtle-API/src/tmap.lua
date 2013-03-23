Map = {}

function Map.new()

  local this = {}

  local map = {}
  local size = 0

  function this.size()
    return size
  end

  function this.exists(location)
    return map[location.toString()] ~= nil
  end

  function this.get(location)
    return map[location.toString()]
  end

  function this.fill(location)
  	size = this.exists(location) and size or (size + 1)
    map[location.toString()] = 1
  end

  function this.free(location)
  	size = this.exists(location) and size or (size - 1)
    map[location.toString()] = nil
  end

  function this.clear()
    map = {}
    size = 0
  end

  return this

end