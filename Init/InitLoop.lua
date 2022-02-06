

function initLoop()
    
    check_DSInterval(INTERVAL)
    check_TradeAccount(firmid, trdaccid)
    check_TradeType(TRADE_TYPE) 
    check_ClassCode(CLASS_CODE) 
    check_SecCodeDaysToMatDate(SEC_CODE, CLASS_CODE)
    
    check_DataSource(CLASS_CODE, SEC_CODE, INTERVAL)

    

    if STATE_KEYS.isRun then

        dataSource(CLASS_CODE, SEC_CODE, INTERVAL)

        PDK     = PossDataKeeper:new(TRADE_TYPE)
        LOGS    = Logs:new(TRADE_TYPE)

        CD      = ChartData:new(CANDLES_TO_CHECK)
        HA      = HeikenAshi:new()

        if STATE_INIT_CHECK.RISK_PER_TRADE then
            STATE_KEYS.isRun = false
            
            check_RiskPerTrade() 
    
        end

    end


    

end