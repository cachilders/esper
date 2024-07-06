local CONST = include('lib/constants')
local ControlSpec = require 'controlspec'
local fileselect = require('fileselect')
local musicutil = require('musicutil')
local PROCESSES = {CONST.MEAN, CONST.MEDIAN, CONST.MODE}

local Parameters = {
  image_path = CONST.ASSET_PATH_ARTIFACT_DEFAULT..CONST.FILENAME_ARTIFACT_DEFAULT..CONST.EXT,
  process = nil,
  scales = nil,
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
  self:_init_synth()
  params:set_action('clock_tempo', function() state:set(CONST.DIRTY_CLOCK, true) end)
end

function Parameters:get(k)
  return self[k]
end

function Parameters:_init_synth()
  params:set('mxsynths_synth', 6)
  params:set('mxsynths_attack', 0.1)
  params:set('mxsynths_decay', 0.3)
  params:set('mxsynths_sustain', 0.5)
  params:set('mxsynths_release', 0.75)
end

function Parameters:_init_character(state)
  params:add_group('esper', 'ESPER', 5)
  params:add_trigger('load', 'Load Image')
  params:set_action('load', function() fileselect.enter(norns.state.data, function(path) self.image_path = path; state:set(CONST.DIRTY_ARTIFACT, true) end) end)
  params:add_option('process', 'Image Process', PROCESSES, 2)
  params:set_action('process', function(i) self.process = PROCESSES[i]; state:set(CONST.DIRTY_ARTIFACT, true) end)
  params:add_number('subdivisions', 'Beat Division', 0.25, 16, 4)
  params:set_action('subdivisions', function() state:set(CONST.DIRTY_CLOCK, true) end)
  params:add_number('root_note', 'Root Note', 0, 127, 36, function(param) return musicutil.note_num_to_name(param:get(), true) end)
  params:set_action('root_note', function() state:set(CONST.DIRTY_SCALE, true) end)
  params:add_option('scale', 'Scale Type', self.scales, 1)
  params:set_action('scale', function() state:set(CONST.DIRTY_SCALE, true) end)
  params:bang()
end

function Parameters:_get_music_scale_names()
  local scales = {}
  for i = 1, #musicutil.SCALES do
    scales[i] = self._truncate_string(musicutil.SCALES[i].name, 16)
  end

  return scales
end

return Parameters