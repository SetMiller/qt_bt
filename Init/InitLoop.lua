

function InitLoop()
    
    check_DSInterval(INTERVAL)
    check_TradeAccount(firmid, trdaccid)
    check_TradeType(TRADE_TYPE) 
    check_ClassCode(CLASS_CODE) 
    check_SecCodeDaysToMatDate(SEC_CODE, CLASS_CODE)
    
    check_DataSource(CLASS_CODE, SEC_CODE, INTERVAL)

    

    if STATE_KEYS.isRun then
        
        PDK     = PossDataKeeper:new(TRADE_TYPE)
        LOGS    = Logs:new(TRADE_TYPE)
        
        CD      = ChartData:new(CANDLES_TO_CHECK)
        HA      = HeikenAshi:new()

        CD2      = ChartData:new(1200)
        -- OnStopObj  = OnStopObj:new()
        -- On_Order = OnOrder:new()
        
        dataSource(CLASS_CODE, SEC_CODE, INTERVAL)
        check_RiskPerTrade(CD2) 

        -- AC      = AwaitCounter:new(1000)

        -- if STATE_INIT_CHECK.RISK_PER_TRADE then
        --     STATE_KEYS.isRun = false
            
    
        -- end

    end


    

end