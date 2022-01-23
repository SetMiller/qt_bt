dofile(getScriptPath().."\\user\\u_State.lua")


function dataSource(class_code, sec_code, interval)
    ds, Error = CreateDataSource(class_code, sec_code, interval)
    local t, tOld, index
    index = ds:Size()
    tOld = ds:T(index).min

    STATE_KEYS.update = true
    
    function cb()
        index = ds:Size()
        t = ds:T(index).min

        if t ~= tOld then
            tOld = t

            STATE_KEYS.update = true     -- если новая свечка, то обновляем данные по свечкам

        end
        
    end
    ds: SetUpdateCallback(cb)
end
