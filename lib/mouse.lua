local Mouse = {
  connection = nil
}

function Mouse._on_event(type, code, value)
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

function Mouse:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Mouse:init(dev)
  self.connection = hid.connect(dev)
  self.connection.event = self._on_event
end

return Mouse