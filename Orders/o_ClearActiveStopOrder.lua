--
--
--
function o_clearStopOrder() end
--
--
--
function o_clearStopOrder(orderNum, transId, sec_code, class_code)

    local userOrderNum      = orderNum
    local userTransId       = transId
    local userSecCode       = sec_code
    local userClassCode     = class_code

    for i = 0, getNumberOf("stop_orders") - 1 do  

        local order_num     = getItem("stop_orders", i).order_num
        local trans_id      = getItem("stop_orders", i).trans_id
            
        if order_num == userOrderNum and trans_id == userTransId then 

            local transaction = {
                ["TRANS_ID"]        = tostring(userTransId),
                ["ACTION"]          = "KILL_STOP_ORDER",
                ["SECCODE"]         = userSecCode,                                        
                ["CLASSCODE"]       = userClassCode,
                ["STOP_ORDER_KEY"]  = tostring(userOrderNum),
            }

            resp = sendTransaction(transaction);
            message(resp)

        end
    end
end