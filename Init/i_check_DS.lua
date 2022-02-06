dofile(getScriptPath().."\\User\\u_UserOptions.lua")

function check_DataSource(class_code, sec_code, interval)

    local t, told, index, shortName

    ds_test, Error = CreateDataSource(class_code, sec_code, interval)

    index = ds_test:Size()
    -- told = ds_test:T(index).min

    if index == 0 then

        error(('bad DataSource index!\nPlease, open ' .. sec_code .. ' chart!!!\n(Index > 0 expected, got -> "%s")'):format(index), 2)

    else

        return true

    end
    
    --FIXME: Добавить проверку минимального и максимального стопа

end