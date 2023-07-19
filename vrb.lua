script_name("VrB")
script_version("0.1")
--------------------------------------------------------------------------------------------------------------
require "lib.moonloader"


local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local sw, sh = getScreenResolution()
local main_window_state = imgui.ImBool(false)

local DotCheckbox = imgui.ImBool(false)
local BracketsCheckbox = imgui.ImBool(true)

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end
    
    sampAddChatMessage("{00ffaa}[VrB] {ffffff}Скрипт успешно загружен! Используйте /zxc для открытия меню взаимодействия", 0xFFFFFF)

    sampRegisterChatCommand("vr", vrb)
    sampRegisterChatCommand("vrb", zxc)
    imgui.Process = true
    while true do 
		wait(0)
        if main_window_state.v == false then
            imgui.Process = false
        end
    end
end

function zxc(args)
    main_window_state.v = not main_window_state.v
    imgui.Process = main_window_state.v
end

function vrb(arg)
    if arg ~= "" then
        if not BracketsCheckbox.v and not DotCheckbox.v then 
            sampSendChat("/vr "..arg)

        elseif BracketsCheckbox.v and not DotCheckbox.v then
            sampSendChat("/vr (( "..arg.." ))")

        elseif not BracketsCheckbox.v and DotCheckbox.v then
            sampSendChat("/vr "..arg..".")
        
        elseif BracketsCheckbox.v and DotCheckbox.v then
            sampSendChat("/vr (( "..arg..". ))")
        end
    end
end

function imgui.OnDrawFrame()
    theme()
    if main_window_state.v then
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2.15), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(325, 110), imgui.Cond.FirstUseEver)
        imgui.Begin("\tVrB", main_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
            imgui.Checkbox(u8'Точка в конце предложения', DotCheckbox)
            imgui.Checkbox(u8'Обособление текста скобками', BracketsCheckbox)
        imgui.End()
    end
end

function theme()
    local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col 
	local ImVec4 = imgui.ImVec4
    
    colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
    colors[clr.TitleBg] = ImVec4(0, 1, 0.67, 0.4)
    colors[clr.TextSelectedBg] = ImVec4(0.10, 0.57, 0.41, 0.43)
    colors[clr.TitleBgCollapsed] = ImVec4(0.10, 0.57, 0.41, 1.00)
    colors[clr.TitleBgActive] = ImVec4(0.10, 0.57, 0.41, 1.00)
    colors[clr.CloseButton] = ImVec4(0.11, 0.38, 0.29, 0.60)
	colors[clr.CloseButtonHovered] = ImVec4(0.11, 0.38, 0.29, 1.00)
	colors[clr.CloseButtonActive] = ImVec4(0.11, 0.38, 0.29, 1.00)
end 