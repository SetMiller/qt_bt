--
--
--

function st_transId() end
function st_checkTransId() end
function st_loadTransId() end
function st_updateTransId() end

--
--
--

function st_transId()
    local initCount     = '1000000'
    local count         = 0
    local newCount      = 0

    -- проверяем наличие файла
    st_checkTransId(initCount)

    -- читаем данные
    count = st_loadTransId()

    -- сохраняем новые данные
    st_updateTransId(count)
    
    return count
end


function st_checkTransId(initCount)
    local f             = ''
    local countCheck    = ''
    local initCount     = initCount

    f = io.open(getScriptPath()..'\\logs\\randomCount.txt','r+')
    countCheck = f:read('*n')

    if f == nil or countCheck == nil or tonumber(countCheck) < 1000000 or tonumber(countCheck) > 9999999 then 
        f = io.open(getScriptPath()..'\\logs\\randomCount.txt','w') 
        f:write(initCount)
        f:flush()
        f:close()
    else
    f:close()
    end

end

function st_loadTransId() 
    local f         = ''
    local count     = ''

    f = io.open(getScriptPath()..'\\logs\\randomCount.txt','r+')
    count = f:read('*n')
    f:close()

    return count
end

function st_updateTransId(count)
    local f         = ''
    local count     = count
    local newCount  = ''


    f = io.open(getScriptPath()..'\\logs\\randomCount.txt','w') 
    newCount = count + 1
    f:write(newCount)
    f:flush()
    f:close()

end