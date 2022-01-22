dofile(getScriptPath().."\\user\\u_Options.lua")
dofile(getScriptPath().."\\garbage.lua")
dofile(getScriptPath().."\\obj\\o_ChartData.lua")
dofile(getScriptPath().."\\obj\\o_HeikenAshi.lua")
dofile(getScriptPath().."\\stack_init.lua")
dofile(getScriptPath().."\\stack_update.lua")
dofile(getScriptPath().."\\dataSource.lua")
dofile(getScriptPath().."\\stuff\\st_QuikData.lua")
dofile(getScriptPath().."\\state.lua")




--
-- Инициализация приложения
--
function OnInit()
    stack_init()
    MAIN_QUEUE = {}
    -- message("init STATE_DATA.depoLimit =" .. STATE_DATA.depoLimit)

    

end

-- function OnParam(class_code, sec_code)
--     if class_code =="SPBFUT" and sec_code == "SiH2" then
--         -- local val  = getParamEx(class_code, sec_code, "VALTODAY").param_value
--         -- Candle.update()
--     end
-- end

function OnStop()
    STATE_KEYS.isRun = false
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

    f = io.open(getScriptPath()..'\\STOP_INFO.txt','w') 

    while STATE_KEYS.isRun do
        
        sleep(100)
        -- if counter > 30000 then is_run = false end
        if #MAIN_QUEUE > 0 then 
            f:write("QUEUE size " .. tostring(#MAIN_QUEUE) .. '\n')
            f:flush()
            -- message("QUEUE size " .. tostring(#MAIN_QUEUE))
            ProcessingCallback(MAIN_QUEUE[1])
            table.sremove(MAIN_QUEUE, 1)

            f:write("QUEUE size left " .. tostring(#MAIN_QUEUE) .. '\n')
            f:write('\n')
            f:flush()
            
        else


            if STATE_KEYS.update then
                
                stack_update()
                
                STATE_KEYS.update = false
            end
        end

        
        -- counter = counter + 1
        -- message(tostring(STATE_DATA.depoLimit))
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
    f:close()
end

function OnFuturesLimitChange(fut_limit)

    -- local depo = fut_limit.cbp_prev_limit + fut_limit.varmargin + fut_limit.accruedint 
    
    -- if STATE_DATA.depoLimit ~= depo then
    --     STATE_DATA.depoLimit = depo
    --     -- message("update depoLimit =" .. STATE_DATA.depoLimit)

    --     STATE_DATA.totalNet = getTotalNet(trdaccid, SEC_CODE)
    --     message("update totalNet =" .. STATE_DATA.totalNet)
    -- end
    



    -- message("callback STATE_DATA.depoLimit =" .. STATE_DATA.depoLimit)
    -- for k, v in pairs(fut_limit) do
    --     message(k .. " =" .. v)
    -- end

    -- читаем первые данные в инит
    -- далее коллбэком обновляем данные в глобале
end

function OnTransReply()
    -- message('OnTransReply')
end

function OnStopOrder(order)
    table.sinsert(MAIN_QUEUE, {callback = "OnStopOrder", order = order, enum = enum_OnStopOrder})
    -- message('OnStopOrder --------------------->')
    
    
    -- message(ReadData(order) .. '\n' .. ReadBitData(order, enum_OnStopOrder))
    
    
    -- message('<--------------------- OnStopOrder')
end

function OnOrder(order)
    table.sinsert(MAIN_QUEUE, {callback = "OnOrder", order = order, enum = enum_OnOrder})
    -- message('OnOrder --------------------->')
    
    -- message(ReadData(order) .. '\n' .. ReadBitData(order, enum_OnOrder))
    
    -- message('<--------------------- OnOrder')
end

function OnTrade(order)
    table.sinsert(MAIN_QUEUE, {callback = "OnTrade", order = order, enum = enum_OnTrade})
    -- message('**OnTrade --------------------->')

    -- message(ReadData(order) .. '\n' .. ReadBitData(order, enum_OnTrade))

    -- message('<--------------------- OnTrade**')
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