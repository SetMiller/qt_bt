

Poss = {
    ['qty'] = 0,
}

PrePoss = {}

PrePoss.CalcPoss = {
    ['trans_id']        = 1000311,
    ['qty']             = 5,
}

PrePoss.StopOrder = {
    -- active
    ['trans_id']        = 1000311,
    ['filled_qty']      = 5,
    ['qty']             = 5,
    ['linkedorder']     = 0,
    ['balance']         = 0.0,

    -- activated
    -- ['trans_id']        = 1000311,
    -- ['filled_qty']      = 0,
    -- ['qty']             = 5,
    -- ['linkedorder']     = 1953472373147613705,
    -- ['balance']         = 5.0,
} -- deleted 

PrePoss.OnOrder = {
    ['trans_id']        = 1000311,
    ['order_num']       = 1953472373147613705,
    ['qty']             = 5,
    ['balance']         = 0.0, -- проверить на равенство 0, иначе не вся заявка исполнена
} 

PrePoss.OnTrade = {
    ['trans_id']        = 1000311,
    ['order_num']       = 1953472373147613705,
    ['qty']             = 5, -- суммировать при каждом вызове и проверять на совпадение по 3м пунктам
} 
