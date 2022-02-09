--
--
--
function CallbackLoop() end
--
--
--
-- function CallbackLoop()

--     if #STATE_ONFUTURESLIMITCHANGE_QUEUE == 0 and #STATE_ONORDER_QUEUE == 0 and #STATE_ONSTOP_QUEUE == 0 then
--         LOGS:updateStringArr("ONTRADE_QUEUE size " .. tostring(#STATE_ONTRADE_QUEUE) .. '\n')

--         callbackQueueProcessingOff() 

--     elseif #STATE_ONFUTURESLIMITCHANGE_QUEUE > 0 and #STATE_ONORDER_QUEUE == 0 and #STATE_ONSTOP_QUEUE == 0 then 
--         LOGS:updateStringArr("ONFUTURESLIMITCHANGE_QUEUE size " .. tostring(#STATE_ONFUTURESLIMITCHANGE_QUEUE) .. '\n')
                
--         onTradeCallback(STATE_ONFUTURESLIMITCHANGE_QUEUE[1])
--         table.sremove(STATE_ONFUTURESLIMITCHANGE_QUEUE, 1)

--         LOGS:updateStringArr("ONFUTURESLIMITCHANGE_QUEUE size left " .. tostring(#STATE_ONFUTURESLIMITCHANGE_QUEUE) .. '\n')
--     elseif #STATE_ONORDER_QUEUE > 0 and #STATE_ONSTOP_QUEUE == 0 then
--         LOGS:updateStringArr("ONORDER_QUEUE size " .. tostring(#STATE_ONORDER_QUEUE) .. '\n')

--         onOrderCallback(STATE_ONORDER_QUEUE[1])
--         table.sremove(STATE_ONORDER_QUEUE, 1)

--         LOGS:updateStringArr("ONORDER_QUEUE size left " .. tostring(#STATE_ONORDER_QUEUE) .. '\n')
--     elseif #STATE_ONSTOP_QUEUE > 0 then
--         LOGS:updateStringArr("ONSTOP_QUEUE size " .. tostring(#STATE_ONSTOP_QUEUE) .. '\n')
        
--         onStopCallback(STATE_ONSTOP_QUEUE[1])
--         table.sremove(STATE_ONSTOP_QUEUE, 1)

--         LOGS:updateStringArr("ONSTOP_QUEUE size left " .. tostring(#STATE_ONSTOP_QUEUE) .. '\n')
--     end

-- end

function CallbackLoop()

    if #STATE_QUEUE == 0 then
        LOGS:updateStringArr("QUEUE size " .. tostring(#STATE_QUEUE) .. '\n')

        callbackQueueProcessingOff() 

    elseif #STATE_QUEUE > 0 then
        LOGS:updateStringArr("QUEUE size " .. tostring(#STATE_QUEUE) .. '\n')
        
        callbackQueueProcessing(STATE_QUEUE[1])
        table.sremove(STATE_QUEUE, 1)

        LOGS:updateStringArr("QUEUE size left " .. tostring(#STATE_QUEUE) .. '\n')
    end

end