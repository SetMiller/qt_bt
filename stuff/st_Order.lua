dofile(getScriptPath().."\\stuff\\st_TransId.lua")
dofile(getScriptPath().."\\user\\u_Options.lua")

--
--
--

function stopOrderOpenPoss() end
function stopOrderClosePoss() end

--
--
--

function stopOrderOpenPoss(StopPrice, Price, Lots, SecScale)
    local stopOrder         = {}
    local priceSecScale     = '%.' .. tonumber(string.format('%.0f', SecScale)) .. 'f'

    stopOrder = {
        ["ACTION"] = "NEW_STOP_ORDER",                              
        ["ACCOUNT"] = trdaccid, 
        ["TRANS_ID"] = tostring(st_transId()),                         
        ["CLASSCODE"] = CLASS_CODE,                                          
        ["SECCODE"] = SEC_CODE,                                        
        ["OPERATION"] = TRADE_TYPE == 'long' and 'B' or 'S',                                      
        ["QUANTITY"] = tostring(Lots),  
        ["CLIENT_CODE"] = TRADE_TYPE .. ' open',                              
        ["STOPPRICE"] = tostring(tonumber(string.format(priceSecScale, StopPrice))),                                 
        ["PRICE"] = tostring(tonumber(string.format(priceSecScale, Price))),                                        
        ["EXPIRY_DATE"] = 'TODAY',
    }

    return stopOrder
end

function stopOrderClosePoss(StopPrice, Price, Lots) 
    local stopOrder = {}

    stopOrder = {
        ["ACTION"] = "NEW_STOP_ORDER",                              
        ["ACCOUNT"] = trdaccid, 
        ["TRANS_ID"] = tostring(st_transId()),                         
        ["CLASSCODE"] = CLASS_CODE,                                          
        ["SECCODE"] = SEC_CODE,                                        
        ["OPERATION"] = TRADE_TYPE == 'long' and 'S' or 'B',                                      
        ["QUANTITY"] = TRADE_TYPE == 'long' and tostring(Lots) or tostring(Lots * (-1)),  
        ["CLIENT_CODE"] = TRADE_TYPE .. ' open',                              
        ["STOPPRICE"] = tostring(tonumber(string.format("%.0f", StopPrice))),                                 
        ["PRICE"] = tostring(tonumber(string.format("%.0f", Price))),                                        
        ["EXPIRY_DATE"] = 'TODAY',
    }

    return stopOrder
end



--
--  очистка активной заявки происходит по данным, которые скопировали при установке !!!
--
function clearStopOrders(order_num, trans_id)

    local stateOrderNum     = order_num
    local stateTransId      = trans_id

    for i = 0, getNumberOf("stop_orders") - 1 do  
        local order_num     = getItem("stop_orders", i).order_num
        local account       = getItem("stop_orders", i).account
        local trans_id      = getItem("stop_orders", i).trans_id

        if order_num == stateOrderNum and trans_id == stateTransId and account == trdaccid then   
            local transaction = {
            ["TRANS_ID"] = tostring(stateTransId),
            ["ACTION"] = "KILL_STOP_ORDER",
            ["SECCODE"] = SEC_CODE,                                        
            ["CLASSCODE"] = CLASS_CODE,
            ["STOP_ORDER_KEY"] = tostring(stateOrderNum),
            }
            resp = sendTransaction(transaction);
            message(resp)
        end
    end
 end


-- function Private:marketClose()
--     -- messsage('2')
--     local totalNet = Private.marketCloseData.totalNet
--     local maxPrice = Private.marketCloseData.priceMax
--     local minPrice = Private.marketCloseData.priceMin
--     local accData = GV:getAccountData()
    
--     if totalNet ~= 0 then
--        for i = 0, getNumberOf("futures_client_holding") - 1 do   
--           local sec_code = getItem("futures_client_holding", i).sec_code
--           -- local account = getItem("stop_orders", i).account
--           local account = getItem("futures_client_holding", i).trdaccid
--           if sec_code == Private.quikSetup.futures.SECCODE and account == accData.trdaccid then
--              local transactionData = {
--                 ["ACTION"] = "NEW_ORDER"; 
--                 ["TYPE"] = "M"; 
--                 ["SECCODE"] = Private.quikSetup.futures.SECCODE; 
--                 ["CLASSCODE"] = Private.quikSetup.futures.CLASSCODE; 
--                 ["ACCOUNT"] = Private.account.trdaccid; 
--                 ["CLIENT_CODE"] = 'marketClose'; 
--                 ["QUANTITY"] = totalNet > 0 and tostring(totalNet) or totalNet < 0 and tostring(totalNet * (-1)),  
--                 ["TRANS_ID"] = Private:getTransId(Private.transIdStack),          
--                 ["OPERATION"] = totalNet > 0 and 'S' or totalNet < 0 and 'B',                                      
--                 ["PRICE"] = totalNet > 0 and minPrice or totalNet < 0 and maxPrice;           
--              }
--              resp = sendTransaction(transactionData)
--              -- message(tostring(resp))
--              if totalNet > 0 then message("Long possitions closed") else message("Short possitions closed") end
--           end
--        end
--     else
--        message("You have no open positions")
--     end

--  end