local ASSET_PATH = '/home/we/dust/code/esper/assets/test/'
local COLUMNS, ROWS = 8, 8

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

function Artifact:init(reference)
  local reflection = screen.load_png(ASSET_PATH..reference)
  local representation = {}
  local simplification = {}
  local function run_thread(routine)
    local continue, arg = coroutine.resume(routine)
    if continue then
      -- TODO this is a WIP optimization investigation for the
      -- queue full error. It solves nothing, but I'd been meaning
      -- to mess with coroutines.
      run_thread(routine)
    end
  end

  run_thread(coroutine.create(
    function()
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
        coroutine.yield()
      end
    end
  ))
  
  self.representation = representation
  self.simplification = simplification
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