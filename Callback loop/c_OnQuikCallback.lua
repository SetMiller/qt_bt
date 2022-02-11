--
--
--
function onQuikCallbackFiltering()          end
function onQuikCallbackProcessingStart()    end
function onQuikCallbackProcessingEnd()      end
function onStopCallback()                   end
function onOrderCallback()                  end
function onTradeCallback()                  end
function onFuturesLimitChange()             end
--
--
--
function callbackQueueProcessingOn(callback_type) 

    
    LOGS:updateStringArr('CallbackProcessing Start -> ', callback_type, '\n')

end
--
--
--
function callbackQueueProcessingOff() 

    STATE_KEYS.callbackQueueProcessing = false
    LOGS:updateStringArr('CallbackProcessing End--', '\n', '\n')

end
--
--
--
function callbackQueueProcessing(queue)
    callbackQueueProcessingOn(queue.callbackType)
    if queue.callback == 'order' then
        LOGS:updateStringArr('**callback queue order processing Start**', '\n')
        
        -- -- отфильтровываем заявки по счету
        -- if queue.order.account == trdaccid and queue.order.firmid == firmid and queue.order.sec_code == SEC_CODE then
            
            LOGS:updateStringArr('order flags -> ', queue.order.flags, '\n')
            orderCallback(queue.order)   
        -- end
        
        
        LOGS:updateStringArr('**callback queue order processing End**', '\n')
        -- return
    end
    
    if queue.callback == 'futLimit' then
        LOGS:updateStringArr('**callback queue futLimit processing Start**', '\n')
        
        -- -- отфильтровываем изменения по позиции по счету
        -- if queue.fut_limit.trdaccid == trdaccid and queue.fut_limit.firmid == firmid and queue.fut_limit.sec_code == SEC_CODE then
            
            futLimitCallback(queue.fut_limit)
            
        -- end
        
        LOGS:updateStringArr('**callback queue futLimit processing End**', '\n')
        -- return
    end


end

--
--
--
function orderCallback(order)           
    -- OnStopOrder_ACTIVE
    if order.flags == 25 or order.flags == 29 then
        LOGS:updateStringArr('-- Stop onStopCallback ACTIVE Start --', '\n')
        -- st_readData_W(queue.order)
        -- -- сохраняем данные по активному стопу
        if order.trans_id == PDK:getRoundTransId() then
            
            PDK:setOnStopOrderNum(order.order_num) 
            
            STATE_KEYS.callbackAwaiting = false

            st_readData_W(PDK:getRoundObj())
            st_readData_W(PDK:getOrderNums())
        else
            
            LOGS:updateStringArr('25.29 onStopCallback ACTIVE ERROR, order.trans_id doesn\'t match. ')
            LOGS:updateStringArr('Await:', PDK:getRoundTransId() ,', but get order.trans_id:', order.trans_id, '\n')
            STATE_KEYS.isRun = false
            
        end
        -- PDK:setActiveStop( queue.order.trans_id,  queue.order.order_num, queue.order.qty ) 
        
        LOGS:updateStringArr('-- Stop Callback ACTIVE End --', '\n')
        
    -- OnStopOrder_ACTIVATED
    elseif order.flags == 24 or order.flags == 28 then
        LOGS:updateStringArr('-- Stop Callback ACTIVATED Start --', '\n')
        
        -- Ловим первый, блокируем выполнение мейна, разблокируем прием данных от позы
        -- ловим второй, отмечаем что он выполнен
        -- st_readData_W(order)
        if not PDK:getOrderExecution('OnStopActivated') and not PDK:getOrderExecution('OnStop') and order.trans_id == PDK:getRoundTransId() then
            LOGS:updateStringArr('OnStopActivated from OnStop Success !!!', '\n')
            -- заблокировать mainloop
            STATE_KEYS.orderActivateProcessing = true   --TODO:

            PDK:setOrderExecution('OnStopActivated')
        end

        if PDK:getOrderExecution('OnStopActivated') and not PDK:getOrderExecution('OnStop') then
            if order.trans_id == PDK:getRoundTransId() and order.balance == 0 then
                
                PDK:setOrderExecution('OnStop')
                LOGS:updateStringArr('OnStop Active Success !!!', '\n')
                
                -- проверка цепочки
                PDK:possChangeSuccess('OnStop')
            end
        end
        
        
        LOGS:updateStringArr('-- Stop Callback ACTIVATED End --', '\n')
        
    -- OnStopOrder_DELETED
    elseif order.flags == 26 or order.flags == 30 then
        LOGS:updateStringArr('-- Stop Callback DELETED Start --', '\n')
        
        -- удаляем данные по удаленному стопу
        if order.trans_id == PDK:getRoundTransId() then
            
            PDK:clearRoundData() 
            STATE_KEYS.callbackAwaiting = false
            STATE_KEYS.mainLoopNeedToUpdate = true
            st_readData_W(PDK:getRoundObj())
            st_readData_W(PDK:getOrderNums())
        else

            LOGS:updateStringArr('26.30 onStopCallback DELETED ERROR, order.trans_id doesn\'t match. ')
            LOGS:updateStringArr('Await:', PDK:getRoundTransId() ,', but get order.trans_id:', order.trans_id, '\n')
            STATE_KEYS.isRun = false

        end

        -- перезапускаем цикл, тк удаление стопа происходит при его переносе и нужно поставить новый
        -- STATE_KEYS.isRun = false    --FIXME:
        -- STATE_KEYS.mainLoopNeedToUpdate = true

        LOGS:updateStringArr('-- Stop onStopCallback DELETED End --', '\n')

    -- OnOrder_ACTIVATED
    elseif order.flags == 1048600 or order.flags == 1048604 then
        LOGS:updateStringArr('++ Order Callback ACTIVATED Start ++', '\n')
        -- st_readData_W(order)
        
        if not PDK:getOrderExecution('OnStopActivated') and not PDK:getOrderExecution('OnOrder') and order.trans_id == PDK:getRoundTransId() then
            
            LOGS:updateStringArr('OnStopActivated from OnOrder Success !!!', '\n')
            PDK:setOrderExecution('OnStopActivated')

            -- заблокировать mainloop
            STATE_KEYS.orderActivateProcessing = true   --TODO:
        end
        
        if PDK:getOrderExecution('OnStopActivated') and not PDK:getOrderExecution('OnOrder') then
            if order.trans_id == PDK:getRoundTransId() and order.balance == 0 then
                
                LOGS:updateStringArr('OnOrder Active Success !!!', '\n')
                PDK:setOrderExecution('OnOrder')

                -- проверка цепочки
                PDK:possChangeSuccess('OnOrder')
            end
        end


            -- ловим заявку и отмечаем что она выполнена
        LOGS:updateStringArr('++ Order Callback ACTIVATED End ++', '\n')
    end
