local State = include('lib/state')

local _hid, state

local function _hid_action(type, code, value)
  -- POC TODO Move to class when purpose is clarified`
  if type == 2 then -- mouse
    if code == 0  then -- x
      print('x delta '..value)
    elseif code == 1 then -- y
      print('y delta '..value)
    end
  elseif type == 1 then
    if code == 272 then -- Left click
      if value == 1 then -- click
        print('left click')
      elseif value == 2 then -- hold
        print('left hold')
      elseif value == 0 then -- release
        print('left release')
      end
    elseif code == 273 then -- Right click
      if value == 1 then -- click
        print('right click')
      elseif value == 2 then -- hold
        print('right hold')
      elseif value == 0 then -- release
        print('right release')
      end
    end
  end
end

local function _init_hid()
  _hid = hid.connect()
  _hid.event = _hid_action
end

local function _init_state()
  state = State:new()
  state:init()
end

function init()
  _init_state()
  _init_hid()
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