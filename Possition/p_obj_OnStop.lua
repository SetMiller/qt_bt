OnStopObj = {}

function OnStopObj:new()

    local Private = {
        ['order_num']   = 0,
        ['trans_id']    = 0,
        ['qty']         = 0,
    }
    
    local Public = {}

    function Private:setOrderNum(order_num)
        Private.order_num = order_num
    end
    function Private:setTransId(trans_id)
        Private.trans_id = trans_id
    end
    function Private:setQTY(qty)
        Private.qty = qty
    end


    function Private:getOrderNum()
        return Private.order_num
    end
    function Private:getTransId()
        return Private.trans_id
    end
    function Private:getQTY()
        return Private.qty
    end

    setmetatable(Public, self)
    self.__index = self
    return Public
end