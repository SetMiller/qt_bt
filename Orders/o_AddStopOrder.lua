--
--
--
function o_stopOrderOpenPoss()    end
function o_stopOrderClosePoss()   end
--
--
--
function o_stopOrderOpenPoss(StopPrice, Price, Lots, SecScale, Trans_id)
    local stopOrder         = {}
    local priceSecScale     = '%.' .. tonumber(string.format('%.0f', SecScale)) .. 'f'

    stopOrder = {
        ["ACTION"] = "NEW_STOP_ORDER",                              
        ["ACCOUNT"] = trdaccid, 
        ["TRANS_ID"] = tostring(Trans_id),                         
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

function o_stopOrderClosePoss(StopPrice, Price, Lots, SecScale, Trans_id)
    local stopOrder         = {}
    local priceSecScale     = '%.' .. tonumber(string.format('%.0f', SecScale)) .. 'f'

    stopOrder = {
        ["ACTION"] = "NEW_STOP_ORDER",                              
        ["ACCOUNT"] = trdaccid, 
        ["TRANS_ID"] = tostring(Trans_id),                         
        ["CLASSCODE"] = CLASS_CODE,                                          
        ["SECCODE"] = SEC_CODE,                                        
        ["OPERATION"] = TRADE_TYPE == 'long' and 'S' or 'B',                                      
        -- ["QUANTITY"] = TRADE_TYPE == 'long' and tostring(Lots) or tostring(Lots * (-1)),  
        ["QUANTITY"] = tostring(Lots),  
        ["CLIENT_CODE"] = TRADE_TYPE .. ' close',                              
        ["STOPPRICE"] = tostring(tonumber(string.format(priceSecScale, StopPrice))),                                 
        ["PRICE"] = tostring(tonumber(string.format(priceSecScale, Price))),                                        
        ["EXPIRY_DATE"] = 'GTC',
    }

    return stopOrder
end
