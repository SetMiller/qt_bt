--
--
--
function o_isActiveStopOrderOnBoard() end
function o_isActiveOrderOnBoard()     end
--
--
--
-- function o_isActiveStopOrderOnBoard(orderNum, transId, t_type, p_type) 
    
--     if t_type == nil then error(("bad argument\n|| Orders\\o_isOrdersOnBoard.lua -> isActiveStopOrderOnBoard -> t_type ||\n('long or short' string expected, got -> '%s')"):format(t_type), 2) end
--     if p_type == nil then error(("bad argument\n|| Orders\\o_isOrdersOnBoard.lua -> isActiveStopOrderOnBoard -> p_type ||\n('open or close' string expected, got -> '%s')"):format(p_type), 2) end
    
--     local userOrderNum      = orderNum
--     local userTransId       = transId
--     local stopOrderFlags    = ''
--     local isFound           = false

--     if p_type == 'open' then

--         stopOrderFlags    = t_type == 'long' and OnStopOrder_ACTIVE.long or OnStopOrder_ACTIVE.short

--     elseif p_type == 'close' then

--         stopOrderFlags    = t_type == 'long' and OnStopOrder_ACTIVE.short or OnStopOrder_ACTIVE.long
        
--     else

--         error(("bad argument\n|| Orders\\o_isOrdersOnBoard.lua -> isActiveStopOrderOnBoard -> p_type ||\n('open or close' expected, got -> '%s')"):format(p_type), 2)
    
--     end
     
--     for i = 0, getNumberOf("stop_orders") - 1 do  
        
--         local order_num     = getItem("stop_orders", i).order_num
--         local trans_id      = getItem("stop_orders", i).trans_id
--         local flags         = getItem("stop_orders", i).flags

--         if order_num == userOrderNum and trans_id == userTransId then 
            
--             if flags == stopOrderFlags then

--                 isFound = true

--             end

--         end
--     end

--     return isFound

-- end

function o_isActiveStopOrderOnBoard(orderNum, transId) 
    
    -- if t_type == nil then error(("bad argument\n|| Orders\\o_isOrdersOnBoard.lua -> isActiveStopOrderOnBoard -> t_type ||\n('long or short' string expected, got -> '%s')"):format(t_type), 2) end
    -- if p_type == nil then error(("bad argument\n|| Orders\\o_isOrdersOnBoard.lua -> isActiveStopOrderOnBoard -> p_type ||\n('open or close' string expected, got -> '%s')"):format(p_type), 2) end
    
    local user_OrderNum         = orderNum
    local user_TransId          = transId
    local user_stopOrderFlags   = OnStopOrder_ACTIVE
    local isFound               = false

    -- if p_type == 'open' then

    --     stopOrderFlags    = t_type == 'long' and OnStopOrder_ACTIVE.long or OnStopOrder_ACTIVE.short

    -- elseif p_type == 'close' then

    --     stopOrderFlags    = t_type == 'long' and OnStopOrder_ACTIVE.short or OnStopOrder_ACTIVE.long
        
    -- else

    --     error(("bad argument\n|| Orders\\o_isOrdersOnBoard.lua -> isActiveStopOrderOnBoard -> p_type ||\n('open or close' expected, got -> '%s')"):format(p_type), 2)
    
    -- end
    for _, v in pairs(user_stopOrderFlags) do
        
        for i = 0, getNumberOf("stop_orders") - 1 do  
            
            local quik_order_num     = getItem("stop_orders", i).order_num
            local quik_trans_id      = getItem("stop_orders", i).trans_id
            local quik_flags         = getItem("stop_orders", i).flags

            if quik_order_num == user_OrderNum and quik_trans_id == user_TransId then 
                
                if quik_flags == v then

                    isFound = true

                end

            end
        end

    end
    return isFound

end

--
--
--
function o_isActiveOrderOnBoard(orderNum, transId, t_type)  
    
    if t_type == nil then error(("bad argument\n|| Orders\\o_isOrdersOnBoard.lua -> isActiveOrderOnBoard -> t_type ||\n('long or short' expected, got -> '%s')"):format(t_type), 2) end

    local userOrderNum      = orderNum
    local userTransId       = transId
    local orderFlags        = t_type == 'long' and OnOrder_ACTIVE.long or OnOrder_ACTIVE.short
    local isFound           = false

    for i = 0, getNumberOf("orders") - 1 do  
        local order_num     = getItem("orders", i).order_num
        local trans_id      = getItem("orders", i).trans_id
        local flags         = getItem("orders", i).flags
        
        if order_num == userOrderNum and trans_id == userTransId then 
            
            if flags == orderFlags then

                isFound = true

            end

        end
    end

    return isFound

end