dofile(getScriptPath().."\\user\\u_State.lua")
dofile(getScriptPath().."\\stuff\\st_StateDump.lua")
dofile(getScriptPath().."\\stuff\\st_Order.lua")

--
--
--

function OnStopCallbackProcessing() end
function OnOrderCallbackProcessing() end
function OnTradeCallbackProcessing() end
function OnQuikCallbackProcessing() end

--
--
--

function OnStopCallbackProcessing(queue)
    -- LOGS:update(string.format("Callback processing %s are started\n", queue.callback))
    -- -- sleep(10) --эмуляция продолжительного алгоритма обработки события
    st_readData_W(queue.order)
    -- st_readBitData_W(queue.order, queue.enum)

    -- LOGS:update(string.format("Callback processing %s are finished\n", queue.callback))

    -- -- TODO: -- заполняем таблицы с данными руководствуясь флагами
    -- if queue.callback == 'OnStopOrder' then

    -- elseif queue.callback == 'OnOrder' then

    -- elseif queue.callback == 'OnTrade' then

    -- end

    if queue.order.flags == 25 or queue.order.flags == 29 then
        --TODO: заявка выставлена

        -- копируем номер активной заявки и trans_id
        for k, v in pairs(queue.order) do
            for j, _ in pairs(STATE_ACTIVE_ONSTOP) do
                if k == j then
                    STATE_ACTIVE_ONSTOP[j] = v
                end
            end
        end

        LOGS:update('\n', 'trans_id = '  .. STATE_ACTIVE_ONSTOP.trans_id .. '\n', 'order_num = '  .. STATE_ACTIVE_ONSTOP.order_num .. '\n', '\n')
        
        -- clearStopOrders(STATE_ACTIVE_ONSTOP.order_num, STATE_ACTIVE_ONSTOP.trans_id)
        -- LOGS:update('clearStopOrders\n')
        
        -- LOGS:update('trans_id = '  .. STATE_ACTIVE_ONSTOP.trans_id .. '\n', 'order_num = '  .. STATE_ACTIVE_ONSTOP.order_num .. '\n', '\n')

        -- STATE_KEYS.callbackProcessing = false
        -- STATE_COUNTER = 0

    elseif queue.order.flags == 26 or queue.order.flags == 30 then
        --TODO: заявка снята


        -- сверяем СТЕЙТ данные со снятой заявкой и сбрасываем их
        if queue.order.trans_id == STATE_ACTIVE_ONSTOP.trans_id and queue.order.order_num == STATE_ACTIVE_ONSTOP.order_num then

            STATE_ACTIVE_ONSTOP.trans_id = 0
            STATE_ACTIVE_ONSTOP.order_num = 0

            LOGS:update('\n', 'trans_id = '  .. STATE_ACTIVE_ONSTOP.trans_id .. '\n', 'order_num = '  .. STATE_ACTIVE_ONSTOP.order_num .. '\n', '\n')
    
            -- message('STATE_COUNTER =' .. STATE_COUNTER)

            STATE_KEYS.callbackProcessing = false
            STATE_COUNTER = 0
        end

    elseif queue.order.flags == 24 or queue.order.flags == 28 then
        --TODO: заявка сработала



    end

    --TODO: -- тут функция должна анализировать что и как заполнено и обновлять позицию
    -- если необходимо и отключать блокировку остального кода
    -- если актив, то в зависимости от позиции или нет, ставим флаги и копируем trans_id

    -- тут должна происходить вся магия
end

function OnQuikCallbackProcessing(order, queue, callbackType)
    
    if order.account == trdaccid and order.firmid == firmid then

        STATE_KEYS.callbackProcessing = true
        
        table.sinsert(queue, {callback = callbackType, order = order})

    end

end