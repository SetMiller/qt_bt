dofile(getScriptPath().."\\user\\u_State.lua")
dofile(getScriptPath().."\\stuff\\st_StateDump.lua")
dofile(getScriptPath().."\\stuff\\st_Order.lua")

--
--
--

function OnStopCallbackProcessing() end
function OnOrderCallbackProcessing() end
function OnTradeCallbackProcessing() end
function OnQuikCallbackProcessing() end

--
--
--

function OnStopCallbackProcessing(queue)

    LOGS:update(queue.callback, '\n')
    st_readData_W(queue.order)



end

function OnOrderCallbackProcessing(queue) 

    -- st_readData_W(queue.order)

end

function OnTradeCallbackProcessing(queue) 

    -- st_readData_W(queue.order)

end

function OnQuikCallbackProcessing(order, queue, callbackType)
    
    if order.account == trdaccid and order.firmid == firmid and order.sec_code == SEC_CODE then

        -- STATE_KEYS.callbackProcessing = true
        if order.flags == 25 or order.flags == 29 then
            table.sinsert(queue, {callback = "OnStopOrder active", order = order})

        elseif order.flags == 24 or order.flags == 28 then
            table.sinsert(queue, {callback = "OnStopOrder activated", order = order})

        elseif order.flags == 1048600 and order.trans_id ~=0 or order.flags == 1048604 and order.trans_id ~=0 then
            
        end



    end

end