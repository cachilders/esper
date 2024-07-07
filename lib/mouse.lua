local CONST = include('lib/constants')

local Mouse = {
  connection = nil,
  throttle = false
}

function Mouse.on_event(interface, state, type, code, value)
  local menu = state:get(CONST.MENU)

  if type == 2 then -- mouse
    value = value < 0 and -1 or 1
    if code == 0  then -- x
      if menu then
        state:traverse_menu(value)
      else
        state:adjust_selection(CONST.X, value)
      end
    elseif code == 1 then -- y
      if not menu then
        state:adjust_selection(CONST.Y, value)
      end
    end
  elseif type == 1 then
    if code == 272 then -- Left click
      if value == 1 then -- click
        print('left click')
      elseif value == 2 then -- hold
        print('left hold')
      elseif value == 0 then -- release
        if menu then
          interface:select_menu_item(state)
        else
          interface:toggle_depth(state)
        end
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
  self.connection.event = function(t, c, v)
    if self.throttle == false then
      self.on_event(interface, state, t, c, v)
    end
    self:_throttle()
  end
end

function Mouse:_throttle()
  self.throttle = true

  clock.run(function()
    clock.sleep(0.1)
    self.throttle = false
  end)
end

return Mouse