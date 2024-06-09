local GRID_W, GRID_H = 8, 8
local REGION = 'region'

local State = {
  active = {1, 1},
  position = 1,
  power = 1,
  pulse = false,
  pulse_frame = 1,
  region = {1, 1},
  reverse = false,
  shift = false,
  track = false
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

function State:advance_pointer(key)
  local reverse = self.reverse
  if self[key][1] == (reverse and 1 or GRID_W) then
    if self[key][2] == (reverse and 1 or GRID_H) then
      if key ~= REGION and self.power == 2 and self.track then
        self:advance_pointer(REGION)
      end
      self[key] = reverse and {GRID_W, GRID_H} or {1, 1}
    else
      self[key] = {reverse and GRID_W or 1, self[key][2] + (reverse and -1 or 1)}
    end
  else
    self[key][1] = self[key][1] + (reverse and -1 or 1)
  end
end

return State