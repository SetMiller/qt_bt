dofile(getScriptPath().."\\quikData\\stuff\\st_Time.lua")

function test_st_IsMarketOpen()

    function st_IsMarketOpen_(testData, iter) 
        local timeToCheck       = testData[1]
        local answer            = testData[2]
        local result            = false
        local marketOpen        = nil
        local marketClose       = nil 
        local marketSession     = {
            { "07:05:00", "13:59:29" },
            { "14:05:00", "18:44:29" },
            -- { "19:05:00", "23:49:29" },
        }
        
        timeToCheck = st_FixTime(timeToCheck)
        

        for i = 1, #marketSession do

            marketOpen      = st_FixTime(marketSession[i][1])
            marketClose     = st_FixTime(marketSession[i][2])

            if os.time(timeToCheck) >= os.time(marketOpen) and os.time(timeToCheck) <= os.time(marketClose) then
                result = true
            end
        end

        if result == answer then 
            message("iter=" .. iter .. " pass") 
        else 
            message("iter=" .. iter .. " wrong") 
        end

    end


    local _time = { 
        { "07:04:59", false },      -- 1
        { "07:05:00", true  },      -- 2
        { "13:59:29", true  },      -- 3
        { "13:59:30", false },      -- 4

        { "14:04:59", false },      -- 5
        { "15:05:00", true  },      -- 6
        { "18:44:29", true  },      -- 7
        { "18:44:30", false },      -- 8

        { "19:04:59", false },      -- 9
        { "19:05:00", false },      -- 10
        { "23:49:29", false },      -- 11
        { "23:49:30", false },      -- 12

        { "07:00:00", false },      -- 13
        { "10:00:00", true  },      -- 14
        { "14:00:30", false },      -- 15
        { "17:49:30", true  },      -- 16
        { "19:01:30", false },      -- 17
        { "20:01:30", false },      -- 18
        { "00:01:30", false },      -- 19
        { "05:01:30", false },      -- 20
     
    }

    for i = 1, #_time do
        st_IsMarketOpen_(_time[ i ], i)
    end
end