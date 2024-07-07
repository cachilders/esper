local CONST = include('lib/constants')
local musicutil = require('musicutil')
local util = require('util')

local State = {
  active_menu_item = 1,
  beat = 1,
  current = nil,
  dirty_artifact = false,
  dirty_clock = false,
  dirty_scale = false,
  menu = false,
  playing = false,
  position = 1,
  power = 1,
  pulse = false,
  pulse_frame = 1,
  region = nil,
  reverse = false,
  selected = nil,
  scale = nil,
  shift = false,
  tracking = false
}

function State:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function State:init()
  self.region = {1, 1}
  self.selected = {1, 1}
  self:reset_step()
end

function State:get(k)
  return self[k]
end

function State:set(k, v)
  self[k] = v
end

function State:advance_beat()
  self.beat = util.wrap(self.beat + 1, 1, 4)
end

function State:advance_pointer(key)
  local reverse = self.reverse
  if self[key][1] == (reverse and 1 or CONST.COLUMNS) then
    if self[key][2] == (reverse and 1 or CONST.ROWS) then
      if key ~= CONST.REGION and self.power == 2 and self.tracking then
        self:advance_pointer(CONST.REGION)
        self.selected = self.region
      end
      self[key] = reverse and {CONST.COLUMNS, CONST.ROWS} or {1, 1}
    else
      self[key] = {reverse and CONST.COLUMNS or 1, self[key][2] + (reverse and -1 or 1)}
    end
  else
    self[key][1] = self[key][1] + (reverse and -1 or 1)
  end
end

function State:adjust_selection(axis, delta)
  local adjusted = axis == CONST.X and 1 or 2
  local max = axis == CONST.X and CONST.COLUMNS or CONST.ROWS
  self.selected[adjusted] = util.clamp(self.selected[adjusted] + delta, 1 , max)
end

function State:grok_current_note(artifact)
  local tiles
  local current = self.current

  if self.power == 1 then
    tiles = artifact:get_simplification()
  else
    local region = self.region
    tiles = artifact:get_representation_at(region[1], region[2])
  end

  return self.scale[tiles[current[1]][current[2]]]
end

function State:reset_step()
  self.current = {0, 1}
  self.beat = 1
end

function State:set_scale()
  self.scale = musicutil.generate_scale_of_length(params:get('root_note'), params:get('scale'), 16)
end

function State:traverse_menu(delta)
  self.active_menu_item = util.clamp(self.active_menu_item + delta, 1 , CONST.MENU_ITEM_COUNT)
end

return State