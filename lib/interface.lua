local GRID_X, GRID_Y, GRID_C, GRID_R = 28, 2, 17, 13

local Interface = {}

function Interface._draw_grid(pulse)
  screen.level(pulse and 12 or 4)

  local x, y = GRID_X, GRID_Y
  for i = 1, GRID_R do
    screen.move(x, y)
    screen.line(x + 80, y)
    y = y + 5
  end

  local x, y = GRID_X, GRID_Y
  for i = 1, GRID_C do
    screen.move(x, y)
    screen.line(x, y + 60)
    x = x + 5
  end
end

function Interface:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Interface:init()
end

function Interface:draw()
  self._draw_grid()
end

function Interface:enhance(x, y)
end

function Interface:go(direction)
end

function Interface:pull_back()
end

function Interface:stop()
end

function Interface:track(angle, direction)
end

function Interface:wait(s)
end

return Interface