end



-- function futLimitCallback(fut_limit)
--     LOGS:updateStringArr('--futLimit Start--', '\n')

--     -- if not PDK:getOrderExecution('OnStopActivated') and not PDK:getOrderExecution('OnFuturesClientHolding') then
--     --     PDK:setOrderExecution('OnStopActivated')
--     --     -- заблокировать mainloop
--     -- end
--     -- LOGS:updateStringArr('fut_limit obj++', '\n')
--     -- st_readData_W(fut_limit)
--     -- LOGS:updateStringArr('fut_limit obj--', '\n')
--     LOGS:updateStringArr(' fut_limit.totalnet:',  fut_limit.totalnet, ' type: ', type(fut_limit.totalnet), '\n')
--     LOGS:updateStringArr('STATE_FUTLIMIT:', STATE_FUTLIMIT, ' type: ', type(STATE_FUTLIMIT), '\n')
    
    
--     if fut_limit.totalnet ~= STATE_FUTLIMIT then
--         LOGS:updateStringArr(' fut_limit.totalnet ~= STATE_FUTLIMIT:', tostring( fut_limit.totalnet ~= STATE_FUTLIMIT), '\n')

--         STATE_FUTLIMIT = fut_limit.totalnet

--         if not PDK:getOrderExecution('OnStopActivated') and not PDK:getOrderExecution('OnFuturesClientHolding') then
--             LOGS:updateStringArr('OnStopActivated from OnFuturesClientHolding Success !!!', '\n')
--             -- заблокировать mainloop
--             STATE_KEYS.orderActivateProcessing = true   --TODO:

--             PDK:setOrderExecution('OnStopActivated')
--         end

--         if PDK:getOrderExecution('OnStopActivated') and not PDK:getOrderExecution('OnFuturesClientHolding') then
--             if fut_limit.totalnet == PDK:getRoundTotalnet() then

--                 LOGS:updateStringArr('OnFuturesClientHolding Active Success !!!', '\n')
--                 PDK:setOrderExecution('OnFuturesClientHolding')
                
--                 -- проверка цепочки
--                 PDK:possChangeSuccess('futLimit')
--             end
--         end

--     else

--         LOGS:updateStringArr(' fut_limit.totalnet == STATE_FUTLIMIT:', tostring( fut_limit.totalnet == STATE_FUTLIMIT), '\n')

--     end

--     -- LOGS:updateStringArr('__ futLimit __', '\n', '\n')
--     -- LOGS:updateStringArr('OnStop: ', tostring(PDK:getOrderExecution('OnStop')), '\n')
--     -- LOGS:updateStringArr('OnOrder: ', tostring(PDK:getOrderExecution('OnOrder')), '\n')
--     -- LOGS:updateStringArr('OnFuturesClientHolding: ', tostring(PDK:getOrderExecution('OnFuturesClientHolding')), '\n')
--     -- LOGS:updateStringArr('OnStopActivated: ', tostring(PDK:getOrderExecution('OnStopActivated')), '\n')
--     -- LOGS:updateStringArr('__ futLimit __', '\n', '\n')


--     -- st_readData_W(fut_limit)
--     LOGS:updateStringArr('--futLimit End--', '\n')
--     -- ловим изменения по позиции, что они совпадают с ожидаемыми
--     -- меняем позу у нас, сбрасываем данные, разблокируем основной цикл, чистим очередь, блокируем прием данных от позы
--     -- STATE_KEYS.isRun = false
-- end