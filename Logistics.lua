-- Name: Logistics.lua
-- Author: n00dles
-- Date Created: 17/05/2020
----------------------------------------------------------------------
-- NOTES:
----------------------------------------------------------------------
-- This will require heavy use of custom function calls to avoid 
-- dublicating tons of code...

env.info( "------------------------------------------------" )
env.info("          Loading Logistics")
env.info( "------------------------------------------------" )

-- This will require heavy use of custom function calls to avoid 
-- dublicating tons of code...

-- Supply chain requests

-- Warehouses from chain
-- BluFor
--  Kobuleti
--  Senaki_Kolkhi
--  Zugdidi
--  BlueFrontLine
-- OpFor
--  Sukhumi_Babushara
--  Sukhumi
--  Gudauta
--  Sochi_Adler
--  Maykop_Khanskaya

--[[
    WAREHOUSE.Attribute.AIR_TRANSPORTPLANE Airplane with transport capability. This can be used to transport other assets.
    WAREHOUSE.Attribute.AIR_AWACS Airborne Early Warning and Control System.
    WAREHOUSE.Attribute.AIR_FIGHTER Fighter, interceptor, ... airplane.
    WAREHOUSE.Attribute.AIR_BOMBER Aircraft which can be used for strategic bombing.
    WAREHOUSE.Attribute.AIR_TANKER Airplane which can refuel other aircraft.
    WAREHOUSE.Attribute.AIR_TRANSPORTHELO Helicopter with transport capability. This can be used to transport other assets.
    WAREHOUSE.Attribute.AIR_ATTACKHELO Attack helicopter.
    WAREHOUSE.Attribute.AIR_UAV Unpiloted Aerial Vehicle, e.g. drones.
    WAREHOUSE.Attribute.AIR_OTHER Any airborne unit that does not fall into any other airborne category.
    WAREHOUSE.Attribute.GROUND_APC Infantry carriers, in particular Amoured Personell Carrier. This can be used to transport other assets.
    WAREHOUSE.Attribute.GROUND_TRUCK Unarmed ground vehicles, which has the DCS "Truck" attribute.
    WAREHOUSE.Attribute.GROUND_INFANTRY Ground infantry assets.
    WAREHOUSE.Attribute.GROUND_ARTILLERY Artillery assets.
    WAREHOUSE.Attribute.GROUND_TANK Tanks (modern or old).
    WAREHOUSE.Attribute.GROUND_TRAIN Trains. Not that trains are not yet properly implemented in DCS and cannot be used currently.
    WAREHOUSE.Attribute.GROUND_EWR Early Warning Radar.
    WAREHOUSE.Attribute.GROUND_AAA Anti-Aircraft Artillery.
    WAREHOUSE.Attribute.GROUND_SAM Surface-to-Air Missile system or components.
    WAREHOUSE.Attribute.GROUND_OTHER Any ground unit that does not fall into any other ground category.
    WAREHOUSE.Attribute.NAVAL_AIRCRAFTCARRIER Aircraft carrier.
    WAREHOUSE.Attribute.NAVAL_WARSHIP War ship, i.e. cruisers, destroyers, firgates and corvettes.
    WAREHOUSE.Attribute.NAVAL_ARMEDSHIP Any armed ship that is not an aircraft carrier, a cruiser, destroyer, firgatte or corvette.
    WAREHOUSE.Attribute.NAVAL_UNARMEDSHIP Any unarmed naval vessel.
    WAREHOUSE.Attribute.NAVAL_OTHER Any naval unit that does not fall into any other naval category.
    WAREHOUSE.Attribute.OTHER_UNKNOWN Anything that does not fall into any other category.
]]

--[[
  WAREHOUSE.Descriptor.ASSETLIST    List of specific assets gives as a table of assets. Mind the curly brackets {}.
  WAREHOUSE.Descriptor.ASSIGNMENT   Assignment of asset when it was added.
  WAREHOUSE.Descriptor.ATTRIBUTE    Generalized attribute WAREHOUSE.Attribute.
  WAREHOUSE.Descriptor.CATEGORY     Asset category of type DCS#Group.Category, i.e. GROUND, AIRPLANE, HELICOPTER, SHIP, TRAIN.
  WAREHOUSE.Descriptor.GROUPNAME    Name of the asset template.
  WAREHOUSE.Descriptor.UNITTYPE     Typename of the DCS unit, e.g. "A-10C".
]]

