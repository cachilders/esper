local CONST = include('lib/constants')

local Mouse = {
  connection = nil,
}

function Mouse.on_event(interface, state, type, code, value)
  if type == 2 then -- mouse
    value = value < 0 and -1 or 1
    if code == 0  then -- x
      state:adjust_selection(CONST.X, value)
    elseif code == 1 then -- y
      state:adjust_selection(CONST.Y, value)
    end
  elseif type == 1 then
    if code == 272 then -- Left click
      if value == 1 then -- click
        print('left click')
      elseif value == 2 then -- hold
        print('left hold')
      elseif value == 0 then -- release
        interface:toggle_depth(state)
      end
    elseif code == 273 then -- Right click
      if value == 1 then -- click
        print('right click')
      elseif value == 2 then -- hold
        print('right hold')
      elseif value == 0 then -- release
        interface:toggle_menu(state)
      end
    end
  end
end

function Mouse:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Mouse:init(interface, state, dev)
  self.connection = hid.connect(dev or 1)
  self.connection.event = function(t, c, v) self.on_event(interface, state, t, c, v) end
end

return Mouse