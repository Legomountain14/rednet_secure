local shrednet = require("shrednet")

local function shrednet_close()
    repeat
        local _, shrednet_close = os.pullEvent("shrednet_close")
    until shrednet_close == true
end

parallel.waitForAny(shrednet.sendPublicKey, shrednet.receivePublicKey, shrednet_close)