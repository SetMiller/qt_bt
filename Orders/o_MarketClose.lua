--
--
--
function o_marketClose() end
--
--
-- транзакции для закрытия всех открытых позиций
function o_marketClose(totalnet, sec_code, class_code, trdaccid, maxprice, minprice, trans_id)
    -- messsage('2')
    local user_totalnet      = totalnet
    local user_maxprice      = maxprice
    local user_minprice      = minprice
    local user_sec_code      = sec_code
    local user_class_code    = class_code
    local user_trdaccid      = trdaccid
    local user_trans_id      = trans_id
    
    for i = 0, getNumberOf("futures_client_holding") - 1 do   
        local quik_sec_code = getItem("futures_client_holding", i).sec_code
        local quik_account = getItem("stop_orders", i).account
        if quik_sec_code == user_sec_code and quik_account == user_trdaccid then
            local transactionData = {
                ["ACTION"]      = "NEW_ORDER"; 
                ["TYPE"]        = "M"; 
                ["SECCODE"]     = user_sec_code; 
                ["CLASSCODE"]   = user_class_code; 
                ["ACCOUNT"]     = user_trdaccid; 
                ["CLIENT_CODE"] = 'marketClose'; 
                ["QUANTITY"]    = user_totalnet > 0 and tostring(user_totalnet) or user_totalnet < 0 and tostring(user_totalnet * (-1)),  
                ["TRANS_ID"]    = user_trans_id,          
                ["OPERATION"]   = user_totalnet > 0 and 'S' or user_totalnet < 0 and 'B',                                      
                ["PRICE"]       = user_totalnet > 0 and user_minprice or user_totalnet < 0 and user_maxprice;           
            }

            resp = sendTransaction(transactionData)

            if user_totalnet > 0 then message("Long possitions closed") else message("Short possitions closed") end
        end
    end
    

 end