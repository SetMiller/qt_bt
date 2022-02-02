dofile(getScriptPath().."\\obj\\o_ChartData.lua")
dofile(getScriptPath().."\\obj\\o_HeikenAshi.lua")

dofile(getScriptPath().."\\stuff\\st_Patterns.lua")
dofile(getScriptPath().."\\stuff\\st_QuikData.lua")
dofile(getScriptPath().."\\stuff\\st_GOcalc.lua")
dofile(getScriptPath().."\\stuff\\st_PossLotsCalc.lua")

dofile(getScriptPath().."\\user\\u_Options.lua")
dofile(getScriptPath().."\\user\\u_State.lua")

dofile(getScriptPath().."\\stuff\\st_ReadData.lua")

--
--
--

function st_newPossStops()   end
function st_moveStop()      end

--
--
--


--FIXME: Добавить передачу объема, если он есть, то брать его в позу, если нет, то считать отдельно
function st_newPossStops() 


    --FIXME: достаточно запрашивать при выставлении первого стопа???
    STATE_DATA.depoLimit            = getDepoLimit(firmid, trdaccid, limitType, currcode)           -- получаем данные по ДЕПО
    STATE_DATA.riskPerTrade         = getRiskPerTrade(STATE_DATA.depoLimit, RISK_PER_TRADE)         -- расчитываем риск на 1 сделку в рублях
    
    --FIXME: достаточно 1 раз запросить данные???
    STATE_DATA.futuresParam         = getParamTable(CLASS_CODE, SEC_CODE, enum_FuturesParam)        -- получаем данные из таблицы параметров для фьючерса
    -- message("init riskPerTrade =" .. STATE_DATA.riskPerTrade)
    -- message("init totalNet =" .. STATE_DATA.totalNet)

    STATE_DATA.chartCandles         = CD:update(ds)                                                 -- получаем массив стандартных
    STATE_DATA.heikenAshiCandles    = HA:update(STATE_DATA.chartCandles, STATE_DATA.futuresParam.SEC_SCALE)        -- получаем массив конвертированных в heikenAshi свечек

    -- Определяем наличие паттерна TODO: если паттерна нет, то пропускаем
    if TRADE_TYPE == 'long' then  STATE_KEYS.isPatterns = is_LongPatterns(STATE_DATA.heikenAshiCandles) else STATE_KEYS.patterns = is_ShortPatterns(STATE_DATA.heikenAshiCandles) end

    -- --FIXME:
    STATE_KEYS.isPatterns = true


    -- Если паттерн есть, то считаем позицию и тд
    --FIXME: вынести логику паттерна в отдельный блок, расчет позы оставить независимым
    if STATE_KEYS.isPatterns then

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
            STATE_POSS.ClosePrice       = STATE_DATA.heikenAshiCandles[1].high + STATE_DATA.futuresParam.SEC_PRICE_STEP * PRICE_SLIPPAGE
        end

        STATE_KEYS.possGO = GOcalc(STATE_DATA.futuresParam, STATE_POSS.OpenStopPrice, TRADE_TYPE)

        
        STATE_POSS.Lots = PossLotsCalc(STATE_POSS, STATE_DATA.futuresParam, STATE_KEYS.possGO, STATE_DATA.riskPerTrade, STATE_DATA.depoLimit)
        
        if STATE_POSS.Lots == 0 then
            message("init Lots =" .. tostring(STATE_POSS.Lots))
        end

        -- message("OpenStop:" .. tostring(STATE_POSS.OpenStopPrice) .. "\nOpen:" .. tostring(STATE_POSS.OpenPrice) .. " \nCloseStop:" .. tostring(STATE_POSS.CloseStopPrice) .. " \nClose:" .. tostring(STATE_POSS.ClosePrice) .. " \npossGO:" .. tostring(STATE_KEYS.possGO))
        -- 
    
        STATE_ORDER.PossIN      = stopOrderOpenPoss(STATE_POSS.OpenStopPrice, STATE_POSS.OpenPrice, STATE_POSS.Lots, STATE_DATA.futuresParam.SEC_SCALE)
        STATE_ORDER.PossOUT     = stopOrderClosePoss(STATE_POSS.CloseStopPrice, STATE_POSS.ClosePrice, STATE_POSS.Lots, STATE_DATA.futuresParam.SEC_SCALE)
        


        -- local resp1 = sendTransaction(STATE_ORDER.PossIN)
        -- STATE_KEYS.callbackProcessing = true
        -- local resp2 = sendTransaction(STATE_ORDER.PossOUT)
        -- message(resp1)
    else
        
        message('pattern not found')
        
    end

    
end