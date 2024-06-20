local Mouse = {
  connection = nil
}

function Mouse.on_event(interface, state, type, code, value)
  if type == 2 then -- mouse
    if code == 0  then -- x
      state:adjust_selection('x', value)
    elseif code == 1 then -- y
      state:adjust_selection('y', value)
    end
  elseif type == 1 then
    if code == 272 then -- Left click
      if value == 1 then -- click
        print('left click')
      elseif value == 2 then -- hold
        print('left hold')
      elseif value == 0 then -- release
        interface:pull_back(state) -- TODO release from hold will be different -- WIP
      end
    elseif code == 273 then -- Right click
      if value == 1 then -- click
        print('right click')
      elseif value == 2 then -- hold
        print('right hold')
      elseif value == 0 then -- release
        interface:enhance(state)
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