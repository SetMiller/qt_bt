--
--
--
function m_IsLongPattern_A() end
function m_IsLongPattern_B() end
function m_IsLongPattern_C() end

--
--
-- паттерн - противоход красной свечке
function m_IsLongPattern_A(candlesArr)

    local candle_A = candlesArr[1]

    return candle_A.open > candle_A.close and true or false

end
-- паттерн - противоход зеленой свечке
function m_IsShortPattern_A(candlesArr)

    local candle_A = candlesArr[1]

    return candle_A.open < candle_A.close and true or false

end
--
--
-- паттерн - после красной свечки идет внутренняя (любая)
function m_IsLongPattern_B(candlesArr)
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
-- паттерн - после зеленой свечки идет внутренняя (любая)
function m_IsShortPattern_B(candlesArr)
    local candle_A = candlesArr[1]
    local candle_B = candlesArr[2]

    if candle_B.open < candle_B.close then
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
--
-- паттерн - проверяем что на момент запуска, последняя цена не вышла за границы
-- цены открытия
function m_IsLongPattern_C(candlesArr, last_price) 

    local candle_A  = candlesArr[1]
    local last      = last_price

    if candle_A.high < last_price then

        return false

    else

        return true

    end

end
function m_IsShortPattern_C(candlesArr, last_price) 

    local candle_A  = candlesArr[1]
    local last      = last_price

    if candle_A.low > last_price then

        return false

    else

        return true

    end

end
--
--
--
--
--
--
function is_LongPatterns(arr, last_price)

    local arr           = arr
    local last_price    = tonumber(last_price)
    local answer_A      = m_IsLongPattern_A(arr)
    local answer_B      = m_IsLongPattern_B(arr)
    local answer_C      = m_IsLongPattern_C(arr, last_price)

    if answer_C then
        
        if answer_A or answer_B then
            -- message('Long pattern found = true')
            return true

        else
            -- message('Long pattern found = false')
            return false

        end
    else

        return false

    end
end

function is_ShortPatterns(arr, last_price)

    local arr           = arr
    local last_price    = tonumber(last_price)
    local answer_A      = m_IsShortPattern_A(arr)
    local answer_B      = m_IsShortPattern_B(arr)
    local answer_C      = m_IsShortPattern_C(arr, last_price)

    if answer_C then

        if answer_A or answer_B then
            -- message('Long pattern found = true')
            return true

        else
            -- message('Long pattern found = false')
            return false

        end
    else

        return false
        
    end
end