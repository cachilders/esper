musicutil = require('musicutil')

local Parameters = {
  scales = nil
}

function Parameters._truncate_string(s, l)
  if string.len(s) > l then
    return ''..string.sub(s, 0, l)..'...'
  end
  return s
end

function Parameters:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Parameters:init(state, artifact)
  self.scales = self:_get_music_scale_names()
  self:_init_character()
end

function Parameters:_init_character()
  params:add_group('character', 'ESPER Character', 2)
  params:add_number('root', 'Root Note', 0, 127, 48, function(param) return musicutil.note_num_to_name(param:get(), true) end)
  params:add_option('scale', 'Scale Type', self.scales, 1)
end

function Parameters:_get_music_scale_names()
  local scales = {}
  for i = 1, #musicutil.SCALES do
    scales[i] = self._truncate_string(musicutil.SCALES[i].name, 16)
  end

  return scales
end

return Parameters