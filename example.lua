local rednet_secure = require("rednet_secure")


local function sendLoop()
    while true do
        rednet_secure.send(1, "asd")
    end
end




local function main()
    rednet_secure.open("top")
    local counter = 0
    while counter < 10 do
    local sender, message, protocol = rednet_secure.receive()
        if protocol ~= nil then
            term.write("Received message from ")
            term.setTextColour(colours.blue)
            term.write(sender)
            term.setTextColour(colours.white)
            term.write(" with protocol ")
            term.setTextColour(colours.green)
            term.write(protocol)
            term.setTextColour(colours.white)
            term.write(" and message ")
            term.setTextColour(colours.red)
            term.write(message)
            term.setTextColour(colours.white)
            print()
            print()
        else
            term.write("Received message from ")
            term.setTextColour(colours.blue)
            term.write(sender)
            term.setTextColour(colours.white)
            term.write(" with message ")
            term.setTextColour(colours.red)
            term.write(message)
            term.setTextColour(colours.white)
            print()
            print()
        end
        counter = counter +1
    end
    rednet_secure.close()
end

parallel.waitForAny(main, rednet_secure.run)