dofile(getScriptPath().."\\obj\\o_ChartData.lua")
dofile(getScriptPath().."\\obj\\o_HeikenAshi.lua")

dofile(getScriptPath().."\\stuff\\st_Patterns.lua")
dofile(getScriptPath().."\\stuff\\st_QuikData.lua")
dofile(getScriptPath().."\\stuff\\st_GOcalc.lua")
dofile(getScriptPath().."\\stuff\\st_PossLotsCalc.lua")

dofile(getScriptPath().."\\user\\u_Options.lua")
dofile(getScriptPath().."\\user\\u_State.lua")
--
--
--

function s_update() end

function s_update() 
    STATE_DATA.depoLimit            = getDepoLimit(firmid, trdaccid, limitType, currcode)           -- получаем данные по ДЕПО
    STATE_DATA.riskPerTrade         = getRiskPerTrade(STATE_DATA.depoLimit, RISK_PER_TRADE)         -- расчитываем риск на 1 сделку в рублях
    STATE_DATA.totalNet             = getTotalNet(trdaccid, SEC_CODE)                               -- получаем данные о стопе
    STATE_DATA.futuresParam         = getParamTable(CLASS_CODE, SEC_CODE, enum_FuturesParam)        -- получаем данные из таблицы параметров для фьючерса
    -- message("init depoLimit =" .. STATE_DATA.depoLimit)
    -- message("init totalNet =" .. STATE_DATA.totalNet)

    STATE_DATA.chartCandles         = CD:update(ds)                             -- получаем массив стандартных
    STATE_DATA.heikenAshiCandles    = HA:update(STATE_DATA.chartCandles)        -- получаем массив конвертированных в heikenAshi свечек

    -- Определяем наличие паттерна TODO: если паттерна нет, то пропускаем
    if TRADE_TYPE == 'long' then  STATE_KEYS.isPatterns = is_LongPatterns(STATE_DATA.heikenAshiCandles) else STATE_KEYS.patterns = is_ShortPatterns(STATE_DATA.heikenAshiCandles) end

    -- Если паттерн есть, то считаем позицию и тд
    -- if STATE_KEYS.isPatterns then

        -- message('pattern found')
        -- Если long скрипт, то считаем лонговый вариант позиции

        --FIXME: обязательно копируем в буфер данные стопа по предыдущей свечке и если нынешний хвост смещен более
        -- чем хвост первой свечки (по которой была набрана поза), то оставить предыдущий вариант (можно даже без
        -- буфера, а просто не менять положение стопа)

        if TRADE_TYPE == 'long' then
            STATE_POSS.OpenStopPrice    = STATE_DATA.heikenAshiCandles[1].high + STATE_DATA.futuresParam.SEC_PRICE_STEP * SEC_PRICE_STEP_OFFSET
            STATE_POSS.OpenPrice        = STATE_DATA.heikenAshiCandles[1].high + STATE_DATA.futuresParam.SEC_PRICE_STEP * PRICE_SLIPPAGE
            STATE_POSS.CloseStopPrice   = STATE_DATA.heikenAshiCandles[1].low - STATE_DATA.futuresParam.SEC_PRICE_STEP * SEC_PRICE_STEP_OFFSET
            STATE_POSS.ClosePrice       = STATE_DATA.heikenAshiCandles[1].low - STATE_DATA.futuresParam.SEC_PRICE_STEP * PRICE_SLIPPAGE
            
            -- Если short скрипт, то считаем шортовый вариант позиции
        else
            STATE_POSS.OpenStopPrice    = STATE_DATA.heikenAshiCandles[1].low - STATE_DATA.futuresParam.SEC_PRICE_STEP * SEC_PRICE_STEP_OFFSET
            STATE_POSS.OpenPrice        = STATE_DATA.heikenAshiCandles[1].low - STATE_DATA.futuresParam.SEC_PRICE_STEP * PRICE_SLIPPAGE
            STATE_POSS.CloseStopPrice   = STATE_DATA.heikenAshiCandles[1].high + STATE_DATA.futuresParam.SEC_PRICE_STEP * SEC_PRICE_STEP_OFFSET
            STATE_POSS.ClospPrice       = STATE_DATA.heikenAshiCandles[1].high + STATE_DATA.futuresParam.SEC_PRICE_STEP * PRICE_SLIPPAGE
        end

        STATE_KEYS.possGO = GOcalc(STATE_DATA.futuresParam, STATE_POSS.OpenStopPrice, TRADE_TYPE)

        
        STATE_POSS.Lots = PossLotsCalc(STATE_POSS, STATE_DATA.futuresParam, STATE_KEYS.possGO, STATE_DATA.riskPerTrade, STATE_DATA.depoLimit)
        
        message("OpenStop:" .. tostring(STATE_POSS.OpenStopPrice) .. "\nOpen:" .. tostring(STATE_POSS.OpenPrice) .. " \nCloseStop:" .. tostring(STATE_POSS.CloseStopPrice) .. " \nClose:" .. tostring(STATE_POSS.ClosePrice) .. " \npossGO:" .. tostring(STATE_KEYS.possGO))
        message(tostring(STATE_POSS.Lots))
    
    -- else
        
        -- message('pattern not found')
        
    -- end
    
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