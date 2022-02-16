

function mainLoop()

    LOGS:updateStringArr('--mainLoop Start--', '\n')

    -- local p_type_open   = 'open' 
    -- local p_type_close  = 'close'

    -- пока запрашиваю каждый раз, потому можно через OnParam
    STATE_DATA.futuresParam         = getParamTable(CLASS_CODE, SEC_CODE, STATE_FUTURESPARAM)

    -- получаем свечки
    STATE_DATA.chartCandles         = CD:update(ds)                                                                 -- получаем массив стандартных
    STATE_DATA.heikenAshiCandles    = HA:update(STATE_DATA.chartCandles, STATE_DATA.futuresParam.SEC_SCALE)         -- получаем массив конвертированных в heikenAshi свечек
    
    -- STAGE 1 - если нет открытой позиции
    -- if PDK.getTotalNet() == 0 then
    if PDK:getPossValue() == 0 then

        -- STAGE 1.1 - если есть активный стоп на открытие позиции
        if o_isActiveStopOrderOnBoard( PDK.getOnStopOrderNum(), PDK.getRoundTransId(), TRADE_TYPE ) then
            
            STATE_KEYS.callbackAwaiting = true
            o_clearStopOrder( PDK.getOnStopOrderNum(), PDK.getRoundTransId(), SEC_CODE, CLASS_CODE )
            LOGS:updateStringArr('  NO POSS clearStopOrder', '\n')
            -- st_readData(PDK:debugAwait())


        -- STAGE 1.2 - если нет активного стопа на открытие позиции  
        else
            
            -- Определяем доступные средства и считаем сколько будет стоп в рублях
            STATE_DATA.depoLimit            = getDepoLimit(firmid, trdaccid, limitType, currcode)           -- получаем данные по ДЕПО
            STATE_DATA.riskPerTrade         = getRiskPerTrade(STATE_DATA.depoLimit, RISK_PER_TRADE)         -- расчитываем риск на 1 сделку в рублях

            -- Определяем наличие паттерна TODO: если паттерна нет, то пропускаем
            if TRADE_TYPE == 'long' then  STATE_KEYS.isPatterns = is_LongPatterns(STATE_DATA.heikenAshiCandles, STATE_DATA.futuresParam.LAST) else STATE_KEYS.isPatterns = is_ShortPatterns(STATE_DATA.heikenAshiCandles, STATE_DATA.futuresParam.LAST) end

            --FIXME:
            -- STATE_KEYS.isPatterns = true

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

                --FIXME:
                STATE_KEYS.possGO   = GOcalc(STATE_DATA.futuresParam, STATE_POSS.OpenPrice, TRADE_TYPE)
                STATE_POSS.Lots     = Lots(STATE_POSS, STATE_DATA.futuresParam, STATE_KEYS.possGO, STATE_DATA.riskPerTrade, STATE_DATA.depoLimit)
                -- STATE_POSS.Lots     = 1
                --FIXME:
                -- if TRADE_TYPE == 'long' then
                --     STATE_POSS.OpenStopPrice = tostring(tonumber(STATE_DATA.futuresParam.LAST) + 3)
                -- else
                --     STATE_POSS.OpenStopPrice = tostring(tonumber(STATE_DATA.futuresParam.LAST) - 3)
                -- end
                    

                if STATE_POSS.Lots > 0 then
                    
                    -- формируем номер транзкции для стопа на открытие позиции и сохраняем его в объекте
                    -- PDK:setAwaitTransId(o_transId())
                    PDK:creatRoundTransId()

                    -- формируем транзакцию
                    STATE_ORDER.OpenPoss    = o_stopOrderOpenPoss(STATE_POSS.OpenStopPrice, STATE_POSS.OpenPrice, STATE_POSS.Lots, STATE_DATA.futuresParam.SEC_SCALE, PDK:getRoundTransId())
                   
                    -- ожидаемый объем по транзакции
                    PDK:setRoundTotalNet(STATE_POSS.Lots)
                    -- PDK:setAwaitTotalNet(STATE_POSS.Lots)
                    -- PDK:setAwaitPossType(p_type_open)

                    STATE_KEYS.callbackAwaiting = true
                    -- отправляем транзакцию
                    local respOpen = sendTransaction(STATE_ORDER.OpenPoss)
                    message(respOpen)

                    -- st_readData(STATE_ORDER.OpenPoss)

                    LOGS:updateStringArr('  OPEN POSS sendTransaction ', 'Lots = ', STATE_POSS.Lots , '\n')

                    st_readData_W(PDK:getRoundObj())

                    -- ожидаем обработки транзакции квиком
                    -- onQuikCallbackProcessingStart() 

                else

                    message("mainLoop STAGE 1.2 Lots = " .. tostring(STATE_POSS.Lots))
                    
                end
            else

                message(TRADE_TYPE .. ' NO pattern')

            end
        end
        
        -- STAGE 2 - если есть открытая позиция
    else
        -- STAGE 2.1 - если есть активный стоп на закрытие позиции
        if o_isActiveStopOrderOnBoard( PDK.getOnStopOrderNum(), PDK.getRoundTransId(), TRADE_TYPE, p_type_close ) then
            -- message('STAGE 2.1')
            
            if not m_isOutsideCandlePattern( STATE_DATA.heikenAshiCandles ) then
                -- message('STAGE 2.1.1')
                
                STATE_KEYS.callbackAwaiting = true
                o_clearStopOrder( PDK.getOnStopOrderNum(), PDK.getRoundTransId(), SEC_CODE, CLASS_CODE )
                LOGS:updateStringArr('  POSS clearStopOrder', '\n')
                -- st_readData(PDK:debugAwait())

                -- ожидаем обработки транзакции квиком
                -- onQuikCallbackProcessingStart() 

            else
                
                message('outside candle')
                
            end
            
        -- STAGE 2.2 - если нет активного стопа на закрытие позиции
        else
            -- message('STAGE 2.2')
            
            if TRADE_TYPE == 'long' then
                STATE_POSS.CloseStopPrice   = STATE_DATA.heikenAshiCandles[1].low - STATE_DATA.futuresParam.SEC_PRICE_STEP * SEC_PRICE_STEP_OFFSET
                STATE_POSS.ClosePrice       = STATE_DATA.heikenAshiCandles[1].low - STATE_DATA.futuresParam.SEC_PRICE_STEP * PRICE_SLIPPAGE
            else
                STATE_POSS.CloseStopPrice   = STATE_DATA.heikenAshiCandles[1].high + STATE_DATA.futuresParam.SEC_PRICE_STEP * SEC_PRICE_STEP_OFFSET
                STATE_POSS.ClosePrice       = STATE_DATA.heikenAshiCandles[1].high + STATE_DATA.futuresParam.SEC_PRICE_STEP * PRICE_SLIPPAGE
            end

            -- берем данные по объему открытой позиции
            --TODO: проверить значение при шорте!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            STATE_POSS.Lots = PDK:getPossValue()
            -- STATE_POSS.Lots = getFuturesHolding(firmid, trdaccid, SEC_CODE, 0).totalnet

            --FIXME:
            -- if TRADE_TYPE == 'long' then
            --     STATE_POSS.CloseStopPrice = tostring(tonumber(STATE_DATA.futuresParam.LAST) - 3)
            -- else
            --     STATE_POSS.CloseStopPrice = tostring(tonumber(STATE_DATA.futuresParam.LAST) + 3)
            -- end
            

            -- формируем номер транзкции для стопа на открытие позиции и сохраняем его в объекте
            PDK:creatRoundTransId()

            -- формируем транзакцию
            STATE_ORDER.ClosePoss    = o_stopOrderClosePoss(STATE_POSS.CloseStopPrice, STATE_POSS.ClosePrice, STATE_POSS.Lots, STATE_DATA.futuresParam.SEC_SCALE, PDK:getRoundTransId())
           
            -- ожидаемый объем по транзакции
            -- PDK:setAwaitTotalNet(0)
            -- PDK:setAwaitPossType(p_type_close)

            STATE_KEYS.callbackAwaiting = true
            -- отправляем транзакцию
            local respClose = sendTransaction(STATE_ORDER.ClosePoss)
            message(respClose)
            LOGS:updateStringArr('  CLOSE POSS sendTransaction ', 'Lots = ', STATE_POSS.Lots , '\n')
            -- st_readData(STATE_ORDER.ClosePoss)
            -- st_readData(PDK:debugAwait())

            -- ожидаем обработки транзакции квиком
            -- onQuikCallbackProcessingStart() 

        end
        
    end
    
    STATE_KEYS.mainLoopNeedToUpdate = false
    LOGS:updateStringArr('--mainLoop End--', '\n')
end


