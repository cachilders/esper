local CONST = include('lib/constants')
local utils = include('lib/utils')

local Artifact = {
  depth = 2,
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

function Artifact:init()
end

function Artifact:get(k)
  return self[k]
end

function Artifact:set(k, v)
  self[k] = v
end

function Artifact:get_simplification()
  return self:_quantize_pixels(self.simplification)
end

function Artifact:get_representation_at(x, y)
  return self:_quantize_pixels(self.representation[x][y])
end

function Artifact:project(parameters)
  local reflection = screen.load_png(parameters:get('image_path'))
  local representation = {}
  local simplification = {}

  for i = 1, CONST.COLUMNS do
    local l1_col = {}
    local s_col = {}
    for j = 1, CONST.ROWS do
      local l1_row = {}
      for k = 1, CONST.COLUMNS do
        local l2_col = {}
        for l = 1, CONST.ROWS do
          table.insert(l2_col, utils.get_pixel_at(reflection, (i - 1) * CONST.COLUMNS + k, (j - 1) * CONST.ROWS + l))
        end
        table.insert(l1_row, l2_col)
      end
      table.insert(l1_col, l1_row)
      table.insert(s_col, utils.matrix(l1_row, parameters:get('process')))
    end
    table.insert(representation, l1_col)
    table.insert(simplification, s_col)
  end
  
  self.representation = representation
  self.simplification = simplification
end

function Artifact:_quantize_pixels(m)
  local quantized_pixels = {}
  for i = 1, #m do
    quantized_pixels[i] = {}
    for j = 1, #m[i] do
      quantized_pixels[i][j] = utils.quantize_pixels(m[i][j], self.depth)
    end
  end
  return quantized_pixels
end

return Artifact