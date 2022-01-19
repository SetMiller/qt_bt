dofile(getScriptPath().."\\obj\\o_ChartData.lua")
dofile(getScriptPath().."\\obj\\o_HeikenAshi.lua")
dofile(getScriptPath().."\\stuff\\st_QuikData.lua")
dofile(getScriptPath().."\\user\\u_Options.lua")
dofile(getScriptPath().."\\state.lua")
--
--
--

function stack_init() end

function stack_init() 

    CD = ChartData:new(CANDLES_TO_CHECK)
    HA = HeikenAshi:new()

    dataSource(CLASS_CODE, SEC_CODE, INTERVAL)

   


end