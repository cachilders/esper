local ASSET_PATH = '/home/we/dust/code/esper/assets/ui/'
local GRID_EDGE, GRID_X, GRID_Y, GRID_C, GRID_R = 6, 5, 13, 8, 8

local Interface = {
  cells_dirty = true
}

function Interface._draw_grid(state)
  screen.display_png(ASSET_PATH..'screen_bg.png', 0, 0)
  screen.level(state:get('pulse') and 5 or 1)

  local x, y = GRID_X, GRID_Y
  local grid_h, grid_w = GRID_R * GRID_EDGE, GRID_C * GRID_EDGE
  for i = 1, GRID_R + 1 do
    screen.move(x, y)
    screen.line(grid_w + x, y)
    y = y + GRID_EDGE
    screen.stroke()
  end

  x, y = GRID_X, GRID_Y
  for i = 1, GRID_C + 1 do
    screen.move(x, y)
    screen.line(x, grid_h + y)
    x = x + GRID_EDGE
    screen.stroke()
  end

  local hl = state:get('active')
  x, y = ((hl[1] - 1) * GRID_EDGE) + GRID_X, ((hl[2] - 1) * GRID_EDGE) + GRID_Y
  screen.level(15)
  screen.rect(x, y, GRID_EDGE, GRID_EDGE)
  screen.stroke()
end

function Interface:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Interface:init()
end

function Interface:draw(artifact, state)
  self:_draw_cells(artifact, state)
  self._draw_grid(state)
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

function Interface:_draw_cells(artifact, state)
  if self.cells_dirty then
    local pixels

    if state:get('power') == 1 then
      pixels = artifact:get('simplification')
    else
      local region = state:get('region')
      pixels = artifact:get_representation_at(region[1], region[2])
    end

    for i = 1, GRID_R do
      for j = 1, GRID_C do
        screen.level(pixels[i][j])
        screen.rect((GRID_EDGE * (i - 1)) + GRID_X, (GRID_EDGE * (j - 1)) + GRID_Y, 5, 5)
        screen.fill()
      end
    end
  end
end

return Interface