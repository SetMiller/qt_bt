STATE_QUEUE = {}
-- STATE_ONSTOP_QUEUE = {}
-- STATE_ONORDER_QUEUE = {}
-- STATE_ONTRADE_QUEUE = {}
-- STATE_ONFUTURESLIMITCHANGE_QUEUE = {}

STATE_KEYS = {
    ['isRun']                       = true,
    ['isPatterns']                  = false,
    ['mainLoopNeedToUpdate']        = false,
    ['callbackQueueProcessing']     = false,
    ['orderActivateProcessing']     = false,
    ['stopButtonPressed']           = false,
    ['callbackAwaiting']            = false,
}

STATE_DATA = {
    ['chartCandles']        = {},
    ['heikenAshiCandles']   = {},
    ['depoLimit']           = '',
    ['varmargin']           = '',
    ['futuresParam']        = {},
    ['possGO']              = '',
    ['riskPerTrade']        = '',                
}

STATE_FUTURESPARAM = {
    ['STEPPRICE']       = '',       -- стоимость шага цены
    ['SEC_PRICE_STEP']  = '',       -- шаг цены
    ['SEC_SCALE']       = '',       -- точность для конвертации 0.2f
    ['CLPRICE']         = '',       -- котировка последнего клиринга
    ['PRICEMAX']        = '',       -- максимально возможная цена
    ['PRICEMIN']        = '',       -- минимально возможная цена
    ['SEC_SCALE']       = '',       -- точность цены
    ['BUYDEPO']         = '',       -- гарантийное обеспечение покупателя
    ['SELLDEPO']        = '',       -- гарантийное обеспечение продавца
    ['LAST']        = '',           -- цена последней сделки
}

STATE_INIT_CHECK = {
    ['DS']              = false,
    ['ACCOUNT']         = false,
    ['USER_OPTIONS']    = false,
    ['RISK_PER_TRADE']  = false,    -- проверка соотношения риска за сделку и размера свечки ( стопа )
}

STATE_POSS = {
    ['OpenStopPrice']   = '',       
    ['OpenPrice']       = '',       
    ['CloseStopPrice']  = '',      
    ['ClosePrice']      = '',       
    ['Lots']            = '',            
}

STATE_ORDER = {
    ['OpenPoss']    = {},
    ['ClosePoss']   = {},
}

STATE_ORDER_BUFFER = {
    ['OnStop']      = {
        -- ['order_num']   = '',
        -- ['trans_id']    = '',
        -- ['qty']         = '',
        -- ['filled_qty']  = '',
        ['linkedorder'] = 0,
    },
    ['OnOrder']     = {
        -- ['order_num']   = '',
        -- ['trans_id']    = '',
        -- ['qty']         = '',
        -- ['filled_qty']  = '',
        ['linkedorder'] = 0,
    },
}

STATE_FUTLIMIT = 0