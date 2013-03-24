Map = {}

function Map.new()

  local this = {}

  local map = {}
  local size = 0

  local function exists(location)
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
  	size = exists(location) and size or (size - 1)
    map[location.toString()] = nil
  end

  return this

end