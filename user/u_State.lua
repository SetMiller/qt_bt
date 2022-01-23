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
    ['trans_id'] = 0,
    ['order_num'] = 0,
}

STATE_ORDER = {
    ['PossIN']      = {},
    ['PossOUT']     = {},
}

STATE_COUNTER = 0