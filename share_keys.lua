local rednet_secure = require("rednet_secure")

local function rednet_secure_close()
    repeat
        local _, rednet_secure_closed = os.pullEvent("rednet_secure_close")
    until rednet_secure_closed == true
    return
end

parallel.waitForAny(rednet_secure.sendPublicKey, rednet_secure.receivePublicKey, rednet_secure_close)