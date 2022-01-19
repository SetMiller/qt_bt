dofile(getScriptPath().."\\factory\\f_User.lua")

-- 
-- Ключи для идентификации заявок
--
function u_GetStopKeys() end

function u_GetStopKeys(keyType) 
    if type(keyType) ~= 'string' then error(("bad argument keyType: u_GetStopKeys.lua -> (string expected, got %s)"):format(type(keyType)), 2) end

    local keys = {}

    keys.active = {
        ['long']    =   { 25, 89 },
        ['short']   =   { 29, 93 },
        ['all']     =   { 25, 89, 29, 93 }
    }
    keys.activated = {
        ['long']    =   { 24, 88 },
        ['short']   =   { 28, 92 },
    }

    return f_ReturnData(keys, keyType) -- local data = TradeConfig("stockOffset")
end






