--
--
--

function PossLotsCalc()     end

--
--
--


function PossLotsCalc(possPrices, Sec, GO, risk, depoLimit)

    local delta = TRADE_TYPE == 'long' and possPrices.OpenStopPrice - possPrices.CloseStopPrice or possPrices.CloseStopPrice - possPrices.OpenStopPrice 
    local oneStopPrice = tonumber(string.format("%.2f", delta / Sec.SEC_PRICE_STEP * Sec.STEPPRICE ))

    local buff  = nil

    buff = tonumber(string.format("%.0f", risk / oneStopPrice * GO ))

    -- message('delta =' .. delta)
    -- message('oneStopPrice =' .. oneStopPrice)
    -- message('buff > depoLimit =' .. tostring(buff > depoLimit))


    if buff > depoLimit then
        -- return tonumber(string.format("%.2f", depoLimit / GO ))
        return math.floor( depoLimit / GO )
    else
        -- return tonumber(string.format("%.2f", risk / oneStopPrice ))
        return math.floor( risk / oneStopPrice )
    end
end


