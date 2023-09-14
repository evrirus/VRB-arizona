script_name("VrB")
script_version("0.1")
--------------------------------------------------------------------------------------------------------------
require "lib.moonloader"

local inicfg = require 'inicfg'
local imgui = require 'imgui'
local encoding = require 'encoding'

encoding.default = 'CP1251'
u8 = encoding.UTF8

local directIni = "moonloader\\config\\vrbcfg.ini"
new_ini = {
    config = {
        dot = false,
        brackets = true,
        rank = 1
    }
}

local sw, sh = getScreenResolution()
local main_window_state = imgui.ImBool(false)

local VRS = imgui.ImBool(false)
local VRC = imgui.ImBool(false)

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end
    
    sampAddChatMessage("{00ffaa}[VrB] {ffffff}Скрипт успешно загружен! Используйте /vrb для открытия меню взаимодействия", 0xFFFFFF)

    sampRegisterChatCommand("vr", vrb)
    sampRegisterChatCommand("vrb", zxc)
    sampRegisterChatCommand("vrs", vrs)
    sampRegisterChatCommand("vrc", vrc)
    sampRegisterChatCommand("vrm", vrm)
    sampRegisterChatCommand("vrbinfo", info)

    imgui.Process = true
    if not doesFileExist("moonloader/config/vrbcfg.ini") then 
        inicfg.save(new_ini, "vrbcfg.ini")
    end
    
    mainIni = inicfg.load(nil, directIni)

    DotCheckbox = imgui.ImBool(mainIni.config.dot)
    BracketsCheckbox = imgui.ImBool(mainIni.config.brackets)
    selected_item = imgui.ImInt(mainIni.config.rank-1)

    police = {u8'Кадет', u8'Офицер', u8'Сержант', u8'Детектив', u8'Лейтенант', u8'Капитан', u8'Командор', u8'Инспектор', u8'Зам.Шефа', u8'Шеф', u8'Шериф', u8'Куратор SWAT', u8'Зам.Куратора SWAT', u8'Капитан SWAT', u8'Командир SWAT', u8'Оперативник SWAT', u8'Лейтенант SWAT', u8'Сержант SWAT', u8'Курсант III', u8'Курсант II', u8'Курсант I', u8'Директор ФБР', u8'Зам. Директора ФБР', u8'Следственный Агент', u8'Специальный Агент', u8'Старший Агент', u8'Агент', u8'Мл.Агент'}

    while true do 
		wait(0)
        if main_window_state.v == false then
            imgui.Process = false
        end
    end
end


function info(args) 
    sampAddChatMessage("{c2c2c2}/vrb{ffffff} - Открыть меню настроек.", -1)
    sampAddChatMessage("{c2c2c2}/vrc [args]{ffffff} - Говорить шепотом.", -1)
    sampAddChatMessage("{c2c2c2}/vrs [args]{ffffff} - Кричать.", -1)
    sampAddChatMessage("{c2c2c2}/vrm [args]{ffffff} - Говорить в мегафон.", -1)
end

function vrm(args)
    mainIni = inicfg.load(nil, directIni)
    if mainIni.config.dot then
        args = args.."."
    end
    sampSendChat("/vr [M] ["..u8:decode(police[mainIni.config.rank]).."]: "..args)
end

function vrs(args)
    mainIni = inicfg.load(nil, directIni)
    if mainIni.config.dot then
        args = args.."."
    end
    sampSendChat("/vr кричит: "..args)
end

function vrc(args)
    mainIni = inicfg.load(nil, directIni)
    if mainIni.config.dot then
        args = args.."."
    end
    sampSendChat("/vr говорит шепотом: "..args)
end

function zxc(args)
    main_window_state.v = not main_window_state.v
    imgui.Process = main_window_state.v
end

function vrb(arg)
    mainIni = inicfg.load(nil, directIni)
    if arg ~= "" then
        if not mainIni.config.brackets and not mainIni.config.dot then 
            sampSendChat("/vr "..arg)

        elseif mainIni.config.brackets and not mainIni.config.dot then
            sampSendChat("/vr (( "..arg.." ))")

        elseif not mainIni.config.brackets and mainIni.config.dot then
            sampSendChat("/vr "..arg..".")
        
        elseif mainIni.config.brackets and mainIni.config.dot then
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
            imgui.Combo(u8'Rank with VRM', selected_item, police, 4)
        imgui.End()
        mainIni.config.dot = DotCheckbox.v
        mainIni.config.brackets = BracketsCheckbox.v
        mainIni.config.rank = selected_item.v+1
        inicfg.save(mainIni, directIni)

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