local ASSET_PATH = '/home/we/dust/code/esper/assets/ui/'
local GRID_EDGE, GRID_X, GRID_Y, GRID_C, GRID_R = 6, 5, 13, 8, 8

local Interface = {}

function Interface._draw_grid(pulse)
  screen.display_png(ASSET_PATH..'screen_bg.png', 0, 0)
  screen.level(pulse and 5 or 1)

  -- 'Pixel' square is 7,7

  local x, y = GRID_X, GRID_Y
  local grid_h, grid_w = GRID_R * GRID_EDGE, GRID_C * GRID_EDGE
  for i = 1, GRID_R + 1 do
    screen.move(x, y)
    screen.line(grid_w + x, y)
    y = y + GRID_EDGE
  end

  local x, y = GRID_X, GRID_Y
  for i = 1, GRID_C + 1 do
    screen.move(x, y)
    screen.line(x, grid_h + y)
    x = x + GRID_EDGE
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