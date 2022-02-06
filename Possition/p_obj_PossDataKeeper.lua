PossDataKeeper = {}

function PossDataKeeper:new(t_type)

    --FIXME: вынести проверку всех переменных в отдельный процесс


    local Private = {}
    

    Private.awaitOpenTransId    = 0
    Private.awaitCloseTransId   = 0

    Private.awaitTotalNet       = 0

    -------------------------------
    
    Private.openOrderNum    = 0
    -- Private.openOrderNum    = 832666963
    Private.openTransId     = 0
    -- Private.openTransId     = 1000843

    Private.closeOrderNum   = 0
    -- Private.closeOrderNum   = 832666964
    Private.closeTransId    = 0
    -- Private.closeTransId    = 1000845

    -- Private.totalNet        = 10
    -- Private.totalNet        = -10
    Private.totalNet        = 0

    -- если вся цепочка собрана, то задача выполнена, обновить информацию о позиции и сбросить
    -- если новый стоп, то сбросить информацию об активном стопе

   

    
    local Public = {}

    -- set
    function Public:setAwaitOpenTransId(trans_id)
        Private.awaitOpenTransId = trans_id
    end

    function Public:setAwaitCloseTransId(trans_id)
        Private.awaitCloseTransId = trans_id
    end

    function Public:setAwaitTotalNet(value)
        Private.awaitTotalNet = value
    end

    -- function Public:setCloseTotalNet(value)
    --     Private.awaitCloseTotalNet = value
    -- end

    -- function Public:setOpenOrderNum(value)
    --     Private.openOrderNum = value
    -- end

    -- function Public:setCloseOrderNum(value)
    --     Private.closeOrderNum = value
    -- end


    -- get
    function Public:getAwaitOpenTransId()
        return Private.awaitOpenTransId
    end

    function Public:getAwaitCloseTransId()
        return Private.awaitCloseTransId
    end

    function Public:getOpenTransId()
        return Private.openTransId
    end

    function Public:getOpenOrderNum()
        return Private.openOrderNum
    end

    function Public:getCloseTransId()
        return Private.closeTransId
    end

    function Public:getCloseOrderNum()
        return Private.closeOrderNum
    end

    function Public:getTotalNet()
        return Private.totalNet
    end




    

    setmetatable(Public, self)
    self.__index = self
    return Public
end