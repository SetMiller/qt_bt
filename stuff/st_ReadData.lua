
--
--
--

function st_readData() end
function st_readData_W() end
function st_readBitData() end
function st_readBitData_W() end
function st_deepCopy() end
function st_checkBit() end

--
--
--

function st_readData(data, enum)
    local data      = data
    local str       = ''

    if type(data) == 'table' then
        for k, v in pairs(data) do
            if type(v) == 'table' then
                -- str = str .. k .. " -> !!! table !!!;\n"
            else
                str = str .. tostring(k) .. ": " .. tostring(v) .. ';\n'
                sleep(10)
            end
        end
    else
        str = str + tostring(data)
    end

    return str
end

function st_readData_W(data, enum)
    local data      = data
    local str       = ''

    
    
    if type(data) == 'table' then
        for k, v in pairs(data) do
            if type(v) == 'table' then
                -- str = str .. k .. " -> !!! table !!!;\n"
            else
                str = tostring(k) .. ": " .. tostring(v) .. ';\n'
                LOGS:update(str)
                -- sleep(10)
                
            end
        end
    else
        str = str + tostring(data)
    end

    
    -- return str
end

function st_readBitData(order, enum) 
    local enum      = enum
    local bit_str   = ''

    for _, v in pairs(enum) do
        bit_str = bit_str .. v ..' bit =' .. tostring(st_checkBit(order.flags, v)) .. ';\n'
    end

    return bit_str
end

function st_readBitData_W(order, enum) 
    local enum      = enum
    local bit_str   = ''

    for _, v in pairs(enum) do
        bit_str = v ..' bit =' .. tostring(st_checkBit(order.flags, v)) .. ';\n'
        LOGS:update(bit_str)
    end

    return bit_str
end


function st_deepCopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
          copy[st_deepCopy(orig_key)] = st_deepCopy(orig_value)
      end
      setmetatable(copy, st_deepCopy(getmetatable(orig)))
  else -- number, string, boolean, etc
      copy = orig
  end
  return copy
end

function st_checkBit(flags, _bit)
    -- Проверяет, что переданные аргументы являются числами
    if type(flags) ~= "number" then error(Private.logicType .. " Error!!! Checkbit: 1-st argument is not a number!") end
    if type(_bit) ~= "number" then error(Private.logicType .. " Error!!! Checkbit: 2-nd argument is not a number!") end
 
    if _bit == 0 then _bit = 0x1
    elseif _bit == 1 then _bit = 0x2
    elseif _bit == 2 then _bit = 0x4
    elseif _bit == 3 then _bit = 0x8
    elseif _bit == 4 then _bit = 0x10
    elseif _bit == 5 then _bit = 0x20
    elseif _bit == 6 then _bit = 0x40
    elseif _bit == 7 then _bit = 0x80
    elseif _bit == 8 then _bit = 0x100
    elseif _bit == 9 then _bit = 0x200
    elseif _bit == 10 then _bit = 0x400
    elseif _bit == 11 then _bit = 0x800
    elseif _bit == 12 then _bit = 0x1000
    elseif _bit == 13 then _bit = 0x2000
    elseif _bit == 14 then _bit = 0x4000
    elseif _bit == 15 then _bit = 0x8000
    elseif _bit == 16 then _bit = 0x10000
    elseif _bit == 17 then _bit = 0x20000
    elseif _bit == 18 then _bit = 0x40000
    elseif _bit == 19 then _bit = 0x80000
    elseif _bit == 20 then _bit = 0x100000
    end
 
    if bit.band(flags,_bit ) == _bit then return true
    else return false end
end

