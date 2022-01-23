STATE_KEYS = {
    ['isRun']               = true,
    ['init']                = false,
    ['update']              = false,
    ['isPatterns']          = false,
    ['callbackProcessing']  = false,
}

STATE_DATA = {
    ['chartCandles']        = {},
    ['heikenAshiCandles']   = {},
    ['depoLimit']           = '',
    ['varmargin']           = '',
    ['totalNet']            = '',
    ['futuresParam']        = {},
    ['possGO']              = '',
    ['riskPerTrade']        = '',                
}

STATE_POSS = {
    ['OpenStopPrice']       = '',       
    ['OpenPrice']           = '',       
    ['CloseStopPrice']      = '',      
    ['ClosePrice']          = '',       
    ['Lots']                = '',            
}

STATE_ONSTOP_QUEUE = {}
STATE_ONORDER_QUEUE = {}
STATE_ONTRADE_QUEUE = {}

STATE_ACTIVE_ONSTOP = {
    ['order_num']   = 0,
    ['trans_id']    = 0,
    ['qty']         = 0,
    -- ['order_num']   = 1672385,
    -- ['trans_id']    = 1000183,
    -- ['qty']         = 2,
}

STATE_ORDER = {
    ['PossIN']      = {},
    ['PossOUT']     = {},
}

STATE_COUNTER = 0