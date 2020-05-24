-- Name: supplychain.lua
-- Author: n00dles
-- Date Created: 18/05/2020
----------------------------------------------------------------------
-- NOTES:
----------------------------------------------------------------------
-- Prototype taken from Mongrelf on Moose Discord 7th Jan 2019
-- https://discordapp.com/channels/378590350614462464/492386897474224128/531516388615913472
-- YouTube: YouTube: https://youtu.be/STIttEogxto

-- Main Functions
-------------------
-- ProcessWarehouseChain()
-- BuildChain()
-- RedOffMapSupply()
-- BlueOffMapSupply()

-- WCHAIN Functions
--------------------
-- WCHAIN:New()                     -- fixed
-- WCHAIN:GetPrevNodeName()         -- fixed
-- WCHAIN:AddWarehouseToChain()     -- fixed
-- WCHAIN:FindSupplier()            -- untested
-- WCHAIN:SupplyChainManager()      -- untested
-- WCHAIN:WarehouseProcessor()      -- untested
-- WCHAIN:FindNodeInDB()            -- todo
-- WCHAIN:SetNodeName()             -- todo
-- WCHAIN:SetNode()                 -- todo
-- WCHAIN:SetPrevNode()             -- todo
-- WCHAIN:SetNextNode()             -- todo

-- TODO
-- Describe table structure for main arrays
--  * winvtemplate  -- DONE, refactored, added missing vars for AddAsset() call and added to calls to that function and off map resupply
--  * Remove, find, track, fix, replace all UNDEF vars
--  * Replace var names with sanity
--  * Break out clean up and better document various logical operations chain building loops call out imporatant vars etc..
--  * CustomInventory is borked, fix and pull inline with other calls that are wrappers for AddAsset()
--  * Define a set of configuration settings for timers etc that can be turned outside main block
--  * Look at, check for functioning and rename "Sub Nodes" to "Stub Nodes" to better ilistrate the fact they go nowhere
--  * Use MOOSE Sets to handle zone management?
--  * Need a method for associating warehouse names with request functions 


 -- add alias field to WCHAIN
 -- create arry of alias for configuration linked against node (ie zone pulled from ME)
 -- assign at build time
----------------------------------------------------------------------
-- Screw Loose ( DynaMis )
----------------------------------------------------------------------
-- Requests to be defined in logistics file for screw loose mission framework
-- aircraft and ground units control code within dispatcher files.

----------------------------------------------------------------------
-- SUPPLY CHAIN BEGINS
----------------------------------------------------------------------
-- SUPPLY CHAIN BEGINS
----------------------------------------------------------------------
----------------------------------------------------------------------
-- WCHAIN CLASS Def
----------------------------------------------------------------------
-- @type WCHAIN
-- @field #WCHAIN
WCHAIN = {
    ClassName      =   "WCHAIN",    -- @field #string ClassName Name of the class
    wchainindex    =   nil,         -- @field #number wchainindex index to entry in wchaintable (trigger zones)
    nodename       =   nil,         -- @field #string nodename Name of the zone.
    Node           =   nil,         -- @field Core.Zone#ZONE Node = This wchain trigger zone.
    NextNode       =   nil,         -- @field Core.Zone#ZONE NextNode = Next Radius Zone Object in chain.
    PrevNode       =   nil,         -- @field Core.Zone#ZONE PrevNode is the prev Radius Zone Object in Chain.
    airbaseind     =   false,       -- @field #boolean airbaseind true = airbase warehouse
    portind        =   false,       -- @field #boolean portind true = port warehouse
    baseind        =   false,       -- @field #boolean baseind true = warehouse is a 'base warehouse' and holds all potential inventory.
    fullstrength   =   false,       -- @field #boolean fullstrength =  true if all assets in warehouse inventory are at full strength
    strengthp      =   100,         -- @field #number strengthp is percent of inventory required to trip fullstrengthind and resupply requessts.
    requestdelay   =   30,          -- @field #number requestdelay = the time in seconds to wait between spawning groups from warehouse  default =30
    maxpending     =   10,          -- @field #number maxpending = the maximum number of pending requests a warehouse supports before denying further requests
    maxrequests    =   2,           -- @field #number maxrequests = the max number of requests a warehouse can throw into the queue per cycle.
    spawnwithinv   =   false,       -- @field #boolean spawnwithinv = if true warehouse at Zone location will spawn with inventory assets from winvtemplate
    NextWarehouse  =   nil,         -- @field Functional.Warehouse#WAREHOUSE NextWarehouse holds the associated warehouse object for the next warehouse in chain.
    PrevWarehouse  =   nil,         -- @field Functional.Warehouse#WAREHOUSE PrevWarehouse holds the associated warehouse object for the previous warehouse in chain.
    ThisWarehouse  =   nil,         -- @field Functional.Warehouse#WAREHOUSE ThisWarehouse holds the associated warehouse object for this warehouse in chain.
    BaseWarehouse  =   nil,         -- @field Functional.Warehouse#WAREHOUSE BaseWarehouse holds the associated warehouse object for the Base warehouse supporting this warehouse.
    PrevAirhouse   =   nil,         -- @field Functional.Warehouse#WAREHOUSE PrevAirhouse holds the associated warehouse object for the prev airbase warehouse in chain.
    winvtemplate   =   {},          -- @field #table winvtemplate table holds the inventory template for a warehouse.
    alias          =   nil,         -- @field #string alias Alias is the nicename for the wchain instance.
    maxspawnunits  =   1,           -- @field #number maxspawnunits is max number of units to spawn per request
    defensegrp     =   nil,         -- @field #string defensegrp string denoting the Core.Set#SET_ZONE name
    defenselvl     =   0,           -- @field #number defenselvl a number that as it increases indicates more readiness 1 - 3
    nxtactionavail =   0,           -- @field #number nxtactionavail  a number that denotes time in seconds when next action is possible for warehouse
}
----------------------------------------------------------------------
-- DEBUG TRACING
----------------------------------------------------------------------
function CommandStart()
    --self:F2( { Start } )

    local CommandStart = {
      id = 'Start',
      params = {},
    }

   --self:T3( { CommandStart } )
    return CommandStart
end

WCHAIN.INFO = function(text)
    env.info('WCHAIN: '..text)
end

WCHAIN.DEBUG = function(text)
    if WCHAIN_DEBUG then
        WCHAIN.INFO(text)
   end
end

WCHAIN_DEBUG = false

WCHAIN.INFO( "------------------------------------------------" )
WCHAIN.INFO("             Supply Chain")
WCHAIN.INFO( "------------------------------------------------" )
----------------------------------------------------------------------
-- Global Defines
----------------------------------------------------------------------
ProcessedChains = false
SUPPLYCHAINREADY = false

BlueWareHouses = {}
RedWareHouses = {}

WChainTable = {}
BWChain = {}
RWChain = {}

BlueWareHouseCounter = 1
RedWareHouseCounter = 1

-- Off map supplies
BlueSupplyTriggerTime = 0
BlueResupplyInterval = 1 * 3600 -- 1 hour

RedSupplyTriggerTime = 0
RedResupplyInterval = 1 * 3600 -- 1 hour

BlueoffMapZone = ZONE:New("BlueOffMapZone")
RedOffMapZone = ZONE:New("RedOffMapZone")

-- Supply manager process interval
BlueSupplyManagerDuration = 300
RedSupplyManagerDuration = 400

-- Warehouse Defences
nextactioninterval = 2 * 3600  -- 2 hours

-- Staic object to spawn from
BlueSupplyWarehouse = SPAWNSTATIC:NewFromStatic("Supply_Zone_Warehouse1", country.id.USA)
RedSupplyWarehouse = SPAWNSTATIC:NewFromStatic("Supply_Zone_Warehouse1", country.id.RUSSIA)

BlueBaseWarehouseInv = {}
RedBaseWareHouseInv = {}

BlueDefaultWareHouseInventory = {}
RedDefaultWareHouseInventory = {}

BlueWareHouseCustomInventory = {}
RedWareHouseCustomInventory = {}

-- TODO for now this list needs to be in the order warehouses are defined in ME #001, #002, #003 etc..
-- simple user define keys to match ME zones would make it idiot proof.
-- REPLACED WITH DATABASE

WarehouseDB = {"Kobuleti",
            "Senaki_Kolkhi",
            "Zugdidi",
            "BlueFrontLine",
            "Sukhumi_Babushara",
            "Sukhumi",
            "Gudauta",
            "Sochi_Adler",
            "Maykop_Khanskaya"
        }

-- TODO Is this needed? or is it just an odd hold over from ported code...?
-- test replacing refereces with WarehouseDB
local warehouse = {}

----------------------------------------------------------------------
-- Warehouse Invetory Def
----------------------------------------------------------------------
-- Basically a wrapper for:
--      WAREHOUSE.__AddAsset(delay, group, ngroups, forceattribute, forcecargobay, forceweight, loadradius, skill, liveries, assignment)
-- IMPORTANT NOTE: last field in the table is used for supply chain request timers so defining a line needs to be in FULL, ending in 0

-- @type WCHAIN.winvtemplate
-- @field #string groupname
-- @field #number groupqty quantity of groups in inventory
-- @field #WAREHOUSE.Attribute GroupCategory
-- @field forcecargobay
-- @field forceweight
-- @field loadradius
-- @field skill
-- @field liveries
-- @field assignment
-- @field #number nextreqtime The next time a request can be made for this inventory group

