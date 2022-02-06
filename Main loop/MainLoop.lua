

function mainLoop()

    local p_type_open   = 'open' 
    local p_type_close  = 'close'

    -- пока запрашиваю каждый раз, потому можно через OnParam
    STATE_DATA.futuresParam         = getParamTable(CLASS_CODE, SEC_CODE, STATE_FUTURESPARAM)

    -- получаем свечки
    STATE_DATA.chartCandles         = CD:update(ds)                                                                 -- получаем массив стандартных
    STATE_DATA.heikenAshiCandles    = HA:update(STATE_DATA.chartCandles, STATE_DATA.futuresParam.SEC_SCALE)         -- получаем массив конвертированных в heikenAshi свечек
    
    -- STAGE 1 - если нет открытой позиции
    if PDK.getTotalNet() == 0 then

        -- STAGE 1.1 - если есть активный стоп на открытие позиции
        if isActiveStopOrderOnBoard( PDK.getOpenOrderNum(), PDK.getOpenTransId(), TRADE_TYPE, p_type_open ) then
            
            clearStopOrder( PDK.getOpenOrderNum(), PDK.getOpenTransId(), SEC_CODE, CLASS_CODE )
            -- clearActiveOrder(1953472407507440070, 13 )

        -- STAGE 1.2 - если нет активного стопа на открытие позиции  
        else
            
            -- Определяем доступные средства и считаем сколько будет стоп в рублях
            STATE_DATA.depoLimit            = getDepoLimit(firmid, trdaccid, limitType, currcode)           -- получаем данные по ДЕПО
            STATE_DATA.riskPerTrade         = getRiskPerTrade(STATE_DATA.depoLimit, RISK_PER_TRADE)         -- расчитываем риск на 1 сделку в рублях

            -- Определяем наличие паттерна TODO: если паттерна нет, то пропускаем
            if TRADE_TYPE == 'long' then  STATE_KEYS.isPatterns = is_LongPatterns(STATE_DATA.heikenAshiCandles) else STATE_KEYS.isPatterns = is_ShortPatterns(STATE_DATA.heikenAshiCandles) end

            --FIXME:
            STATE_KEYS.isPatterns = true

            if STATE_KEYS.isPatterns then

                -- message(TRADE_TYPE .. ' pattern')
                --FIXME: добавить проверку что цена последней сделки не вышла за диапазон свечки
                
                if TRADE_TYPE == 'long' then
                    STATE_POSS.OpenStopPrice    = STATE_DATA.heikenAshiCandles[1].high + STATE_DATA.futuresParam.SEC_PRICE_STEP * SEC_PRICE_STEP_OFFSET
                    STATE_POSS.OpenPrice        = STATE_DATA.heikenAshiCandles[1].high + STATE_DATA.futuresParam.SEC_PRICE_STEP * PRICE_SLIPPAGE
                    STATE_POSS.CloseStopPrice   = STATE_DATA.heikenAshiCandles[1].low - STATE_DATA.futuresParam.SEC_PRICE_STEP * SEC_PRICE_STEP_OFFSET
                    STATE_POSS.ClosePrice       = STATE_DATA.heikenAshiCandles[1].low - STATE_DATA.futuresParam.SEC_PRICE_STEP * PRICE_SLIPPAGE
                else
                    STATE_POSS.OpenStopPrice    = STATE_DATA.heikenAshiCandles[1].low - STATE_DATA.futuresParam.SEC_PRICE_STEP * SEC_PRICE_STEP_OFFSET
                    STATE_POSS.OpenPrice        = STATE_DATA.heikenAshiCandles[1].low - STATE_DATA.futuresParam.SEC_PRICE_STEP * PRICE_SLIPPAGE
                    STATE_POSS.CloseStopPrice   = STATE_DATA.heikenAshiCandles[1].high + STATE_DATA.futuresParam.SEC_PRICE_STEP * SEC_PRICE_STEP_OFFSET
                    STATE_POSS.ClosePrice       = STATE_DATA.heikenAshiCandles[1].high + STATE_DATA.futuresParam.SEC_PRICE_STEP * PRICE_SLIPPAGE
                end
        
                STATE_KEYS.possGO   = GOcalc(STATE_DATA.futuresParam, STATE_POSS.OpenStopPrice, TRADE_TYPE)
                STATE_POSS.Lots     = Lots(STATE_POSS, STATE_DATA.futuresParam, STATE_KEYS.possGO, STATE_DATA.riskPerTrade, STATE_DATA.depoLimit)
                
                if STATE_POSS.Lots > 0 then
                    
                    -- формируем номер транзкции для стопа на открытие позиции и сохраняем его в объекте
                    PDK:setAwaitOpenTransId(o_transId())

                    -- формируем транзакцию
                    STATE_ORDER.OpenPoss    = stopOrderOpenPoss(STATE_POSS.OpenStopPrice, STATE_POSS.OpenPrice, STATE_POSS.Lots, STATE_DATA.futuresParam.SEC_SCALE, PDK:getAwaitOpenTransId())
                   
                    -- ожидаемый объем по транзакции
                    PDK:setAwaitTotalNet(STATE_POSS.Lots)

                    -- отправляем транзакцию
                    local respOpen = sendTransaction(STATE_ORDER.OpenPoss)
                    message(respOpen)
                    -- st_readData(STATE_ORDER.OpenPoss)
                    --FIXME: запускаем счетчик ожидания ответа???

                else

                    message("mainLoop STAGE 1.2 Lots = " .. tostring(STATE_POSS.Lots))
                    
                end
            else
                -- ничего не делаем
                message(TRADE_TYPE .. ' NO pattern')

            end
        end
        
        -- STAGE 2 - если есть открытая позиция
    else
        -- STAGE 2.1 - если есть активный стоп на закрытие позиции

        if isActiveStopOrderOnBoard( PDK.getCloseOrderNum(), PDK.getCloseTransId(), TRADE_TYPE, p_type_close ) then
            message('STAGE 2.1')
            
            if not isOutsideCandlePattern(STATE_DATA.heikenAshiCandles) then
                message('STAGE 2.1.1')

                clearStopOrder(PDK.getCloseOrderNum(), PDK.getCloseTransId(), SEC_CODE, CLASS_CODE)
                
                -- else
                
                -- внешний день, ничего не делаем
                
            end
            
        -- STAGE 2.2 - если нет активного стопа на закрытие позиции
        else
            message('STAGE 2.2')
            
            if TRADE_TYPE == 'long' then
                STATE_POSS.CloseStopPrice   = STATE_DATA.heikenAshiCandles[1].low - STATE_DATA.futuresParam.SEC_PRICE_STEP * SEC_PRICE_STEP_OFFSET
                STATE_POSS.ClosePrice       = STATE_DATA.heikenAshiCandles[1].low - STATE_DATA.futuresParam.SEC_PRICE_STEP * PRICE_SLIPPAGE
            else
                STATE_POSS.CloseStopPrice   = STATE_DATA.heikenAshiCandles[1].high + STATE_DATA.futuresParam.SEC_PRICE_STEP * SEC_PRICE_STEP_OFFSET
                STATE_POSS.ClosePrice       = STATE_DATA.heikenAshiCandles[1].high + STATE_DATA.futuresParam.SEC_PRICE_STEP * PRICE_SLIPPAGE
            end

            -- берем данные по объему открытой позиции
            STATE_POSS.Lots = PDK.getTotalNet()

            -- формируем номер транзкции для стопа на открытие позиции и сохраняем его в объекте
            PDK:setAwaitCloseTransId(o_transId())

            -- формируем транзакцию
            STATE_ORDER.ClosePoss    = stopOrderClosePoss(STATE_POSS.CloseStopPrice, STATE_POSS.ClosePrice, STATE_POSS.Lots, STATE_DATA.futuresParam.SEC_SCALE, PDK:getAwaitCloseTransId())
           
            -- отправляем транзакцию
            local respOpen = sendTransaction(STATE_ORDER.ClosePoss)
            message(respOpen)
            -- st_readData(STATE_ORDER.ClosePoss)


            --отправить стоп на закрытие позиции
            
        end
        
    end
    
    STATE_KEYS.mainLoopUpdate = false
    
end






-- STATE_ORDER.ClosePoss     = stopOrderClosePoss(STATE_POSS.CloseStopPrice, STATE_POSS.ClosePrice, STATE_POSS.Lots, STATE_DATA.futuresParam.SEC_SCALE)
-- st_readData(STATE_ORDER.OpenPoss)
