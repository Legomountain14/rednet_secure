local shrednet = require("shrednet")
local randutils = require("randutils")

print(randutils.randomString(16))


local function main()
    shrednet.open("top")

    sleep(60)

    shrednet.close()
end

parallel.waitForAny(main, shrednet.run)