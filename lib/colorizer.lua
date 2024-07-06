local CONST = include('lib/constants')
local mxsynths = include('mx.synths/lib/mx.synths')

engine.name="MxSynths"

local Colorizer = {
  scale = nil,
  synths = nil
}

function Colorizer:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Colorizer:init()
  self.synths = mxsynths:new()
end

function Colorizer:radiate(note) -- TODO This whole class is WIP af to prove stuff works
  if note then
    self.synths:play({
      note = note,
      velocity = 100,
    })
  end
end

return Colorizer