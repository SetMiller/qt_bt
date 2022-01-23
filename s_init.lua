dofile(getScriptPath().."\\obj\\o_ChartData.lua")
dofile(getScriptPath().."\\obj\\o_HeikenAshi.lua")
dofile(getScriptPath().."\\obj\\o_Logs.lua")

dofile(getScriptPath().."\\stuff\\st_QuikData.lua")
dofile(getScriptPath().."\\user\\u_Options.lua")
dofile(getScriptPath().."\\state.lua")
--
--
--

function s_init() end

function s_init() 

    CD      = ChartData:new(CANDLES_TO_CHECK)
    HA      = HeikenAshi:new()
    LOGS    = Logs:new(TRADE_TYPE)

    dataSource(CLASS_CODE, SEC_CODE, INTERVAL)

end