-- WAREHOUSE:OnAfterSelfRequest(From, Event, To, groupset, request)
-- WAREHOUSE:__AddRequest(delay, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
-- WAREHOUSE:onafterAddRequest(From, Event, To, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
-- WAREHOUSE:onbeforeAddRequest(From, Event, To, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)

function Logistics()
if SUPPLYCHAINREADY == true then
-----------------------------------------------------------------
--  BlUE
-----------------------------------------------------------------
        ---------------------------------------------------------
        -- Kobuleti
        ---------------------------------------------------------
        -- OnAfterSelfRequest
        ---------------------------------------------------------
        --  Air Assets
            function WarehouseDB.Kobuleti:OnAfterSelfRequest(From,Event,To,groupset,request)
            local groupset = groupset
            local request = request

            if request.assignment == "AWACS" then
                for _, group in ipairs(groupset:GetSetObjects()) do
                    local group = group --Wrapper.Group#GROUP
                    local AWACSGroup = group:GetName()

                    _AWACS.DEBUG('INIT: AWACS unt: '..AWACSGroup)

                    local fsm = _AWACS.FSM:New(group)
                    group:StartUncontrolled()
                    _AWACS._fsm[group] = fsm
                    fsm:Ready()
                end
            end

            if request.assignment == "TANKER" then
                for _, group in ipairs(groupset:GetSetObjects()) do
                    local group = group --Wrapper.Group#GROUP
                    local TANKERGroup = group:GetName()

                    _TANKER.DEBUG('INIT: TANKER unt: '..TANKERGroup)

                    local fsm = _TANKER.FSM:New(group)
                    group:StartUncontrolled()
                    _TANKER._fsm[group] = fsm
                    fsm:Ready()
                end
            end

        end

        --[[ Need to work this out, something like this...
        function WarehouseDB.Kobuleti:OnAfterDelivered(From,Event,To,request)
            local request = request

            if request.assignment == "AWACS" then
                if group and group:IsAlive() then
                    local velocity = group:GetUnit(1):GetVelocity()
                    local total_speed = math.abs(velocity.x) + math.abs(velocity.y) + math.abs(velocity.z)
                    if total_speed < 3 then
                        group:Debug('removing unit')
                        group:Destroy()
                    end
                end
        --]]

--[[ Don't run unfinished code...
function warehouse.Senaki_Kolkhi:OnAfterSelfRequest(From,Event,To,groupset,request)

function warehouse.Zugdidi:OnAfterSelfRequest(From,Event,To,groupset,request)
--]]
        ---------------------------------------------------------
        -- BlueFrontLine
        ---------------------------------------------------------
        -- OnAfterSelfRequest
        ---------------------------------------------------------
        --  Gound Assets
        function WarehouseDB.BlueFrontLine:OnAfterSelfRequest(From,Event,To,groupset,request)
            local groupset=groupset --Core.Set#SET_GROUP
            local request=request   --Functional.Warehouse#WAREHOUSE.Pendingitem

            if request.assignment == "BlueFrontLine" then -- Check request
                for _,group in pairs(groupset:GetSet()) do  -- loop over set returned by request
                    local group=group --Wrapper.Group#GROUP -- get group
                    -- Route group to location
                    -- get zone set
                    -- select random zone
                    -- pass group route
                    -- group:RouteGroundOnRoad(ToCoord, group:GetSpeedMax()*0.8)
                    local BlueAreasOfOperations = Blu_Arm_Zone:GetSetObjects()
                    local AO = BlueAreasOfOperations[math.random(1, table.getn(BlueAreasOfOperations))]
                    -- Route group to Battle zone.
                    local ToCoord=(AO:GetRandomPointVec2())
                    group:Activate()
                    -- use on road
                    group:RouteGroundTo(ToCoord, group:GetSpeedMax()*0.8)

                end
            end
        end
        ---------------------------------------------------------
        -- OnAfterAssetDead
        ---------------------------------------------------------
        function WarehouseDB.BlueFrontLine:OnAfterAssetDead(From, Event, To, asset, request)
            local asset=asset       --Functional.LOGISTICS#LOGISTICS.Assetitem
            local request=request   --Functional.LOGISTICS#LOGISTICS.Pendingitem
            -- Get assignment.
            local assignment=WarehouseDB.BlueFrontLine:GetAssignment(request)
            -- make request
            -- WAREHOUSE:__AddRequest(delay, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
            WarehouseDB.BlueFrontLine:AddRequest(WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.CATEGORY, Group.Category.GROUND, 1, nil, nil, 100, assignment)
        end
        ---------------------------------------------------------
        -- OnAfterNewAsset
        ---------------------------------------------------------
        function WarehouseDB.BlueFrontLine:OnAfterNewAsset(From, Event, To, asset, assignment)
            local asset=asset --Functional.Warehouse#WAREHOUSE.Assetitem
            BootBlueFrontLine()
        end
--[[
-----------------------------------------------------------------
--  RED
-----------------------------------------------------------------
function warehouse.Sukhumi_Babushara:OnAfterSelfRequest(From,Event,To,groupset,request)

function warehouse.Sukhumi:OnAfterSelfRequest(From,Event,To,groupset,request)

function warehouse.Gudauta:OnAfterSelfRequest(From,Event,To,groupset,request)

function warehouse.Sochi_Adler:OnAfterSelfRequest(From,Event,To,groupset,request)

function warehouse.Maykop_Khanskaya:OnAfterSelfRequest(From,Event,To,groupset,request)

---------------------------------------------------------
--  OnAfterAssetDead
---------------------------------------------------------
function warehouse.Kobuleti:OnAfterAssetDead(From, Event, To, asset, request)

function warehouse.Senaki_Kolkhi:OnAfterAssetDead(From, Event, To, asset, request)

function warehouse.Zugdidi:OnAfterAssetDead(From, Event, To, asset, request)

function warehouse.Sukhumi_Babushara:OnAfterAssetDead(From, Event, To, asset, request)

function warehouse.Sukhumi:OnAfterAssetDead(From, Event, To, asset, request)

function warehouse.Gudauta:OnAfterAssetDead(From, Event, To, asset, request)

function warehouse.Sochi_Adler:OnAfterAssetDead(From, Event, To, asset, request)

function warehouse.Maykop_Khanskaya:OnAfterAssetDead(From, Event, To, asset, request)
--]]
end
end