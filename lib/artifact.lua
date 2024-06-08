local ASSET_PATH = '/home/we/dust/code/esper/assets/test/'
local COLUMNS, ROWS = 8, 8

local Artifact = {
  depth = 8,
  power = 2,
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

  local function get_pixel_at(x, y)
    screen.display_image_region(reflection, x, y, 1, 1, 0, 0)
    local buff = screen.peek(0, 0, 1, 1)
    return string.byte(buff, 1)
  end

  local function get_mean_of_matrix(m)
    local sum = 0
    local count = 0
    for i = 1, #m do
      local row = m[i]
      for j = 1, #row do
        sum = sum + row[j]
        count = count + 1
      end
    end
    return math.floor(sum / count)
  end
  
  for i = 1, COLUMNS do
    local l1_col = {}
    local s_col = {}
    for j = 1, ROWS do
      local l1_row = {}
      for k = 1, COLUMNS do
        local l2_col = {}
        for l = 1, ROWS do
          table.insert(l2_col, get_pixel_at(i * COLUMNS + k, j * ROWS + l))
        end
        table.insert(l1_row, l2_col)
      end
      table.insert(l1_col, l1_row)
      table.insert(s_col, get_mean_of_matrix(l1_row))
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

function Artifact:get_representation_at(x, y)
  return self.representation[x][y]
end

return Artifact