--
--
--
function st_IsLongPattern_A() end
function st_IsLongPattern_B() end

function st_IsLongPattern_A(candlesArr)
    local candle_A = candlesArr[1]

    -- if candle_A.open > candle_A.close then message('A true') else message('A false') end
    return candle_A.open > candle_A.close and true or false
end

function st_IsLongPattern_B(candlesArr)
    local candle_A = candlesArr[1]
    local candle_B = candlesArr[2]

    if candle_B.open > candle_B.close then
        if candle_A.high < candle_B.high and candle_A.low > candle_B.low then
            -- message('B true')
            return true
        else
            -- message('B false')
            return false
        end
    else
        -- message('B false')
        return false
    end
end

function is_LongPatterns(arr)
    local arr = arr
    local answer_A = false
    local answer_B = false
    
    local answer_A = st_IsLongPattern_A(arr)
    local answer_B = st_IsLongPattern_B(arr)

    if answer_A == true or answer_B == true then
        -- message('Long pattern found = true')
        return true
        -- CANDLE_PATTERN_IS_FOUND = true
    else
        -- message('Long pattern found = false')
        return false
        -- CANDLE_PATTERN_IS_FOUND = false
    end
end

function is_ShortPatterns(arr)
    -- message('is_ShortPatterns')
    return false
end