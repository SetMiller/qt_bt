--
--
--
function m_isOutsideCandlePattern()  end
--
--
--  паттерн - любая внешняя свечка
function m_isOutsideCandlePattern(candleArr) 
    local isOutsideCandle = false
    local candle_A = candleArr[1]
    local candle_B = candleArr[2]

    if TRADE_TYPE == 'long' then
        if candle_B.low > candle_A.low then isOutsideCandle = true end
    else
        if candle_B.high < candle_A.high then isOutsideCandle = true end
    end

    return isOutsideCandle
    -- if candle_A.high > candle_B.high and candle_A.low < candle_B.low then

    --     return true

    -- else

    --     return false
    --     -- return true

    -- end
end