local isSeersLodeUnlocked = true
local isKaramjaLodeUnlocked = true
local isOoglogLodeUnlocked = true
local isCanafisLodeUnlocked = true

local API = require("api")
API.Write_fake_mouse_do(false)
local UTILS = require("utils")
local LODESTONES = require("lodestones")

local interfaces = {
    mostAnnoyingInterfaceInTheGame = { { 955,4,-1,-1,0 }, { 955,6,-1,4,0 }, { 955,9,-1,6,0 }, { 955,10,-1,9,0 }, { 955,13,-1,10,0 }, { 955,13,0,13,0 } }
}

local function waitForVB(number)
    while API.Read_LoopyLoop() and not API.Compare2874Status(number, false) do
        API.RandomSleep2(600, 100, 200)
    end
end



local function run_to_tile(x, y, z)
    math.randomseed(os.time())

    local rand1 = math.random(-2, 2)
    local rand2 = math.random(-2, 2)
    local tile = WPOINT.new(x + rand1, y + rand2, z)

    API.DoAction_WalkerW(tile)


    local threshold = math.random(4, 6)
    while API.Read_LoopyLoop() and API.Math_DistanceW(API.PlayerCoord(), tile) > threshold do
        API.RandomSleep2(200, 200, 200)
    end
end



local function harvest()
    if not API.Read_LoopyLoop() or not API.PlayerLoggedIn() or API.InvFull_() then return end

    print("Harvesting")
    if API.GetAllObjArrayInteract_str({"Enriched"}, 50, {1})[1] ~= nil then
        API.DoAction_NPC_str(0xc8, API.OFF_ACT_InteractNPC_route, { "Enriched" }, 50)
    elseif API.GetAllObjArrayInteract_str({"wisp"}, 50, {1})[1] ~= nil then
        API.DoAction_NPC_str(0xc8, API.OFF_ACT_InteractNPC_route, { "wisp" }, 50)
    elseif API.GetAllObjArrayInteract_str({"spring"}, 50, {1})[1] ~= nil then
        API.DoAction_NPC_str(0xc8, API.OFF_ACT_InteractNPC_route, { "spring" }, 50)
    end
    local i = 0
    while API.Read_LoopyLoop() and API.ReadPlayerAnim() == 0 do
        API.RandomSleep2(200, 200, 200)
        if i >= 10 then
            if API.GetAllObjArray1({87306, 93489}, 1, {12})[1] ~= nil or not API.ReadPlayerMovin2() then
                math.randomseed(os.time())
                API.DoAction_Tile(WPOINT.new(API.PlayerCoord().x + math.random(-2, 2), API.PlayerCoord().y + math.random(-2, 2), API.PlayerCoord().z))
                API.RandomSleep2(600, 100, 200)
            end
            break
        end
        i = i + 1
    end
end


local enhancedChronicleFragment = 51489
local chronicleFragment = 29293

local function getDivinationLevel()
    local currentExp = API.GetSkillXP("DIVINATION")
    return API.XPLevelTable(currentExp)
end

local function isInterfaceVisible(interface_components)
    return API.ScanForInterfaceTest2Get(false, interface_components)[1].x ~= nil 
        and API.ScanForInterfaceTest2Get(false, interface_components)[1].x ~= 0
end

