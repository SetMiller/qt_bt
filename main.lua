dofile(getScriptPath().."\\user\\u_Options.lua")
dofile(getScriptPath().."\\stuff\\st_ReadData.lua")

dofile(getScriptPath().."\\obj\\o_ChartData.lua")
dofile(getScriptPath().."\\obj\\o_HeikenAshi.lua")
dofile(getScriptPath().."\\init\\i_Init.lua")
dofile(getScriptPath().."\\init\\i_ds.lua")

dofile(getScriptPath().."\\loop\\loop_Update.lua")
dofile(getScriptPath().."\\loop\\loop_cbp.lua")

dofile(getScriptPath().."\\stuff\\st_QuikData.lua")
dofile(getScriptPath().."\\user\\u_State.lua")

dofile(getScriptPath().."\\stuff\\st_Order.lua")

dofile(getScriptPath().."\\test\\st_shortOrders_test.lua")


--
-- Инициализация приложения
--
function OnInit()
    i_Init()
    
    -- message("init STATE_DATA.depoLimit =" .. STATE_DATA.depoLimit)

    -- for k, v in pairs(STATE_ACTIVE_ONSTOP) do
    --     message(STATE_ACTIVE_ONSTOP[k])
    -- end
    OnQuikCallbackProcessing(SHORT_STOP_ACTIVE, STATE_ONSTOP_QUEUE)
    OnQuikCallbackProcessing(SHORT_STOP_ACTIVATED, STATE_ONSTOP_QUEUE)
end

-- function OnParam(class_code, sec_code)
--     if class_code =="SPBFUT" and sec_code == "SiH2" then
--         -- local val  = getParamEx(class_code, sec_code, "VALTODAY").param_value
--         -- Candle.update()
--     end
-- end

function OnStop()
    STATE_KEYS.isRun = false
    LOGS:close()
    -- return 100
end

-- function Run()
--     message("size "..ds:Size())
-- end
-- 
-- Запуск основного цикла приложения
--
function main()
    
    --TODO: обернуть в функцию проверки правильности введенных данных из Options
    if TRADE_TYPE ~= 'long' and TRADE_TYPE ~= 'short' then error(("check TRADE_TYPE in user -> u_Options -> (must be 'long or short', got '%s')"):format(TRADE_TYPE), 2) end

    
    -- local a = stopOrderOpenPoss(78697, 78797, 1, 1)
    -- local b = stopOrderOpenPoss(78797, 78897, 2)

    -- respa = sendTransaction(a)
    -- message(tostring(respa))
    -- respb = sendTransaction(b)
    -- message(tostring(respb))



    while STATE_KEYS.isRun do
        
        sleep(2)
        -- if counter > 30000 then is_run = false end
        if #STATE_ONTRADE_QUEUE > 0 and #STATE_ONORDER_QUEUE == 0 and #STATE_ONSTOP_QUEUE == 0 then 
            LOGS:update("ONTRADE_QUEUE size " .. tostring(#STATE_ONTRADE_QUEUE) .. '\n')

            -- message("QUEUE size " .. tostring(#MAIN_QUEUE))
            
            OnTradeCallbackProcessing(STATE_ONTRADE_QUEUE[1])


            table.sremove(STATE_ONTRADE_QUEUE, 1)
            LOGS:update("ONTRADE_QUEUE size left " .. tostring(#STATE_ONTRADE_QUEUE) .. '\n', '\n')
            
        elseif #STATE_ONORDER_QUEUE > 0 and #STATE_ONSTOP_QUEUE == 0 then
            LOGS:update("ONORDER_QUEUE size " .. tostring(#STATE_ONORDER_QUEUE) .. '\n')

            -- message("QUEUE size " .. tostring(#MAIN_QUEUE))
            
            OnOrderCallbackProcessing(STATE_ONORDER_QUEUE[1])

            
            table.sremove(STATE_ONORDER_QUEUE, 1)
            LOGS:update("ONORDER_QUEUE size left " .. tostring(#STATE_ONORDER_QUEUE) .. '\n', '\n')
        elseif #STATE_ONSTOP_QUEUE > 0 then
            LOGS:update("ONSTOP_QUEUE size " .. tostring(#STATE_ONSTOP_QUEUE) .. '\n')

            -- message("QUEUE size " .. tostring(#MAIN_QUEUE))
            
            OnStopCallbackProcessing(STATE_ONSTOP_QUEUE[1])

            
            table.sremove(STATE_ONSTOP_QUEUE, 1)
            LOGS:update("ONSTOP_QUEUE size left " .. tostring(#STATE_ONSTOP_QUEUE) .. '\n', '\n')
        end


        if STATE_KEYS.update and not STATE_KEYS.callbackProcessing then
            
            loop_update() 
            
            STATE_KEYS.update = false
        end

        -- if STATE_KEYS.callbackProcessing then
        --     STATE_COUNTER = STATE_COUNTER + 1
        --     if STATE_COUNTER == 10000 then
        --         message('STATE_COUNTER get 10000')
        --         STATE_KEYS.isRun = false
        --     end
        -- end


        
        -- counter = counter + 1
        collectgarbage()
        -- STATE_KEYS.isRun = false
    end
end

-- 
-- Функция обратного вызова для отслеживания восстановления соединения с сервером
--
function OnConnected()

end

-- 
-- Функция обратного вызова для отслеживания разрыва соединения с сервером
--
function OnDisconnected()

end

-- 
-- Функция обратного вызова для завершения работы привода
--
function OnStop()                                                         
    LOGS:close()
end

function OnFuturesLimitChange(fut_limit)

end

function OnTransReply()
    -- message('OnTransReply')
end

function OnStopOrder(order)
    OnQuikCallbackProcessing(order, STATE_ONSTOP_QUEUE, "OnStopOrder")
end

function OnOrder(order)
    OnQuikCallbackProcessing(order, STATE_ONORDER_QUEUE, "OnOrder")
end

function OnTrade(order)
    OnQuikCallbackProcessing(order, STATE_ONTRADE_QUEUE, "OnTrade")
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