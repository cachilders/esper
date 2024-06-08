local Artifact = include('lib/artifact')
local Interface = include('lib/interface')
local Mouse = include('lib/mouse')
local State = include('lib/state')

local interface, mouse, state

local function _init_artifact()
  artifact = Artifact:new()
  artifact:init('test.png')
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
end

function redraw()
  screen.clear()
  interface:draw()
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
  redraw()
end