-- Blue
-- Warehouse Template for warehouses with baseind = true
BlueBaseWarehouseInv[#BlueBaseWarehouseInv+1] = {"Blue Infantry Platoon", 24, WAREHOUSE.Attribute.GROUND_INFANTRY, nil, nil, nil, nil, {}, "", 0}
BlueBaseWarehouseInv[#BlueBaseWarehouseInv+1] = {"Blue Truck", 20, WAREHOUSE.Attribute.GROUND_TRUCK, nil, nil, nil, nil, {}, "", 0}
BlueBaseWarehouseInv[#BlueBaseWarehouseInv+1] = {"Blue APC1", 20, WAREHOUSE.Attribute.GROUND_APC, nil, nil, nil, nil, {}, "", 0}
BlueBaseWarehouseInv[#BlueBaseWarehouseInv+1] = {"Blue Armor Group", 20, WAREHOUSE.Attribute.GROUND_TANK, nil, nil, nil, nil, {}, "", 0}
BlueBaseWarehouseInv[#BlueBaseWarehouseInv+1] = {"Blue Air Defense SAM", 5, WAREHOUSE.Attribute.GROUND_SAM, nil, nil, nil, nil, {}, "", 0}
BlueBaseWarehouseInv[#BlueBaseWarehouseInv+1] = {"Blue Air Defense Gun #002", 10, WAREHOUSE.Attribute.GROUND_SAM, nil, nil, nil, nil, {}, "", 0}
BlueBaseWarehouseInv[#BlueBaseWarehouseInv+1] = {"Blue Air Defense SAM #002", 10, WAREHOUSE.Attribute.GROUND_SAM, nil, nil, nil, nil, {}, "", 0}
BlueBaseWarehouseInv[#BlueBaseWarehouseInv+1] = {"A10 Tactical Bomber", 12, WAREHOUSE.Attribute.AIR_BOMBER, nil, nil, nil, nil, {}, "", 0}
BlueBaseWarehouseInv[#BlueBaseWarehouseInv+1] = {"Blue CAP", 12, WAREHOUSE.Attribute.AIR_FIGHTER, nil, nil, nil, nil, {}, "", 0}
BlueBaseWarehouseInv[#BlueBaseWarehouseInv+1] = {"C-130Herc", 2, WAREHOUSE.Attribute.AIR_TRANSPORTPLANE, nil, nil, 0, nil, {}, "", 0}
BlueBaseWarehouseInv[#BlueBaseWarehouseInv+1] = {"C-17Globe", 2, WAREHOUSE.Attribute.AIR_TRANSPORTPLANE, 50000, nil, 0, nil, {}, "", 0}
BlueBaseWarehouseInv[#BlueBaseWarehouseInv+1] = {"Blue Transport Helo CH47", 4, WAREHOUSE.Attribute.AIR_TRANSPORTHELO, 4000, nil, nil, nil, {}, "", 0}
BlueBaseWarehouseInv[#BlueBaseWarehouseInv+1] = {"Overlord", 2, WAREHOUSE.Attribute.AIR_AWACS, nil, nil, nil, nil, {}, "", 0}
BlueBaseWarehouseInv[#BlueBaseWarehouseInv+1] = {"Texaco", 2, WAREHOUSE.Attribute.AIR_TANKER, nil, nil, nil, nil, {}, "", 0}
-- Red
-- Warehouse Template for warehouses with baseind = true
RedBaseWareHouseInv[#RedBaseWareHouseInv+1] = {"Red Infantry Platoon", 40, WAREHOUSE.Attribute.GROUND_INFANTRY, nil, nil, nil, nil, {}, "", 0}
RedBaseWareHouseInv[#RedBaseWareHouseInv+1] = {"Red Truck", 30, WAREHOUSE.Attribute.GROUND_TRUCK, nil, nil, nil, nil,{}, "", 0}
RedBaseWareHouseInv[#RedBaseWareHouseInv+1] = {"Red APC", 30, WAREHOUSE.Attribute.GROUND_APC, nil, nil, nil, nil,{}, "", 0}
RedBaseWareHouseInv[#RedBaseWareHouseInv+1] = {"Red Armor Group", 30, WAREHOUSE.Attribute.GROUND_TANK, nil, nil, nil, nil,{}, "", 0}
RedBaseWareHouseInv[#RedBaseWareHouseInv+1] = {"Red SAM #001", 15, WAREHOUSE.Attribute.GROUND_SAM, nil, nil, nil, nil,{}, "", 0}
RedBaseWareHouseInv[#RedBaseWareHouseInv+1] = {"Red SAM #002", 15, WAREHOUSE.Attribute.GROUND_SAM, nil, nil, nil, nil,{}, "", 0}
RedBaseWareHouseInv[#RedBaseWareHouseInv+1] = {"SU-33 CAP", 12, WAREHOUSE.Attribute.AIR_FIGHTER, nil, nil, nil, nil,{}, "", 0}
RedBaseWareHouseInv[#RedBaseWareHouseInv+1] = {"An30", 2, WAREHOUSE.Attribute.AIR_TRANSPORTPLANE, nil, nil, nil, nil,{}, "", 0}
RedBaseWareHouseInv[#RedBaseWareHouseInv+1] = {"IL76", 2, WAREHOUSE.Attribute.AIR_TRANSPORTPLANE, 50000, nil, nil, nil,{}, "", 0}
RedBaseWareHouseInv[#RedBaseWareHouseInv+1] = {"Red Transport Helo MI8", 2, WAREHOUSE.Attribute.AIR_TRANSPORTHELO, 3000, nil, nil, nil,{}, "", 0}
RedBaseWareHouseInv[#RedBaseWareHouseInv+1] = {"Red Transport Helo MI24", 2, WAREHOUSE.Attribute.AIR_TRANSPORTHELO, 3000, nil, nil, nil,{}, "", 0}

-- Blue 
-- Default Warehouse Template for warehouses with baseind = false and No Custom Inventory template
BlueDefaultWareHouseInventory[#BlueDefaultWareHouseInventory+1] = {"Blue Infantry Platoon", 5, WAREHOUSE.Attribute.GROUND_INFANTRY, nil, nil, nil, nil, {}, "", 0}
BlueDefaultWareHouseInventory[#BlueDefaultWareHouseInventory+1] = {"Blue Truck", 5, WAREHOUSE.Attribute.GROUND_TRUCK, nil, nil, nil, nil, {}, "", 0}
BlueDefaultWareHouseInventory[#BlueDefaultWareHouseInventory+1] = {"Blue APC1", 5, WAREHOUSE.Attribute.GROUND_APC, nil, nil, nil, nil, {}, "", 0}
BlueDefaultWareHouseInventory[#BlueDefaultWareHouseInventory+1] = {"Blue Armor Group", 5, WAREHOUSE.Attribute.GROUND_TANK, nil, nil, nil, nil, {}, "", 0}
BlueDefaultWareHouseInventory[#BlueDefaultWareHouseInventory+1] = {"Blue Air Defense SAM", 5, WAREHOUSE.Attribute.GROUND_SAM, nil, nil, nil, nil, {}, "", 0}
BlueDefaultWareHouseInventory[#BlueDefaultWareHouseInventory+1] = {"Blue Air Defense Gun #002", 5, WAREHOUSE.Attribute.GROUND_SAM, nil, nil, nil, nil, {}, "", 0}
BlueDefaultWareHouseInventory[#BlueDefaultWareHouseInventory+1] = {"Blue Air Defense SAM #002", 5, WAREHOUSE.Attribute.GROUND_SAM, nil, nil, nil, nil, {}, "", 0}
BlueDefaultWareHouseInventory[#BlueDefaultWareHouseInventory+1] = {"Blue Transport Helo CH47", 1, WAREHOUSE.Attribute.AIR_TRANSPORTHELO, 4000, nil, nil, nil,{}, "", 0}

-- Red 
-- Default Warehouse Template for warehouses with baseind = false and No Custom Inventory template
RedDefaultWareHouseInventory[#RedDefaultWareHouseInventory+1] = {"Red Infantry Platoon", 5, WAREHOUSE.Attribute.GROUND_INFANTRY, nil, nil, 5000, nil, {}, "", 0}
RedDefaultWareHouseInventory[#RedDefaultWareHouseInventory+1] = {"Red Truck", 5, WAREHOUSE.Attribute.GROUND_TRUCK, nil, nil, 100, nil,{}, "", 0}
RedDefaultWareHouseInventory[#RedDefaultWareHouseInventory+1] = {"Red APC", 5, WAREHOUSE.Attribute.GROUND_APC, nil, nil, 100, nil,{}, "", 0}
RedDefaultWareHouseInventory[#RedDefaultWareHouseInventory+1] = {"Red Armor Group", 5, WAREHOUSE.Attribute.GROUND_TANK, nil, nil, nil, nil,{}, "", 0}
RedDefaultWareHouseInventory[#RedDefaultWareHouseInventory+1] = {"Red SAM #001", 5, WAREHOUSE.Attribute.GROUND_SAM, nil, nil, nil, nil,{}, "", 0}
RedDefaultWareHouseInventory[#RedDefaultWareHouseInventory+1] = {"Red Transport Helo MI8", 1, WAREHOUSE.Attribute.AIR_TRANSPORTHELO, 3000, nil, 2000, nil,{}, "", 0}
RedDefaultWareHouseInventory[#RedDefaultWareHouseInventory+1] = {"Red Transport Helo MI24", 1, WAREHOUSE.Attribute.AIR_TRANSPORTHELO, 3000, nil, 2000, nil,{}, "", 0}

-- TODO These are borken
--[[ 
2020-05-20 02:18:37.256 INFO    SCRIPTING: Adding warehouse v1.0.2 for structure 2 with alias BlueWareHouse2
2020-05-20 02:18:37.258 INFO    SCRIPTING: Error in timer function: [string "E:/code/supplychain/supplychain.lua"]:693: attempt to get length of field '?' (a nil value)
2020-05-20 02:18:37.258 INFO    SCRIPTING: stack traceback:
    [string "Scripts/Moose/Core/ScheduleDispatcher.lua"]:179: in function <[string "Scripts/Moose/Core/ScheduleDispatcher.lua"]:176>
    [string "E:/code/supplychain/supplychain.lua"]:693: in function 'AddWarehouseToChain'
    [string "E:/code/supplychain/supplychain.lua"]:1183: in function <[string "E:/code/supplychain/supplychain.lua"]:1174>
    (tail call): ?
    [C]: in function 'xpcall'
    [string "Scripts/Moose/Core/ScheduleDispatcher.lua"]:232: in function <[string "Scripts/Moose/Core/ScheduleDispatcher.lua"]:168>
--]]
--[[
-- custom  warehouse template for warehouses by warehouse name
BlueWareHouseCustomInventory["<BlueCutomWarehouseName>"] = {
            {"Blue Air Defense SAM #002", 2, WAREHOUSE.Attribute.GROUND_SAM, 0},
            {"Blue Infantry Platoon", 8, WAREHOUSE.Attribute.GROUND_INFANTRY, 0},
            {"Blue APC1", 10, WAREHOUSE.Attribute.GROUND_APC, 0},
            {"Blue Armor Group", 4, WAREHOUSE.Attribute.GROUND_APC, 0},
            {"Blue Air Defense Gun #002", 4, WAREHOUSE.Attribute.GROUND_SAM, 0}
}
-- RED Warehouses
RedWareHouseCustomInventory["<RedCutomWarehouseName>"] = {
            {"Red Infantry Platoon", 6, WAREHOUSE.Attribute.GROUND_INFANTRY, 0},
            {"Red APC", 4, WAREHOUSE.Attribute.GROUND_APC, 0},
            {"Red Armor Group", 4, WAREHOUSE.Attribute.GROUND_TANK, 0},
            {"Red Truck", 4, WAREHOUSE.Attribute.GROUND_TRUCK, 0},
            {"Red SAM #002", 2, WAREHOUSE.Attribute.GROUND_SAM, 0},
            {"Red SAM #001", 2, WAREHOUSE.Attribute.GROUND_SAM, 0}
}
--]]

----------------------------------------------------------------------
-- BuildChain()
----------------------------------------------------------------------
function BuildChain()
    local DebugFunc = "BuildChain(): "
    local wcnodes = SET_ZONE:New()
    wcnodes:FilterPrefixes("wchain #0")
    wcnodes:FilterOnce()

    --local zoneproc = true       -- UNDEF?..
    --local nodecount = 0         -- UNDEF?..
    --local tempnodetable = {}    -- UNDEF?..
    --TODO This PLUS 1 SUPER IMPORTANT, Prototype code SUPER BROKEN, For loop in lua stops at count,
    -- thus it was cutting off the last element of all tables!
    -- they all need re-writing to make this clear!
    local indexcounter = wcnodes:Count() +1  -- while loop control itterate over zone list

    WCHAIN.INFO(DebugFunc .. "Starting")

    local z = 1    -- While loop control var
    local wchainindex = 1   -- W Chain zone table index reference.

    while z < indexcounter do
        wcnodes = SET_ZONE:New() -- why?
        WCHAIN.DEBUG(DebugFunc .. "Index Counter = " .. indexcounter .. " z = " .. z)
        local prefixstring

        -- check zone name handle double digits
        if z < 10 then
            prefixstring = "wchain #00" .. z
            wcnodes:FilterPrefixes(prefixstring)
            wcnodes:FilterStart()
        else
            prefixstring = "wchain #0" .. z
            wcnodes:FilterPrefixes("wchain #0" .. z)
            wcnodes:FilterStart()
        end

        WCHAIN.DEBUG(DebugFunc .. "Prefix String = " .. prefixstring)
        WCHAIN.DEBUG(DebugFunc .. "wcnodes Count = " .. wcnodes:Count())

        -- Add zones to W Chain Table
        local insertcounter = 0
        if wcnodes:Count() == 1 then        -- If found number of zones is one
            local foundnodename = prefixstring      -- copy to foundnode
            WChainTable[wchainindex] = foundnodename        -- insert @ table index defined in wchainindex

            WCHAIN.DEBUG(DebugFunc .. "Node Name = " .. foundnodename)
            WCHAIN.DEBUG(DebugFunc .. "Number = " .. z)

            wchainindex = wchainindex + 1       -- increment table index 
        else    -- find subnodes
            wcnodes:ForEachZone(
                function(mooseobj)
                    local nodename = mooseobj:GetName()
                    --local nodenumber = string.sub(nodename, 9 ,11)      -- UNDEF?....
                    local nodeletter = string.sub(nodename, 12)     -- nibble alpha index from string
                    local insertloc = wchainindex + string.byte(nodeletter) - 97        -- obtain index order from byte value
                    WChainTable[insertloc] = nodename       -- update Chain table
                    insertcounter = insertcounter + 1       -- increment insert count
                end
            )
            -- increment index with new entries
            wchainindex = wchainindex + insertcounter
        end
        -- increment loop control var
        z = z + 1
    end

    for x = 1, #WChainTable do
        WCHAIN.DEBUG(DebugFunc .. "NodeName: " .. WChainTable[x])
    end

    -- WChainTable populated        ?? only seeing 3 values in list not 4...
    -- itterate to build node links

    WCHAIN.DEBUG(DebugFunc .. "Start node assignment. WChainTable count = " .. #WChainTable)

    for y = 1, #WChainTable do
        local tempnodename = WChainTable[y]
        local node = ZONE:FindByName(tempnodename)

        -- Link 1 is blue base
        if y == 1 then
            BWChain[tempnodename] = WCHAIN:New()

            -- Set values for blue base
            BWChain[tempnodename].winvtemplate = BlueBaseWarehouseInv
            BWChain[tempnodename].nodename = tempnodename
            BWChain[tempnodename].spawnwithinv = true
            BWChain[tempnodename].airbaseind = true
            BWChain[tempnodename].wchainindex = y
            BWChain[tempnodename].baseind = true
            BWChain[tempnodename].Node = node
            BWChain[tempnodename].fullstrength = true
            BWChain[tempnodename].alias = WarehouseDB[y]

            BWChain[tempnodename] = BWChain[tempnodename]:AddWarehouseToChain(coalition.side.BLUE)
        else
            WCHAIN.DEBUG(DebugFunc ..  "Processing Chain Node: " .. tempnodename)
            BWChain[tempnodename] = WCHAIN:New()
            BWChain[tempnodename].nodename = tempnodename
            BWChain[tempnodename].Node = node
            BWChain[tempnodename].wchainindex = y
            BWChain[tempnodename].alias = WarehouseDB[y]
            --if y == 2 then
            --    BWChain[tempnodename].fullstrength = true
            --end

            -- get previous nodes in BuildChain
            BWChain[tempnodename] = BWChain[tempnodename]:GetPrevNodeName(coalition.side.BLUE)
            --WCHAIN.DEBUG("NodeName " .. BWChain[tempnodename].nodename)
            --WCHAIN.DEBUG("Previous NodeName " .. BWChain[tempnodename].prevnodename)
        end
    end

    -- build "next" list by iterating through BuildChain
    for  x = 1, #WChainTable - 1 do
        local nextnodetemp = {}
        local tempnodename = WChainTable[x]

        -- look for matches between currentnode and prev node to id nextnode
        for y = 1, #WChainTable do
            local tnode1 = WChainTable[y]
            if BWChain[tempnodename].nodename == BWChain[tnode1].prevnodename then      -- if node matches value of prevnodename
                nextnodetemp[#nextnodetemp +1] = {BWChain[tnode1].nodename}     -- next temp node is +1 
            end
        end

        -- subnodes prevnodenames don't get filled in for all subnodes
        -- through the GetPrevNodeName function so have to accomodate
        -- should be situ (ex: 3c->4b) = stragglers
        if #nextnodetemp > 0 then
            BWChain[tempnodename].nextnodenames = nextnodetemp
            nextnodetemp= nil
        else
            WCHAIN.DEBUG(DebugFunc .. "nextnodenames == NIL")
            WCHAIN.DEBUG(DebugFunc .. "NodeName = " .. tempnodename)
            -- look adhead for stub Nodes
            local currentnodenumber = string.sub(tempnodename, 9,11)
            local nodeprefix = string.sub(tempnodename, 1, 8)
            local currentsubnode = string.sub(tempnodename, 12)
            local nodenum = tonumber(currentnodenumber) + 1
            local nextnodenumstring = tostring(nodenum)

            -- TODO Turn this into a function()
            -- setup to handle case where numeric digits change to 10's
            if string.len(nextnodenumstring) == 1 then
                nextnodenumstring = "00" .. nextnodenumstring
            else
                nextnodenumstring = "0" .. nextnodenumstring
            end

            local procflag = true
            local prevsubnodechar = currentsubnode
            local searchnode = ""
            while procflag == true do
                -- build BWChain string
                searchnode = nodeprefix .. nextnodenumstring .. prevsubnodechar
                -- find step down example 4b -> 3c
                if BWChain[searchnode] ~= nil then
                    nextnodetemp[#nextnodetemp + 1] = {searchnode}
                    BWChain[tempnodename].nextnodenames = nextnodetemp
                    nextnodetemp = nil
                    procflag = false
                else    -- stepdown not found
                    WCHAIN.DEBUG(DebugFunc .. "Node Name = " .. tempnodename)
                    WCHAIN.DEBUG(DebugFunc .. "searchnode = " .. searchnode)
                    WCHAIN.DEBUG(DebugFunc .. "nodenum = " .. nodenum)
                    WCHAIN.DEBUG(DebugFunc .. "prevsubnodechar = " .. prevsubnodechar)
                    local prevsubnodebyte = string.byte(prevsubnodechar) - 1
                    if prevsubnodebyte < 97 then
                        WCHAIN.DEBUG(DebugFunc .. "Reached end -- error")
                        break
                    end
                    prevsubnodechar = string.char(prevsubnodebyte)
                end
            end
        end
    end

    -----------------------------------------------------------------
    --- Debug
    -----------------------------------------------------------------
    -- drop thought chain and print links
    for x = 1, #WChainTable - 1 do
        local index = WChainTable[x]
        if x ~= 1 then
            --WCHAIN.DEBUG("Node Name - Prev = " .. index .. " " .. BWChain[index].prevnodename)
            --WCHAIN.DEBUG("Prev Node = " .. BWChain[index].prevnodename)
        else
            --WCHAIN.DEBUG("Node Name = " .. index .. "Prev Node: None")
        end
        for y = 1, #BWChain[index].nextnodenames do
            if #BWChain[index].nextnodenames > 0 then
                if x == 1 then
                    WCHAIN.DEBUG(DebugFunc .. "Prev/Current/Next = " .. " None " .. BWChain[index].nodename .. " " .. BWChain[index].nextnodenames[y][1])
                else
                    WCHAIN.DEBUG(DebugFunc .. "Prev/Current/Next = " .. BWChain[index].prevnodename .. " " .. BWChain[index].nodename .. " " .. BWChain[index].nextnodenames[y][1])
                end
            end
        end
    end
    -----------------------------------------------------------------
    --- Debug
    -----------------------------------------------------------------

    -- Build Red chain iterating backwards
    local index = #WChainTable
    for y = 1, #WChainTable do
        local tempnodename = WChainTable[index]
        local node = ZONE:FindByName(tempnodename)

        if index == #WChainTable then
            RWChain[tempnodename] = WCHAIN:New()
            -- setup Red base
            RWChain[tempnodename].winvtemplate = RedBaseWareHouseInv
            RWChain[tempnodename].nodename = tempnodename
            RWChain[tempnodename].spawnwithinv = true
            RWChain[tempnodename].airbaseind = true
            RWChain[tempnodename].wchainindex = y
            RWChain[tempnodename].baseind = true
            RWChain[tempnodename].Node = node
            RWChain[tempnodename].fullstrength = true
            RWChain[tempnodename].alias = WarehouseDB[index]

            RWChain[tempnodename] = RWChain[tempnodename]:AddWarehouseToChain(coalition.side.RED)
        else
            RWChain[tempnodename] = WCHAIN:New()
            RWChain[tempnodename].nodename = tempnodename
            RWChain[tempnodename].Node = node
            RWChain[tempnodename].wchainindex = y
            RWChain[tempnodename].alias = WarehouseDB[index]
            RWChain[tempnodename] = RWChain[tempnodename]:GetPrevNodeName(coalition.side.RED)
        end

        if index > 1 then
            index = index - 1
        end
    end

    -- Populate next node names for red
    for x = #WChainTable, 2, -1 do
        local nextnodetemp = {}
        local tempnodename = WChainTable[x]

        for y = #WChainTable, 1, -1 do
            local tnode1 = WChainTable[y]
            if RWChain[tempnodename].nodename == RWChain[tnode1].prevnodename then
                nextnodetemp[#nextnodetemp +1] = {RWChain[tnode1].nodename}
            end
        end

        -- subnodes prev node names don't get filled for all stubs
        -- via GetPrevNodeName function so work around
        if #nextnodetemp > 0 then
            RWChain[tempnodename].nextnodenames = nextnodetemp
            nextnodetemp = nil
        else
            WCHAIN.DEBUG(DebugFunc .. "Processing nextnodenames == NIL")
            WCHAIN.DEBUG(DebugFunc .. "NodeName = " .. tempnodename)
            -- look ahead for stub node
            local currentnodenumber = string.sub(tempnodename, 9, 11)
            local nodeprefix = string.sub(tempnodename, 1, 8)
            local currentsubnode = string.sub(tempnodename, 12)
            local nodenum = tonumber(currentnodenumber) - 1
            local nextnodenumstring = tostring(nodenum)

            -- TODO Turn this into a function()
            -- handle numbers in 10's
            if string.len(nextnodenumstring) == 1 then
                nextnodenumstring = "00" .. nextnodenumstring
            else
                nextnodenumstring = "0" .. nextnodenumstring
            end

            local procflag = true
            local prevsubnodechar = currentsubnode
            local searchnode = ""
            while procflag == true do
                -- build chain string
                searchnode = nodeprefix .. nextnodenumstring .. prevsubnodechar
                -- stepdown
                if RWChain[searchnode] ~= nil then
                    nextnodetemp[#nextnodetemp + 1] = {searchnode}
                    RWChain[tempnodename].nextnodenames = nextnodetemp
                    procflag = false
                else -- none found stepdown
                    WCHAIN.DEBUG(DebugFunc .. "Node Name = " .. tempnodename)
                    WCHAIN.DEBUG(DebugFunc .. "SearchNode = " .. searchnode)
                    WCHAIN.DEBUG(DebugFunc .. "NodeNum = " .. nodenum)
                    WCHAIN.DEBUG(DebugFunc .. "prevsubnodechar = " .. prevsubnodechar)

                    local prevsubnodebyte = string.byte(prevsubnodechar)
                    if prevsubnodebyte == 97 then
                        WCHAIN.DEBUG(DebugFunc .. "Reached the end - must be primary node")
                        searchnode = nodeprefix .. nextnodenumstring
                        nextnodetemp[#nextnodetemp +1] = {searchnode}
                        RWChain[tempnodename].nextnodenames = nextnodetemp
                        procflag = false
                        WCHAIN.DEBUG(DebugFunc .. "Pushed -> " .. searchnode .. " into " .. tempnodename)
                        WCHAIN.DEBUG(DebugFunc .. "Valuse of next temp = " .. nextnodetemp[1][1])
                    else
                        prevsubnodebyte = prevsubnodebyte - 1
                        prevsubnodechar = string.char(prevsubnodebyte)
                    end
                end
            end
        end
    end

    -----------------------------------------------------------------
    --- Debug
    -----------------------------------------------------------------
    -- drop thought chain and print links
    for x = #WChainTable, 2, -1 do
        local index = WChainTable[x]
        --if x ~= 1 then
            --WCHAIN.DEBUG("Node Name - Prev = " .. index .. " " .. RWChain[index].prevnodename)
            --WCHAIN.DEBUG("Prev Node = " .. RWChain[index].prevnodename)
        --else
            --WCHAIN.DEBUG("Node Name = " .. index .. "Prev Node: None")
        --end
        for y = 1, #RWChain[index].nextnodenames do
            if #RWChain[index].nextnodenames > 0 then
                if x == #WChainTable then
                    WCHAIN.DEBUG(DebugFunc .. "Prev/Current/Next = " .. " None " .. RWChain[index].nodename .. " " .. RWChain[index].nextnodenames[y][1])
                else
                    WCHAIN.DEBUG(DebugFunc .. "Prev/Current/Next = " .. RWChain[index].prevnodename .. " " .. RWChain[index].nodename .. " " .. RWChain[index].nextnodenames[y][1])
                end
            end
        end
    end
    -----------------------------------------------------------------
    --- Debug
    -----------------------------------------------------------------
end -- end of buildchain()

----------------------------------------------------------------------
-- WCHAIN:New()
----------------------------------------------------------------------
 -- @param #WCHAIN self
 -- @param #WCHAIN wchain
 -- @param #WCHAIN self
function WCHAIN:New(wchain)
    wchain = wchain or {}
    setmetatable(wchain, self)
    self.__index = self
    --WCHAIN.db.Nodes[nodename]=self  -- returns undef???
    return wchain
end -- end of WCHAIN:New()

----------------------------------------------------------------------
-- WCHAIN:GetPrevNodeName()
----------------------------------------------------------------------
  -- @param #WCHAIN self
  -- @param #Number coalition 
  -- @return #WCHAIN self
function WCHAIN:GetPrevNodeName(coalition)
    local DebugFunc = "GetPrevNodeName(): "
    local tcoalition = coalition
    local cnodename = self.nodename
    local currentnodenumber = string.sub(cnodename, 9, 11)
    local nodeprefix = string.sub(cnodename, 1, 8)
    local currentsubnode = ""
    --local nextnodetable = {}    -- undef
    --local subnodechar = 0       -- undef
    local savedsubnode = ""
    local prevnodenumber = 0
    local prevsubnodebyte
    local prevsubnodechar
    local tempnodename
    local procflag
    local nextnodetemp = {}

    -- update previous number based on direction through chain
    if tcoalition == 2 then
        prevnodenumber = tonumber(currentnodenumber) - 1
    else
        prevnodenumber = tonumber(currentnodenumber) + 1
    end

    local prevnodenumstring = tostring(prevnodenumber)

    -- TODO Turn this into a function()
    -- handle numbers in 10's
    if string.len(prevnodenumstring) == 1 then
        prevnodenumstring = "00" .. prevnodenumstring
    else
        prevnodenumstring = "0" .. prevnodenumstring
    end

    -- Seperate nodes into subnodes and those with 0 lengh string
    if string.len(cnodename) == 12 then
        -- node is stub
        currentsubnode = string.sub(cnodename, 12)
        -- look to prev node for existing subnode
        tempnodename = nodeprefix .. prevnodenumstring .. currentsubnode
        WCHAIN.DEBUG(DebugFunc .. "Processing with len(12): " .. tempnodename)
        if BWChain[tempnodename] ~= nil then
            WCHAIN.DEBUG(DebugFunc .. "Found previous subnode: " .. currentsubnode)
            -- found sub node
            self.prevnodename = tempnodename
            return self  -- leave function
        else
            -- no a->a like relationships look for previous subnode - 1  ex. b->a,  c->b etc
            procflag = true
            prevsubnodebyte = string.byte(currentsubnode) -- ascii or char
            WCHAIN.DEBUG(DebugFunc .. "prevsubnodebyte = " .. prevsubnodebyte)
            while procflag == true do
                if prevsubnodebyte > 97 then
                    prevsubnodebyte = prevsubnodebyte - 1
                    prevsubnodechar = string.char(prevsubnodebyte)
                    tempnodename = nodeprefix .. prevnodenumstring .. prevsubnodechar
                    if BWChain[tempnodename] ~= nil then
                        -- found step down
                        WCHAIN.DEBUG(DebugFunc .. "Found previous subnode " .. currentsubnode)
                        procflag = false
                        self.prevnodename = tempnodename
                        return self
                    end
                else
                    if prevsubnodebyte == 97 then -- end of the chain no step downs
                        -- make last node primary node
                        tempnodename = nodeprefix .. prevnodenumstring
                        procflag = false
                        self.prevnodename = tempnodename
                        WCHAIN.DEBUG(DebugFunc .. "---Should Push " .. cnodename .. " into " .. tempnodename .. " ---")
                        return self
                    end
                end
            end
        end
    else
        -- currentnode is a primary node
        -- need to look for previous subnodes which means look for 'a' if not nil and work up the subnodes 
        -- to end of list a, b, c... look to previous node to see if subnode exists
        tempnodename = nodeprefix .. prevnodenumstring .. currentsubnode
        --found prev primary node
        if BWChain[tempnodename] ~= nil then
            self.prevnodename = tempnodename
            return self
        else
            -- must be subnodes then for previous node   ex. nosubnode->c ,  nosubnodec->b etc
            -- let's look first at if 'a' subnode exists
            prevsubnodebyte = 97 -- ascii 97 == a
            procflag = true
            while procflag == true do
                prevsubnodechar = string.char(prevsubnodebyte)
                tempnodename = nodeprefix .. prevnodenumstring .. prevsubnodechar

                -- found prev node a so look for last subnode
                if BWChain[tempnodename] ~= nil then -- found higher sub node
                    savedsubnode = prevsubnodechar
                    prevsubnodebyte = prevsubnodebyte + 1
                    -- now we knoe next node to save to
                    nextnodetemp[#nextnodetemp + 1] = {cnodename}
                    BWChain[tempnodename].nextnodenames = nextnodetemp
                else
                    -- use saved sub since this try not found
                    procflag = false
                    tempnodename = nodeprefix .. prevnodenumstring .. savedsubnode
                    self.prevnodename = tempnodename
                    return self
                end
            end
        end
    end
end  -- end of GetPrevNodeName()

----------------------------------------------------------------------
-- WCHAIN:AddWarehouseToChain()
----------------------------------------------------------------------
-- @param #WCHAIN self
-- @param #WCHAIN wchain
-- @param #number 
-- @return #WCHAIN self
function WCHAIN:AddWarehouseToChain(coalition)
    local DebugFunc = "AddWarehouseToChain(): "
    local warehousecoalition = coalition
    local localwarehouse = nil
    local wbuildstring = ""
    -- Debug
    --MessageToAll("Adding Warehouse -> Node = " .. self.nodename, 30)

    -- Spawn warehouse and assign object
    if warehousecoalition == 2 then
        -- Use Human readable alias to name warehouse
        wbuildstring = self.alias
        -- Spawn warehouse object from ME placed zone marker
        localwarehouse = BlueSupplyWarehouse:SpawnFromZone(self.Node, 0, tostring(BlueWareHouseCounter)) -- DCS function returns nil if passed int
        -- Create warehouse object with alias as name.
        warehouse.wbuildstring = WAREHOUSE:New(localwarehouse, wbuildstring) --Functional.Warehouse#WAREHOUSE

        BlueWareHouseCounter = tonumber(BlueWareHouseCounter) + 1 -- remember to convert back

        -- point to warehouse inventory template  base, custom or default
        if self.baseind == true then
            self.winvtemplate = BlueBaseWarehouseInv
        else
            --TODO this is Borked
            --if BlueWareHouseCustomInventory[warehouse.wbuildstring.alias] ~= nil then
            --if #BlueWareHouseCustomInventory[warehouse.wbuildstring.alias] > 0 then
                --self.winvtemplate = BlueWareHouseCustomInventory[warehouse.wbuildstring.alias]
            --else
                self.winvtemplate = BlueDefaultWareHouseInventory
            --end
        end

        -- Set ThisWarehouse (Current Node's Warehouse)
        self.ThisWarehouse = warehouse.wbuildstring
        -- store links to next, prev warehouseobj's
        BlueWareHouses[#BlueWareHouses + 1] = warehouse.wbuildstring

        if #BlueWareHouses > 1 then
            -- self.PrevWarehouse = BlueWareHouses[#BlueWareHouses - 1]
            for z = #BlueWareHouses -1, 1, -1 do
                local tempnodename = self.prevnodename
                if BWChain[tempnodename].ThisWarehouse ~= nil then
                    self.PrevWarehouse = BWChain[tempnodename].ThisWarehouse
                    BWChain[tempnodename].NextWarehouse = self.ThisWarehouse

                    -- TODO What does this line do??? doesn't seem to have a reference anywhere
                    -- orginal code had two instances of a global, and one local.
                    -- local Previouswarehouse = self.PrevWarehouse.alias    -- UNDEF

                    break
                end
            end
        end
        -- Set Base warehouse
        self.BaseWarehouse = BlueWareHouses[1]
        -- Set PrevAirWarehouse
        self.PrevAirhouse = BlueWareHouses[1]
        -- Add to Database
        WarehouseDB[wbuildstring] = self.ThisWarehouse

    else  -- Process RED AddWarehouseToChain Requests
        -- Use Human readable alias to name warehouse
        wbuildstring = self.alias
        -- Spawn warehouse object from ME placed zone marker
        localwarehouse = RedSupplyWarehouse:SpawnFromZone(self.Node, 0, tostring(RedWareHouseCounter + 100)) -- DCS function returns nil if passed int
        -- Create warehouse object with alias as name.
        warehouse.wbuildstring = WAREHOUSE:New(localwarehouse, wbuildstring) --Functional.Warehouse#WAREHOUSE

        RedWareHouseCounter = tonumber(RedWareHouseCounter) + 1 -- remember to convert back 

        -- point to warehouse inventory template  base, custom or default
        if self.baseind == true then
            self.winvtemplate = RedBaseWareHouseInv
        else
            -- TODO BORKED
            --if bluewarehousecustominventory[warehouse.wbuildstring.alias] ~= nil then
            --if #RedWareHouseCustomInventory[warehouse.wbuildstring.alias] > 0 then
                --self.winvtemplate = RedWareHouseCustomInventory[warehouse.wbuildstring.alias]
            --else
                self.winvtemplate = RedDefaultWareHouseInventory
            --end
        end

        -- Set ThisWarehouse (Current Node's Warehouse)
        -- add current warehouse instance to RWChain.ThisWarehouse
        self.ThisWarehouse = warehouse.wbuildstring
        -- store links to next, prev warehouseobj's
        -- increment ReWareHouses with is warehouse object by full name
        RedWareHouses[#RedWareHouses + 1] = warehouse.wbuildstring
        -- if RedWareHouses index > 1 then we have a previous warehouse that need registering 
        -- other wise register RWChain.<warehouse>.BaseWarehouse and RWChain.<warehouse>.PrevAirhouse
        if #RedWareHouses > 1 then
            -- 
            for z = #RedWareHouses -1, 1, -1  do
                   local tempnodename = self.prevnodename
                   if RWChain[tempnodename].ThisWarehouse ~= nil then
                        self.PrevWarehouse = RWChain[tempnodename].ThisWarehouse
                        RWChain[tempnodename].NextWarehouse = self.ThisWarehouse

                        local Previouswarehouse = self.PrevWarehouse.alias -- UNDEF

                        break
                    end
            end
        end
         -- Set Base Warehouse
         self.BaseWarehouse = RedWareHouses[1]
         -- Set PrevAirWarehouse
         self.PrevAirhouse = RedWareHouses[1]
        -- Add to Database
        WarehouseDB[wbuildstring] = self.ThisWarehouse
    end

    -- Set Warehouse status updates to 2min
    self.ThisWarehouse:SetStatusUpdate(120)
    -- Start warehouse = red or blue warehouse
    warehouse.wbuildstring:Start()


    WCHAIN.DEBUG(DebugFunc .. "This Warehouse before airbsae check = " .. self.ThisWarehouse.alias)
    -- Set airbase indicator
    local myairbasename = self.ThisWarehouse:GetAirbaseName()

    WCHAIN.DEBUG(DebugFunc .. "Airbasename = " .. myairbasename)
    if myairbasename ~= "none" then
        self.airbaseind = true
    end

    WCHAIN.DEBUG(DebugFunc .. "Warehouse airbaseind = " .. tostring(self.airbaseind))
    --determine starting inventory for warehouse and load assets
    -- strengthp is the % strength modifier. 50 == 50% etc..
    -- winvtemplate is pointing to the base template inventory = base, custom or default
    if self.spawnwithinv == true then
        local unitstrpercent = self.strengthp
        -- apply modifier
        unitstrpercent = unitstrpercent/100
        WCHAIN.DEBUG(DebugFunc .. "unitstrpercent = " .. unitstrpercent)
        WCHAIN.DEBUG(DebugFunc .. "Count of winvtemplate = " .. #self.winvtemplate)
        for z = 1, #self.winvtemplate do
            local group = self.winvtemplate[z][1]
            local ngroups = self.winvtemplate[z][2]
            local forceattribute = self.winvtemplate[z][3]
            local forcecargobay = self.winvtemplate[z][4]
            local forceweight = self.winvtemplate[z][5]
            local loadradius = self.winvtemplate[z][6]
            local skill = self.winvtemplate[z][7]
            local liveries = self.winvtemplate[z][8]
            local assignment = self.winvtemplate[z][9]
            local mygroupqty = math.ceil(ngroups * unitstrpercent)
            WCHAIN.DEBUG(DebugFunc .. "Would Add #Units = " .. mygroupqty)
            -- WAREHOUSE:AddAsset(group, ngroups, forceattribute, forcecargobay, forceweight, loadradius, skill, liveries, assignment)
            self.ThisWarehouse:AddAsset(group, ngroups, forceattribute, forcecargobay, forceweight, loadradius, skill, liveries, assignment)
        end
    end

    -- self.ThisWarehouse:AddRequest(self.ThisWarehouse, WAREHOUSE.Descriptor.GROUPNAME, "Blue Air Defense SAM #002", 1, nil, 1, 5, "Warehouse Defense Force")
    -- function definitions for dynamic named warehouses  ThisWarehouse is same as warehouse.(warehousename)
    -- function on after self request. Will pick up spawned units and give orders based on request attribute 
    function self.ThisWarehouse:OnAfterSelfRequest()
        -- MessageToAll("I spawned a self request")
    end
    return self
end  -- end of AddWarehouseToChain

----------------------------------------------------------------------
-- WCHAIN:FindSupplier()
----------------------------------------------------------------------
-- @param #WCHAIN self
-- @param #WCHAIN wchain
-- @param #string groupname     
-- @param #number groupattribute The cat type of the group.
-- @param #number number of units to spawn
-- @return #WAREHOUSE requestwarehouse
-- @return #WAREHOUSE supplierwarehouse
-- @return #boolean   cantransportvair  boolean.
function WCHAIN:FindSupplier(groupname, groupattribute, unitstospawn)
    local DebugFunc = "FindSupplier(): "
    local lclwhain = self -- UNDEF??
    local mygroupname = groupname
    local lgroupattrib = groupattribute
    local spawncount = unitstospawn
    local supplierwarehouse

    -- Get the coalition of the groupname in order to determine which way to iterate chain
    local groupcoalition = GROUP:FindByName(groupname):GetCoalition()

    WCHAIN.DEBUG(DebugFunc .. "Processing group: " .. groupname .. " with " .. unitstospawn .. " number of units.")

    local procflag = true
    while procflag == true do
        local requestwarehouse = self.ThisWarehouse
        local wcindex = self.wchainindex
        WCHAIN.DEBUG(DebugFunc .. "Processing Warehouse -->> " .. self.ThisWarehouse.alias)

        -- if airbase look for infantry and air
        if self.airbaseind == true then
            if lgroupattrib == WAREHOUSE.Attribute.GROUND_INFANTRY then
                supplierwarehouse = self.PrevAirhouse
                procflag = false
                WCHAIN.DEBUG(DebugFunc .. "FindSupplier")
                WCHAIN.DEBUG(DebugFunc .. "requestwarehouse = " .. requestwarehouse.alias .. " supplier warehouse = " .. supplierwarehouse.alias)
                return requestwarehouse, supplierwarehouse, true
            else
                --Check if air asset
                if string.sub(lgroupattrib, 1, 3) == "Air" then
                    supplierwarehouse = self.PrevAirhouse
                    procflag = false
                    WCHAIN.DEBUG(DebugFunc .. "Find Supplier1")
                    WCHAIN.DEBUG(DebugFunc .. "request Warehouse = " .. requestwarehouse.alias .. " supplier warehouse =" .. supplierwarehouse.alias)
                    return requestwarehouse, supplierwarehouse, false
                else
                    -- Everything not GROUND_INFANTRY or air but at airbase
                    supplierwarehouse = self.PrevWarehouse
                    -- Get a count of assets at supplier warehouse
                    local supplierassetcount = supplierwarehouse:GetNumberOfAssets(WAREHOUSE.Descriptor.GROUPNAME, mygroupname)
                    if supplierassetcount >= spawncount then -- inventory exists
                        procflag = false
                        WCHAIN.DEBUG(DebugFunc .. "FindSupplier2")
                        WCHAIN.DEBUG(DebugFunc .. "request Warehouse = " .. requestwarehouse.alias .. " Supplier warehouse = " .. supplierwarehouse.alias)
                        return requestwarehouse, supplierwarehouse, false -- found supplier with inventory
                    else
                        if wcindex == 1 or wcindex == #WChainTable then
                            WCHAIN.DEBUG(DebugFunc .. "FindSupplier3")
                            WCHAIN.DEBUG(DebugFunc .. "request Warehouse = " .. requestwarehouse.alias .. " supplier warehouse = " .. supplierwarehouse.alias)
                            return requestwarehouse, supplierwarehouse, false
                            -- no supplier move to previous warehouse and try again
                        else
                            -- find previous warehouse in chain
                            local searchwarehouse = self.PrevWarehouse
                            local tempprevnodename = self.prevnodename
                            if groupcoalition == 2 then
                                for z = #BlueWareHouses-1, 2, -1 do
                                    if BlueWareHouses[z] == searchwarehouse then
                                        self = BWChain[tempprevnodename]
                                    end
                                end
                            else
                                for z = #RedWareHouses -1, 2, -1 do
                                    if RedWareHouses[z] == searchwarehouse then
                                        self = RWChain[tempprevnodename]
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            -- Everything not Ground_Infantry or air but at airbase
            supplierwarehouse = self.PrevWarehouse

            -- get count of assets at supplier
            local supplierassetcount = supplierwarehouse:GetNumberOfAssets(WAREHOUSE.Descriptor.GROUPNAME, mygroupname)
            if supplierassetcount >= spawncount then -- inv exists
                procflag = false
                WCHAIN.DEBUG(DebugFunc .. "FindSupplier4")
                WCHAIN.DEBUG(DebugFunc .. "requestwarehouse = " .. requestwarehouse.alias .. " supplier warehouse = " .. supplierwarehouse.alias)
                return requestwarehouse, supplierwarehouse, false -- found supplier with inventory
            else
                -- no supplier move to previous warehouse and try again
                if wcindex == 1 or wcindex == #WChainTable then
                    return requestwarehouse, supplierwarehouse, false
                else
                    -- find previous warehouse in chain
                    local searchwarehouse = self.PrevWarehouse
                    local tempprevnodename = self.prevnodename

                    if groupcoalition == 2 then
                        for z = #BlueWareHouses, 2, -1 do
                            if BlueWareHouses[z] == searchwarehouse then
                                self = BWChain[tempprevnodename]
                            end
                        end
                    else
                        for z = #RedWareHouses -1, 2, -1 do
                            if RedWareHouses[z] == searchwarehouse then
                                self = RWChain[tempprevnodename]
                            end
                        end
                    end
                end
            end
        end
    end
end     -- End of AddWarehouseToChain()

----------------------------------------------------------------------
-- WCHAIN:SupplyChainManager()
----------------------------------------------------------------------
-- @param #WCHAIN self
-- @param #number wrequestcount - persisted requestcount across warehouses
-- @return #WCHAIN self
-- @return #wrequestcount
function WCHAIN:SupplyChainManager(wrequestcount)
    local DebugFunc = "SupplyChainManager(): "
    local wrequestcount = wrequestcount
    WCHAIN.DEBUG(DebugFunc .. "Supply Chain Manager -> Processing: " .. self.ThisWarehouse.alias)
    WCHAIN.DEBUG(DebugFunc .. "Request Count: " .. wrequestcount)
    local wpendingcount = 0
    local currenttime = timer.getTime()
    local requestcount = 0

    -- Periodic off map resupply
    if BlueSupplyTriggerTime < currenttime then
        BlueOffMapSupply()
        BlueSupplyTriggerTime = currenttime + BlueResupplyInterval
    end

    if RedSupplyTriggerTime < currenttime then
        RedOffMapSupply()
        RedSupplyTriggerTime = currenttime + RedResupplyInterval
    end

    local maxrequests = self.maxrequests 
    local maxunitstospawn = self.maxspawnunits
    local warehouseairbaseind = self.airbaseind     -- UNDEF
    local fullstrength = self.fullstrength          -- UNDEF
    local maxpendingtransactions = self.maxpending
    local previouswarehouse = self.PrevWarehouse    -- UNDEF
    local basewarehouse = self.BaseWarehouse        -- UNDEF
    local supplierwarehouse = self.PrevWarehouse
    local requestwarehouse = self.ThisWarehouse
    local requestdelay = self.requestdelay
    local suppliertransportcount = 0
    local TransportPlaneCount = 0
    local TransportHeloCount = 0

    --TODO: Red Warehouse 2 bugs out on this line
    --[[2020-05-21 03:06:15.342 INFO    SCRIPTING: Error in timer function: [string "E:/Code/Screw Loose/Supplychain.lua"]:1026: attempt to index field 'PrevWarehouse' (a nil value)
2020-05-21 03:06:15.342 INFO    SCRIPTING: stack traceback:
        [string "Scripts/Moose/Core/ScheduleDispatcher.lua"]:179: in function <[string "Scripts/Moose/Core/ScheduleDispatcher.lua"]:176>
        [string "E:/Code/Screw Loose/Supplychain.lua"]:1026: in function 'SupplyChainManager'
        [string "E:/Code/Screw Loose/Supplychain.lua"]:1411: in function <[string "E:/Code/Screw Loose/Supplychain.lua"]:1283>
        (tail call): ?
        [C]: in function 'xpcall'
        [string "Scripts/Moose/Core/ScheduleDispatcher.lua"]:232: in function <[string "Scripts/Moose/Core/ScheduleDispatcher.lua"]:168>
]]
    wpendingcount = #self.PrevWarehouse.pending + #self.BaseWarehouse.pending
    WCHAIN.DEBUG(DebugFunc .. "wpendingcount = " .. wpendingcount)

    if wpendingcount <= maxpendingtransactions then
        -- process cutom units

        for y=1, #self.winvtemplate do
            -- get inv from template
            local invgroupname = self.winvtemplate[y][1]
            local defunitcount = self.winvtemplate[y][2]
            local groupattrib =  self.winvtemplate[y][3]
            local nextreqtime =  self.winvtemplate[y][10]
            -- set some variables for processing
            local supplierassetcount = 0
            --local bsupplierassetcount = 0     -- UNDEF
            --local matchind = false            -- UNDEF
            --local bmatchind = false           -- UNDEF
            local cantransportvair = false
            local unitstospawn = 0
            WCHAIN.DEBUG(DebugFunc .. "requestcount = " .. requestcount)

            -- maxrequests per cycle per warehouse
            if requestcount < maxrequests then

                -- Request time expired can request unit
                if nextreqtime < currenttime then
                    -- asset deficit so issue request
                    local assestcount = self.ThisWarehouse:GetNumberOfAssets(WAREHOUSE.Descriptor.GROUPNAME, invgroupname)
                    WCHAIN.DEBUG(DebugFunc .. "asset count = " .. assestcount .. " def unit count = " .. defunitcount)
                    
                    if assestcount < defunitcount then
                        self.fullstrength = false
                        local intenttospawn = defunitcount - assestcount
                        -- max spawn per transaction

                        if intenttospawn >= maxunitstospawn then
                            unitstospawn = maxunitstospawn
                        end

                    WCHAIN.DEBUG(DebugFunc .. "units to spawn: " .. unitstospawn)
                    -- only if downstream has inventory
                    requestwarehouse, supplierwarehouse, cantransportvair = self:FindSupplier(invgroupname, groupattrib, unitstospawn)

                    -- look for pending transactions at fulfillment warehouse
                    wpendingcount = #supplierwarehouse.pending
                    WCHAIN.DEBUG(DebugFunc .. "SupplierWarehouse " .. supplierwarehouse.alias .. " pending transactions " .. wpendingcount)

                    -- get a count of assets at supplier warehouse
                    supplierassetcount = supplierwarehouse:GetNumberOfAssets(WAREHOUSE.Descriptor.GROUPNAME, invgroupname)
                    WCHAIN.DEBUG(DebugFunc .. "SupplierWarehouse " .. supplierwarehouse.alias .. " asset count: " .. supplierassetcount)

                    if supplierassetcount >= unitstospawn then

                        if wpendingcount <= maxpendingtransactions then
                            WCHAIN.DEBUG(DebugFunc .. "intent to spawn = " .. intenttospawn .. " units to spawn = " .. unitstospawn)

                            -- TODO make these a configurable setting?...
                            if intenttospawn > unitstospawn + 2 then
                                -- set nextreqtime if still supply deficit then wont allow request again for 5min
                                self.winvtemplate[y][10] = currenttime + (5*60)
                                WCHAIN.DEBUG(DebugFunc .. "Next Request time: winvtemplate [y][4] set to : " .. currenttime + (5*60))
                            else
                                -- set nextreqtime wont allow request again for 60 min since close to full supply
                                -- TODO adjust time based on distance to warehouse?... maybe.. maybe not worth it
                                self.winvtemplate[y][10] = currenttime + (60*60)
                                WCHAIN.DEBUG(DebugFunc .. "Next Request time: winvtemplate [y][1] set to: " .. currenttime + (60*60))
                            end

                            -- adjust delay time based on spawncount
                            if requestcount == 0 then
                                requestcount = 1
                            end

                            -- TODO whats the scope of this var? is it actually functional?
                            local modrequestdelay = requestdelay * requestcount

                            ---------------------------------------------------------------------
                            -- GROUND_INFANTRY Request
                            ---------------------------------------------------------------------
                            if groupattrib == WAREHOUSE.Attribute.GROUND_INFANTRY then

                                if cantransportvair == true then
                                    -- check for transport
                                    -- TODO Generalise this whole section shouldn't need to repeat the same blocks
                                    -- when the only thing that really changes is the transport asset
                                    -- TODO add support for helo

                                    TransportPlaneCount = supplierwarehouse:GetNumberOfAssets(WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.AIR_TRANSPORTPLANE)
                                    WCHAIN.DEBUG(DebugFunc .. "TransportPlaneCount: " .. TransportPlaneCount)
                                    TransportHeloCount = supplierwarehouse:GetNumberOfAssets(WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.AIR_TRANSPORTHELO)
                                    WCHAIN.DEBUG(DebugFunc .. "TransportHeloCount: " .. TransportHeloCount)

                                    if TransportPlaneCount > 0 then
                                        unitstospawn = unitstospawn * 2
                                        -- WAREHOUSE:__AddRequest(Delay, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
                                        supplierwarehouse:__AddRequest(modrequestdelay,
                                                                    requestwarehouse,
                                                                    WAREHOUSE.Descriptor.GROUPNAME,
                                                                    invgroupname,
                                                                    unitstospawn,
                                                                    WAREHOUSE.TransportType.AIRPLANE,
                                                                    1,
                                                                    10,
                                                                    "AutoResupply"
                                                                )

                                        requestcount = requestcount + 1
                                        -- TODO make this a configurable setting
                                        self.winvtemplate[y][10] = currenttime + (1*60)  -- airtransport has 1 hour delay after request
                                        WCHAIN.DEBUG(DebugFunc .. "Pushed Request to: " .. supplierwarehouse.alias .. " for group: " .. invgroupname)
                                        WCHAIN.DEBUG(DebugFunc .. "Requesting Warehouse: " .. requestwarehouse.alias)
                                    else -- Check TransportHeloCount
                                        if TransportHeloCount > 0 then
                                            unitstospawn = unitstospawn * 2
                                            -- WAREHOUSE:__AddRequest(Delay, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
                                            supplierwarehouse:__AddRequest(modrequestdelay,
                                                                        requestwarehouse,
                                                                        WAREHOUSE.Descriptor.GROUPNAME,
                                                                        invgroupname,
                                                                        unitstospawn,
                                                                        WAREHOUSE.TransportType.HELICOPTER,
                                                                        1,
                                                                        10,
                                                                        "AutoResupply"
                                                                    )

                                            requestcount = requestcount + 1
                                            -- TODO make this a configurable setting
                                            self.winvtemplate[y][10] = currenttime + (1*60)  -- airtransport has 1 hour delay after request
                                            WCHAIN.DEBUG(DebugFunc .. "Pushed Request to: " .. supplierwarehouse.alias .. " for group: " .. invgroupname)
                                            WCHAIN.DEBUG(DebugFunc .. "Requesting Warehouse: " .. requestwarehouse.alias)
                                        else -- no transport
                                            WCHAIN.DEBUG(DebugFunc .. "Not enought air transports for " .. invgroupname .. " request")
                                        end
                                    end -- End Air asset check
                                else
                                    -- check Ground tranport available
                                    suppliertransportcount = supplierwarehouse:GetNumberOfAssets(WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_APC)

                                    if suppliertransportcount > 0 then
                                        -- WAREHOUSE:__AddRequest(Delay, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
                                        supplierwarehouse:__AddRequest(modrequestdelay,
                                                                    requestwarehouse,
                                                                    WAREHOUSE.Descriptor.GROUPNAME,
                                                                    invgroupname,
                                                                    unitstospawn,
                                                                     WAREHOUSE.TransportType.APC,
                                                                    1,
                                                                    10,
                                                                    "AutoResupply"
                                                                )

                                        requestcount = requestcount + 1
                                        modrequestdelay = modrequestdelay   -- give grunts APC extra 2 min to load
                                        WCHAIN.DEBUG(DebugFunc .. "Pushed Request to: " .. supplierwarehouse.alias .. " for group: " .. invgroupname)
                                        WCHAIN.DEBUG(DebugFunc .. "Requesting Warehouse: " .. requestwarehouse.alias)
                                    else -- no transport
                                        WCHAIN.DEBUG(DebugFunc .. "Not enought ground transports for " .. invgroupname .. " request")
                                    end
                                end
                            else
                            -- TODO make this configurable
                            -- check if air asset and make requestdelay 1 hour
                            if string.sub(groupattrib, 1, 3) == "Air" then
                                self.winvtemplate[y][10] = currenttime + (10*60)
                            end
                            -- If no transport make the fuckers walk...
                            -- WAREHOUSE:__AddRequest(Delay, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
                            supplierwarehouse:__AddRequest(modrequestdelay,
                                                        requestwarehouse,
                                                        WAREHOUSE.Descriptor.GROUPNAME,
                                                        invgroupname,
                                                        unitstospawn,
                                                        nil,
                                                        nil,
                                                        10,
                                                        "AutoResupply"
                                                   )

                                    requestcount = requestcount + 1
                                    WCHAIN.DEBUG(DebugFunc .. "Pushed Request to: " .. supplierwarehouse.alias .. " for " .. " Group: " .. invgroupname)
                                    WCHAIN.DEBUG(DebugFunc .. "Requesting Warehouse: " .. requestwarehouse.alias)
                                end
                            else
                                MessageToAll("Request Cancelled. Pending Requests already for " .. supplierwarehouse.alias, 30)
                            end
                            --MessageToAll("Pushed Request " .. requestwarehouse.alias .. " = Requester " .. supplierwarehouse.alias, 30) 
                        else
                            MessageToAll("Not enough assets to fulfill request for " .. invgroupname , 30)
                        end
                    else
                        self.fullstrength = true
                    end -- if assetcount
                else
                    --MessageToAll("Request not available. Next Request Timer not exceeded.", 30)
                end -- nextreqtime
            end -- maxrequests
        end -- for y = 1
    else
        MessageToAll("Request Cancelled. Pending Requests already for supplier warehouse.", 30)
    end
    wrequestcount = requestcount
    return self, wrequestcount
end     -- End of SupplyChainManager()

----------------------------------------------------------------------
-- SUPPLY CHAIN ENDS
----------------------------------------------------------------------
-- SUPPLY CHAIN ENDS
----------------------------------------------------------------------
----------------------------------------------------------------------
-- WCHAIN:WarehouseProcessor() -- aka Warehouse defence
----------------------------------------------------------------------
-- TODO this was never finished in the original, not sure how or if I'll handle this the same
-- Not sure why I typed it out tbh......
-- @param #WCHAIN self
-- @param wchain#WCHAIN mywchain
-- #param #number coalition
-- @return #WCHAIN self The node object or nil if no node exists.
function WCHAIN:WarehouseProcessor(mywchain, coalition)
    local DebugFunc = "WarehouseProcessor(): "
    self = mywchain
    local mycoalition = coalition
    local currenttime = timer.getTime()
    local cnodename = mywchain.nodename
    WCHAIN.DEBUG(DebugFunc .. "Inside Wharehouse processor -> with " .. cnodename)
    -- eval full strength indicator

    if mycoalition == 2 then
        if self.fullstrength == true and self.defenselvl == 0 and self.nxtactionavail < currenttime then
            WCHAIN.DEBUG(DebugFunc .. "Should spawn defence force")
            self.ThisWarehouse:AddRequest(self.ThisWarehouse, WAREHOUSE.Descriptor.GROUPNAME, "Blue Air Defense Gun #002", 1, nil, nil, 5, "Warehouse Defense Force")
            self.ThisWarehouse:AddRequest(self.ThisWarehouse, WAREHOUSE.Descriptor.GROUPNAME, "Blue Air Defense SAM #002", 1, nil, nil, 5, "Warehouse Defense Force")
            self.defenselvl = 1
            self.nxtactionavail = currenttime + nextactioninterval
        end

        if self.defenselvl == 1 and self.nxtactionavail <= currenttime then
            WCHAIN.DEBUG (DebugFunc .. "Spawn level 2 air defence")
            -- spawn lvl 2 defence
        end
    else
        if self.fullstrength == true and self.defenselvl == 0 and self.nxtactionavail < currenttime then
            WCHAIN.DEBUG(DebugFunc .. "Should red defense force")
            self.ThisWarehouse:AddRequest(self.ThisWarehouse, WAREHOUSE.Descriptor.GROUPNAME, "Red SAM #002", 1, nil, nil, 5, "Warehouse Defense Force")
            self.ThisWarehouse:AddRequest(self.ThisWarehouse, WAREHOUSE.Descriptor.GROUPNAME, "Red SAM #001", 1, nil, nil, 5, "Warehouse Defense Force")
            self.defenselvl = 1
            self.nxtactionavail = currenttime + nextactioninterval
        end
        if self.defenselvl == 1 and self.nxtactionavail <= currenttime then 
            WCHAIN.DEBUG (DebugFunc .. "Spawn level 2 air defense.")
            -- spawn lvl 2 air defense
        end
    end
return self
end

----------------------------------------------------------------------
-- ProcessWarehouseChain() 
----------------------------------------------------------------------
function ProcessWarehouseChain(lcoalition)
    local DebugFunc = "ProcessWarehouseChain(): "
    local mycoalition = lcoalition

    if ProcessedChains == false then
        -- Blue
        -- Sneaki-Kolkhi (Airbase)
        BWChain["wchain #002"].spawnwithinv = true
        BWChain["wchain #002"].fullstrength = true
        BWChain["wchain #002"].baseind = true
        BWChain["wchain #002"].strengthp = 50
        BWChain["wchain #002"].nodename = "wchain #002"
        BWChain["wchain #002"] = BWChain["wchain #002"]:AddWarehouseToChain(coalition.side.BLUE)

        -- Zugdidi (FARP)
        BWChain["wchain #003"].spawnwithinv = true
        BWChain["wchain #003"].fullstrength = false
        BWChain["wchain #003"].baseind = false
        BWChain["wchain #003"].strengthp = 50
        BWChain["wchain #003"].nodename = "wchain #003"
        BWChain["wchain #003"] = BWChain["wchain #003"]:AddWarehouseToChain(coalition.side.BLUE)

        -- Blue Front Line (FARP)
        BWChain["wchain #004"].spawnwithinv = true
        BWChain["wchain #004"].fullstrength = false
        BWChain["wchain #004"].baseind = false
        BWChain["wchain #004"].strengthp = 50
        BWChain["wchain #004"].nodename = "wchain #004"
        BWChain["wchain #004"] = BWChain["wchain #004"]:AddWarehouseToChain(coalition.side.BLUE)

        -- TODO Order processing here is super important, if Red not added in numerical reverse order the setting
        -- of .PrevWarehouse WILL FAIL... Seriously needs a logic Fix
        --[[        --         
            if #RedWareHouses > 1 then 
            for z = #RedWareHouses -1, 1, -1  do
                local tempnodename = self.prevnodename
                if RWChain[tempnodename].ThisWarehouse ~= nil then --!!!!!! if processed in decending order Previous warehouse doesn't exist! thus chain building fails....
                     self.PrevWarehouse = RWChain[tempnodename].ThisWarehouse
                     RWChain[tempnodename].NextWarehouse = self.ThisWarehouse
        --]]
        -- Red
        -- Sochi-Adler (Airbase)
        RWChain["wchain #008"].spawnwithinv = true
        RWChain["wchain #008"].fullstrength = true
        RWChain["wchain #008"].baseind = true
        RWChain["wchain #008"].strengthp = 50
        RWChain["wchain #008"].nodename = "wchain #008"
        RWChain["wchain #008"] = RWChain["wchain #008"]:AddWarehouseToChain(coalition.side.RED)

        -- Gudauta (Airbase)
        RWChain["wchain #007"].spawnwithinv = true
        RWChain["wchain #007"].fullstrength = false
        RWChain["wchain #007"].baseind = true
        RWChain["wchain #007"].strengthp = 50
        RWChain["wchain #007"].nodename = "wchain #007"
        RWChain["wchain #007"] = RWChain["wchain #007"]:AddWarehouseToChain(coalition.side.RED)

        -- Sukhumi (FARP)
        RWChain["wchain #006"].spawnwithinv = true
        RWChain["wchain #006"].fullstrength = false
        RWChain["wchain #006"].baseind = false
        RWChain["wchain #006"].strengthp = 50
        RWChain["wchain #006"].nodename = "wchain #006"
        RWChain["wchain #006"] = RWChain["wchain #006"]:AddWarehouseToChain(coalition.side.RED)

        -- Sukhumi-Babushara (Airbase)
        RWChain["wchain #005"].spawnwithinv = true
        RWChain["wchain #005"].fullstrength = true
        RWChain["wchain #005"].baseind = true
        RWChain["wchain #005"].strengthp = 50
        RWChain["wchain #005"].nodename = "wchain #005"
        RWChain["wchain #005"] = RWChain["wchain #005"]:AddWarehouseToChain(coalition.side.RED)

        ProcessedChains = true
        -- Setup complete call Logistics functions
        SUPPLYCHAINREADY = true
        Logistics()
    end

    WCHAIN.DEBUG(DebugFunc .. "My Coalition = " .. mycoalition)
    local requests = 1
    local warehousecount = 0

    ---- SupplyChainManager Function - will analyze inventory based on template and issue
    --   requests to try and maintain full strength to the template
    if mycoalition == 2 then
        -- SupplyChainManager works best going backward through the chain hence (step -1 in for loop)
        for x = #BlueWareHouses, 2, -1 do
            local tempnodename = WChainTable[x]

            WCHAIN.DEBUG(DebugFunc .. "BlueWarehouses x = " .. x .. " Requests = " .. requests)
            BWChain[tempnodename], retrequestcount = BWChain[tempnodename]:SupplyChainManager(requests)
            requests = retrequestcount + requests
        end
        -- WarehouseProcessor works best forwards
        for x = 1, #BlueWareHouses do
            local tempnodename = WChainTable[x]
            local mywchain = BWChain[tempnodename]

            -- eval warehouse defense, full etc..
            mywchain = BWChain[tempnodename]:WarehouseProcessor(BWChain[tempnodename], mycoalition)
        end
    else
        local rrcounter = #WChainTable + 1
        for x = #RedWareHouses, 2, -1 do
            local tempnodename = WChainTable[rrcounter - x ]

            WCHAIN.DEBUG(DebugFunc .. "RedWarehouses x = " .. x .. " Requests = " .. requests)
            WCHAIN.DEBUG(DebugFunc .. "rrcounter = " .. rrcounter)
            RWChain[tempnodename], retrequestcount = RWChain[tempnodename]:SupplyChainManager(requests)
            requests = retrequestcount + requests
        end

        local rrcounter = #WChainTable + 1
        for x = 1, #RedWareHouses, 1 do
            local tempnodename = WChainTable[rrcounter - x]
            local mywchain = RWChain[tempnodename]
            -- eval warehouse defense, full strenght ind etc
            mywchain = RWChain[tempnodename]:WarehouseProcessor(RWChain[tempnodename], mycoalition)
        end
    end
end     -- End of ProcessWarehouseChain()

----------------------------------------------------------------------
-- Blue Resupply Aircraft
----------------------------------------------------------------------
-- TODO Rewrite, clean up, replace vars with names that make sense.
-- on landing will add to base warehouse assets
BlueDailyTransport = SPAWN:New("Blue Daily Transport")
BlueDailyTransport:OnSpawnGroup(
    function(groupname)
        SpawnedBlueResupplyGroup = GROUP:FindByName(groupname.GroupName)
        -- local tempgroupname = groupname.GroupName  -- UNDEF

        --setup event handler
        SpawnedResupplyGroup:HandleEvent(
            EVENTS.Land
        )
        -- @param self
        -- @param Core.Event#EVENTDATA EventData
        function SpawnedResupplyGroup:OnEventLand(EventData)
            for y=1, #BlueBaseWarehouseInv do
                local group = self.winvtemplate[y][1]
                local ngroups = self.winvtemplate[y][2]
                local forceattribute = self.winvtemplate[y][3]
                local forcecargobay = self.winvtemplate[y][4]
                local forceweight = self.winvtemplate[y][5]
                local loadradius = self.winvtemplate[y][6]
                local skill = self.winvtemplate[y][7]
                local liveries = self.winvtemplate[y][8]
                local assignment = self.winvtemplate[y][9]

                --local supplierassetcount = BlueWareHouses[1]:GetNumberOfAssets(WAREHOUSE.Descriptor.GROUPNAME, group)  -- UNDEF

                -- WAREHOUSE:AddAsset(group, ngroups, forceattribute, forcecargobay, forceweight, loadradius, skill, liveries, assignment)
                BlueWareHouses[1]:AddAsset(group, math.ceil(ngroups/10), forceattribute, forcecargobay, forceweight, loadradius, skill, liveries, assignment)
            end
                WCHAIN.DEBUG("Adding Daily Assets to Base Warehouse " .. BlueWareHouses[1].alias)
                EventData.IniGroup:Destroy()
            end
        end
)

function BlueOffMapSupply()
    local spawnresupply = false

    for y=1, #BlueBaseWarehouseInv do
        -- local groupattrib = BlueBaseWarehouseInv[y][3]   -- UNDEF
        local invgroupname = BlueBaseWarehouseInv[y][1]
        local maxunits = BlueBaseWarehouseInv[y][2]
        local supplierassetcount = BlueWareHouses[1]:GetNumberOfAssets(WAREHOUSE.Descriptor.GROUPNAME, invgroupname)
    
        -- check to see if delivery required
        if supplierassetcount < maxunits then
            spawnresupply = true
        end

    end

    if spawnresupply == true then
        BlueResupplyPlane = BlueDailyTransport:SpawnInZone(BlueOffMapZone, false, 5000, 6500, nil)
    end

end

----------------------------------------------------------------------
-- Red Resupply Aircraft
----------------------------------------------------------------------
-- on landing will add to base warehouse assets
RedDailyTransport = SPAWN:New("Red Daily Transport")
RedDailyTransport:OnSpawnGroup(
    function(groupname)
        SpawnedRedResupplyGroup = GROUP:FindByName(groupname.GroupName)
        local tempgroupname = groupname.GroupName

        --setup event handler 
        SpawnedRedResupplyGroup:HandleEvent(
                EVENTS.Land
        )
        -- @param self
        -- @param Core.Event#EVENTDATA EventData
        function SpawnedRedResupplyGroup:OnEventLand(EventData)

            for y=1, #RedBaseWareHouseInv do
                local group = self.winvtemplate[y][1]
                local ngroups = self.winvtemplate[y][2]
                local forceattribute = self.winvtemplate[y][3]
                local forcecargobay = self.winvtemplate[y][4]
                local forceweight = self.winvtemplate[y][5]
                local loadradius = self.winvtemplate[y][6]
                local skill = self.winvtemplate[y][7]
                local liveries = self.winvtemplate[y][8]
                local assignment = self.winvtemplate[y][9]
                -- WAREHOUSE:AddAsset(group, ngroups, forceattribute, forcecargobay, forceweight, loadradius, skill, liveries, assignment)
                RedWareHouses[1]:AddAsset(group, math.ceil(ngroups/10), forceattribute, forcecargobay, forceweight, loadradius, skill, liveries, assignment)
            end

            WCHAIN.DEBUG("Adding Daily Assets to Base Warehouse " .. RedWareHouses[1].alias)
            EventData.IniGroup:Destroy()
        end

    end
)

function RedOffMapSupply()
    local spawnresupply = false

    for y=1, #RedBaseWareHouseInv do
        -- local groupattrib = RedBaseWareHouseInv[y][3]    -- UNDEF
        local invgroupname = RedBaseWareHouseInv[y][1]
        local maxunits = RedBaseWareHouseInv[y][2]
        local supplierassetcount = RedWareHouses[1]:GetNumberOfAssets(WAREHOUSE.Descriptor.GROUPNAME, invgroupname)

        -- check to see if delivery required
        if supplierassetcount < maxunits then
            spawnresupply = true
        end

    end

    if spawnresupply == true then
        RedResupplyPlane = RedDailyTransport:SpawnInZone(RedOffMapZone, false, 5000, 6500, nil)
    end

end

----------------------------------------------------------------------
-- Boot Supply Chain
----------------------------------------------------------------------
SchedulerObject, SchedulerID = SCHEDULER:New( nil, BuildChain, {}, 5, 0 )
SchedulerObject, SchedulerID = SCHEDULER:New( nil, ProcessWarehouseChain, {coalition.side.BLUE}, 10, BlueSupplyManagerDuration )
SchedulerObject, SchedulerID = SCHEDULER:New( nil, ProcessWarehouseChain, {coalition.side.RED}, 15, RedSupplyManagerDuration )
