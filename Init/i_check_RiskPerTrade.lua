--
--
--
function check_RiskPerTrade() end
--
--
--
function check_RiskPerTrade() 
    local deltaArr = {}
    local delta = 0
    local deltaInMoney = 0

    local deltaOk = 0
    local deltaNo = 0
    local futures_sec_scale = ''

    STATE_DATA.futuresParam         = getParamTable(CLASS_CODE, SEC_CODE, STATE_FUTURESPARAM)
    futures_sec_scale               = '%.' .. tonumber(string.format('%.0f', STATE_DATA.futuresParam.SEC_SCALE)) .. 'f'

    -- получаем свечки
    STATE_DATA.chartCandles         = CD:update(ds)                                                                 -- получаем массив стандартных
    STATE_DATA.heikenAshiCandles    = HA:update(STATE_DATA.chartCandles, STATE_DATA.futuresParam.SEC_SCALE) 

    -- Определяем доступные средства и считаем сколько будет стоп в рублях
    STATE_DATA.depoLimit            = getDepoLimit(firmid, trdaccid, limitType, currcode)           -- получаем данные по ДЕПО
    STATE_DATA.riskPerTrade         = getRiskPerTrade(STATE_DATA.depoLimit, RISK_PER_TRADE)
    
    
    for i = #STATE_DATA.heikenAshiCandles, 1, -1 do
        
        delta = tonumber(string.format(futures_sec_scale, STATE_DATA.heikenAshiCandles[i].high + STATE_DATA.futuresParam.SEC_PRICE_STEP * SEC_PRICE_STEP_OFFSET - STATE_DATA.heikenAshiCandles[i].low - STATE_DATA.futuresParam.SEC_PRICE_STEP * SEC_PRICE_STEP_OFFSET ))
        deltaInMoney = math.ceil( delta / STATE_DATA.futuresParam.SEC_PRICE_STEP * STATE_DATA.futuresParam.STEPPRICE )
        
        -- st_readData_W({['delta'] = delta})
        -- st_readData_W({['deltaInMoney'] = deltaInMoney})
        
        if deltaInMoney >= STATE_DATA.riskPerTrade then
            deltaArr[i] = false
        else
            deltaArr[i] = true
        end
        
    end
    
    for _, v in ipairs(deltaArr) do
        
        if v then
            deltaOk = deltaOk + 1
        else
            deltaNo = deltaNo + 1
        end
        
        
    end
    
    LOGS:updateStringArr('#### Risk Per Trade check ####', '\n')
    st_readData_W({['SEC_CODE'] = SEC_CODE})
    st_readData_W({['RISK_PER_TRADE'] = RISK_PER_TRADE * 100 .. '%'})
    st_readData_W({['riskPerTrade'] = STATE_DATA.riskPerTrade .. ' rub.'})
    st_readData_W({['deltaOk'] = deltaOk .. ' candles', ['deltaNo'] = deltaNo .. ' candles'})
    LOGS:updateStringArr('##############################', '\n')

end