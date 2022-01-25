PossConstructor = {}

function PossConstructor:new(t_type)

    if t_type ~= 'long' or t_type ~= 'short' then 
        error(("bad argument init: Logs:new(TRADE_TYPE) (TRADE_TYPE expected, got %s)"):format(type(t_type)), 2) 
    end

    local Private = {}
    Private.orderChain = {
        ['OnStopActive']        = false,
        ['OnStop.Activated']    = false,
        ['OnOrder']             = false,
        ['OnTrade']             = false,
    }

    -- если вся цепочка собрана, то задача выполнена, обновить информацию о позиции и сбросить
    -- если новый стоп, то сбросить информацию об активном стопе

    Private.OnStop.Active = {
        ['order_num']   = '',
        ['trans_id']    = '',
        ['qty']         = '',
        ['filled_qty']  = '',
        ['linkedorder'] = '',
    }

    Private.OnStop.Activated = {
        ['order_num']   = '',
        ['trans_id']    = '',
        ['qty']         = '',
        ['filled_qty']  = '',
        ['linkedorder'] = '',
        
    }
    
    Private.OnOrder = {
        ['order_num']   = '',
        ['trade_num']   = '',
        ['trans_id']    = '',
        ['qty']         = '',
        ['linkedorder'] = '',
    }

    Private.OnTrade = {
        ['order_num']   = '',
        ['trade_num']   = {},
        ['trans_id']    = '',
        ['qty']         = {},
        ['linkedorder'] = '',
    }

    
    local Public = {}

    -- function Public:OnStopCallbackProcessing(order)
    --     st_readData_W(queue.order)

    -- end

    -- function Public:OnOrderCallbackProcessing(order)

        
    -- end

    -- function Public:OnTradeCallbackProcessing(order)


    -- end

    setmetatable(Public, self)
    self.__index = self
    return Public
end