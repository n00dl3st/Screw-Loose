-- Name: Dispatcher.lua
-- Author: n00dles
-- Date Created: 16/05/2020
----------------------------------------------------------------------
-- NOTES:
----------------------------------------------------------------------
--TODO Need to unify/generalise Tanker/AWACS and their debug code possibly add escort control.
--
--
env.info( "------------------------------------------------" )
env.info("          Loading Dispatcher")
env.info( "------------------------------------------------" )

--[[
----------------------------------------------------------------------
-- Blue Fighter GCI Setup
----------------------------------------------------------------------
Blu_GCI = AI_A2A_DISPATCHER:New(Blu_Air_Detection)
  :SetEngageRadius(74080) -- 40Nm
  :SetDisengageRadius(370400) -- 200Nm
  
----------------------------------------------------------------------
-- Blue Ground Attack Setup
----------------------------------------------------------------------
Blu_A2G = AI_A2G_DISPATCHER:New( Blu_Ground_Detection )
 
Blu_A2G:AddDefenseCoordinate("A2G",ZONE:FindByName("A2G"):GetCoordinate())
Blu_A2G:AddDefenseCoordinate("A2G Maykop",ZONE:FindByName("A2G Maykop"):GetCoordinate())
Blu_A2G:AddDefenseCoordinate("A2G MSRW",ZONE:FindByName("A2G MSRW"):GetCoordinate())
Blu_A2G:AddDefenseCoordinate("A2G Port Production",ZONE:FindByName("A2G Port Production"):GetCoordinate())
Blu_A2G:AddDefenseCoordinate("A2G Sochi Port",ZONE:FindByName("A2G Sochi Port"):GetCoordinate())
Blu_A2G:AddDefenseCoordinate("A2G Sochi",ZONE:FindByName("A2G Sochi"):GetCoordinate())
Blu_A2G:AddDefenseCoordinate("A2G Gudauta",ZONE:FindByName("A2G Gudauta"):GetCoordinate())
Blu_A2G:AddDefenseCoordinate("A2G Tbilisi",ZONE:FindByName("A2G Tbilisi"):GetCoordinate())
Blu_A2G:SetDefenseRadius(92600) -- 50nm
Blu_A2G:SetDefenseReactivityMedium()

----------------------------------------------------------------------
-- Red Fighter GCI Setup
----------------------------------------------------------------------
Red_GCI = AI_A2A_DISPATCHER:New(Red_Air_Detection)
  :SetEngageRadius(74080) -- 40Nm
  :SetDisengageRadius(370400) -- 200Nm
  
----------------------------------------------------------------------
-- Red Ground Attack Setup
----------------------------------------------------------------------
Red_A2G = AI_A2G_DISPATCHER:New( Red_Ground_Detection )
 
Red_A2G:AddDefenseCoordinate("A2G",ZONE:FindByName("A2G"):GetCoordinate())
Red_A2G:AddDefenseCoordinate("A2G Maykop",ZONE:FindByName("A2G Maykop"):GetCoordinate())
Red_A2G:AddDefenseCoordinate("A2G MSRW",ZONE:FindByName("A2G MSRW"):GetCoordinate())
Red_A2G:AddDefenseCoordinate("A2G Port Production",ZONE:FindByName("A2G Port Production"):GetCoordinate())
Red_A2G:AddDefenseCoordinate("A2G Sochi Port",ZONE:FindByName("A2G Sochi Port"):GetCoordinate())
Red_A2G:AddDefenseCoordinate("A2G Sochi",ZONE:FindByName("A2G Sochi"):GetCoordinate())
Red_A2G:AddDefenseCoordinate("A2G Gudauta",ZONE:FindByName("A2G Gudauta"):GetCoordinate())
Red_A2G:AddDefenseCoordinate("A2G Tbilisi",ZONE:FindByName("A2G Tbilisi"):GetCoordinate())
Red_A2G:SetDefenseRadius(92600) -- 50nm
Red_A2G:SetDefenseReactivityMedium()
--]]

----------------------------------------------------------------------
-- Supply Chain related Dispatcher Functions.
----------------------------------------------------------------------
-- WAREHOUSE:AssetDead(asset, request)   -- Triggers the FSM event "AssetDead" when an asset group has died.
-- WAREHOUSE:AssetLowFuel(asset, request)    -- Triggers the FSM event "AssetLowFuel" when an asset runs low on fuel
-- WAREHOUSE:AssetSpawned(group, asset, request)   -- Triggers the FSM e

