--
--
--
function m_possValueOnQuikBoard()end
--
--
--
function m_possValueOnQuikBoard(firmid, trdaccid, sec_code)

    return getFuturesHolding(firmid, trdaccid, sec_code, 0).totalnet

end