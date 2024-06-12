musicutil = require('musicutil')

local Colorizer = {
  scale = nil
}

function Colorizer:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Colorizer:init()
  self:set_scale()
end

function Colorizer:radiate(state, artifact) -- TODO This whole class is WIP af to prove stuff works
  local notes, note
  local active = state:get('active')

  if state:get('power') == 1 then
    notes = artifact:get_simplification()
  else
    local region = state:get('region')
    notes = artifact:get_representation_at(region[1], region[2])
  end

  note = notes[active[1]][active[2]]
  if note > 0 then
    engine.play_note(
      self.scale[note],
      127,
      15 / params:get('clock_tempo') * params:get('sustain'),
      params:get('attack'),
      params:get('decay'),
      1,
      params:get('release')
    )
  end
end

function Colorizer:set_scale()
  self.scale = musicutil.generate_scale_of_length(params:get('root_note'), params:get('scale'), 16)
end

return Colorizer