----------------------------------------------------------------------
-- Blue Ground Forces DIRTY DIRTY DIRTY CHEAP HACK Dispatchers
----------------------------------------------------------------------
    -- WAREHOUSE:__AddRequest(delay, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
-- Blue front line boot
function BootBlueFrontLine()
    local time=1*40
    -- TODO Troops ofthen Broken
    --WarehouseDB.BlueFrontLine:__AddRequest(time, WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_INFANTRY, 1, nil, nil, 10, "BlueFrontLine")
    WarehouseDB.BlueFrontLine:__AddRequest(time, WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_APC, 4, nil, nil, 20, "BlueFrontLine")
    WarehouseDB.BlueFrontLine:__AddRequest(time, WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_TANK, 5, nil, nil, 30, "BlueFrontLine")
    --WarehouseDB.BlueFrontLine:__AddRequest(time, WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_ARTILLERY, 2, nil, nil, 30, "BlueFrontLine")    
    WarehouseDB.BlueFrontLine:__AddRequest(time, WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_TRUCK, 4, nil, nil, 30, "BlueFrontLine")
    WarehouseDB.BlueFrontLine:__AddRequest(time, WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_AAA, 2, nil, nil, 30, "BlueFrontLine")
    WarehouseDB.BlueFrontLine:__AddRequest(time, WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_SAM, 2, nil, nil, 30, "BlueFrontLine")
end

function BootBlueSecondLine()
    local time=1*40
    -- Zugdidi
    --WarehouseDB.Zugdidi:__AddRequest(time, WarehouseDB.Zugdidi, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_INFANTRY, 1, nil, nil, 10, "BlueSecondLine")
    WarehouseDB.Zugdidi:__AddRequest(time, WarehouseDB.Zugdidi, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_APC, 4, nil, nil, 20, "BlueSecondLine")
    WarehouseDB.Zugdidi:__AddRequest(time, WarehouseDB.Zugdidi, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_TANK, 4, nil, nil, 30, "BlueSecondLine")
    --WarehouseDB.Zugdidi:__AddRequest(time, WarehouseDB.Zugdidi, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_ARTILLERY, 2, nil, nil, 30, "BlueSecondLine")    
    WarehouseDB.Zugdidi:__AddRequest(time, WarehouseDB.Zugdidi, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_TRUCK, 4, nil, nil, 30, "BlueSecondLine")
    WarehouseDB.Zugdidi:__AddRequest(time, WarehouseDB.Zugdidi, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_AAA, 2, nil, nil, 30, "BlueSecondLine")
    WarehouseDB.Zugdidi:__AddRequest(time, WarehouseDB.Zugdidi, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_SAM, 2, nil, nil, 30, "BlueSecondLine")
end

function ForTheMotherLand()
  --for i=1,2,2 do
    local time=1*30
    -- Sukhumi_Babushara
    --WarehouseDB.Sukhumi_Babushara:__AddRequest(time, WarehouseDB.Sukhumi_Babushara, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_INFANTRY, 2, nil, nil, 10, "ForTheMotherLand")
    WarehouseDB.Sukhumi_Babushara:__AddRequest(time, WarehouseDB.Sukhumi_Babushara, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_APC, 5, nil, nil, 20, "ForTheMotherLand")
    WarehouseDB.Sukhumi_Babushara:__AddRequest(time, WarehouseDB.Sukhumi_Babushara, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_TANK, 4, nil, nil, 30, "ForTheMotherLand")
    --WarehouseDB.BlueFrontLine:__AddRequest(time, WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_ARTILLERY, 4, nil, nil, 30, "ForTheMotherLand")    
    WarehouseDB.Sukhumi_Babushara:__AddRequest(time, WarehouseDB.Sukhumi_Babushara, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_TRUCK, 8, nil, nil, 30, "ForTheMotherLand")
    WarehouseDB.Sukhumi_Babushara:__AddRequest(time, WarehouseDB.Sukhumi_Babushara, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_AAA, 4, nil, nil, 30, "ForTheMotherLand")
    WarehouseDB.Sukhumi_Babushara:__AddRequest(time, WarehouseDB.Sukhumi_Babushara, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_SAM, 4, nil, nil, 30, "ForTheMotherLand")
  --end
end

-----------------------------------------------------------------
--  dispatch functions
-----------------------------------------------------------------
-- Calling these Dispatchers because I can't think of a real name
-- code that is run from WAREHOUSE FSM calls like OnAfterSelfRequest
-- in Logistics source file would prob be more readable in, but they
-- "dispatch" things so they feckin' live here...
-----------------------------------------------------------------
--  Ground Unit dispatcher
-----------------------------------------------------------------
function DispatchGroundForces (groupset, assignment)
  local Zones = BattleZones[assignment]
  for _,group in pairs(groupset:GetSet()) do  -- loop over set returned by request
      local group=group --Wrapper.Group#GROUP -- get group
      local BlueAreasOfOperations = Zones:GetSetObjects()
      local Destination = BlueAreasOfOperations[math.random(1, table.getn(BlueAreasOfOperations))]
      -- Route group to Battle zone.
      local ToCoord=(Destination:GetRandomPointVec2())
      local RouteType = math.random(1,10)
      if RouteType <= 5 then
          group:RouteGroundOnRoad(ToCoord, group:GetSpeedMax()*0.8)
      else
          group:RouteGroundTo(ToCoord, group:GetSpeedMax()*0.8)
      end
      group:Activate()
      -- do I need to return group?
  end
end
-----------------------------------------------------------------
--  Support Unit dispatcher
-----------------------------------------------------------------
function DispatchSupportAircraft (groupset, assignment)
  for _, group in ipairs(groupset:GetSetObjects()) do
    local group = group --Wrapper.Group#GROUP
    if assignment == "AWACS" then
      local fsm = _AWACS.FSM:New(group)
      group:StartUncontrolled()
      _AWACS._fsm[group] = fsm
      fsm:Ready()
    elseif assignment == "TANKER" then
      local fsm = _TANKER.FSM:New(group)
      group:StartUncontrolled()
      _TANKER._fsm[group] = fsm
      fsm:Ready()
    end
  end
end

-----------------------------------------------------------------
--  Air CAP dispatcher
-----------------------------------------------------------------
--[[
function DispatchCAPAircraft (groupset, assignment)
  for _, group in ipairs(groupset:GetSetObjects()) do
    local group = group --Wrapper.Group#GROUP
    local CAPZone = BlueCAPZone:GetSetObjects()
    local Destination = CAPZone[math.random(1, table.getn(CAPZone))]
--]]
-----------------------------------------------------------------
--  Whirly Bird CAS Patrol dispatcher
-----------------------------------------------------------------
-- Largely taken from Moose dispatcher classes, to make use of better
-- moose intergation, 90% of this project so far is reinventing the wheel
-- wheels that moose already provides for.
--
-- TODO generalise this class so it can be used for all aircraft
-- HeloCAS as proof of concept

--[[
-- @field #HeloCAS
HeloCAS = {
  ClassName = "HeloCAS",
}

--- @field #HeloCAS.PatrolZones PatrolZones
HeloCAS.PatrolZones = {}

--- Enumerator for spawns at airbases
-- @type HeloCAS.Takeoff
-- @extends Wrapper.Group#GROUP.Takeoff
--- @field #HeloCAS.Takeoff Takeoff
HeloCAS.Takeoff = GROUP.Takeoff

--- Defnes Landing location.
-- @field #HeloCAS.Landing
HeloCAS.Landing = {}

-- HeloCAS Constructor
-- @param #HeloCAS self
-- @param Functional.Detection#DETECTION_BASE Detection The DETECTION object that will detects targets using the the Early Warning Radar network.
-- @return #HeloCAS self
function HeloCAS:New(Detection)
  -- Inherits from DETECTION_MANAGER
  local self = BASE:Inherit( self, DETECTION_MANAGER:New( nil, Detection ) )

  self.Detection:FilterCategories( Unit.Category.GROUND_UNIT )

  -- This table models Sqn templates
  self.DefenderSquadrons = {} -- The Defender Squadrons.
  self.DefenderSpawns = {}
  self.DefenderTasks = {} -- The Defenders Tasks.
  self.DefenderDefault = {} -- The Defender Default Settings over all Squadrons.

  self:SetDefaultLanding( HeloCAS.Landing.AtEngineShutdown )
  self:SetDefaultFuelThreshold( 0.15, 0 ) -- 15% of fuel remaining in the tank will trigger the airplane to return to base or refuel.
  self:SetDefaultDamageThreshold( 0.4 ) -- When 40% of damage, go RTB.

  self:AddTransition( "Started", "Assign", "Started" )

    --- OnAfter Transition Handler for Event Assign.
    -- @function [parent=#HeloCAS] OnAfterAssign
    -- @param #HeloCAS self
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.
    -- @param Tasking.Task_A2G#AI_A2G Task
    -- @param Wrapper.Unit#UNIT TaskUnit
    -- @param #string PlayerName

    self:AddTransition( "*", "Patrol", "*" )

    --- Patrol Handler OnBefore for HeloCAS
    -- @function [parent=#HeloCAS] OnBeforePatrol
    -- @param #HeloCAS self
    -- @param #string From
    -- @param #string Event
    -- @param #string To
    -- @return #boolean

    --- Patrol Handler OnAfter for HeloCAS
    -- @function [parent=#HeloCAS] OnAfterPatrol
    -- @param #HeloCAS self
    -- @param #string From
    -- @param #string Event
    -- @param #string To

    --- Patrol Trigger for HeloCAS
    -- @function [parent=#HeloCAS] Patrol
    -- @param #HeloCAS self

    --- Patrol Asynchronous Trigger for HeloCAS
    -- @function [parent=#HeloCAS] __Patrol
    -- @param #HeloCAS self
    -- @param #number Delay

    self:AddTransition( "*", "Defend", "*" )

    --- Defend Handler OnBefore for HeloCAS
    -- @function [parent=#HeloCAS] OnBeforeDefend
    -- @param #HeloCAS self
    -- @param #string From
    -- @param #string Event
    -- @param #string To
    -- @return #boolean
    
    --- Defend Handler OnAfter for HeloCAS
    -- @function [parent=#HeloCAS] OnAfterDefend
    -- @param #HeloCAS self
    -- @param #string From
    -- @param #string Event
    -- @param #string To
    
    --- Defend Trigger for HeloCAS
    -- @function [parent=#HeloCAS] Defend
    -- @param #HeloCAS self
    
    --- Defend Asynchronous Trigger for HeloCAS
    -- @function [parent=#HeloCAS] __Defend
    -- @param #HeloCAS self
    -- @param #number Delay

    self:AddTransition( "*", "Engage", "*" )

    --- Engage Handler OnBefore for HeloCAS
    -- @function [parent=#HeloCAS] OnBeforeEngage
    -- @param #HeloCAS self
    -- @param #string From
    -- @param #string Event
    -- @param #string To
    -- @return #boolean
    
    --- Engage Handler OnAfter for HeloCAS
    -- @function [parent=#HeloCAS] OnAfterEngage
    -- @param #HeloCAS self
    -- @param #string From
    -- @param #string Event
    -- @param #string To
    
    --- Engage Trigger for HeloCAS
    -- @function [parent=#HeloCAS] Engage
    -- @param #HeloCAS self
    
    --- Engage Asynchronous Trigger for HeloCAS
    -- @function [parent=#HeloCAS] __Engage
    -- @param #HeloCAS self
    -- @param #number Delay

    -- Subscribe to the CRASH event so that when planes are shot
    -- by a Unit from the dispatcher, they will be removed from the detection...
    -- This will avoid the detection to still "know" the shot unit until the next detection.
    -- Otherwise, a new defense or engage may happen for an already shot plane!

    self:HandleEvent( EVENTS.Crash, self.OnEventCrashOrDead )
    self:HandleEvent( EVENTS.Dead, self.OnEventCrashOrDead )
    --self:HandleEvent( EVENTS.RemoveUnit, self.OnEventCrashOrDead )

    self:HandleEvent( EVENTS.Land )
    self:HandleEvent( EVENTS.EngineShutdown )

    self.DefenderPatrolIndex = 0

    self:__Start( 1 )

    return self

end

for each zone
 insert into HeloCAS[Zone]


local HeloCasAO = HeloCASZone:GetSetObjects()

function DispatchHeloCAS (groupset, assignment)
  for _, group in ipairs(groupset:GetSetObjects()) do
    local group = group --Wrapper.Group#GROUP
    local HeloCasName = group:GetName()

    -- Start the unit
    group:StartUncontrolled()

need a class to store patrol state
table = {
  Zone1 = SomeState
  Zone2 = SomeOtherState
  Zone3 = SomeThirdState

    -- Get list of potential AOs
    local HeloCasAO= HeloCASZone:GetSetObjects()

    A2ACap = AI_A2A_CAP:New( WarehouseUnit, ZoneFromTable, 500, 1000, 500, 600 )
    A2ACap:Patrol()

end

--- Creates a new AI_A2A_CAP object
-- @param #AI_A2A_CAP self
-- @param Wrapper.Group#GROUP AICap
-- @param Core.Zone#ZONE_BASE PatrolZone The @{Zone} where the patrol needs to be executed.
-- @param DCS#Altitude PatrolFloorAltitude The lowest altitude in meters where to execute the patrol.
-- @param DCS#Altitude PatrolCeilingAltitude The highest altitude in meters where to execute the patrol.
-- @param DCS#Speed  PatrolMinSpeed The minimum speed of the @{Wrapper.Group} in km/h.
-- @param DCS#Speed  PatrolMaxSpeed The maximum speed of the @{Wrapper.Group} in km/h.
-- @param DCS#Speed  EngageMinSpeed The minimum speed of the @{Wrapper.Group} in km/h when engaging a target.
-- @param DCS#Speed  EngageMaxSpeed The maximum speed of the @{Wrapper.Group} in km/h when engaging a target.
-- @param DCS#AltitudeType PatrolAltType The altitude type ("RADIO"=="AGL", "BARO"=="ASL"). Defaults to RADIO
-- @return #AI_A2A_CAP

--]]
----------------------------------------------------------------------
-- Blue Support Air craft "Dispatchers" 
----------------------------------------------------------------------
-- TODO Replace ALL this with a unified model its mostly borrowed code and dumb duplicating
-- for what is a few lines difference. Doubt its even working as I intend vis-ve respawns etc..
env.info( "------------------------------------------------" )
env.info("          Loading tankers")
env.info( "------------------------------------------------" )
----------------------------------------------------------------------
-- Tankers
----------------------------------------------------------------------
--[[
_TANKER_UNITS = {
  {NAME='Texaco', TACAN=12 },
  {NAME='Tanker', TACAN=14 },
}
--]]
-- Minimum fuel
---------------
_TANKER_MIN_FUEL = 0.3
 
-- Debug
--------
_TANKER_DEBUG = false
 
-- Reinforcement zone radius
----------------------------
--
-- This value defines a radius around the "Orbit" point of the tanker.
--
-- When the new tanker arrives within this distance of the intended
-- orbiting waypoint, the out-of-fuel waiting tanker will be sent home.
--
-- The distans is expressed in meters
_TANKER_REINF_RADIUS = 74080 -- 40nm

_TANKER = {}
_TANKER._fsm = {}
_TANKER.INFO = function(text)
    env.info('TANKER: '..text)
end
_TANKER.DEBUG = function(text)
    if _TANKER_DEBUG then
        _TANKER.INFO(text)
   end
end
_TANKER.UNITS = _TANKER_UNITS
_TANKER.MIN_FUEL = _TANKER_MIN_FUEL
 
if _TANKER_DEBUG then
    _TANKER.DEBUG_MENU = MENU_COALITION:New( coalition.side.BLUE, 'Tanker debug')
else
    _TANKER.DEBUG_MENU = nil
end

  ----------------------------------------------------------------------
  -- function _TANKER.Awacs:New
  ----------------------------------------------------------------------
_TANKER.Tanker = {}
function _TANKER.Tanker:New( group )
 
    group.rtb = false
    --group:StartUncontrolled()
    --TODO if coalition pick unit template to copy from
    -- change this route collection method to be tied to REQUEST based template unit to clone
    -- copy route from template unit
    local tempRoute = GROUP:FindByName("Texaco"):CopyRoute(0, 0, true, 100)
    -- add route to unit
    group:Route(tempRoute)
    -- copy route to group to allow hooks
    group.route = tempRoute

    function group:Debug( text )
        _TANKER.DEBUG(group:GetName()..': '..text)
    end
   
    if _TANKER.DEBUG_MENU then
      group.debug_menu = MENU_COALITION_COMMAND:New(
            coalition.side.BLUE,
            'Destroy '..group:GetName(),
            _TANKER.DEBUG_MENU,
            group.Destroy,
            group
        )
    end
   
    group:Debug('hullo? Am I a tanker now?')
   
    --- Send the tanker back to its homeplate
    function group:RTB()
   
        if not group.going_home then -- check that the tanker isn't already going home
     
            group:Debug('screw you guys, I\' going home') -- let the world know
       
            -- Send the tanker to its last waypoint
            local command = group:CommandSwitchWayPoint( 2, 1 )
            group:SetCommand( command )
           
            -- Create a 5km radius zone around the home plate
            local last_wp = group.route[1]
            group.rtb_zone = ZONE_RADIUS:New(
                'rtb_'..group:GetName(),
                {x=last_wp.x, y=last_wp.y},
                20000
            )
           
            -- Wait for the tanker to enter the zone; when it's in, remove all tasks, and force it to land
            group.rtb_scheduler = SCHEDULER:New(
                group,
                function()
                    group:Debug('daddy, is it far yet ?')
                    if group and group:IsAlive() then
                        if group:IsCompletelyInZone(group.rtb_zone) then
                            group:Debug('no place like home')
                            group:ClearTasks()
                            group:RouteRTB()
                            group.rtb_scheduler:Stop()
                            group:remove_debug_menu()
                        end
                    end
                end,
                {}, 10, 10, 0, 0 )
 
            -- Wait for the tanker to stop, and remove it from the game once it has
            group.despawn_scheduler = SCHEDULER:New(group,
                function()
                    group:Debug('I am so tired...')
                    if group and group:IsAlive() then
                        local velocity = group:GetUnit(1):GetVelocity()
                        local total_speed = math.abs(velocity.x) + math.abs(velocity.y) + math.abs(velocity.z)
                        if total_speed < 3 then -- increased from 1
                            group:Debug('Goodbye, cruel world !')
                            group:Destroy()
                            -- TODO Return to stock
                            -- WarehouseDB.<SomeAirBase>:AddAsset(<Me>, 1)
                        end
                    end
                end,
                {}, 10, 10, 0, 0)
 
            group.going_home = true
        end
    end
   
    --- Create a zone around the first waypoint found with an "Orbit" task
    function group:ZoneFromOrbitWaypoint()
       
        -- "x" & "y" are the waypoint's location
        local x
        local y
       
        -- Iterate over all waypoints
        for _, wp_ in ipairs(group.route) do
       
            -- Iterate over the tasks
            for _, task_ in ipairs(wp_['task']['params']['tasks']) do
           
                -- Waypoint found;
                if task_['id'] == 'Orbit' then
                   
                    -- Save position
                    x = wp_['x']
                    y = wp_['y']
                   
                    -- Break the loop
                    break
                   
                -- Manages special cases
                elseif task_['id'] == 'ControlledTask' then          
                    if task_['params']['task']['id'] == 'Orbit' then
                        x = wp_['x']
                        y = wp_['y']
                        break
                    end          
                end
            end
       
            -- If waypoint found, break the loop, no need to iterate over the rest
            if not x == nil then break end
        end
     
        -- If the waypoint has been found, create a 5k radius zone around it and return it
        if x then
            group:Debug('creating ')
            return ZONE_RADIUS:New(group:GetName(), {x=x, y=y}, _TANKER_REINF_RADIUS)
        end
 
    end
   
    --- Returns the fuel onboard, as a percentage
    function group:GetFuel()
        local fuel_left = group:GetUnit(1):GetFuel()
        group:Debug('I got '..fuel_left..' fuel left.')
        return fuel_left
    end
   
    --- Return the Tanker "instance"
    return group
end
 
 
--- Declare a Finite State Machine "class" to manage the tankers
_TANKER.FSM = {
    previous_tankers = {}
}
 
 
function _TANKER.FSM:Debug( text )
    _TANKER.DEBUG('FSM: '..self.template_name..': '..text)
end
 
function _TANKER.FSM:New( group )
   
    -- Inherit from MOOSE's FSM
    local self = BASE:Inherit( self, FSM:New() )

    -- copy template group from ME UNIT
    self.template_name = group:GetName()
   
    -- Template name is the name of the group in the ME to copy from
    -- TODO Need to code something to set TACAN
    --self.tacan_channel = template.TACAN
    self.tacan_channel = 10
   
    self:Debug('FSM created')
   
    -- Declare the possible transitions
    FSM.SetStartState(self, 'INIT')
    FSM.AddTransition(self,'INIT','Ready','NO_TANKER')
    FSM.AddTransition(self, '*', 'Failure', 'INIT')
    FSM.AddTransition(self, '*', 'Destroyed', 'NO_TANKER')
    FSM.AddTransition(self, 'NO_TANKER', 'Spawned', 'EN_ROUTE')
    FSM.AddTransition(self, 'EN_ROUTE', 'Arrived', 'ORBIT')
    FSM.AddTransition(self, 'ORBIT', 'WaitRTB', 'EN_ROUTE')
   
    -- Log errors on special event "Failure"
    function self:OnBeforeFailure(from, to, event, text)
        self:Debug('ERROR: '..text)
    end
   
    -- Spawn a tanker group
    function self:SpawnNewTanker()    
        --self.group = _TANKER.Tanker:New(self.spawner:Spawn())
              -- WAREHOUSE:__AddRequest(delay, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
      WarehouseDB.Kobuleti:AddRequest(WarehouseDB.Kobuleti, WAREHOUSE.Descriptor.GROUPNAME, WAREHOUSE.Attribute.AIR_TANKER, 1, nil, nil, 10, "TANKER")
        -- Schedules the creation of the TACAN 10 seconds later, so the unit has time to appear
        self.tacan_scheduler = SCHEDULER:New(
          nil,
          function( fsm )
            if fsm.beacon ~= nil then
              fsm.beacon:StopAATACAN()
              fsm.group:Debug('stopping previous TACAN on channel: '..fsm.tacan_channel..'Y')
            end
            local unit = fsm.group:GetUnit(1)
            fsm.beacon = unit:GetBeacon()
            fsm.beacon:AATACAN(fsm.tacan_channel, fsm.template_name, true)
            fsm.group:Debug('starting TACAN on channel: '..fsm.tacan_channel..'Y')
          end, { self }, 10
        )
    end
   
    -- Triggered when the FSM is ready to work
    function self:OnLeaveINIT(from, event, to)
        self:Debug('initializing FSM')
        self:Debug('creating spawner')
        self.spawner = group
    end
   
    -- Triggered when there is no *active* tanker
    function self:OnEnterNO_TANKER(from, event, to)
      if self.template_name == nil then
        self:Debug('no tanker available; spawning new tanker')
        self:SpawnNewTanker()
      else
        self.group = _TANKER.Tanker:New(self.spawner)
      end
       
        -- If we come from "INIT" (the first ever state)
        if from == 'INIT' then
            -- Create a zone around the first "Orbit" waypoint
            self:Debug('registering zone')
            local zone = self.group:ZoneFromOrbitWaypoint()
            -- If we didn't find an "Orbit" waypoint, fail miserably
            if zone == nil then
                self:Failure('no waypoint with task "Orbit" found for template: '..self.template_name)
            end
            -- Otherwise, we're golden
            self.zone = zone
        end
       
        -- Let the FSM know we have a valid tanker
        self:Debug('registering new group: '..self.group:GetName())
        self:Spawned()
    end
   
    -- Triggered when there's a tanker making its way to the refueling track
    function self:OnEnterEN_ROUTE(from, event, to)
        -- Triggered by a tanker almost out of fuel
        if event == 'WaitRTB' then
            self:Debug('a new tanker is on its way')
        end
     
        -- Periodic check for tanker position
        self:Debug('monitoring tanker progress to Orbit waypoint')
        self.monitor_arriving_tanker = SCHEDULER:New(
            nil,
            function(fsm, event)
                -- Check that it's still alive
                if not fsm.group:IsAlive() then
                    fsm:Debug('transiting tanker has been destroyed')
                    -- Kill the periodic check
                    fsm.monitor_arriving_tanker:Stop()
                    -- Let the FSM know that someone derped
                    fsm:Destroyed()
               
                -- When the tanker arrives at the orbit waypoint
                elseif fsm.group:IsCompletelyInZone(fsm.zone) then
                    fsm:Debug('tanker has arrived')
                    -- Kill the periodic check
                    fsm.monitor_arriving_tanker:Stop()
                    -- If an WaitRTB event triggered the state
                    if event == 'WaitRTB' then            
                        self:Debug('sending previous tanker home')
                        for _, tanker in ipairs(fsm.previous_tankers) do
                            if tanker and tanker:IsAlive() then
                                tanker:RTB()
                            end
                        end
                    end
                    -- Let the FSM know that we now have a tanker on station
                    fsm:Arrived()
                end
            end,
            {self, event}, 10, 10, 0, 0
        )
    end

    -- "Normal" state of the FSM; there's a tanker orbiting
    function self:OnEnterORBIT(from, event, to)
        self:Debug('tanker is orbiting at waypoint')
        -- Periodic check
        self.monitor_orbiting_tanker = SCHEDULER:New(
        nil,
        function()
            -- Is the tanker dead ?
            if not self.group:IsAlive() then
                self:Debug('orbiting tanker has been destroyed')
                -- kill the check
                self.monitor_orbiting_tanker:Stop()
                -- remove the debug menu
                --self.group:remove_debug_menu()
                -- let the FSM know
                self:Destroyed()
            -- Is the tanker out of fuel ?
            elseif self.group:GetFuel() <= _TANKER_MIN_FUEL then
                self:Debug('tanker will soon be out of fuel, spawning a new one')
                -- Register the tanker for later RTB
                table.insert (self.previous_tankers, self.group)
                -- Kill the check
                self.monitor_orbiting_tanker:Stop()
                -- Start a new tanker on the apron
                self:SpawnNewTanker()
                -- Switch to the waiting state
                self:WaitRTB()
            end
        end,
        {}, 10, 10, 0, 0)    
    end
    return self
end

-- Need to get the group name returned by supply chain
-- bootstrap awacs
function BootStrapTANKER()
  _TANKER.INFO('TANKER: INIT: BootStrapTANKER()')
  WarehouseDB.Kobuleti:AddRequest(WarehouseDB.Kobuleti, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.AIR_TANKER, 1, nil, nil, 10, "TANKER")
end

----------------------------------------------------------------------
-- AWACS
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading awacs")
env.info( "------------------------------------------------" )

  -- min fuel to manage rtb and replacement
  _AWACS_MIN_FUEL = 0.3
  
  -- radius around orbit wp on station unit will be sent home when replacement approches
  _AWACS_ONSTATION_RADIUS = 92600 -- 50nm
  
  _AWACS_DEBUG = true
  
  -- create awacs class and fsm
  _AWACS = {}
  _AWACS._fsm = {}
  
  -- debug
  -- .INFO method which consists of a function with one arg "debugtext"
  -- that is passed to env.info to print "AWACS: <contents of 'debugtext'>"
  _AWACS.INFO = function(debugtext)
    env.info('AWACS: '..debugtext)
  end
  
  -- .DEBUG method if defeined call .INFO method passing debugtext
  _AWACS.DEBUG = function(debugtext)
    if _AWACS_DEBUG then
      _AWACS.INFO(debugtext)
    end
  end
    
  -- populate .UNITS table with unit arry
  _AWACS.UNITS = _AWACS_UNITS
  -- populate .MIN_FUEL table from array
  _AWACS.MIN_FUEL = _AWACS_MIN_FUEL
  
  -- add debug menu 
  if _AWACS_DEBUG then
    _AWACS.DEBUG_MENU = MENU_COALITION:New(coalition.side.BLUE,'AWACS Debug')
  else
    _AWACS.DEBUG_MENU = nil
  end
      
  -- AWACS Class
  _AWACS.Awacs = {}
  
  ----------------------------------------------------------------------
  -- function _AWACS.Awacs:New
  ----------------------------------------------------------------------
  -- @function [parent=#_AWACS.Awacs] New
  -- @param #group
  function _AWACS.Awacs:New(group)
    -- define and init rtb flag
    group.rtb = false
    --group:StartUncontrolled()
    --TODO if coalition pick unit template to copy from
    -- copy route from template unit
    local tempRoute = GROUP:FindByName("Overlord"):CopyRoute(0, 0, true, 100)
    -- add route to unit
    group:Route(tempRoute)
    -- copy route to group to allow hooks
    group.route = tempRoute

    ----------------------------------------------------------------------
    -- function Debug
    ----------------------------------------------------------------------
    -- add debug function to unit
    -- @function [parent=#self] Debug
    -- @param #debugtext
    function group:Debug(debugtext)
      _AWACS.DEBUG(group:GetName()..': '..debugtext)
    end
  
    if _AWACS.DEBUG_MENU then
      group.debug_menu = MENU_COALITION_COMMAND:New(
          coalition.side.BLUE,
          'Destroy '..group:GetName(),
          _AWACS.DEBUG_MENU,
          group.Destroy,
          group
      )
    end

    group:Debug('AWACS init')

    ----------------------------------------------------------------------
    -- function RTB
    ----------------------------------------------------------------------
    -- RTB function
    -- @function [parent=#self] RTB
    -- @param #none
    function group:RTB()
      
      -- check rtb flag
      if not group.rtb then
        group:Debug('RTB')

        -- send awacs to last waypoint
        local command = group:CommandSwithcWayPoint(2,1)
        group:SetCommand(command)

        -- create zone around airbase, to enable stripping commands and force landing
        local last_wp = group.route[1] -- TODO check array index in debugger
        group.rtb_zone = ZONE_RADIUS:New(
          'rtb_'..group:GetName(),
          {x=last_wp.x, y=last_wp.y},
          20000
        )

        ----------------------------------------------------------------------
        -- Schedule in zone check
        ----------------------------------------------------------------------
        -- check group in zone, strip all tasks
        group.rtb_scheduler = SCHEDULER:New(group,
          function()
            group:Debug('Are we there yet?')
            if group and group:IsAlive() then
              if group:IsCompletelyInZone(group.rtb_zone) then
                group:Debug('In rtb zone')
                group:ClearTasks()
                group:RouteRTB()
                group.rtb_scheduler:Stop()
                group:remove_debug_menu()
              end
            end
          end, -- remeber  , !!!! this block is an arg list!!
          {}, 10, 10, 0, 0)

          ----------------------------------------------------------------------
          -- Schedule shutdown check
          ----------------------------------------------------------------------
          -- when unit stopped despawn
          group.despawn_scheduler = SCHEDULER:New(group,
            function()
              group:Debug('Engines shutdown')
              if group and group:IsAlive() then
                local velocity = group:GetUnit(1):GetVelocity()
                local total_speed = math.abs(velocity.x) + math.abs(velocity.y) + math.abs(velocity.z)
                if total_speed < 3 then
                  group:Debug('removing unit')
                  group:Destroy()
                end
              end
            end, -- remeber  , !!!! this block is an arg list!!
          {}, 10, 10, 0, 0)

        -- set RTB flag
        group.rtb = true
      end
    end

    ----------------------------------------------------------------------
    -- function Get orbit wp and create zone to mark it
    ----------------------------------------------------------------------
    -- create zone round orbit wp
    -- @function [parent=#self] ZoneFromOrbitWaypoint
    -- @param #none
    function group:ZoneFromOrbitWaypoint()
      -- vars to store x,y coords
      local x
      local y

      -- iterate over wp's
      for _, wp_ in ipairs(group.route) do
        -- iterate over tasks
        for _, task_ in ipairs(wp_['task']['params']['tasks']) do
          -- wp found
          if task_['id'] == 'Orbit' then
            -- save x,y into local vars
            x = wp_['x']
            y = wp_['y']
            -- break loop
            break

          -- manage edge cases, player controlled
          elseif task_['id'] == 'ControlledTask' then
            if task_['params']['task']['id'] == 'Orbit' then
              x = wp_['x']
              y = wp_['y']
              break
            end
          end
        end

        -- if wp found break loop completely
        if not x == nil then 
          break 
        end
      end

      -- if wp is valid create zone around orbit wp
      if x then
        group:Debug('creating ')
        return ZONE_RADIUS:New(group:GetName(),{x=x, y=y},_AWACS_ONSTATION_RADIUS)
      end
    end
   
    ----------------------------------------------------------------------
    -- function Fuel check
    ----------------------------------------------------------------------
    -- TODO I believe theres a warehouse function for this..?
    -- WAREHOUSE:__AssetLowFuel(delay, asset, request)
    -- obtain fuel to gauge remaining sortie
    -- @function [parent=#self] GetFuel
    -- @param #none
    function group:GetFuel()
      local fuel_left = group:GetUnit(1):GetFuel()
      group:Debug('Fuel Remaining: '..fuel_left)
      return fuel_left
    end

    -- return awacs instance
    return group
  end
  
  ----------------------------------------------------------------------
  -- Declare state machine to manage units
  ----------------------------------------------------------------------
  _AWACS.FSM = {
    awacs_log = {}
  }

  ----------------------------------------------------------------------
  -- function FSM debug
  ----------------------------------------------------------------------
  -- @function [parent=#_AWACS.FSM] Debug
  -- @param #debugtext
  function _AWACS.FSM:Debug(debugtext)
    _AWACS.DEBUG('FSM: '..self.template_name..': '..debugtext)
  end
  
  ----------------------------------------------------------------------
  -- AWACS Entry point 
  -- function define new FSN instance
  ----------------------------------------------------------------------
  -- @function [parent=#_AWACS.FSM] Debug
  -- @param #template
  function _AWACS.FSM:New(group)
    -- inherit from moose FSM
    local self = BASE:Inherit(self, FSM:New())
  
    -- copy template group from ME UNIT
    self.template_name = group:GetName()
  
    self:Debug('FSM Init ')
  
    -- Define FSM state transitions
    FSM.SetStartState(self, 'INIT')
    FSM.AddTransition(self, 'INIT','Ready','NO_AWACS')
    FSM.AddTransition(self, '*', 'Failure', 'INIT')
    FSM.AddTransition(self, '*', 'Destroyed', 'NO_AWACS')
    FSM.AddTransition(self, 'NO_AWACS', 'Spawned', 'EN_ROUTE')
    FSM.AddTransition(self, 'EN_ROUTE', 'Arrived', 'ORBIT')
    FSM.AddTransition(self, 'ORBIT', 'WaitRTB', 'EN_ROUTE')
  
    -- log catch all "failures"
    function self:OnBeforeFailure(from, to, event, text)
      self:Debug('ERROR: '..debugtext)
    end
  
    -- spawn AWACS group
    function self:SpawnNewAWACS()
      -- TODO This maybe broken, maybe not....
      --self.group = _AWACS.Awacs:New(self.spawner:Spawn())
  
      -- WAREHOUSE:__AddRequest(delay, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
      WarehouseDB.Kobuleti:AddRequest(WarehouseDB.Kobuleti, WAREHOUSE.Descriptor.GROUPNAME, WAREHOUSE.Attribute.AIR_AWACS, 1, nil, nil, 10, "AWACS")
    end
  
    function self:OnLeaveINIT(From, event, to)
      self:Debug('init FSM')
      --self:Debug('creating supply request')
      self.spawner = group
    end
  
    function self:OnEnterNO_AWACS(from, event, to)
      if self.template_name == nil then
        self:Debug('No AWACS avilable, spawning new AWACS')
        self:SpawnNewAWACS()
      else
        self.group = _AWACS.Awacs:New(self.spawner)
      end
    end

    function self:INIT(from, event, to)
      self:Debug('capturing orbit zone')
      local zone = self.group:ZoneFromOrbitWaypoint()
      if zone == nil then
        self:Failure('No orbit WP found'..self.template_name)
      end
      self.zone = zone
      self:Debug('Reginister new group: '..self.group:GetName())
      self:Spawned()
    end
  
    function self:OnEnterEN_ROUTE(from, event, to)
      if event == 'WaitRTB' then
        self:Debug('New AWACS on-route')
      end
  
      self:Debug('Monitoring AWACS')
      self.monitor_arriving_awacs = SCHEDULER:New(
        nil,
        function(fsm, event)
          if not fsm.group:IsAlive() then
            fsm:Debug('AWACS Destroyed')
            fsm.monitor_arriving_awacs:Stop()
            fsm:Destroyed()
          elseif fsm.group:IsCompletelyInZone(fsm.zone) then
            fsm:Debug('AWACS Arrived')
            fsm.monitor_arriving_awacs:Stop()
            if event == 'WaitRTB' then
              self:Debug('On station AWACS RTB')
              for _, awacs in ipairs(fsm.awacs_log) do
                if awacs and awacs:IsAlive() then
                  awacs:RTB()
                end
              end
            end
            fsm:Arrived()
          end
        end,
      {self, event}, 10, 10, 0, 0)
    end
  
    function self:OnEnterORBIT(from, event, to)
      self:Debug('AWACS orbiting WP')
  
      self.monitor_orbiting_awacs = SCHEDULER:New(
        nil,
        function()
          if not self.group:IsAlive() then
            self:Debug('Orbiting AWACS Destroyed')
            self.monitor_orbiting_awacs:Stop()
            self:Destroyed()
          elseif self.group:GetFuel() <= _AWACS_MIN_FUEL then
            self:Debug('AWACS will be out of fuel soon')
            table.insert(self.awacs_log, self.group)
            self.monitor_orbiting_awacs:Stop()
            self:SpawnNewAWACS()
            self:WaitRTB()
          end
        end,
      {}, 10, 10, 0, 0)
    end
    return self
end

-- bootstrap awacs
function BootStrapAWACS()
  _AWACS.INFO('AWACS: INIT: BootStrapAWACS()')
  WarehouseDB.Kobuleti:AddRequest(WarehouseDB.Kobuleti, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.AIR_AWACS, 1, nil, nil, 10, "AWACS")
end

----------------------------------------------------------------------
-- Boot Support Aircraft
----------------------------------------------------------------------
SchedulerObject, SchedulerID = SCHEDULER:New( nil, BootStrapAWACS, {}, 40, 0)
SchedulerObject, SchedulerID = SCHEDULER:New( nil, BootStrapTANKER, {}, 60, 0)
----------------------------------------------------------------------
-- Blue Ground forces
----------------------------------------------------------------------
SchedulerObject, SchedulerID = SCHEDULER:New( nil, BootBlueFrontLine, {}, 60, 0)
SchedulerObject, SchedulerID = SCHEDULER:New( nil, BootBlueSecondLine, {}, 50, 0)
----------------------------------------------------------------------
-- Red Ground forces
----------------------------------------------------------------------
SchedulerObject, SchedulerID = SCHEDULER:New( nil, ForTheMotherLand, {}, 90, 0)