--
--
--
function check_UserData() end

function check_DSInterval() end
function check_TradeAccount() end
function check_TradeType() end
function check_ClassCode() end



--
--
--
function check_DSInterval(userInterval) 

    local isFound = false

    local intervals = {
        INTERVAL_M1,    --1 минута  
        INTERVAL_M2,    --2 минуты  
        INTERVAL_M3,    --3 минуты  
        INTERVAL_M4,    --4 минуты
        INTERVAL_M5,    --5 минут
        INTERVAL_M6,    --6 минут
        INTERVAL_M10,   --10 минут
        INTERVAL_M15,   --15 минут
        INTERVAL_M20,   --20 минут
        INTERVAL_M30,   --30 минут
        INTERVAL_H1,    --1 час
    }

    for _, v in ipairs(intervals) do
        if v == userInterval then
            isFound = true
            break
        end
    end

    if not isFound then error(("bad argument\n|| User\\u_UserOptions.lua -> INTERVAL ||\n('INTERVAL_M1-2-3' expected, got -> '%s')"):format(userInterval), 2) end

end
--
--
--
function check_TradeAccount(firmid, trdaccid)

    local user_firmid       = firmid
    local user_trdaccid     = trdaccid
    local isFound           = false

    for i = 0, getNumberOf("trade_accounts") - 1 do  
        local quik_firmid       = getItem("trade_accounts", i).firmid
        local quik_trdaccid     = getItem("trade_accounts", i).trdaccid

        if user_firmid == quik_firmid and user_trdaccid == quik_trdaccid then 

            isFound = true

        end

    end

    if not isFound then error(("bad argument\n|| User\\u_UserOptions.lua -> Trade Account data ||\n('firmid and trdaccid' expected, got -> '%s' and '%s')"):format(firmid, trdaccid), 2) end

end
--
--
--
function check_TradeType(t_type) 
    
    if t_type ~= 'long' and t_type ~= 'short' then
        
        error(("bad argument\n|| User\\u_UserOptions.lua -> TRADE_TYPE ||\n('long or short' expected, got -> '%s')"):format(t_type), 2)
        
    end
    
end
--
--
--
function check_ClassCode(class_code) 
    
    if class_code ~= 'SPBFUT' then
        
        error(("bad argument\n|| User\\u_UserOptions.lua -> CLASS_CODE ||\n('SPBFUT' expected for futures FORTS trade, got -> '%s')"):format(class_code), 2)
        
    end
    
end
--
--
--
function check_SecCodeDaysToMatDate(sec_code, class_code)

    if sec_code == nil then 
        error(("bad argument\n|| User\\u_UserOptions.lua -> SEC_CODE ||\n('SEC_CODE = SiH2' as example, expected, got -> '%s')"):format(sec_code), 2) 
    end
    
    local daysToMatDate     = 0

    daysToMatDate = tonumber(getParamEx(class_code, sec_code, 'DAYS_TO_MAT_DATE').param_value)

    if daysToMatDate > 2 and daysToMatDate < 10 then

        message('less than ' .. daysToMatDate .. ' days left until maturity!!!\nPlease, change SEC_CODE -> User\\u_UserOptions.lua')
        return
    end

    if daysToMatDate <= 2 then

        error(("bad argument\n|| User\\u_UserOptions.lua -> SEC_CODE ||\n('daysToMatDate' > 1 expected, got -> '%s days left')"):format(daysToMatDate), 2)
        return
    end

end
--
--
--
function check_MinAndMaxDelta()

end