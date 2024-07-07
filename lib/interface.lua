local CONST = include('lib/constants')
local GRID_EDGE, GRID_X, GRID_Y = 6, 5, 13
local musicutil = require('musicutil')

local Interface = {
  cells_dirty = true,
  note = nil
}

function Interface._draw_grid(state)
  if not state:get(CONST.MENU) then
    screen.display_png(CONST.ASSET_PATH_UI..CONST.BG..CONST.EXT, 0, 0)
  end

  screen.level(state:get('pulse') and 5 or 1)

  local x, y = GRID_X, GRID_Y
  local grid_h, grid_w = CONST.ROWS * GRID_EDGE, CONST.COLUMNS * GRID_EDGE
  for i = 1, CONST.ROWS + 1 do
    screen.move(x, y)
    screen.line(grid_w + x, y)
    y = y + GRID_EDGE
    screen.stroke()
  end

  x, y = GRID_X, GRID_Y
  for i = 1, CONST.COLUMNS + 1 do
    screen.move(x, y)
    screen.line(x, grid_h + y)
    x = x + GRID_EDGE
    screen.stroke()
  end

  local current = state:get(CONST.CURRENT)
  x, y = ((current[1] - 1) * GRID_EDGE) + GRID_X, ((current[2] - 1) * GRID_EDGE) + GRID_Y
  screen.level(7)
  screen.rect(x, y, GRID_EDGE, GRID_EDGE)
  screen.stroke()

  local selected = state:get(CONST.SELECTED)
  x, y = ((selected[1] - 1) * GRID_EDGE) + GRID_X, ((selected[2] - 1) * GRID_EDGE) + GRID_Y
  screen.level(state:get(CONST.MENU) and 1 or 14)
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


function Interface:set(k, v)
  self[k] = v
end

function Interface:draw(artifact, state)
  if artifact.simplification then
    self:_draw_detail()
    self:_draw_beat(state)
    self:_draw_cells(artifact, state)
    self._draw_grid(state)
    self:_draw_menu(state)
    self:_draw_power(state)
  end
end

function Interface:select_menu_item(state)
  local menu_items = {
    {'playing', true},
    {'playing', false},
    {'reverse', false},
    {'reverse', true},
  }
  local item = state:get('active_menu_item')

  if item < 5 then
    local action = menu_items[item]
    state:set(action[1], action[2])
  else
    self:toggle_tracking(state)
  end

  self:toggle_menu(state)
end

function Interface:toggle_depth(state)
  if state:get(CONST.POWER) == 1 then
    self:_enhance(state)
  else
    self:_pull_back(state)
  end
end

function Interface:toggle_menu(state)
  state:set(CONST.MENU, not state:get(CONST.MENU))
  state:set('active_menu_item', 1)
end

function Interface:toggle_tracking(state)
  state:set(CONST.TRACKING, not state:get(CONST.TRACKING))
end

function Interface:_draw_beat(state)
  screen.display_png(CONST.ASSET_PATH_UI..CONST.GLYPH_PATH..CONST.BEAT..state:get('beat')..CONST.EXT, 123, 0)
end

function Interface:_draw_cells(artifact, state)
  if self.cells_dirty then -- TODO unused
    local menu = state:get(CONST.MENU)
    local pixels

    if state:get(CONST.POWER) == 1 then
      pixels = artifact:get_simplification()
    else
      local region = state:get(CONST.REGION)
      pixels = artifact:get_representation_at(region[1], region[2])
    end

    for i = 1, CONST.ROWS do
      for j = 1, CONST.COLUMNS do
        local level = menu and math.floor(pixels[i][j] / 4) or pixels[i][j]
        screen.level(level)
        screen.rect((GRID_EDGE * (i - 1)) + GRID_X, (GRID_EDGE * (j - 1)) + GRID_Y, 5, 5)
        screen.fill()          
      end
    end
  end
end

function Interface:_draw_detail()
  if self.note then
    screen.font_face(3)
    screen.font_size(35)
    screen.move(126, 35)
    screen.text_right(musicutil.note_num_to_name(self.note, true))
  end
end

function Interface:_draw_menu(state)
  if state:get(CONST.MENU) then
    local anchor = state:get('selected')
    local active = state:get('active_menu_item')
    local playing = state:get('playing')
    local reverse = state:get('reverse')
    local track = state:get(CONST.TRACKING)
    local menu_items = {'PLAY', 'STOP', 'FORWARD', 'REVERSE', 'TRACK'}
    local menu_item_paths = {
      CONST[menu_items[1]]..(playing and CONST.ACTIVE or CONST.INACTIVE),
      CONST[menu_items[2]]..(playing and CONST.INACTIVE or CONST.ACTIVE),
      CONST[menu_items[3]]..(reverse and CONST.INACTIVE or CONST.ACTIVE),
      CONST[menu_items[4]]..(reverse and CONST.ACTIVE or CONST.INACTIVE),
      CONST[menu_items[5]]..(track and CONST.ACTIVE or CONST.INACTIVE)
    }
    local x = (GRID_EDGE * (anchor[1] - 1)) + GRID_X
    local y = (GRID_EDGE * (anchor[2] - 1)) + GRID_Y

    for i = 1, #menu_item_paths do
      local ix = i * 5 + x
      screen.level(7)
      screen.rect(ix + i - 1, y - 1, 7, 7)
      screen.fill()
      screen.display_png(CONST.ASSET_PATH_UI..CONST.GLYPH_PATH..menu_item_paths[i]..CONST.EXT, ix + i, y)
    end

    screen.level(14)
    screen.rect(active * 5 + x + active, y, 6, 6)
    screen.stroke()

    screen.level(14)
    screen.move(120, 5)
    screen.font_face(1)
    screen.font_size(8)
    screen.text_right(menu_items[active])
  end
end

function Interface:_draw_power(state)
  if not state:get(CONST.MENU) then
    local power = state:get(CONST.POWER) == 1 and CONST.MINUS or CONST.PLUS
    screen.display_png(CONST.ASSET_PATH_UI..CONST.GLYPH_PATH..power..CONST.EXT, 57, 53)
  end
end

function Interface:_enhance(state)
  -- TODO transition on bar with animtion on beats prior (zoom effect)
  local selected = state:get(CONST.SELECTED)
  state:set(CONST.POWER, 2)
  state:set(CONST.REGION, {selected[1], selected[2]})
end

function Interface:_pull_back(state)
  -- TODO transition on bar with animtion on beats prior (zoom effect)
  state:set(CONST.POWER, 1)
end

return Interface