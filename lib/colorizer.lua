local CONST = include('lib/constants')

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
end

function Colorizer:radiate(note) -- TODO This whole class is WIP af to prove stuff works
  if note then
    engine.play_note(
      note,
      127,
      15 / params:get('clock_tempo') * params:get('sustain'),
      params:get('attack'),
      params:get('decay'),
      1,
      params:get('release')
    )
  end
end

return Colorizer