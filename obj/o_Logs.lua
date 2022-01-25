Logs = {}

function Logs:new(t_type)

    if t_type ~= 'long' and t_type ~= 'short' then 
        error(("bad argument init: Logs:new(TRADE_TYPE) (TRADE_TYPE expected, got %s)"):format(type(t_type)), 2) 
    end

    local Private = {
        ['f']   = '',
        ['path'] = '',
        ['start'] = '@@@@@@@@@@ ' .. os.date( "%x") .. ' | ' .. os.date( "%X") .. ' @@@@@@@@@@\n',
    }

    function Private:init()
        local date = os.date("!*t",os.time())
        
        Private.path = '\\logs\\'.. tostring(date.year) .. "." ..tostring(date.month) .. "." ..tostring(date.day) .. '_' .. t_type .. '.txt'
        
        Private.f = io.open(getScriptPath() .. Private.path,'r+')
        
        if Private.f == nil then 
            Private.f = io.open(getScriptPath()..Private.path,'w') 
            Private.f:close()
            Private.f = io.open(getScriptPath() .. Private.path,'r+')
        else
            Private.f = io.open(getScriptPath() .. Private.path,'a')
        end
        Private.f:write(Private.start)
        Private.f:write('\n')
    end

    Private:init()

    local Public = {}

    function Public:update(...) 

        local arg = table.pack(...)
        
        for i = 1, #arg do
            Private.f:write(arg[i])
            Private.f:flush()
        end

    end

    function Public:close()
        Private.f:close()
    end

    setmetatable(Public, self)
    self.__index = self
    return Public
end