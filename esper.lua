-- Esper
-- Image Sonifier
-- Add 64x64 images to
-- dust/data/esper/
--
-- Load image from
-- Esper params
--
-- K1 Action:
--  Zoom in/out. Menu select
-- K2 Toggle Context Menu
-- Enc2 Navigate X or Menu
-- Enc3 Navigate Y or Menu

local Artifact = include('lib/artifact')
local Colorizer = include('lib/colorizer')
local CONST = include('lib/constants')
local Interface = include('lib/interface')
local Mouse = include('lib/mouse')
local Parameters = include('lib/parameters')
local State = include('lib/state')

local artifact, beat_clock, colorizer, interface, met, mouse, parameters, state
local util = require('util')

local function _get_beat_duration()
  return (60 / params:get('clock_tempo')) / params:get('subdivisions')
end

local function _init_artifact()
  artifact = Artifact:new()
  artifact:init()
end

local function _init_clocks()
  local beat_duration = _get_beat_duration()
  beat_clock = metro.init(function() on_step() end, beat_duration)
  beat_clock:start()
end

local function _init_colorizer()
  colorizer = Colorizer:new()
  colorizer:init()
end

local function _init_interface()
  interface = Interface:new()
  interface:init()
end

local function _init_mouse()
  mouse = Mouse:new()
  mouse:init(interface, state)
end

local function _init_params()
  parameters = Parameters:new()
  parameters:init(state)
end

local function _init_state()
  state = State:new()
  state:init()
end

local function _refresh_params()
  if state:get(CONST.DIRTY_ARTIFACT) then
    artifact:project(parameters)
    state:set(CONST.DIRTY_ARTIFACT, false)
  end

  if state:get(CONST.DIRTY_CLOCK) then
    beat_clock.time = _get_beat_duration()
    state:set(CONST.DIRTY_CLOCK, false)
  end

  if state:get(CONST.DIRTY_SCALE) then
    state:set_scale()
    state:set(CONST.DIRTY_SCALE, false)
  end
end

function on_step()
  _refresh_params()

  if state:get('playing') then
    state:advance_beat()
    state:advance_pointer(CONST.CURRENT)

    local note = state:grok_current_note(artifact)
    
    colorizer:radiate(note)
    interface:set('note', note)
  end
end

function init()
  _init_state()
  _init_artifact()
  _init_colorizer()
  _init_interface()
  _init_mouse()
  _init_params()
  _init_clocks()
end

function redraw()
  screen.clear()
  interface:draw(artifact, state)
  screen.update()
end

function enc(e, d)
  local menu = state:get(CONST.MENU)
  local shift = state:get(CONST.SHIFT)
  local position = state:get(CONST.REGION)
  local pos_x, pos_y = position[1], position[2]

  if menu then
    state:traverse_menu(d)
  elseif e == 2 then
    state:adjust_selection(CONST.X, d)
    if state:get(CONST.POWER) == 2 then
      pos_x = util.clamp(pos_x + d, 1, 8)
    end
  elseif e == 3 then
    state:adjust_selection(CONST.Y, d)
    if state:get(CONST.POWER) == 2 then
      pos_y = util.clamp(pos_y + d, 1, 8)
    end
  end
  state:set(CONST.REGION, {pos_x, pos_y})
end

function key(k, z)
  local shift = state:get(CONST.SHIFT)
  local menu = state:get(CONST.MENU)
  if z == 0 then
    if k == 2 then
      interface:toggle_menu(state)
    elseif k == 3 then
      if menu then
        interface:select_menu_item(state)
      else
        interface:toggle_depth(state)
      end
    end
  end
end

function refresh()
  redraw()
end