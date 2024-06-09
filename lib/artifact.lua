local ASSET_PATH = '/home/we/dust/code/esper/assets/test/'
local COLUMNS, ROWS = 8, 8

local utils = include('lib/utils')

local Artifact = {
  depth = 4,
  power = 1,
  region = nil,
  reference = nil,
  representation = nil,
  simplification = nil
}

function Artifact:new(options)
  local instance = options or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Artifact:init(reference)
  local reflection = screen.load_png(ASSET_PATH..reference)
  local representation = {}
  local simplification = {}

  for i = 1, COLUMNS do
    local l1_col = {}
    local s_col = {}
    for j = 1, ROWS do
      local l1_row = {}
      for k = 1, COLUMNS do
        local l2_col = {}
        for l = 1, ROWS do
          table.insert(l2_col, utils.get_pixel_at(reflection, (i - 1) * COLUMNS + k, (j - 1) * ROWS + l))
        end
        table.insert(l1_row, l2_col)
      end
      table.insert(l1_col, l1_row)
      table.insert(s_col, utils.matrix(l1_row, 'median'))
    end
    table.insert(representation, l1_col)
    table.insert(simplification, s_col)
  end
  
  self.region = {1, 1} -- selected zoom segment
  self.representation = representation
  self.simplification = simplification
end

function Artifact:get(k)
  return self[k]
end

function Artifact:set(k, v)
  self[k] = v
end

function Artifact:get_representation_at(x, y)
  return self.representation[x][y]
end

return Artifact