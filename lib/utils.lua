local utils = {}

function utils.get_pixel_at(img_buff, x, y)
  -- image is 0-indexed
  screen.display_image_region(img_buff, x - 1, y - 1, 1, 1, 0, 0)
  local buff = screen.peek(0, 0, 1, 1)
  return string.byte(buff, 1)
end

function utils.matrix(m, method)
  if method == 'mean' then
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
  elseif method == 'median' then
    local vals = {}
    local total = #m * #m[1]
    local mid = math.floor(total / 2)
    local even = total % 2 == 0
    local median
    for i = 1, #m do
      local row = m[i]
      for j = 1, #row do
        table.insert(vals, row[j])
      end
    end

    table.sort(vals)

    if even then
      median = math.floor((vals[mid] + vals[mid + 1]) / 2)
    else
      median = vals[mid]
    end

    return median
  elseif method == 'mode' then
    local vals = {}
    local mode = 1
    for i = 1, #m do
      local row = m[i]
      for j = 1, #row do
        local val = row[j] + 1
        vals[val] = vals[val] and vals[val] + 1 or 1
      end
    end

    for i = 1, 16 do
      mode = vals[i] and vals[i] > mode and i or mode
    end
    
    return mode - 1
  end
end

function utils.quantize_pixels(value, depth)
  -- TODO: Improve this to make even use of the entire 0 - 15 range
  --        naive solution here is not great
  local MAX_DEPTH = 16
  local colors = 2^depth
  local multiplier = colors /  MAX_DEPTH
  local scaler = MAX_DEPTH / colors
  return math.floor(value * multiplier) * scaler
end

return utils