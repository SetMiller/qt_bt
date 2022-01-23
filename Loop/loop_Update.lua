-- dofile(getScriptPath().."\\obj\\o_ChartData.lua")
-- dofile(getScriptPath().."\\obj\\o_HeikenAshi.lua")

-- dofile(getScriptPath().."\\stuff\\st_Patterns.lua")
-- dofile(getScriptPath().."\\stuff\\st_QuikData.lua")
-- dofile(getScriptPath().."\\stuff\\st_GOcalc.lua")
-- dofile(getScriptPath().."\\stuff\\st_PossLotsCalc.lua")

-- dofile(getScriptPath().."\\user\\u_Options.lua")
dofile(getScriptPath().."\\user\\u_State.lua")

-- dofile(getScriptPath().."\\stuff\\st_ReadData.lua")
dofile(getScriptPath().."\\stuff\\st_PossStops.lua")
--
--
--

function loop_update() end
-- STATE_ACTIVE_ONSTOP = {
--     ['trans_id'] = 0,
    -- ['order_num'] = 0,
--
--
--

function loop_update() 
    STATE_DATA.totalNet             = getTotalNet(trdaccid, SEC_CODE)                               -- получаем данные о стопе
    
    -- 1.1 старт программы (нет позиции, нет стопов)
    
    -- 1.2 нет позиции (активный стоп), (новая свеча) нужно снять стоп и перезапустить цикл 1.1

    
    -- 2.1 есть позиция (нет стопов), (старая свеча) нужно поставить стоп

    -- 2.2 есть позиция (активный стоп), (новая свеча) нужно снять стоп и поставить новый со старым объемом


    -- 3.1 закрытие позиции (нет стопов), перезапустить цикл 1.1
        -- STATE_DATA.totalNet == 0





    -- if STATE_DATA.totalNet == 0 and STATE_ACTIVE_ONSTOP.trans_id == 0 and STATE_ACTIVE_ONSTOP.order_num == 0 then
        
    --     if STATE_ACTIVE_ONSTOP.qty == 0 then
    --         st_newPossStops()
    --         local resp = sendTransaction(STATE_ORDER.PossIN)
    --         -- message(resp)
    --         STATE_KEYS.callbackProcessing = true
    --     else
    --         --расчитать новые точки, но с старым объемом
    --     end
        
    --     -- позиции нет, заявка есть (новая свечка, старая не сработала)
    -- elseif STATE_DATA.totalNet == 0 and STATE_ACTIVE_ONSTOP.trans_id ~= 0 and STATE_ACTIVE_ONSTOP.order_num ~= 0 then
        
    --     clearStopOrders(STATE_ACTIVE_ONSTOP.order_num, STATE_ACTIVE_ONSTOP.trans_id)
    --     STATE_KEYS.callbackProcessing = true
        
    -- elseif STATE_DATA.totalNet ~= 0 and STATE_ACTIVE_ONSTOP.trans_id == 0 and STATE_ACTIVE_ONSTOP.order_num == 0 then
        
    --     -- local resp = sendTransaction(STATE_ORDER.PossOUT)
    --     -- -- message(resp)
    --     -- STATE_KEYS.callbackProcessing = true

    -- elseif STATE_DATA.totalNet ~= 0 and STATE_ACTIVE_ONSTOP.trans_id ~= 0 and STATE_ACTIVE_ONSTOP.order_num ~= 0 then

    --     -- st_moveStop()
    -- end


    -- local resp2 = sendTransaction(STATE_ORDER.PossOUT)
    -- message(resp2)

    -- st_readData(STATE_ORDER.PossIN)
    -- st_readData(STATE_ORDER.PossOUT)
    
    -- TODO:    -- отдельный цикл для формировании позы и заявок
    -- и сделать по ключу что позиция сформирована уже отправку и отслеживание

    -- STATE_DATA.depoLimit            = getDepoLimit(firmid, trdaccid, limitType, currcode)               -- получаем данные по ДЕПО

    -- TODO: в зависимости от типа скрипта присвоить точку входа с сдвигом и передать для расчета ГО
    -- STATE_DATA.priceIn              = 
    -- STATE_DATA.possGO               = TRADE_TYPE == 'long' and GOcalc(Sec, go, deal_price, possType) or GOcalc(Sec, go, deal_price, possType)
   

    -- STATE_DATA.possGO = GOcalc(STATE_DATA.futuresParam, STATE_DATA.futuresParam.PRICEMIN, 'long')
    
    
    -- STATE_DATA.possGO = GOcalc(STATE_DATA.futuresParam, STATE_DATA.futuresParam.PRICEMIN, 'short')
    
   
   
   
   
   
   
   
   
   
   
    -- for k = #STATE_DATA.heikenAshiCandles, #STATE_DATA.heikenAshiCandles - 4, -1 do
    --     message("O:" .. tostring(STATE_DATA.heikenAshiCandles[k].open) .. " \nH:" .. tostring(STATE_DATA.heikenAshiCandles[k].high) .. " \nL:" .. tostring(STATE_DATA.heikenAshiCandles[k].low) .. " \nC:" .. tostring(STATE_DATA.heikenAshiCandles[k].close) .. " \nT:" .. tostring(STATE_DATA.heikenAshiCandles[k].datetime.hour) .. " " .. tostring(STATE_DATA.heikenAshiCandles[k].datetime.min))
    -- end
    -- for k, v in pairs(STATE_DATA.futuresParam) do
    --     message(k .. " =" .. STATE_DATA.futuresParam[k])
    -- end

    -- is_Patterns(CD.getCandlesArr())
    -- HA:update(CD:getCandlesArr())
    -- STATE_KEYS.patterns.long = is_LongPatterns(HA.getCandlesArr())

    -- message(tostring(STATE.patterns.long))

    -- getDepoLimit(firmid, trdaccid, limitType, currcode)
    -- getParamTable(CLASS_CODE, SEC_CODE, enum_FuturesParamData)
end