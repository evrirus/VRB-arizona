script_name("{7ef3fa}VrB")
script_version("0.0.1")
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
require "lib.moonloader"

local sampev = require "samp.events"
local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8    

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end
    sampRegisterChatCommand("vr", vrb)
    sampRegisterChatCommand("fh", findihouse)
    
    while true do 
		wait(0)
        if isKeyJustPressed(VK_Z) and not sampIsChatInputActive() then
            sampSendChat("/armour")
        end
    end
end

function vrb(arg)
    if arg ~= "" then
        sampSendChat("/vr (( "..arg.." ))")
    end
end