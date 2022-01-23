STATE_KEYS = {
    ['isRun']       = true,
    ['init']        = false,
    ['update']      = false,
    ['isPatterns']  = false,
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

STATE_MAIN_QUEUE = {}

STATE_ORDER = {
    ['PossIN']      = {},
    ['PossOUT']     = {},
}