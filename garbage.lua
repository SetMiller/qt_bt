function ReadData(data)
  local data = data
  if type(data) == 'table' then
    for k, v in pairs(data) do
      message(tostring(k) .. ": " .. tostring(v))
    end
  elseif type(data) == 'number' or type(data) == 'string' then
    message(tostring(data))
  end
end

function DeepCopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
          copy[DeepCopy(orig_key)] = DeepCopy(orig_value)
      end
      setmetatable(copy, DeepCopy(getmetatable(orig)))
  else -- number, string, boolean, etc
      copy = orig
  end
  return copy
end