local ASSET_PATH = '/home/we/dust/code/esper/assets/ui/'
local GRID_X, GRID_Y, GRID_C, GRID_R = 32, 8, 14, 11

local Interface = {}

function Interface._draw_grid(pulse)
  screen.display_png(ASSET_PATH..'screen_bg.png', 0, 0)
  screen.level(pulse and 12 or 4)

  local x, y = GRID_X, GRID_Y
  for i = 1, GRID_R do
    screen.move(x, y)
    screen.line(x + 65, y)
    y = y + 5
  end

  local x, y = GRID_X, GRID_Y
  for i = 1, GRID_C do
    screen.move(x, y)
    screen.line(x, y + 50)
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