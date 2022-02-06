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
dofile(getScriptPath().."\\Main loop\\MainLoop.lua")

dofile(getScriptPath().."\\Orders\\o_AddStopOrder.lua")
dofile(getScriptPath().."\\Orders\\o_ClearActiveStopOrder.lua")
dofile(getScriptPath().."\\Orders\\o_ClearActiveOrder.lua")
dofile(getScriptPath().."\\Orders\\o_isOrdersOnBoard.lua")
dofile(getScriptPath().."\\Orders\\o_TransId.lua")

dofile(getScriptPath().."\\Possition\\p_obj_PossDataKeeper.lua")
--
-- Инициализация приложения
--
function OnInit()

    initLoop()

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
        
        sleep(2)

        -- STACK 1
        if STATE_KEYS.onConnectLoopNeedToUpdate then
        end
        --


        -- STACK 2
        if STATE_KEYS.callbackLoopNeedToUpdate and not STATE_KEYS.onConnectLoopNeedToUpdate then

            if #STATE_ONTRADE_QUEUE > 0 and #STATE_ONORDER_QUEUE == 0 and #STATE_ONSTOP_QUEUE == 0 then 
                
            elseif #STATE_ONORDER_QUEUE > 0 and #STATE_ONSTOP_QUEUE == 0 then

            elseif #STATE_ONSTOP_QUEUE > 0 then
                
            end

        end
        --


        --STACK 3
        if STATE_KEYS.mainLoopNeedToUpdate and not STATE_KEYS.callbackLoopNeedToUpdate and not STATE_KEYS.onConnectLoopNeedToUpdate then
            
            mainLoop() 
            
            STATE_KEYS.mainLoopNeedToUpdate = false

        end
        --

        -- if STATE_KEYS.callbackProcessing then
        --     STATE_COUNTER = STATE_COUNTER + 1
        --     if STATE_COUNTER == 10000 then
        --         message('STATE_COUNTER get 10000')
        --         STATE_KEYS.isRun = false
        --     end
        -- end


        
        -- counter = counter + 1
        collectgarbage()
        STATE_KEYS.isRun = false

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
    -- LOGS:close()
end

function OnFuturesLimitChange(fut_limit)
    --TODO: меняем позу отсюда!!
    -- OnQuikCallbackProcessing(fut_limit, STATE_ONSTOP_QUEUE, "OnStopOrder")
end

function OnTransReply()
    -- message('OnTransReply')
end

function OnStopOrder(order)
    -- OnQuikCallbackProcessing(order, STATE_ONSTOP_QUEUE, "OnStopOrder")
end

function OnOrder(order)
    -- OnQuikCallbackProcessing(order, STATE_ONORDER_QUEUE, "OnOrder")
end

function OnTrade(order)
    -- OnQuikCallbackProcessing(order, STATE_ONTRADE_QUEUE, "OnTrade")
end



-- первый стоп - смотри флаг, если активный, то записываем id и номер заявки
-- в конце проверяем заполнение данных и ставим флаг что стоп активен и установлен
-- если заполнены данные только по стопу (флаг активен)

-- стоп активирован - смотрим, если наши данные совпадают с активированным стопом
-- и у активированного стопа новый флаг, то меняем флаг
-- так же заполняем данные по OnOrder и OnTrade
-- если все данные заполнены и флаги совпадают с маской, то обновляем данные по позиции и ДЕПО
-- старые данные по tradePossStruct обнуляем (можно созранять в переменную и обнулять ее)
-- при флаге активной стоп заявки, создавать переменную и заполнять ее данными