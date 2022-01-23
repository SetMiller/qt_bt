--
--
--

function StateCallBackProcessingDump()      end
function StateActiveOnStopDumpNoPoss()      end
function StateActiveOnStopDumpWithPoss()    end

--
--
--

function StateCallBackProcessingDump()
    STATE_KEYS.callbackProcessing   = false
    STATE_COUNTER                   = 0
end

function StateActiveOnStopDumpNoPoss()
    STATE_ACTIVE_ONSTOP.trans_id    = 0
    STATE_ACTIVE_ONSTOP.order_num   = 0
    STATE_ACTIVE_ONSTOP.qty         = 0
end

function StateActiveOnStopDumpWithPoss()
    STATE_ACTIVE_ONSTOP.trans_id    = 0
    STATE_ACTIVE_ONSTOP.order_num   = 0
end