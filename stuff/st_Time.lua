-- 
-- Функционал для получения данных по времени
--

function st_GetServerTime()     end
function st_GetOsTime()         end

function st_FixTime()           end
function st_IsWorkingDay()      end
function st_IsMarketOpen()      end

function st_IsAllowedToTrade()  end


--
--  Получаем время сервера
--
function st_GetServerTime() 
    local res = nil
    local status = true
    
    res = getInfoParam( "SERVERTIME" )

    if res == "" then 
        res = "Server doesn't response!"  
        status = false
    end

    return res, status  -- 14:59:10, true
end


--
--  Получаем время операционной системы
--
function st_GetOsTime()
    return os.date( "%X", os.time() )  -- 14:59:10
end


--
--  Подготовка данных о времени в требуемый формат
--
function st_FixTime(time)
    if type(time) ~= 'string' then error(("bad argument dataType: st_Time.lua -> st_FixTime -> (string expected, got %s)"):format(type(time)), 2) end

    local time = time
    local Out = os.date("!*t",os.time())
    local len = string.len(time)

    if len>6 then
       Out.hour,Out.min,Out.sec = string.match(time,"(%d%d)%p(%d%d)%p(%d%d)")
    elseif len==6 then
       Out.hour,Out.min,Out.sec  = string.match(time,"(%d%d)(%d%d)(%d%d)")
    elseif len==5 then
       Out.hour,Out.min,Out.sec  = string.match(time,"(%d)(%d%d)(%d%d)")
    end
    return Out  -- ассоциативный список [["hour"] = .. ,["min"] = ..]
end


--
--  Определяем рабочий или выходной день
--
function st_IsWorkingDay()        
    local weekday           = nil
    local isWorkingDay      = false
    local enumWorkingWeek   = { 1, 5 }      -- FIXME: перенести переменные в u_GlobalVar
    local enumWeekDays      = {             -- FIXME: перенести переменные в u_GlobalVar
        "sunday",
        "monday",
        "tuesday",
        "wednesday",
        "thursday",
        "friday",
        "saturday"
    }

    weekday = os.date( "%w", os.time() )
    
    if tonumber( weekday ) >= enumWorkingWeek[ 1 ] and tonumber( weekday ) <= enumWorkingWeek[ 2 ] then
        isWorkingDay = true
    end

    return isWorkingDay, enumWeekDays[ weekday + 1 ]   -- true, monday
end

--
--  Определяем допустимол ли торговать сейчас относительно времени работы биржи
--
function st_IsMarketOpen() 
    local timeToCheck       = nil
    local fixedTime         = nil
    local result            = false
    local marketOpen        = nil
    local marketClose       = nil 
    local marketSession     = {
        { "07:05:00", "13:59:29" },     -- FIXME: перенести переменные в u_GlobalVar
        { "14:05:00", "18:44:29" },
        -- { "19:05:00", "23:49:29" },
    }

    timeToCheck = st_GetOsTime()
    fixedTime = st_FixTime(timeToCheck)
    
    for i = 1, #marketSession do

        marketOpen      = st_FixTime(marketSession[i][1])
        marketClose     = st_FixTime(marketSession[i][2])

        if os.time(fixedTime) >= os.time(marketOpen) and os.time(fixedTime) <= os.time(marketClose) then
            result = true
        end
    end

    return result   -- false/true
end


--
--  Определяем можно ли торговать в зависимости от дня недели и времени
--
function st_IsAllowedToTrade()  

    if st_IsMarketOpen() and st_IsWorkingDay() then
        return true
    else
        return false
    end

end