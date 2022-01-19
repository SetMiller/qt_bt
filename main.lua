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


    while STATE_KEYS.isRun do
        
        sleep(100)
        -- if counter > 30000 then is_run = false end

        if STATE_KEYS.update then
            
            stack_update()
            
            STATE_KEYS.update = false
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
    message('OnStopOrder --------------------->')

    message('0 bit =' .. tostring(checkBit(order.flags, 0)))
    message('1 bit =' .. tostring(checkBit(order.flags, 1)))
    message('2 bit =' .. tostring(checkBit(order.flags, 2)))
    message('3 bit =' .. tostring(checkBit(order.flags, 3)))
    message('5 bit =' .. tostring(checkBit(order.flags, 5)))
    message('6 bit =' .. tostring(checkBit(order.flags, 6)))
    message('8 bit =' .. tostring(checkBit(order.flags, 8)))
    message('9 bit =' .. tostring(checkBit(order.flags, 9)))
    message('10 bit =' .. tostring(checkBit(order.flags, 10)))
    message('11 bit =' .. tostring(checkBit(order.flags, 11)))
    message('12 bit =' .. tostring(checkBit(order.flags, 12)))
    message('13 bit =' .. tostring(checkBit(order.flags, 13)))
    message('15 bit =' .. tostring(checkBit(order.flags, 15)))

    -- for k, v in pairs(order) do
    --     if type(v) ~= 'table' then
    --         if k == 'trans_id' or k == 'flags' then
    --             message(k .. " =" .. v)
    --         end
    --     end
    -- end
    
    message('<--------------------- OnStopOrder')
end

function OnOrder(order)
    message('OnOrder --------------------->')

    message('0 bit =' .. tostring(checkBit(order.flags, 0)))
    message('1 bit =' .. tostring(checkBit(order.flags, 1)))
    message('2 bit =' .. tostring(checkBit(order.flags, 2)))
    message('3 bit =' .. tostring(checkBit(order.flags, 3)))
    message('4 bit =' .. tostring(checkBit(order.flags, 4)))
    message('5 bit =' .. tostring(checkBit(order.flags, 5)))
    message('6 bit =' .. tostring(checkBit(order.flags, 6)))
    message('7 bit =' .. tostring(checkBit(order.flags, 7)))
    message('8 bit =' .. tostring(checkBit(order.flags, 8)))
    message('9 bit =' .. tostring(checkBit(order.flags, 9)))
    message('10 bit =' .. tostring(checkBit(order.flags, 10)))
    message('20 bit =' .. tostring(checkBit(order.flags, 20)))

    -- for k, v in pairs(order) do
    --     if type(v) ~= 'table' then
    --         if k == 'trans_id' or k == 'flags' then
    --             message(k .. " =" .. v)
    --         end
    --     end
    -- end
    
    message('<--------------------- OnOrder')
end

function OnTrade(trade)
    message('**OnTrade --------------------->')

    message('0 bit =' .. tostring(checkBit(order.flags, 0)))
    message('2 bit =' .. tostring(checkBit(order.flags, 2)))
    message('3 bit =' .. tostring(checkBit(order.flags, 3)))
    message('4 bit =' .. tostring(checkBit(order.flags, 4)))
    message('5 bit =' .. tostring(checkBit(order.flags, 5)))
    message('6 bit =' .. tostring(checkBit(order.flags, 6)))
    message('7 bit =' .. tostring(checkBit(order.flags, 7)))
    message('8 bit =' .. tostring(checkBit(order.flags, 8)))

    -- for k, v in pairs(trade) do
    --     if type(v) ~= 'table' then
    --         if k == 'trans_id' or k == 'flags' then
    --             message(k .. " =" .. v)
    --         end
    --     end
    -- end

    message('<--------------------- OnTrade**')
end
-- function OnOrder()
--     message('OnOrder')
-- end

function checkBit(flags, _bit)
    -- Проверяет, что переданные аргументы являются числами
    if type(flags) ~= "number" then error(Private.logicType .. " Error!!! Checkbit: 1-st argument is not a number!") end
    if type(_bit) ~= "number" then error(Private.logicType .. " Error!!! Checkbit: 2-nd argument is not a number!") end
 
    if _bit == 0 then _bit = 0x1
    elseif _bit == 1 then _bit = 0x2
    elseif _bit == 2 then _bit = 0x4
    elseif _bit == 3 then _bit = 0x8
    elseif _bit == 4 then _bit = 0x10
    elseif _bit == 5 then _bit = 0x20
    elseif _bit == 6 then _bit = 0x40
    elseif _bit == 7 then _bit = 0x80
    elseif _bit == 8 then _bit = 0x100
    elseif _bit == 9 then _bit = 0x200
    elseif _bit == 10 then _bit = 0x400
    elseif _bit == 11 then _bit = 0x800
    elseif _bit == 12 then _bit = 0x1000
    elseif _bit == 13 then _bit = 0x2000
    elseif _bit == 14 then _bit = 0x4000
    elseif _bit == 15 then _bit = 0x8000
    elseif _bit == 16 then _bit = 0x10000
    elseif _bit == 17 then _bit = 0x20000
    elseif _bit == 18 then _bit = 0x40000
    elseif _bit == 19 then _bit = 0x80000
    elseif _bit == 20 then _bit = 0x100000
    end
 
    if bit.band(flags,_bit ) == _bit then return true
    else return false end
 end