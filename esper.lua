local Artifact = include('lib/artifact')
local Colorizer = include('lib/colorizer')
local Interface = include('lib/interface')
local Mouse = include('lib/mouse')
local Parameters = include('lib/parameters')
local State = include('lib/state')

local artifact, beat_clock_fwd, beat_clock_rev, colorizer, interface, met, mouse, parameters, state
local util = require('util')

engine.name = 'Asterion'

local function _get_beat_duration()
  return 60 / params:get('clock_tempo')
end

local function _init_artifact()
  artifact = Artifact:new()
  artifact:init('test.png')
end

local function _init_clocks()
  local beat_duration = _get_beat_duration()
  beat_clock_fwd = metro.init(function() state:advance_pointer('active'); colorizer:radiate(state, artifact) end, beat_duration)
  beat_clock_fwd:start()
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
  mouse:init()
end

local function _init_params()
  parameters = Parameters:new()
  parameters:init(state, artifact, colorizer)
end

local function _init_state()
  state = State:new()
  state:init()
end

local function _refresh_params()
  if state:get('dirty_clock') then
    beat_clock_fwd.time = _get_beat_duration()
    state:set('dirty_clock', false)
  end
end

function init()
  _init_artifact()
  _init_interface()
  _init_mouse()
  _init_state()
  _init_params()
  _init_colorizer()
  _init_clocks()
end

function redraw()
  _refresh_params()
  screen.clear()
  interface:draw(artifact, state)
  screen.update()
end

function enc(e, d)
  local shift = state:get('shift')
  local position = state:get('region')
  local pos_x, pos_y = position[1], position[2]
  if e == 2 then
    pos_x = util.clamp(pos_x + d, 1, 8)
  elseif e == 3 then
    pos_y = util.clamp(pos_y + d, 1, 8)
  end
  state:set('region', {pos_x, pos_y})
end

function key(k, z)
  local shift = state:get('shift')
  if z == 0 then
    if k == 2 then
      state:set('power', 1)
    elseif k == 3 then
      state:set('power', 2)
    end
  end
end

function refresh()
  redraw()
end