local Mouse = include('lib/mouse')
local State = include('lib/state')

local mouse, state

local function _init_mouse()
  mouse = Mouse:new()
  mouse:init()
end

local function _init_state()
  state = State:new()
  state:init()
end

function init()
  _init_mouse()
  _init_state()
end

function redraw()
end

function enc(e, d)
  local shift = state:get('shift')
end

function key(k, z)
  local shift = state:get('shift')
end

function refresh()
end