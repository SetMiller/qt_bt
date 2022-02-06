HeikenAshi = {}

function HeikenAshi:new()

    local Private = {
        ['HAcandleArr'] = {}
    }

    local Public = {}

    function Public:update(candleArr, SecScale) 
        local candleArr         = candleArr
        local priceSecScale     = '%.' .. tonumber(string.format('%.0f', SecScale)) .. 'f'
        
        for i = #candleArr, 1, -1 do
            Private.HAcandleArr[i] = {}
            if i == #candleArr then
                Private.HAcandleArr[i].open     = tonumber(string.format(priceSecScale, candleArr[i].open ))
                Private.HAcandleArr[i].high     = tonumber(string.format(priceSecScale, candleArr[i].high ))
                Private.HAcandleArr[i].low      = tonumber(string.format(priceSecScale, candleArr[i].low ))
                Private.HAcandleArr[i].close    = tonumber(string.format(priceSecScale, candleArr[i].close ))
                Private.HAcandleArr[i].datetime = st_deepCopy(candleArr[i].datetime)
            else
                Private.HAcandleArr[i].open     = tonumber(string.format(priceSecScale, ( Private.HAcandleArr[i + 1].open + Private.HAcandleArr[i + 1].close ) / 2 ))
                Private.HAcandleArr[i].close    = tonumber(string.format(priceSecScale, ( candleArr[i].open + candleArr[i].high + candleArr[i].low + candleArr[i].close ) / 4 ))
                Private.HAcandleArr[i].high     = tonumber(string.format(priceSecScale, math.max( candleArr[i].high, Private.HAcandleArr[i].open, Private.HAcandleArr[i].close ) ))
                Private.HAcandleArr[i].low      = tonumber(string.format(priceSecScale, math.min( candleArr[i].low, Private.HAcandleArr[i].open, Private.HAcandleArr[i].close ) ))
                Private.HAcandleArr[i].datetime = st_deepCopy(candleArr[i].datetime)
            end
        end

        -- for k = #Private.HAcandleArr, #Private.HAcandleArr - 4, -1 do
        --     message("O:" .. tostring(Private.HAcandleArr[k].open) .. " \nH:" .. tostring(Private.HAcandleArr[k].high) .. " \nL:" .. tostring(Private.HAcandleArr[k].low) .. " \nC:" .. tostring(Private.HAcandleArr[k].close) .. " \nT:" .. tostring(Private.HAcandleArr[k].datetime.day) .. " " .. tostring(Private.HAcandleArr[k].datetime.hour))
        -- end

        -- message("O:" .. tostring(Private.HAcandleArr[1].open) .. " \nH:" .. tostring(Private.HAcandleArr[1].high) .. " \nL:" .. tostring(Private.HAcandleArr[1].low) .. " \nC:" .. tostring(Private.HAcandleArr[1].close) .. " \nT:" .. tostring(Private.HAcandleArr[1].datetime.hour))
        -- message(" \nH:" .. tostring(Private.HAcandleArr[1].high) .. " \nL:" .. tostring(Private.HAcandleArr[1].low) .. " \nT:" .. tostring(Private.HAcandleArr[1].datetime.hour))
        -- message("O:" .. tostring(Private.HAcandleArr[#candleArr].open) .. " \nH:" .. tostring(Private.HAcandleArr[#candleArr].high) .. " \nL:" .. tostring(Private.HAcandleArr[#candleArr].low) .. " \nC:" .. tostring(Private.HAcandleArr[#candleArr].close) .. " \nT:" .. tostring(Private.HAcandleArr[#candleArr].datetime.hour))
        -- counter = nil

        return Private.HAcandleArr
    end

    function Public:getCandlesArr()
        return Private.HAcandleArr
    end

    setmetatable(Public, self)
    self.__index = self
    return Public
end