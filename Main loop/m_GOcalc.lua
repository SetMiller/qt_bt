--
--
--

function GOcalc() end

--@param Sec            - Param table характеристики фьючерса
--@param deal_price     - цена совершения сделки
--@param possType       - направление позиции ( long / short )   

function GOcalc(Sec, deal_price, possType)

    if type(possType) ~= 'string' then error(("bad argument possType: st_GOcalc.lua -> GOcalc() -> (string expected, got %s)"):format(type(possType)), 2) end

    local priceKoeff        = tonumber(string.format("%.2f", Sec.STEPPRICE / Sec.SEC_PRICE_STEP ))
    local cl_price          = Sec.CLPRICE
    local max_price         = Sec.PRICEMAX
    local min_price         = Sec.PRICEMIN
    local GO                = possType == 'long' and Sec.BUYDEPO or Sec.SELLDEPO
    -- if cl_price==0 or max_price == 0 or min_price == 0 then return go end
    local L2                = ( max_price - min_price ) * ( 10 ^ Sec.SEC_SCALE )
    local R                 = ( GO / ( L2 * priceKoeff ) - 1) * 100
    local Sign              = possType == 'long' and -1 or 1
    -- message('priceKoeff =' .. tostring(priceKoeff))
    -- message('cl_price =' .. tostring(cl_price))
    -- message('max_price =' .. tostring(max_price))
    -- message('min_price =' .. tostring(min_price))
    -- message('GO =' .. tostring(GO))
    -- message('L2 =' .. tostring(L2))
    -- message('R =' .. tostring(R))
    -- message('Sign =' .. tostring(Sign))
    return                  tonumber(string.format("%.2f", GO + (Sign * ( cl_price - deal_price ) * priceKoeff * ( 1 + R / 100 )) / Sec.SEC_PRICE_STEP ))
end