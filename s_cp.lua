--
--
--

function CallbackProcessing() end



function CallbackProcessing(queue)
    -- message(string.format("Callback processing %s are started", queue.callback))
    LOGS:update(string.format("Callback processing %s are started\n", queue.callback))
    -- sleep(10) --эмуляция продолжительного алгоритма обработки события
    ReadData_W(queue.order)
    ReadBitData_W(queue.order, queue.enum)

    LOGS:update(string.format("Callback processing %s are finished\n", queue.callback))

    -- TODO: -- заполняем таблицы с данными руководствуясь флагами
    if queue.callback == 'OnStopOrder' then

    elseif queue.callback == 'OnOrder' then

    elseif queue.callback == 'OnTrade' then

    end

    --TODO: -- тут функция должна анализировать что и как заполнено и обновлять позицию
    -- если необходимо и отключать блокировку остального кода
    -- если актив, то в зависимости от позиции или нет, ставим флаги и копируем trans_id

    -- тут должна происходить вся магия
end