local Artifact = include('lib/artifact')
local Colorizer = include('lib/colorizer')
local Interface = include('lib/interface')
local Mouse = include('lib/mouse')
local Parameters = include('lib/parameters')
local State = include('lib/state')

local artifact, beat_clock_fwd, beat_clock_rev, colorizer, interface, met, mouse, parameters, state
local util = require('util')

engine.name = 'Asterion'

local function _init_artifact()
  artifact = Artifact:new()
  artifact:init('test.png')
end

local function _init_clocks()
  local beat_duration = 60 / params:get('clock_tempo')
  beat_clock_fwd = metro.init(function() state:advance_pointer('current'); colorizer:radiate(state, artifact) end, beat_duration)
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
  mouse:init(interface, state)
end

local function _init_params()
  parameters = Parameters:new()
  parameters:init(state, artifact, colorizer)
end

local function _init_state()
  state = State:new()
  state:init()
end

function init()
  _init_artifact()
  _init_interface()
  _init_state()
  _init_mouse()
  _init_params()
  _init_colorizer()
  _init_clocks()
end

function redraw()
  screen.clear()
  interface:draw(artifact, state)
  screen.update()
end

function enc(e, d)
  local shift = state:get('shift')
  local position = state:get('region')
  local pos_x, pos_y = position[1], position[2]
  -- There's a more sophisticated product question about this to be sorted re above/below
  if e == 2 then
    if state:get('power') == 1 then
      state:adjust_selection('x', d)
    else
      pos_x = util.clamp(pos_x + d, 1, 8)
    end
  elseif e == 3 then
    if state:get('power') == 1 then
      state:adjust_selection('y', d)
    else
      pos_y = util.clamp(pos_y + d, 1, 8)
    end
  end
  state:set('region', {pos_x, pos_y})
end

function key(k, z)
  local shift = state:get('shift')
  if z == 0 then
    if k == 2 then
      interface:pull_back(state)
    elseif k == 3 then
      interface:enhance(state)
    end
  end
end

function refresh()
  redraw()
end