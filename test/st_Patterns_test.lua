dofile(getScriptPath().."\\quikData\\stuff\\st_Patterns.lua")

function test_st_Patterns()

    function st_Patterns_(testData, iter) 
        local candlesArr          = testData[1]
        local answer_A          = testData[2]
        local answer_B          = testData[3]
        local result_A            = false
        local result_B            = false
        
        for i = 1, #testData do
            result_A = st_IsPattern_A(candlesArr)
            result_B = st_IsPattern_B(candlesArr)
        end

        if result_A == answer_A and result_B == answer_B then 
            message("iter=" .. iter .. " pass") 
        else 
            message("iter=" .. iter .. " wrong") 
        end
    end

    local _testData = { 
        {{{['open'] = 135.38, ['high'] = 136.75, ['low'] = 132.59, ['close'] = 133.66,}, {['open'] = 135.42, ['high'] = 137.46, ['low'] = 128, ['close'] = 133.49,}}, true, true},      -- 1
        {{{['open'] = 150.59, ['high'] = 155.28, ['low'] = 145.53, ['close'] = 153.59,}, {['open'] = 160, ['high'] = 161.28, ['low'] = 144.93, ['close'] = 150.08,}}, false, true},      -- 1
        {{{['open'] = 138.35, ['high'] = 142.35, ['low'] = 132.10, ['close'] = 142.35,}, {['open'] = 148.9, ['high'] = 150.94, ['low'] = 142, ['close'] = 144.07,}}, false, false},      -- 1
        {{{['open'] = 148.9, ['high'] = 150.94, ['low'] = 142, ['close'] = 144.07,}, {['open'] = 147.03, ['high'] = 152.81, ['low'] = 144.42, ['close'] = 148.94,}}, true, false},      -- 1
    }

    for i = 1, #_testData do
        st_Patterns_(_testData[ i ], i)
    end
end