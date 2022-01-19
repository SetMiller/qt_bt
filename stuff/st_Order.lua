-- возвращает стоп заявку


-- local transactionStack.outPoss = {
--     ["ACTION"] = "NEW_STOP_ORDER",                              
--     ["SECCODE"] = Private.quikSetup.futures.SECCODE,                                        
--     ["CLASSCODE"] = Private.quikSetup.futures.CLASSCODE,                                          
--     ["ACCOUNT"] = Private.account.trdaccid, 
--     ["CLIENT_CODE"] = GV:getInfo(),                              
--     ["QUANTITY"] = tradePoss.operation == 'long' and tostring(tradePoss.stopLotsValue) or tostring(tradePoss.stopLotsValue * (-1)),  
--     ["TRANS_ID"] = Private:getTransId(Private.transIdStack),                         
--     ["OPERATION"] = tradePoss.operation == 'long' and 'S' or 'B',                                      
--     ["STOPPRICE"] = tostring(tradePoss.stockPriceOut),                                 
--     ["PRICE"] = tostring(tradePoss.futuresPriceOut),                                        
--     ["EXPIRY_DATE"] = 'GTC',
--  }




-- function clearStopOrders(stopType)
--     local stopTypes
--     local accData = GV:getAccountData()
--     if stopType == 'long' then
--        stopTypes = GV:getLongActiveStops()
--     elseif stopType == 'short' then
--        stopTypes = GV:getShortActiveStops()
--     else
--        stopTypes = GV:getAllActiveStops()
--        message('All stops are deleted')
--     end

--     for i = 0, getNumberOf("stop_orders") - 1 do  
--        for k, v in ipairs(stopTypes) do  
--           local orderNum = getItem("stop_orders", i).order_num
--           local account = getItem("stop_orders", i).account
--           -- message('' .. account)
--           if getItem("stop_orders", i).flags == v and account == accData.trdaccid then   
--              local transaction = {
--                 ["TRANS_ID"] = Private:getTransId(Private.transIdStack),
--                 ["ACTION"] = "KILL_STOP_ORDER",
--                 ["SECCODE"] = Private.quikSetup.futures.SECCODE,                                        
--                 ["CLASSCODE"] = Private.quikSetup.futures.CLASSCODE,
--                 ["STOP_ORDER_KEY"] = tostring(orderNum),
--              }
--              resp = sendTransaction(transaction);
--              message(resp)
--           end
--        end
--     end
    
--  end


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