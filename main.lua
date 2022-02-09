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
        if STATE_KEYS.mainLoopNeedToUpdate and not STATE_KEYS.callbackLoopNeedToUpdate and not STATE_KEYS.orderActivateProcessing and not STATE_KEYS.stopButtonPressed then
            
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
    local p_type = ''

    futLimitTotalnet = getFuturesHolding(firmid, trdaccid, SEC_CODE, 0).totalnet

    if futLimitTotalnet == 0 then
        p_type = 'open'
    else
        p_type = 'close'
    end
    
    if o_isActiveStopOrderOnBoard( PDK.getOnStopOrderNum(), PDK.getRoundTransId(), TRADE_TYPE, p_type ) then

        o_clearStopOrder( PDK.getOnStopOrderNum(), PDK.getRoundTransId(), SEC_CODE, CLASS_CODE )

    end

    if futLimitTotalnet ~= 0 then
        
        o_marketClose(futLimitTotalnet, SEC_CODE, CLASS_CODE, trdaccid, STATE_DATA.futuresParam.PRICEMAX, STATE_DATA.futuresParam.PRICEMIN, PDK:creatRoundTransId())

    end

    STATE_KEYS.isRun = false
    LOGS:updateStringArr('--STOP BUTTON PUSHED--', '\n')  
end

function OnFuturesClientHolding(fut_limit)
    callbackQueueProcessingOn("FutLimit")
    table.sinsert(STATE_QUEUE, {callback = "futLimit", fut_limit = fut_limit})

end


function OnStopOrder(order)
    callbackQueueProcessingOn("OnStopOrder") 
    table.sinsert(STATE_QUEUE, {callback = 'order', order = order})
end

function OnOrder(order)
    callbackQueueProcessingOn("OnOrder")
    table.sinsert(STATE_QUEUE, {callback = 'order', order = order})
end
