

local API = require("api")
API.Write_fake_mouse_do(false)
local UTILS = require("utils")
local LODESTONES = require("lodestones")



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
        if i >= 6 then
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


local function divDiv()
    if not API.Read_LoopyLoop() or not API.PlayerLoggedIn() then return end

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
        if API.PInArea(3121, 10, 3217, 10, 0) then return end
        if not API.PInArea(3105, 5, 3298, 5, 0) then
            waitAnim()
            LODESTONES.DraynorVillage()
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
        if API.PInArea(3005, 10, 3402, 10, 0) then return end
        if not API.PInArea(2967, 5, 3403, 5, 0) then
            waitAnim()
            LODESTONES.Falador()
        end
        run_to_tile(3005, 3402, 0)
    elseif getDivinationLevel() < 30 then
        if API.PInArea(3302, 10, 3394, 10, 0) then return end
        if not API.PInArea(3214, 5, 3376, 5, 0) then
            waitAnim()
            LODESTONES.Varrock()
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
            run_to_tile(2734, 3417, 0)
        end
    elseif getDivinationLevel() < 50 then
        if API.PInArea(2769, 10, 3597, 10, 0) then return end
        if not API.PInArea(2734, 10, 3414, 10, 0) then
            if API.InvItemFound1(8010) then
                waitAnim()
                API.DoAction_Inventory1(8010,0,1,API.OFF_ACT_GeneralInterface_route)
                while API.Read_LoopyLoop() and not API.PInArea(2756, 5, 3477, 5, 0) do
                    API.RandomSleep2(600, 600, 600)
                end
            end
        end
        run_to_tile(2728,3481,0)
        run_to_tile(2741,3533,0)
        run_to_tile(2715,3543,0)
        run_to_tile(2697,3542,0)
        run_to_tile(2663,3557,0)
        run_to_tile(2652,3585,0)

        run_to_tile(2653,3608,0)

        run_to_tile(2700,3601,0)
        run_to_tile(2732,3595,0)
        run_to_tile(2769,3590,0)
    elseif getDivinationLevel() < 60 then
        if API.PInArea(2888, 10, 3047, 10, 0) then return end
        if not API.PInArea(2803, 5, 3086, 5, 0) and API.InvItemFound1(19479) then
            waitAnim()
            API.DoAction_Inventory1(19479,0,1,API.OFF_ACT_GeneralInterface_route)
            while API.Read_LoopyLoop() and not API.PInArea(2803, 5, 3086, 5, 0) do
                API.RandomSleep2(600, 600, 600)
            end
            run_to_tile(2841,3061, 0)
            run_to_tile(2872,3049, 0)
            run_to_tile(2887,3047, 0)
        end
    else
        if not API.PInArea(2420, 10, 2863, 10, 0) and API.InvItemFound1(2552) then
            waitAnim()
            API.DoAction_Inventory1(2552,0,7,API.OFF_ACT_GeneralInterface_route2)
            while API.Read_LoopyLoop() and not API.Compare2874Status(13, false) do
                API.RandomSleep2(600, 600, 600)
            end
            API.DoAction_Interface(0xffffffff,0xffffffff,0,720,23,-1,API.OFF_ACT_GeneralInterface_Choose_option)
            while API.Read_LoopyLoop() and not API.PInArea(2411, 8, 2848, 8, 0) do
                API.RandomSleep2(600, 600, 600)
            end
            run_to_tile(2420,2862, 0)
        end 
    end
end

API.SetDrawTrackedSkills(true)
API.ScriptRuntimeString()
API.GetTrackedSkills()



API.Write_LoopyLoop(true)
while(API.Read_LoopyLoop())
do-----------------------------------------------------------------------------------

newArea()

divDiv()
UTILS:antiIdle()

API.RandomSleep2(300, 200, 200)
end----------------------------------------------------------------------------------
