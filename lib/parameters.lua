musicutil = require('musicutil')
local CONST = include('lib/constants')
local ControlSpec = require 'controlspec'
local Formatters = require 'formatters'

local Parameters = {
  scales = nil
}

function Parameters._truncate_string(s, l)
  if string.len(s) > l then
    return ''..string.sub(s, 0, l)..'...'
  end
  return s
end

function Parameters._quantize_and_format(value, step, unit)
  return util.round(value, step)..unit
end

function Parameters:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Parameters:init(state)
  self.scales = self:_get_music_scale_names()
  self:_init_character(state)
  self:_init_adsr()
  params:set_action('clock_tempo', function() state:set(CONST.DIRTY_CLOCK, true) end)
end

function Parameters:_init_adsr()
  params:add_group('envelope', 'ESPER Envelope', 4)
  params:add_control('attack', 'Attack', ControlSpec.new(0.01, 1, 'lin', 0, 0.05),
    function(param) return self._quantize_and_format(param:get(), 0.01, ' s') end)
  params:add_control('decay', 'Decay', ControlSpec.new(0.01, 1, 'lin', 0, 0.01),
    function(param) return self._quantize_and_format(param:get(), 0.01, ' s') end)
  params:add_control('sustain', 'Sustain', ControlSpec.new(0.01, 1, 'lin', 0, 0.5),
    function(param) return self._quantize_and_format(param:get()*100, 0.1, '%') end)
  params:add_control('release', 'Release', ControlSpec.new(0.01, 1, 'lin', 0, 0.01),
    function(param) return self._quantize_and_format(param:get(), 0.01, ' s') end)
end

function Parameters:_init_character(state)
  params:add_group('character', 'ESPER Character', 3)
  params:add_number('subdivisions', 'Beat Division', 0.25, 16, 4)
  params:set_action('subdivisions', function() state:set(CONST.DIRTY_CLOCK, true) end)
  params:add_number('root_note', 'Root Note', 0, 127, 36, function(param) return musicutil.note_num_to_name(param:get(), true) end)
  params:set_action('root_note', function() state:set(CONST.DIRTY_SCALE, true) end)
  params:add_option('scale', 'Scale Type', self.scales, 1)
  params:set_action('scale', function() state:set(CONST.DIRTY_SCALE, true) end)
end

function Parameters:_get_music_scale_names()
  local scales = {}
  for i = 1, #musicutil.SCALES do
    scales[i] = self._truncate_string(musicutil.SCALES[i].name, 16)
  end

  return scales
end

return Parameters