local function divDiv()
    if not API.Read_LoopyLoop() or not API.PlayerLoggedIn() then return end

    if isInterfaceVisible(interfaces['mostAnnoyingInterfaceInTheGame']) then
        print("Closing annoying interface")
        API.DoAction_Interface(0x24,0xffffffff,1,955,18,-1,API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(2200, 1200, 1000)
    end
    if not API.InventoryInterfaceCheckvarbit() then
        print("Open inventory")
        API.DoAction_Interface(0xc2,0xffffffff,1,1431,0,9,API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(600, 0, 1200)
    end

    if API.InvItemFound1(39486) then
        API.DoAction_Inventory1(39486,0,3,API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(300, 300, 300)
    end
    

    if API.InvFull_() then
        print("Dumping")

        if API.DoAction_Object1(0xc8,API.OFF_ACT_GeneralObject_route0,{ 93489 },50) then
            print("guthx rift")
        elseif API.DoAction_Object1(0xc8,API.OFF_ACT_GeneralObject_route0,{ 87306 },50) then
            print("normal rift")
        end
        
        local i = 0
        local memoryCount = API.InvItemcount_String("memory")
        while API.Read_LoopyLoop() and API.InvItemcount_String("memory") > 0 do
            API.RandomSleep2(200, 200, 200)
            if i >= 6 and memoryCount == API.InvItemcount_String("memory") then
                i = 0
                math.randomseed(os.time())
                API.DoAction_Tile(WPOINT.new(API.PlayerCoord().x + math.random(-2, 2), API.PlayerCoord().y + math.random(-2, 2), API.PlayerCoord().z))
                API.RandomSleep2(600, 100, 200)
                break
            else
               i = 0 
            end
            i = i + 1
        end
    elseif API.InvStackSize(chronicleFragment) >= 10 or API.InvStackSize(enhancedChronicleFragment) >= 10 then
        print("Empowering")
        if API.DoAction_Object1(0x29,API.OFF_ACT_GeneralObject_route2,{ 93489 },50) then
            print("guthix empowering")
        elseif API.DoAction_Object1(0x29,API.OFF_ACT_GeneralObject_route2,{ 87306 },50) then
            print("normal empowering")
        end
        local x = 0
        while API.Read_LoopyLoop() and API.InvItemcount_String("fragment") > 0 do
            API.RandomSleep2(200, 200, 200)
            if x >= 10 and not API.ReadPlayerMovin2() then
                x = 0
                math.randomseed(os.time())
                API.DoAction_Tile(WPOINT.new(API.PlayerCoord().x + math.random(-2, 2), API.PlayerCoord().y + math.random(-2, 2), API.PlayerCoord().z))
                API.RandomSleep2(600, 100, 200)
                break
            end
            x = x + 1
            if tonumber(API.Dialog_Option("Yes, and don't ask again.")) then
                API.Select_Option("Yes, and don't ask again.")
                API.RandomSleep2(1000, 100, 200)
            end
        end
    elseif API.GetAllObjArray1({18204, 18205}, 50, {1})[1] ~= nil then
        local currectChronicleCount = API.InvStackSize(chronicleFragment)
        local currecntEnrichedChronicleCount = API.InvStackSize(enhancedChronicleFragment)
        API.DoAction_NPC(0x29,API.OFF_ACT_InteractNPC_route,{ 18204, 18205 },50)
        while API.Read_LoopyLoop() and ( currecntEnrichedChronicleCount == API.InvStackSize(enhancedChronicleFragment) and currectChronicleCount == API.InvStackSize(chronicleFragment) ) do
            API.RandomSleep2(200, 200, 200)
        end
    elseif not API.IsPlayerAnimating_(API.GetLocalPlayerName(), 30) and API.PlayerLoggedIn() then
        harvest()
    end
end

local function waitAnim()
    if not API.Read_LoopyLoop() or not API.PlayerLoggedIn() then return end
    while API.Read_LoopyLoop() and API.ReadPlayerAnim() ~= 0 do
        API.RandomSleep2(600, 600, 600)
    end
    API.RandomSleep2(600, 600, 600)
    if API.InvItemcount_String("energy") > 0 then
        API.DoAction_Inventory3("energy",0,8,API.OFF_ACT_GeneralInterface_route2)
        API.RandomSleep2(300, 300, 300)
    end
end

local function newArea()
    if not API.Read_LoopyLoop() or not API.PlayerLoggedIn() then return end
    if getDivinationLevel() < 10 then
        if API.PInArea(3121, 12, 3217, 12, 0) then return end
        if not API.PInArea(3105, 5, 3298, 5, 0) then
            waitAnim()
            LODESTONES.DRAYNOR_VILLAGE.Teleport()
        end
        run_to_tile(3121, 3217, 0)

        --configuring memory conversion
        if API.DoAction_Object1(0x29,API.OFF_ACT_GeneralObject_route1,{ 93489, 93495 },50) then
            print("guthx rift")
        elseif API.DoAction_Object1(0x29,API.OFF_ACT_GeneralObject_route1,{ 87306 },50) then
            print("normal rift")
        end
        while API.Read_LoopyLoop() and not API.Compare2874Status(18, false) do
            API.RandomSleep2(600, 600, 600)
        end
        API.DoAction_Interface(0x24,0xffffffff,1,131,16,-1,API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(600, 600, 600)
        API.DoAction_Interface(0x24,0xffffffff,1,131,8,-1,API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(600, 600, 600)
    elseif getDivinationLevel() < 20 then
        if API.PInArea(3005, 12, 3402, 12, 0) then return end
        if not API.PInArea(2967, 5, 3403, 5, 0) then
            waitAnim()
            LODESTONES.FALADOR.Teleport()
        end
        run_to_tile(3005, 3402, 0)
    elseif getDivinationLevel() < 30 then
        if API.PInArea(3302, 10, 3394, 10, 0) then return end
        if not API.PInArea(3214, 5, 3376, 5, 0) then
            waitAnim()
            LODESTONES.VARROCK.Teleport()
        end
        run_to_tile(3254, 3372, 0)
        run_to_tile(3302, 3394, 0)
    elseif getDivinationLevel() < 40 then
        if API.PInArea(2734, 10, 3414, 10, 0) then return end
        if not API.PInArea(2756, 5, 3477, 5, 0) and API.InvItemFound1(8010) then
            waitAnim()
            API.DoAction_Inventory1(8010,0,1,API.OFF_ACT_GeneralInterface_route)
            while API.Read_LoopyLoop() and not API.PInArea(2756, 5, 3477, 5, 0) do
                API.RandomSleep2(600, 600, 600)
            end
            API.RandomSleep2(600, 600, 600)
            run_to_tile(2734, 3417, 0)
        elseif isSeersLodeUnlocked and not API.PInArea(2769, 12, 3597, 12, 0) and not API.PInArea(2756, 8, 3477, 8, 0) and not API.PInArea(2735, 50, 3458, 50, 0) then
            waitAnim()
            LODESTONES.SEERS_VILLAGE.Teleport()
            run_to_tile(2719,3461,0)
            run_to_tile(2727,3437,0)
            run_to_tile(2735,3412,0)
        end
    elseif getDivinationLevel() < 50 then
        if API.PInArea(2769, 12, 3597, 12, 0) then return end
        if not API.PInArea(2769, 12, 3597, 12, 0) and not API.PInArea(2756, 8, 3477, 8, 0) and API.InvItemFound1(8010) then
            if API.InvItemFound1(8010) then
                waitAnim()
                API.DoAction_Inventory1(8010,0,1,API.OFF_ACT_GeneralInterface_route)
                while API.Read_LoopyLoop() and not API.PInArea(2756, 8, 3477, 8, 0) do
                    API.RandomSleep2(600, 600, 600)
                end
                API.RandomSleep2(600, 600, 600)
            end
        elseif isSeersLodeUnlocked and not API.PInArea(2769, 12, 3597, 12, 0) and not API.PInArea(2756, 8, 3477, 8, 0) then
            waitAnim()
            LODESTONES.SEERS_VILLAGE.Teleport()
        end
        run_to_tile(2727,3470,0)
        run_to_tile(2741,3533,0)
        run_to_tile(2715,3543,0)
        run_to_tile(2697,3542,0)
        run_to_tile(2663,3557,0)
        run_to_tile(2652,3585,0)

        run_to_tile(2653,3608,0)

        run_to_tile(2700,3601,0)
        run_to_tile(2732,3595,0)
        run_to_tile(2769,3595,0)
        
    elseif getDivinationLevel() < 60 then
        if API.PInArea(2888, 12, 3047, 12, 0) then return end
        if API.InvItemFound1(19479) then
            waitAnim()
            API.DoAction_Inventory1(19479,0,1,API.OFF_ACT_GeneralInterface_route)
            while API.Read_LoopyLoop() and not API.PInArea(2803, 8, 3086, 8, 0) do
                API.RandomSleep2(600, 600, 600)
            end
            API.RandomSleep2(600, 600, 600)
            run_to_tile(2841,3061, 0)
            run_to_tile(2872,3049, 0)
            run_to_tile(2887,3047, 0)
        elseif isKaramjaLodeUnlocked and not API.PInArea(2888, 12, 3047, 12, 0) then
            waitAnim()
            if not API.PInArea(2803, 5, 3086, 5, 0) then LODESTONES.KARAMJA.Teleport() end
            run_to_tile(2780,3132,0)
            run_to_tile(2798,3117,0)
            run_to_tile(2818,3109,0)
            run_to_tile(2840,3092,0)
            run_to_tile(2853,3068,0)
            run_to_tile(2861,3055,0)
            run_to_tile(2872,3039,0)
            run_to_tile(2887,3046,0)
        end
    elseif getDivinationLevel() < 70 then
        if not API.PInArea(2420, 12, 2863, 12, 0) and API.InvItemFound1(2552) then
            waitAnim()
            API.DoAction_Inventory1(2552,0,7,API.OFF_ACT_GeneralInterface_route2)
            while API.Read_LoopyLoop() and not API.Compare2874Status(13, false) do
                API.RandomSleep2(600, 600, 600)
            end
            API.DoAction_Interface(0xffffffff,0xffffffff,0,720,23,-1,API.OFF_ACT_GeneralInterface_Choose_option)
            while API.Read_LoopyLoop() and not API.PInArea(2411, 10, 2848, 10, 0) do
                API.RandomSleep2(600, 600, 600)
            end
            run_to_tile(2420,2862, 0) 
        elseif isOoglogLodeUnlocked and not API.PInArea(2420, 12, 2863, 12, 0) and not API.PInArea(2411, 10, 2848, 10, 0) then
            waitAnim()
            if not API.PInArea(2532, 5, 2871, 5, 0) then LODESTONES.OOGLOG.Teleport() end
            run_to_tile(2486,2885,0)
            run_to_tile(2452,2884,0)
            run_to_tile(2422,2865,0)
        end
    elseif getDivinationLevel() >= 70 and isCanafisLodeUnlocked then
        if not API.PInArea(3468, 12, 3537, 12, 0) then
            waitAnim()
            if not API.PInArea(3517, 5, 3515, 5, 0) then LODESTONES.CANIFIS.Teleport() end
            run_to_tile(3477,3521,0)
            run_to_tile(3468,3538,0)
        end
    end
end

API.SetDrawTrackedSkills(true)
API.ScriptRuntimeString()
API.GetTrackedSkills()


API.Write_LoopyLoop(true)
while(API.Read_LoopyLoop())
do-----------------------------------------------------------------------------------
    

if not API.InvFull_() and API.ReadPlayerAnim() == 0 then newArea() end  


divDiv()
UTILS:antiIdle()

API.RandomSleep2(300, 200, 200)
end----------------------------------------------------------------------------------
