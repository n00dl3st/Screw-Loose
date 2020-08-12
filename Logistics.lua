-- Name: Logistics.lua
-- Author: n00dles
-- Date Created: 17/05/2020
----------------------------------------------------------------------
-- NOTES:
----------------------------------------------------------------------
-- This will require heavy use of custom function calls to avoid 
-- dublicating tons of code... need to make this more programatic


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

--[[
    WAREHOUSE.TransportType.AIRPLANE        Transports are carried out by airplanes.
    WAREHOUSE.TransportType.APC             Transports are conducted by APCs.
    WAREHOUSE.TransportType.HELICOPTER      Transports are carried out by helicopters.
    WAREHOUSE.TransportType.SELFPROPELLED   Assets go to their destination by themselves. No transport carrier needed.
    WAREHOUSE.TransportType.SHIP            Transports are conducted by ships. Not implemented yet.
    WAREHOUSE.TransportType.TRAIN           Transports are conducted by trains. Not implemented yet. Also trains are buggy in DCS.
--]]

-- WAREHOUSE:OnAfterSelfRequest(From, Event, To, groupset, request)
-- WAREHOUSE:__AddRequest(delay, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
-- WAREHOUSE:onafterAddRequest(From, Event, To, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
-- WAREHOUSE:onbeforeAddRequest(From, Event, To, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)

-- The world breaks if this is loaded before Supply chain is created and active
-- so wraping it in function solves the chicken/egg debate once and for all.
function Logistics()
    -- Check the chain is actually a thing.
    if SUPPLYCHAINREADY == true then
-----------------------------------------------------------------
--  BlUE
-----------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------
        -- Kobuleti
        ------------------------------------------------------------------------------------------------------------------
        -- OnAfterSelfRequest
        ---------------------------------------------------------
        --  Air Assets
        function WarehouseDB.Kobuleti:OnAfterSelfRequest(From,Event,To,groupset,request)
            local groupset = groupset
            local request = request
            local assignment = request.assignment
            local DispatchingWarehouse = WarehouseDB.Kobuleti

            if assignment == "AWACS" or "TANKER" then
                DispatchSupportAircraft(groupset, assignment, DispatchingWarehouse)
            end

            if assignment == "DoSomePilotShit" then
                DispatchPatrolAircraft(groupset, assignment, DispatchingWarehouse)
            end
        end

        ---------------------------------------------------------
        -- OnAfterDelivered
        ---------------------------------------------------------
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

        ---------------------------------------------------------
        -- OnAfterAssetDead
        ---------------------------------------------------------
        function WarehouseDB.Kobuleti:OnAfterAssetDead(From, Event, To, asset, request)
            local request = request
            local assignment = WarehouseDB.Kobuleti:GetAssignment(request)

            if assignment == "AWACS" or "TANKER" then
                local delay=1*(math.random(1,300))
                -- Attrib AIR_TANKER? what about AWACSzzzz
                WarehouseDB.Kobuleti:__AddRequest(delay, WarehouseDB.Kobuleti, WAREHOUSE.Descriptor.GROUPNAME, WAREHOUSE.Attribute.AIR_TANKER, 1, nil, nil, 100, assignment)
            end
        end

        --[[ --TODO TEST THIS
        ---------------------------------------------------------
        -- OnAfterNewAsset
        ---------------------------------------------------------
        function WarehouseDB.Kobuleti:OnAfterNewAsset(From, Event, To, asset, assignment)
            local Asset = asset
            if Asset.speedmax>0 then
                -- WAREHOUSE:AddAsset(group, ngroups, forceattribute, forcecargobay, forceweight, loadradius, skill, liveries, assignment)
                WarehouseDB.Kobuleti:AddAsset(Asset)
            end
        end
        --]]
        ------------------------------------------------------------------------------------------------------------------
        -- Senaki_Kolkhi
        ------------------------------------------------------------------------------------------------------------------
        ---------------------------------------------------------
        -- OnAfterSelfRequest
        ---------------------------------------------------------
        function WarehouseDB.Senaki_Kolkhi:OnAfterSelfRequest(From,Event,To,groupset,request)
            local groupset = groupset
            local request = request
            local assignment = WarehouseDB.Senaki_Kolkhi:GetAssignment(request)
            local DispatchingWarehouse = WarehouseDB.Senaki_Kolkhi
        
            if assignment == "DoSomePilotShit" then
                DispatchPatrolAircraft(groupset, assignment, DispatchingWarehouse)
            end
        end

        ---------------------------------------------------------
        -- OnAfterAssetDead
        ---------------------------------------------------------
        --[[
        function WarehouseDB.Senaki_Kolkhi:OnAfterAssetDead(From, Event, To, asset, request)
            local request = request
            local assignment = WarehouseDB.Senaki_Kolkhi:GetAssignment(request)
        end
        --]]
        ------------------------------------------------------------------------------------------------------------------
        -- Zugdidi (FARP)
        ------------------------------------------------------------------------------------------------------------------
        -- OnAfterSelfRequest
        ---------------------------------------------------------
        function WarehouseDB.Zugdidi:OnAfterSelfRequest(From,Event,To,groupset,request)
            local groupset=groupset
            local request=request
            local assignment = request.assignment
            --local DispatchingWarehouse = WarehouseDB.Zugdidi

            for _, group in ipairs(groupset:GetSetObjects()) do
                local group = group
                    -- TODO need to find a handle in WAREHOUSE or request var to use as for logical branching
                    -- request holds a value like Ground_APC maybe I and regex out and hook on prefix.
                    -- like:
                    ---  nodeprefix = string.sub(tempnodename, 1, 8)
                    DispatchGroundForces(groupset, assignment)
                --end
            end
        end

        ---------------------------------------------------------
        -- OnAfterAssetDead
        ---------------------------------------------------------
        function WarehouseDB.Zugdidi:OnAfterAssetDead(From, Event, To, asset, request)
            --local asset=asset
            local request=request
            --local DispatchingWarehouse = WarehouseDB.Zugdidi
            local assignment=WarehouseDB.Zugdidi:GetAssignment(request)
            -- WAREHOUSE:__AddRequest(delay, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
            WarehouseDB.Zugdidi:AddRequest(WarehouseDB.Zugdidi, WAREHOUSE.Descriptor.CATEGORY, Group.Category.GROUND, 1, nil, nil, 100, assignment)
        end

        ----------------------------------------------------------------------------------------------------------
        -- BlueFrontLine (FARP)
        ------------------------------------------------------------------------------------------------------------------
        -- OnAfterSelfRequest
        ---------------------------------------------------------
        --  Gound Assets
        function WarehouseDB.BlueFrontLine:OnAfterSelfRequest(From,Event,To,groupset,request)
            local groupset=groupset
            local request=request
            --local DispatchingWarehouse = WarehouseDB.BlueFrontLine
            local assignment=WarehouseDB.BlueFrontLine:GetAssignment(request)
            -- Ground Forces Dispatcher
            DispatchGroundForces(groupset, assignment)
        end
        ---------------------------------------------------------
        -- OnAfterAssetDead
        ---------------------------------------------------------
        function WarehouseDB.BlueFrontLine:OnAfterAssetDead(From, Event, To, asset, request)
            --local asset=asset
            local request=request
            --local DispatchingWarehouse = WarehouseDB.BlueFrontLine
            local assignment=WarehouseDB.BlueFrontLine:GetAssignment(request)
            -- WAREHOUSE:__AddRequest(delay, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
            WarehouseDB.BlueFrontLine:AddRequest(WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.CATEGORY, Group.Category.GROUND, 1, nil, nil, 100, assignment)
        end

-----------------------------------------------------------------
--  RED
-----------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------
        -- Red Sukhumi_Babushara (FrontLine)
        ------------------------------------------------------------------------------------------------------------------
        -- OnAfterSelfRequest
        ---------------------------------------------------------
        --  Gound Assets
        function WarehouseDB.Sukhumi_Babushara:OnAfterSelfRequest(From,Event,To,groupset,request)
            local groupset=groupset
            local request=request
            --local DispatchingWarehouse = WarehouseDB.Sukhumi_Babushara
            local assignment=WarehouseDB.Sukhumi_Babushara:GetAssignment(request)
            -- Ground Forces Dispatcher
            DispatchGroundForces(groupset, assignment)
        end
        ---------------------------------------------------------
        -- OnAfterAssetDead
        ---------------------------------------------------------
        function WarehouseDB.Sukhumi_Babushara:OnAfterAssetDead(From, Event, To, asset, request)
            --local asset=asset
            local request=request
            --local DispatchingWarehouse = WarehouseDB.Sukhumi_Babushara
            local assignment=WarehouseDB.Sukhumi_Babushara:GetAssignment(request)
            -- WAREHOUSE:__AddRequest(delay, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
            WarehouseDB.Sukhumi_Babushara:AddRequest(WarehouseDB.Sukhumi_Babushara, WAREHOUSE.Descriptor.CATEGORY, Group.Category.GROUND, 1, nil, nil, 100, assignment)
        end
        ---------------------------------------------------------
        -- OnAfterNewAsset
        ---------------------------------------------------------
        --[[
        function WarehouseDB.Sukhumi_Babushara:OnAfterNewAsset(From, Event, To, asset, assignment)
            local asset=asset --Functional.Warehouse#WAREHOUSE.Assetitem
            ForTheMotherLand()
        end
        --]]

        ------------------------------------------------------------------------------------------------------------------
        -- Red Sukhumi (FARP)
        ------------------------------------------------------------------------------------------------------------------
        -- OnAfterSelfRequest
        ---------------------------------------------------------
        --function WarehouseDB.Sukhumi:OnAfterSelfRequest(From,Event,To,groupset,request)
        --end
        ---------------------------------------------------------
        -- OnAfterAssetDead
        ---------------------------------------------------------
        --function WarehouseDB.Sukhumi:OnAfterAssetDead(From, Event, To, asset, request)
        --end

        ------------------------------------------------------------------------------------------------------------------
        -- Red Gudauta (AIRBASE)
        ------------------------------------------------------------------------------------------------------------------
        -- OnAfterSelfRequest
        ---------------------------------------------------------
        function WarehouseDB.Gudauta:OnAfterSelfRequest(From,Event,To,groupset,request)
            local groupset = groupset
            local request = request
            local assignment = WarehouseDB.Senaki_Kolkhi:GetAssignment(request)
            local DispatchingWarehouse = WarehouseDB.Senaki_Kolkhi

            if assignment == "DoSomePilotShit" then
                DispatchPatrolAircraft(groupset, assignment, DispatchingWarehouse)
            end
        end

        ---------------------------------------------------------
        -- OnAfterAssetDead
        ---------------------------------------------------------
        --[[
        function WarehouseDB.Gudauta:OnAfterAssetDead(From, Event, To, asset, request)
            local request = request
            local assignment = WarehouseDB.Gudauta:GetAssignment(request)
        end
        --]]
        ------------------------------------------------------------------------------------------------------------------
        -- Red Sochi_Adler (AIRBASE)
        ------------------------------------------------------------------------------------------------------------------
        -- OnAfterSelfRequest
        ---------------------------------------------------------
        function WarehouseDB.Sochi_Adler:OnAfterSelfRequest(From,Event,To,groupset,request)
            local groupset = groupset
            local request = request
            local assignment = WarehouseDB.Senaki_Kolkhi:GetAssignment(request)
            local DispatchingWarehouse = WarehouseDB.Senaki_Kolkhi

            if assignment == "DoSomePilotShit" then
                DispatchPatrolAircraft(groupset, assignment, DispatchingWarehouse)
            end
        end
        ---------------------------------------------------------
        -- OnAfterAssetDead
        ---------------------------------------------------------
        --[[
        function WarehouseDB.Sochi_Adler:OnAfterAssetDead(From, Event, To, asset, request)
            local request = request
            local assignment = WarehouseDB.Sochi_Adler:GetAssignment(request)
        end
        --]]
        ------------------------------------------------------------------------------------------------------------------
        -- Red Maykop_Khanskaya
        ------------------------------------------------------------------------------------------------------------------
        -- OnAfterSelfRequest
        ---------------------------------------------------------
        function WarehouseDB.Maykop_Khanskaya:OnAfterSelfRequest(From,Event,To,groupset,request)
            local groupset = groupset
            local request = request
            local assignment = request.assignment
            local DispatchingWarehouse = WarehouseDB.Maykop_Khanskaya

            if assignment == "AWACS" or "TANKER" then
                DispatchSupportAircraft(groupset, assignment)
            end

            if assignment == "DoSomePilotShit" then
                DispatchPatrolAircraft(groupset, assignment, DispatchingWarehouse)
            end
        end

        ---------------------------------------------------------
        -- OnAfterAssetDead
        ---------------------------------------------------------
        function WarehouseDB.Maykop_Khanskaya:OnAfterAssetDead(From, Event, To, asset, request)
            local request = request
            local assignment = WarehouseDB.Maykop_Khanskaya:GetAssignment(request)
            if assignment == "AWACS" or "TANKER" then
                local delay=1*(math.random(1,300))
                WarehouseDB.Maykop_Khanskaya:__AddRequest(delay, WarehouseDB.Maykop_Khanskaya, WAREHOUSE.Descriptor.GROUPNAME, WAREHOUSE.Attribute.AIR_TANKER, 1, nil, nil, 100, assignment)
            end
        end
    end
end