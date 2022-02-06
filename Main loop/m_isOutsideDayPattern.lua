--
--
--
function isOutsideCandlePattern()  end
--
--
--  паттерн - любая внешняя свечка
function isOutsideCandlePattern(candleArr) 

    local candle_A = candleArr[1]
    local candle_B = candleArr[2]

    if candle_A.high > candle_B.high and candle_A.low < candle_B.low then

        return true

    else

        return false

    end
end