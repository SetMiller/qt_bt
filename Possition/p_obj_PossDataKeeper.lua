PossDataKeeper = {}

function PossDataKeeper:new(t_type)


    local Private = {}

    -- Private.tradeType = t_type

    Private.possValue = 0

    Private.round = {
        ['trans_id']    = 0,
        ['totalnet']    = 0,
    }

    Private.orderExecution = {
        ['OnStop']                  = false,
        ['OnOrder']                 = false,
        -- ['OnFuturesClientHolding']  = false,
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
        if value < 0 then
            Private.possValue = value * (-1)
        else
            Private.possValue = value
        end
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
    
        Private.orderExecution.OnStopActivated          = false
        Private.orderExecution.OnStop                   = false
        Private.orderExecution.OnOrder                  = false
        -- Private.orderExecution.OnFuturesClientHolding   = false
    
        Private.orderNum.OnStop  = 0
    end

    function Public:possChangeSuccess(executed)
        LOGS:updateStringArr('\n','is possChangeSuccess? executed by:', executed,'\n')
        
        local isSuccess = true
        -- local futLimitTotalnet = 0

        LOGS:updateStringArr('OnStopActivated: ', tostring(Private.orderExecution.OnStopActivated),'\n')
        LOGS:updateStringArr('OnStop: ', tostring(Private.orderExecution.OnStop),'\n')
        LOGS:updateStringArr('OnOrder: ', tostring(Private.orderExecution.OnOrder),'\n')
        
        LOGS:updateStringArr('\n','is possChangeSuccess? for loop start isSuccess:', tostring(isSuccess),'\n')
        for k, v in pairs(Private.orderExecution) do
            LOGS:updateStringArr('k:', tostring(k),', v:', tostring(v),'\n')
            if not v then
                isSuccess = false
            end
        end
        LOGS:updateStringArr('is possChangeSuccess? for loop end isSuccess:', tostring(isSuccess),'\n')
        
        if isSuccess then
            LOGS:updateStringArr('\n', 'is possChangeSuccess: ', 'Start processing','\n')
            -- futLimitTotalnet = tonumber(getFuturesHolding(firmid, trdaccid, SEC_CODE, 0).totalnet)
            
            -- if TRADE_TYPE == 'short' and futLimitTotalnet < 0 then futLimitTotalnet = futLimitTotalnet * ( -1 ) end
            
            LOGS:updateStringArr('isSuccess: 1', '\n')

            -- LOGS:updateStringArr('futLimitTotalnet:', futLimitTotalnet, ' type: ', type(futLimitTotalnet), '\n')
            LOGS:updateStringArr('Private.round.totalnet:', Private.round.totalnet, ' type: ', type(Private.round.totalnet), '\n')
            -- LOGS:updateStringArr('futLimitTotalnet == tonumber(Private.round.totalnet):', tostring(futLimitTotalnet == tonumber(Private.round.totalnet)), '\n')
            
            -- if futLimitTotalnet == tonumber(Private.round.totalnet) then
                LOGS:updateStringArr('isSuccess: 1.1', '\n')
                
                Private.possValue = Private.round.totalnet
                PDK:clearRoundData()
                
                if Private.possValue ~= 0 then
                    LOGS:updateStringArr('isSuccess: 1.1.1', '\n')
                    
                    STATE_KEYS.mainLoopNeedToUpdate = true
                end
                
                STATE_QUEUE = {}
                
                STATE_KEYS.orderActivateProcessing = false
                STATE_KEYS.callbackQueueProcessing = false  --FIXME:
                LOGS:updateStringArr('\n','@@@@@@@@@@@@@@@@@@@@@@@','\n','ROUND SUCCESS, got possValue:', Private.possValue, '\n','@@@@@@@@@@@@@@@@@@@@@@@','\n','\n','\n')
            -- else
            --     LOGS:updateStringArr('isSuccess: 2', '\n')
                
            --     LOGS:updateStringArr('possChangeSuccess() ERROR, got quik:', futLimitTotalnet, ' and your\'s: ', Private.possValue, '\n')
            --     STATE_KEYS.isRun = false
                
            -- end
        else
            
            LOGS:updateStringArr('\n', 'is possChangeSuccess: ', 'NOOOO','\n')
            LOGS:updateStringArr('OnStopActivated: ', tostring(Private.orderExecution.OnStopActivated),'\n')
            LOGS:updateStringArr('OnStop: ', tostring(Private.orderExecution.OnStop),'\n')
            LOGS:updateStringArr('OnOrder: ', tostring(Private.orderExecution.OnOrder),'\n')
            -- LOGS:updateStringArr('OnFuturesClientHolding: ', tostring(Private.orderExecution.OnFuturesClientHolding),'\n','\n')
        end

    end

    setmetatable(Public, self)
    self.__index = self
    return Public
end