dofile(getScriptPath().."\\Params\\p_State.lua")

dofile(getScriptPath().."\\Init\\i_check_UserOptions.lua")
dofile(getScriptPath().."\\Init\\i_check_DS.lua")
dofile(getScriptPath().."\\Init\\i_check_RiskPerTrade.lua")
dofile(getScriptPath().."\\Init\\InitLoop.lua")

dofile(getScriptPath().."\\User\\u_obj_Logs.lua")
dofile(getScriptPath().."\\User\\u_UserOptions.lua")
dofile(getScriptPath().."\\User\\u_ReadData.lua")
dofile(getScriptPath().."\\User\\u_StopKeys.lua")

dofile(getScriptPath().."\\Main loop\\m_obj_ChartData.lua")
dofile(getScriptPath().."\\Main loop\\m_obj_HeikenAshi.lua")
dofile(getScriptPath().."\\Main loop\\m_DS.lua")
dofile(getScriptPath().."\\Main loop\\m_QuikData.lua")
dofile(getScriptPath().."\\Main loop\\m_isOpenPatterns.lua")
dofile(getScriptPath().."\\Main loop\\m_isOutsideDayPattern.lua")
dofile(getScriptPath().."\\Main loop\\m_GOcalc.lua")
dofile(getScriptPath().."\\Main loop\\m_Lots.lua")
dofile(getScriptPath().."\\Main loop\\m_PossValueOnQuikBoard.lua")
dofile(getScriptPath().."\\Main loop\\MainLoop.lua")

dofile(getScriptPath().."\\Orders\\o_AddStopOrder.lua")
dofile(getScriptPath().."\\Orders\\o_ClearActiveStopOrder.lua")
dofile(getScriptPath().."\\Orders\\o_ClearActiveOrder.lua")
dofile(getScriptPath().."\\Orders\\o_isOrdersOnBoard.lua")
dofile(getScriptPath().."\\Orders\\o_TransId.lua")
dofile(getScriptPath().."\\Orders\\o_MarketClose.lua")

dofile(getScriptPath().."\\Possition\\p_obj_PossDataKeeper.lua")
dofile(getScriptPath().."\\Possition\\p_obj_OnStop.lua")
dofile(getScriptPath().."\\Possition\\p_obj_OnOrder.lua")

dofile(getScriptPath().."\\Callback loop\\c_obj_AwaitCounter.lua")
dofile(getScriptPath().."\\Callback loop\\c_OnQuikCallback.lua")
dofile(getScriptPath().."\\Callback loop\\CallbackLoop.lua")



--
-- Инициализация приложения
--
function OnInit()

    InitLoop()

end

-- function OnParam(class_code, sec_code)
--     if class_code =="SPBFUT" and sec_code == "SiH2" then
--         -- local val  = getParamEx(class_code, sec_code, "VALTODAY").param_value
--         -- Candle.update()
--     end
-- end

function OnStop()
   
   
    -- return 100
end

-- Запуск основного цикла приложения
--
function main()

    while STATE_KEYS.isRun do
        sleep(1)
        

        -- -- STACK 1 --
        -- if STATE_KEYS.onConnectLoopNeedToUpdate then


        -- end
        -------------


        -- STACK 2 --
        -- if STATE_KEYS.callbackLoopNeedToUpdate and not STATE_KEYS.onConnectLoopNeedToUpdate then
        if STATE_KEYS.callbackQueueProcessing then

            CallbackLoop()

        end
        -------------


        --STACK 3 --
        -- if STATE_KEYS.mainLoopNeedToUpdate and not STATE_KEYS.callbackLoopNeedToUpdate and not STATE_KEYS.onConnectLoopNeedToUpdate then
        if STATE_KEYS.mainLoopNeedToUpdate and not STATE_KEYS.callbackLoopNeedToUpdate and not STATE_KEYS.orderActivateProcessing and not STATE_KEYS.stopButtonPressed and not STATE_KEYS.callbackAwaiting then
            
            mainLoop() 
            

        end
        -------------

        collectgarbage()
        -- STATE_KEYS.isRun = false

    end

end

-- 
-- Функция обратного вызова для отслеживания восстановления соединения с сервером
--
function OnConnected()
    message('Connected')
end

-- 
-- Функция обратного вызова для отслеживания разрыва соединения с сервером
--
function OnDisconnected()
    message('Disconnected')
end

-- 
-- Функция обратного вызова для завершения работы привода
--
function OnStop()                                     
    STATE_KEYS.stopButtonPressed = true
    
    local futLimitTotalnet = 0

    futLimitTotalnet = getFuturesHolding(firmid, trdaccid, SEC_CODE, 0).totalnet

    if o_isActiveStopOrderOnBoard( PDK.getOnStopOrderNum(), PDK.getRoundTransId()) then
        -- message('activestop')
        o_clearStopOrder( PDK.getOnStopOrderNum(), PDK.getRoundTransId(), SEC_CODE, CLASS_CODE )

    end

    if futLimitTotalnet ~= 0 then
        PDK:creatRoundTransId()
        o_marketClose(futLimitTotalnet, SEC_CODE, CLASS_CODE, trdaccid, STATE_DATA.futuresParam.LAST + 100, STATE_DATA.futuresParam.LAST - 100, PDK:getRoundTransId(), STATE_DATA.futuresParam.SEC_SCALE)

    end

    STATE_KEYS.isRun = false
    LOGS:updateStringArr('--STOP BUTTON PUSHED--', '\n')  
end

-- function OnFuturesClientHolding(fut_limit)
--      -- отфильтровываем изменения по позиции по счету
--      if fut_limit.trdaccid == trdaccid and fut_limit.firmid == firmid and fut_limit.sec_code == SEC_CODE then
        
--         -- if fut_limit.totalnet ~= STATE_FUTLIMIT then

--             -- STATE_FUTLIMIT = fut_limit.totalnet
            
--             table.sinsert(STATE_QUEUE, {callback = "futLimit", fut_limit = fut_limit, callbackType = 'FutLimit'})

--         -- end

--      end
-- end


function OnStopOrder(order)
    -- отфильтровываем заявки по счету
    if order.account == trdaccid and order.firmid == firmid and order.sec_code == SEC_CODE then
        STATE_KEYS.callbackQueueProcessing = true
        table.sinsert(STATE_QUEUE, {callback = 'order', order = order, callbackType = 'OnStopOrder'})
    
    end   
end

function OnOrder(order)
    -- отфильтровываем заявки по счету
    if order.account == trdaccid and order.firmid == firmid and order.sec_code == SEC_CODE then
        STATE_KEYS.callbackQueueProcessing = true
        table.sinsert(STATE_QUEUE, {callback = 'order', order = order, callbackType = 'OnOrder'})
    
    end 
end


function OnTransReply(reply)

    if reply.account == trdaccid and reply.firm_id == firmid and reply.sec_code == SEC_CODE then
    


    end 

end