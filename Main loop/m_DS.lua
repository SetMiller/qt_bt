dofile(getScriptPath().."\\Params\\p_State.lua")


function dataSource(class_code, sec_code, interval)

    -- if class_code ~= 'long' and TRADE_TYPE ~= 'short' then error(("check TRADE_TYPE in user -> u_Options -> (must be 'long or short', got '%s')"):format(TRADE_TYPE), 2) end
    -- if sec_code ~= 'long' and TRADE_TYPE ~= 'short' then error(("check TRADE_TYPE in user -> u_Options -> (must be 'long or short', got '%s')"):format(TRADE_TYPE), 2) end
    -- if interval ~= 'long' and TRADE_TYPE ~= 'short' then error(("check TRADE_TYPE in user -> u_Options -> (must be 'long or short', got '%s')"):format(TRADE_TYPE), 2) end

    ds, Error = CreateDataSource(class_code, sec_code, interval)
    local t, tOld, index
    index = ds:Size()
    tOld = ds:T(index).min

    if index == 0 then
        STATE_KEYS.isRun = false
        -- LOGS:update('ds index =' .. index, '\n')
        -- LOGS:update('!!! PROGRAM CLOSE !!!', '\n')
        message('ds index =' .. index .. '.\nPlease, open ' .. SEC_CODE .. ' chart!!!')
    end

    STATE_KEYS.mainLoopNeedToUpdate = true
    
    function cb()
        index = ds:Size()
        t = ds:T(index).min

        if t ~= tOld then
            tOld = t

            STATE_KEYS.mainLoopNeedToUpdate = true     -- если новая свечка, то обновляем данные по свечкам

        end
        
    end
    ds: SetUpdateCallback(cb)
end
