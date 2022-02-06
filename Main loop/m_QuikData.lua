--
--
--

function getDepoLimit()         end
function getParamTableData(obj) end
-- function getTotalNet()          end
-- function getActiveStopOrders()  end
function getRiskPerTrade()      end

--
--
--

function getDepoLimit(firmid, trdaccid, limitType, currcode)  
    
    local depoLimit, varMargin
    -- local availableDepoLimit = ''

    if getFuturesLimit(firmid, trdaccid, limitType, currcode).cbplimit ~= nil then
        depoLimit = getFuturesLimit(firmid, trdaccid, limitType, currcode).cbplplanned
    else
        depoLimit = nil
    end
    if getFuturesLimit(firmid, trdaccid, limitType, currcode).accruedint ~= nil then
        varMargin = getFuturesLimit(firmid, trdaccid, limitType, currcode).accruedint
    else
        varMargin = nil
    end

    -- if depoLimit == 0 then message("check u_Options -> trdaccid") else message("depoLomit =" .. depoLimit) end
   
    -- return depoLimit, varMargin
    return depoLimit
end  

-- заполняем таблицы параметров по фьючерсу
function getParamTable(class_code, sec_code, obj)
    local futuresParamData = obj
  

    for k, v in pairs(futuresParamData) do
        futuresParamData[k] = getParamEx(class_code, sec_code, k).param_value
        -- message(k .. " =" .. futuresParamData[k])
    end

    return futuresParamData
end

-- получаем данные по текущей позиции
-- function getTotalNet(trdaccid, sec_code)

--     local lotsInPos = 0
--     local numbOfPossitions = getNumberOf("futures_client_holding") - 1


--     if numbOfPossitions > -1 then
--         for i = 0, numbOfPossitions do
--             if trdaccid == getItem("futures_client_holding", i).trdaccid then
--                 -- message(getItem("futures_client_holding", i).trdaccid) sleep(400)
--                 if getItem("futures_client_holding", i).sec_code == sec_code then
--                     lotsInPos = getItem("futures_client_holding", i).totalnet
--                 end
--             end
--         end
--     end
--     return lotsInPos
-- end

function getRiskPerTrade(depoLimit, risk) 
    
    return tonumber(string.format("%.0f", depoLimit * risk ))

end
