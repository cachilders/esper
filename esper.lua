local Artifact = include('lib/artifact')
local Interface = include('lib/interface')
local Mouse = include('lib/mouse')
local State = include('lib/state')

local interface, met, mouse, state

local function _init_artifact()
  artifact = Artifact:new()
  artifact:init('test.png')
end

local function _init_clocks()
  local met = metro.init(redraw, 15 / params:get('clock_tempo'))
end

local function _init_interface()
  interface = Interface:new()
  interface:init()
end

local function _init_mouse()
  mouse = Mouse:new()
  mouse:init()
end

local function _init_state()
  state = State:new()
  state:init()
end

function init()
  _init_artifact()
  _init_interface()
  _init_mouse()
  _init_state()
  _init_clocks()
end

function redraw()
  screen.clear()
  interface:draw(artifact)
  screen.stroke()
  screen.update()
end

function enc(e, d)
  local shift = state:get('shift')
end

function key(k, z)
  local shift = state:get('shift')
end

function refresh()
  -- redraw()
end