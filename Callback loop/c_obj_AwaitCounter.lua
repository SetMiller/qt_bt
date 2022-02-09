AwaitCounter = {}

function AwaitCounter:new(delay)

    --FIXME: вынести проверку всех переменных в отдельный процесс


    local Private = {}
    
    Private.counter = 0
    Private.delay   = delay
    
    local Public = {}

    function Public:Delay() 
        while Private.delay ~= Private.counter do
            Private.counter = Private.counter + 1
            sleep(2)
        end
    end

    setmetatable(Public, self)
    self.__index = self
    return Public
end