ChartData = {}

--
--
-- @param chartId string -> 'Si_f'
-- @param candlesToCheck number -> 2
function ChartData:new(arrLenght)
  
    local Private = {
        ['offset']          = 1,
        ['arrLenght']       = arrLenght,
        ['candlesArr']      = {},
    }

    local Public = {}
    
    function Public:update(ds)

        local ds = ds
        local index = ds:Size()
        local counter = 1
        
        if Private.arrLenght == 1 then

            Private.candlesArr[counter] = {}
            Private.candlesArr[counter].open     = ds:O(index - Private.offset)
            Private.candlesArr[counter].high     = ds:H(index - Private.offset)
            Private.candlesArr[counter].low      = ds:L(index - Private.offset)
            Private.candlesArr[counter].close    = ds:C(index - Private.offset)
            Private.candlesArr[counter].datetime = st_deepCopy(ds:T(index - Private.offset))

        else

            for i = index - Private.offset, index - Private.arrLenght, -1 do
                Private.candlesArr[counter] = {}
                Private.candlesArr[counter].open     = ds:O(i)
                Private.candlesArr[counter].high     = ds:H(i)
                Private.candlesArr[counter].low      = ds:L(i)
                Private.candlesArr[counter].close    = ds:C(i)
                Private.candlesArr[counter].datetime = st_deepCopy(ds:T(i))
                counter = counter + 1
            end

        end
        

        -- LOGS:update(SEC_CODE, '\n')
        -- LOGS:update(" \nH:" .. tostring(Private.candlesArr[1].high) .. " \nL:" .. tostring(Private.candlesArr[1].low) .. " \nT:" .. tostring(Private.candlesArr[1].datetime.min))
        -- LOGS:update(SEC_CODE, '\n')
        -- message(" \nH:" .. tostring(Private.candlesArr[1].high) .. " \nL:" .. tostring(Private.candlesArr[1].low) .. " \nT:" .. tostring(Private.candlesArr[1].datetime.min))

        -- table.sinsert(MAIN_QUEUE_ONPARAM, {callback = "OnParam", value = order})
        -- CHART_DATA_IS_UPDATED = true
        return Private.candlesArr

    end

    function Public:getCandlesArr()
        return Private.candlesArr
    end
    
    setmetatable(Public, self)
    self.__index = self
    return Public
end


