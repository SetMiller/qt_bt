PossDataKeeper = {}

function PossDataKeeper:new(t_type)


    local Private = {}

    Private.tradeType = t_type

    Private.possValue = 0

    Private.round = {
        ['trans_id']    = 0,
        ['totalnet']    = 0,
    }

    Private.orderExecution = {
        ['OnStop']                  = false,
        ['OnOrder']                 = false,
        ['OnFuturesClientHolding']  = false,
        ['OnStopActivated']         = false,
    }

    Private.orderNum = {
        ['OnStop']      = 0,
    }
   

    
    local Public = {}

    
    function Public:creatRoundTransId()
        Private.round.trans_id = o_transId()
    end

    function Public:setRoundTotalNet(value)
        Private.round.totalnet = value
    end

    function Public:setOnStopOrderNum(value)
        Private.orderNum.OnStop = value
    end

    function Public:setPossValue(value)
        Private.possValue = value
    end

    function Public:setOrderExecution(e_type)
        local isTypeCorrect = false

        for k, _ in pairs(Private.orderExecution) do
            if k == e_type then isTypeCorrect = true end
        end

        if isTypeCorrect then
            for k, _ in pairs(Private.orderExecution) do
                if k == e_type then Private.orderExecution[k] = true end
            end
        else
            LOGS:updateStringArr('setOrderExecution(e_type) ERROR, got ', e_type, '\n')
            STATE_KEYS.isRun = false
        end
    end

    --------------------------------------    

    function Public:getRoundTotalnet()
        return Private.round.totalnet
    end

    function Public:getRoundTransId()
        return Private.round.trans_id
    end
    
    function Public:getOnStopOrderNum()
        return Private.orderNum.OnStop
    end

    function Public:getOrderExecution(e_type)
        local isTypeCorrect = false

        for k, v in pairs(Private.orderExecution) do
            if k == e_type then isTypeCorrect = true end
        end

        if isTypeCorrect then
            for k, v in pairs(Private.orderExecution) do
                if k == e_type then return v end
            end
        else
            LOGS:updateStringArr('getOrderExecution(e_type) ERROR, got ', e_type, '\n')
            STATE_KEYS.isRun = false
        end
    end
    
    --------------------------------------
    
    function Public:getRoundObj()
        return Private.round
    end

    function Public:getPossValue()
        return Private.possValue
    end
    
    function Public:getOrderNums()
        return Private.orderNum
    end

    --------------------------------------
    
    function Public:clearRoundData()
        Private.round.trans_id  = 0
        Private.round.totalnet  = 0
    
        Private.orderExecution.OnStop                   = false
        Private.orderExecution.OnOrder                  = false
        Private.orderExecution.OnFuturesClientHolding   = false
        Private.orderExecution.OnStopActivated          = false
    
        Private.orderNum.OnStop  = 0
    end

    function Public:possChangeSuccess()
        local isSuccess = true
        local futLimitTotalnet = 0

        for k, v in pairs(Private.orderExecution) do
            if not v then
                isSuccess = false
            end
        end

        if isSuccess then

            futLimitTotalnet = getFuturesHolding(firmid, trdaccid, SEC_CODE, 0).totalnet

            if TRADE_TYPE == 'short' and futLimitTotalnet < 0 then futLimitTotalnet = futLimitTotalnet * ( -1 ) end

            if futLimitTotalnet == Private.round.totalnet then

                Private.possValue = futLimitTotalnet
                PDK:clearRoundData()

                if Private.possValue ~= 0 then
                    
                    STATE_KEYS.mainLoopNeedToUpdate = true
                end
                
                STATE_KEYS.orderActivateProcessing = false
                LOGS:updateStringArr('\n','@@@@@@@@@@@@@@@@@@@@@@@','\n','ROUND SUCCESS, got possValue:', Private.possValue, '\n','@@@@@@@@@@@@@@@@@@@@@@@','\n','\n','\n')
            else

                LOGS:updateStringArr('possChangeSuccess() ERROR, got quik:', futLimitTotalnet, ' and your\'s: ', Private.possValue, '\n')
                STATE_KEYS.isRun = false

            end

        end

    end

    setmetatable(Public, self)
    self.__index = self
    return Public
end