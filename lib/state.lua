local State = {
  active = {1, 1},
  position = 1,
  power = 1,
  pulse = false,
  pulse_frame = 1,
  region = {1, 1},
  shift = false
}

function State:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function State:init()
  -- dunno
end

function State:get(k)
  return self[k]
end

function State:set(k, v)
  self[k] = v
end

return State