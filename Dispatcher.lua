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

----------------------------------------------------------------------
-- Blue Ground Forces DIRTY DIRTY DIRTY CHEAP HACK Dispatchers
----------------------------------------------------------------------
    -- WAREHOUSE:__AddRequest(delay, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
-- Blue front line boot
function BootBlueFrontLine()
    local time=1*(math.random(30,180))
    -- TODO Troops often Broken
    --WarehouseDB.BlueFrontLine:__AddRequest(time, WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_INFANTRY, 4, WAREHOUSE.TransportType.HELICOPTER, nil, 90, "BlueFrontLine")
    WarehouseDB.BlueFrontLine:__AddRequest(time, WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_APC, 4, nil, nil, 90, "BlueFrontLine")
    WarehouseDB.BlueFrontLine:__AddRequest(time, WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_TANK, 5, nil, nil, 90, "BlueFrontLine")
    --WarehouseDB.BlueFrontLine:__AddRequest(time, WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_ARTILLERY, 2, nil, nil, 90, "BlueFrontLine")    
    WarehouseDB.BlueFrontLine:__AddRequest(time, WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_TRUCK, 4, nil, nil, 90, "BlueFrontLine")
    WarehouseDB.BlueFrontLine:__AddRequest(time, WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_AAA, 2, nil, nil, 80, "BlueFrontLine")
    WarehouseDB.BlueFrontLine:__AddRequest(time, WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_SAM, 2, nil, nil, 80, "BlueFrontLine")
end

function BootBlueSecondLine()
    local time=1*(math.random(60,180))
    -- Zugdidi
    --WarehouseDB.Zugdidi:__AddRequest(time, WarehouseDB.Zugdidi, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_INFANTRY, 4, WAREHOUSE.TransportType.HELICOPTER, nil, 10, "BlueSecondLine")
    WarehouseDB.Zugdidi:__AddRequest(time, WarehouseDB.Zugdidi, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_APC, 4, nil, nil, 90, "BlueSecondLine")
    WarehouseDB.Zugdidi:__AddRequest(time, WarehouseDB.Zugdidi, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_TANK, 5, nil, nil, 90, "BlueSecondLine")
    --WarehouseDB.Zugdidi:__AddRequest(time, WarehouseDB.Zugdidi, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_ARTILLERY, 2, nil, nil, 30, "BlueSecondLine")    
    WarehouseDB.Zugdidi:__AddRequest(time, WarehouseDB.Zugdidi, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_TRUCK, 4, nil, nil, 90, "BlueSecondLine")
    WarehouseDB.Zugdidi:__AddRequest(time, WarehouseDB.Zugdidi, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_AAA, 2, nil, nil, 80, "BlueSecondLine")
    WarehouseDB.Zugdidi:__AddRequest(time, WarehouseDB.Zugdidi, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_SAM, 2, nil, nil, 80, "BlueSecondLine")
end

function ForTheMotherLand()
  --for i=1,2,2 do
    local time=1*(math.random(30,180))
    -- Sukhumi_Babushara
    --WarehouseDB.Sukhumi_Babushara:__AddRequest(time, WarehouseDB.Sukhumi_Babushara, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_INFANTRY, 8, WAREHOUSE.TransportType.HELICOPTER, nil, 90, "ForTheMotherLand")
    WarehouseDB.Sukhumi_Babushara:__AddRequest(time, WarehouseDB.Sukhumi_Babushara, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_APC, 10, nil, nil, 90, "ForTheMotherLand")
    WarehouseDB.Sukhumi_Babushara:__AddRequest(time, WarehouseDB.Sukhumi_Babushara, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_TANK, 10, nil, nil, 90, "ForTheMotherLand")
    --WarehouseDB.BlueFrontLine:__AddRequest(time, WarehouseDB.BlueFrontLine, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_ARTILLERY, 4, nil, nil, 30, "ForTheMotherLand")    
    WarehouseDB.Sukhumi_Babushara:__AddRequest(time, WarehouseDB.Sukhumi_Babushara, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_TRUCK, 8, nil, nil, 90, "ForTheMotherLand")
    WarehouseDB.Sukhumi_Babushara:__AddRequest(time, WarehouseDB.Sukhumi_Babushara, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_AAA, 4, nil, nil, 80, "ForTheMotherLand")
    WarehouseDB.Sukhumi_Babushara:__AddRequest(time, WarehouseDB.Sukhumi_Babushara, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_SAM, 4, nil, nil, 80, "ForTheMotherLand")
  --end
end

-----------------------------------------------------------------
--  dispatch functions
-----------------------------------------------------------------
-- Calling these Dispatchers because I can't think of a real name
-- code that is run from WAREHOUSE FSM calls like OnAfterSelfRequest
-- in Logistics source file would prob be more readable, but they
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
  end
end
-----------------------------------------------------------------
--  Support Unit dispatcher
-----------------------------------------------------------------
function DispatchSupportAircraft (groupset, assignment, DispatchingWarehouse)
  for _, group in ipairs(groupset:GetSetObjects()) do
    local group = group
    if assignment == "AWACS" then
      local fsm = _AWACS.FSM:New(group, DispatchingWarehouse)
      group:StartUncontrolled()
      _AWACS._fsm[group] = fsm
      fsm:Ready()
    elseif assignment == "TANKER" then
      local fsm = _TANKER.FSM:New(group, DispatchingWarehouse)
      group:StartUncontrolled()
      _TANKER._fsm[group] = fsm
      fsm:Ready()
    end
  end
end

-----------------------------------------------------------------
--  Air Unit dispatcher
-----------------------------------------------------------------
-- First pass on this, mimial functionality.
-- TODO everyhting.
function PatrolManager()
  -- init patrol object, entitiy, thing, concept whatever
  PATROLMANAGER = {
      ClassName = "PATROLMANAGER",
      New = nil,      -- FSM
      BlueZones = {},     -- Zones
      RedZones = {},
      Assets = {},    -- All assets
      Settings = {},  -- Global settings
      BlueMission = {},     -- Mission Index
      RedMission = {},     -- Mission Index
      BluePending = {}, -- List of zones without mission
      RedPending = {}   -- List of zones without mission
  }

  -- collect zones to patrol
  PATROLMANAGER.BlueZones = BlueCAPZone:GetSetObjects()
  PATROLMANAGER.RedZones = RedCAPZone:GetSetObjects()

  -- This secton of branches populates the PATROLMANAGER Class
  -- Starting with collecting the number of zones to be managed
  -- then populates PATROLMANAGER.Mission table with MissionID
  -- State, and Zone object, Indexed from zone count.
  -- So zone 1 becomes MissionID 1, adds default state and passes in
  -- zone 1 from PATROLMANAGER.Zones, repeat until all zones processed.
  -- We also generate a table of pending MissionIDs for easy access
  -- Structure of PATROLMANAGER class is still subject to change is I
  -- find more effient methods.

  -- build index from zone list
  local BlueZoneTableSize = 0
  for _ in pairs(PATROLMANAGER.BlueZones) do
      BlueZoneTableSize = BlueZoneTableSize + 1
  end

  local RedZoneTableSize = 0
  for _ in pairs(PATROLMANAGER.RedZones) do
    RedZoneTableSize = RedZoneTableSize + 1
  end

  for ZoneIndex = 1, BlueZoneTableSize do
      local TempMissionTable = {MissionID = ZoneIndex, State = "Pending", Zone = PATROLMANAGER.BlueZones[ZoneIndex]}
      table.insert(PATROLMANAGER.BlueMission, ZoneIndex, TempMissionTable)
  end

  for ZoneIndex = 1, RedZoneTableSize do
    local TempMissionTable = {MissionID = ZoneIndex, State = "Pending", Zone = PATROLMANAGER.RedZones[ZoneIndex]}
    table.insert(PATROLMANAGER.RedMission, ZoneIndex, TempMissionTable)
  end

end
-- Init PatrolManager
PatrolManager()

function PollPatrolManager()
  for _, Mission in ipairs(PATROLMANAGER.BlueMission) do
    if Mission.State == 'Pending' then
      local delay = 1*(math.random(180, 300))
      local base = (math.random(1, 2))
      if base == 1 then
        WarehouseDB.Kobuleti:__AddRequest(delay, WarehouseDB.Kobuleti, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.AIR_FIGHTER, 1, nil, nil, nil, "DoSomePilotShit")
      else
        if base == 2 then
          WarehouseDB.Senaki_Kolkhi:__AddRequest(delay, WarehouseDB.Senaki_Kolkhi, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.AIR_FIGHTER, 1, nil, nil, nil, "DoSomePilotShit")
        end
      end
    end
  end

  for _, Mission in ipairs(PATROLMANAGER.RedMission) do
    if Mission.State == 'Pending' then
      local delay = 1*(math.random(180, 300))
      local base = (math.random(1, 3))
      if base == 1 then
        WarehouseDB.Gudauta:__AddRequest(delay, WarehouseDB.Gudauta, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.AIR_FIGHTER, 1, nil, nil, nil, "DoSomePilotShit")
      else
        if base == 2 then
          WarehouseDB.Sochi_Adler:__AddRequest(delay, WarehouseDB.Sochi_Adler, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.AIR_FIGHTER, 1, nil, nil, nil, "DoSomePilotShit")
      elseif base == 3 then
          WarehouseDB.Maykop_Khanskaya:__AddRequest(delay, WarehouseDB.Maykop_Khanskaya, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.AIR_FIGHTER, 1, nil, nil, nil, "DoSomePilotShit")
        end
      end
    end
  end
end

-- New Patrol, or whatever I'm calling this
function PATROLMANAGER:New(group, assignment, DispatchingWarehouse)
    -- TODO Handle verious events, landing, crash etc..
    -- PATROLMANAGER.BlueMission[CurrentMission].Patrol prob needs to go to mission group insted
    -- Need a better method of calling and monitoring patrols should be watching the pending list
    -- and spawning off that. 
    -- First I need active flight event handlers to reset Active flags
      local Coalition = group:GetCoalition()
      local Assignment = assignment
      local DispatchingWarehouse = DispatchingWarehouse
    
      -- TODO These blocks can be condensed/turned into a function
      if Coalition == 2 then
        local CurrentMission = nil
        for ID, Mission in ipairs(PATROLMANAGER.BlueMission) do
          if Mission.State == 'Pending' then
              CurrentMission = ID
          end
        end
        if CurrentMission ~= nil then
          -- Update Pending mission list
          local GroupName = group:GetName()
          local CurrentMissionZone = PATROLMANAGER.BlueMission[CurrentMission].Zone
          PATROLMANAGER.BlueMission[CurrentMission].GroupName = GroupName
          PATROLMANAGER.BlueMission[CurrentMission].Group = group
          PATROLMANAGER.BlueMission[CurrentMission].State = "Assigned"
          PATROLMANAGER.BlueMission[CurrentMission].Warehouse = DispatchingWarehouse
          PATROLMANAGER.BlueMission[CurrentMission].Assignment = Assignment
          group:StartUncontrolled()
          --AI_CAP_ZONE:New( PatrolZone, PatrolFloorAltitude, PatrolCeilingAltitude, PatrolMinSpeed, PatrolMaxSpeed, PatrolAltType )
          PATROLMANAGER.BlueMission[CurrentMission].Patrol = AI_CAP_ZONE:New( CurrentMissionZone, 4572, 6096, 500, 600 )
          PATROLMANAGER.BlueMission[CurrentMission].Patrol:SetControllable( group )
          PATROLMANAGER.BlueMission[CurrentMission].Patrol:SetEngageRange( 40000 )
          PATROLMANAGER.BlueMission[CurrentMission].Patrol:__Start( 1 )
          group.BlueMissionID = CurrentMission
        end
      else
        local CurrentMission = nil
        for ID, Mission in ipairs(PATROLMANAGER.RedMission) do
          if Mission.State == 'Pending' then
              CurrentMission = ID
          end
        end
        if CurrentMission ~= nil then
          -- Update Pending mission list
          local GroupName = group:GetName()
          local CurrentMissionZone = PATROLMANAGER.RedMission[CurrentMission].Zone
          PATROLMANAGER.RedMission[CurrentMission].GroupName = GroupName
          PATROLMANAGER.RedMission[CurrentMission].Group = group
          PATROLMANAGER.RedMission[CurrentMission].State = "Assigned"
          PATROLMANAGER.RedMission[CurrentMission].Warehouse = DispatchingWarehouse
          PATROLMANAGER.RedMission[CurrentMission].Assignment = Assignment
          group:StartUncontrolled()
          --AI_CAP_ZONE:New( PatrolZone, PatrolFloorAltitude, PatrolCeilingAltitude, PatrolMinSpeed, PatrolMaxSpeed, PatrolAltType )
          PATROLMANAGER.RedMission[CurrentMission].Patrol = AI_CAP_ZONE:New( CurrentMissionZone, 4572, 6096, 500, 600 )
          PATROLMANAGER.RedMission[CurrentMission].Patrol:SetControllable( group )
          PATROLMANAGER.RedMission[CurrentMission].Patrol:SetEngageRange( 40000 )
          PATROLMANAGER.RedMission[CurrentMission].Patrol:__Start( 1 )
          group.RedMissionID = CurrentMission
        end
      end
  
      function SetMissionPending(group)
          local Coalition = group:GetCoalition()
          if Coalition == 2 then
              local MissionID = group.BlueMissionID
              PATROLMANAGER.BlueMission[MissionID].State = "Pending"
              PATROLMANAGER.BlueMission[MissionID].Assignment = nil
              PATROLMANAGER.BlueMission[MissionID].GroupName = nil
              PATROLMANAGER.BlueMission[MissionID].Group = nil
              PATROLMANAGER.BlueMission[MissionID].Warehouse = nil
          else
              local MissionID = group.RedMissionID
              PATROLMANAGER.RedMission[MissionID].State = "Pending"
              PATROLMANAGER.RedMission[MissionID].Assignment = nil
              PATROLMANAGER.RedMission[MissionID].GroupName = nil
              PATROLMANAGER.RedMission[MissionID].Group = nil
              PATROLMANAGER.RedMission[MissionID].Warehouse = nil
          end
      end
  
      group:HandleEvent( EVENTS.Crash, group.OnEventCrashOrDead )
      group:HandleEvent( EVENTS.Dead, group.OnEventCrashOrDead )
      group:HandleEvent( EVENTS.Land )
      group:HandleEvent( EVENTS.EngineShutdown )
  
      function group:OnEventCrash(EventData)
          local GroupUnit = EventData.IniUnit
          local Group = EventData.IniGroup
          SetMissionPending(group)
      end
  
      function group:OnEventDead(EventData)
          local GroupUnit = EventData.IniUnit
          local Group = EventData.IniGroup
          local Coalition = Group:GetCoalition()
          SetMissionPending(group)
      end
  
      function group:OnEventLand(EventData)
          local GroupUnit = EventData.IniUnit
          local Group = EventData.IniGroup
          SetMissionPending(group)
          if GroupUnit:GetLife() ~= GroupUnit:GetLife0() then
              GroupUnit:Destroy()
          end
      end
  
      function group:OnEventEngineShutdown( EventData )
          local GroupUnit = EventData.IniUnit
          local Group = EventData.IniGroup
          SetMissionPending(group)
          if not GroupUnit:InAir() then
              GroupUnit:Destroy()
          end
        end
end

-----------------------------------------------------------------
--  DispatchCapAircraft
-----------------------------------------------------------------
function DispatchPatrolAircraft(groupset, assignment, DispatchingWarehouse)
  for _, group in ipairs(groupset:GetSetObjects()) do
    local group = group
    PATROLMANAGER:New(group, assignment, DispatchingWarehouse)
  end
end

----------------------------------------------------------------------
-- Blue Support Air craft "Dispatchers" 
----------------------------------------------------------------------
-- TODO Replace ALL this with a unified model its mostly borrowed code and dumb duplicating
-- for what is a few lines difference. Doubt its even working as I intend vis-ve respawns etc..
-- TODO Replace ALL This..
env.info( "------------------------------------------------" )
env.info("          Loading tankers")
env.info( "------------------------------------------------" )
----------------------------------------------------------------------
-- Tankers
----------------------------------------------------------------------
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

    --TODO if coalition pick unit template to copy from
    -- copy route from template unit
    local Template = ""
    local TempRoute
    local GroupCoalition = group:GetCoalition()

    if GroupCoalition == 2 then
      Template = Blu_Tanker_Set:Get("Blue Tanker")
      local TemplateName = Template:GetName()
      TempRoute = GROUP:FindByName(TemplateName):CopyRoute(0, 0, true, 100)
    else
      Template = Red_Tanker_Set:Get("Red Tanker")
      local TemplateName = Template:GetName()
      TempRoute = GROUP:FindByName(TemplateName):CopyRoute(0, 0, true, 100)
    end

    -- add route to unit
    group:Route(TempRoute)
    -- copy route to group to allow hooks
    group.route = TempRoute

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
 
function _TANKER.FSM:New( group, DispatchingWarehouse )
   
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
        --DispatchingWarehouse:AddRequest(DispatchingWarehouse, WAREHOUSE.Descriptor.GROUPNAME, WAREHOUSE.Attribute.AIR_TANKER, 1, nil, nil, 10, "TANKER")
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
  WarehouseDB.Kobuleti:AddRequest(WarehouseDB.Kobuleti, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.AIR_TANKER, 1, nil, nil, 100, "TANKER")
  WarehouseDB.Maykop_Khanskaya:AddRequest(WarehouseDB.Maykop_Khanskaya, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.AIR_TANKER, 1, nil, nil, 100, "TANKER")
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
  
  _AWACS_DEBUG = false
  
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
    
  _AWACS.UNITS = _AWACS_UNITS
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

  function _AWACS.Awacs:New(group)
    -- define and init rtb flag
    group.rtb = false

    -- copy route from template unit
    local Template = ""
    local TempRoute
    local GroupCoalition = group:GetCoalition()

    if GroupCoalition == 2 then
      Template = Blu_AWACS_Set:Get("Blue AWACS")
      local TemplateName = Template:GetName()
      TempRoute = GROUP:FindByName(TemplateName):CopyRoute(0, 0, true, 100)
    else
      Template = Red_AWACS_Set:Get("Red AWACS")
      local TemplateName = Template:GetName()
      TempRoute = GROUP:FindByName(TemplateName):CopyRoute(0, 0, true, 100)
    end

    -- add route to unit
    group:Route(TempRoute)
    -- copy route to group to allow hooks
    group.route = TempRoute

    ----------------------------------------------------------------------
    -- function Debug
    ----------------------------------------------------------------------
    -- add debug function to unit
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
  function _AWACS.FSM:Debug(debugtext)
    _AWACS.DEBUG('FSM: '..self.template_name..': '..debugtext)
  end
  
  ----------------------------------------------------------------------
  -- AWACS Entry point 
  -- function define new FSN instance
  ----------------------------------------------------------------------
  function _AWACS.FSM:New(group, DispatchingWarehouse)
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
      -- TODO Handle Red/Blue cases
      -- WAREHOUSE:__AddRequest(delay, warehouse, AssetDescriptor, AssetDescriptorValue, nAsset, TransportType, nTransport, Prio, Assignment)
      --DispatchingWarehouse:AddRequest(DispatchingWarehouse, WAREHOUSE.Descriptor.GROUPNAME, WAREHOUSE.Attribute.AIR_AWACS, 1, nil, nil, 10, "AWACS")
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
  WarehouseDB.Kobuleti:AddRequest(WarehouseDB.Kobuleti, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.AIR_AWACS, 1, nil, nil, 100, "AWACS")
  WarehouseDB.Maykop_Khanskaya:AddRequest(WarehouseDB.Maykop_Khanskaya, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.AIR_AWACS, 1, nil, nil, 100, "AWACS")
end

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
        local groupattrib = BlueBaseWarehouseInv[y][3]   -- UNDEF
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
        local groupattrib = RedBaseWareHouseInv[y][3]    -- UNDEF
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


function UnitSchedulers()
  if SUPPLYCHAINREADY == true then
----------------------------------------------------------------------
-- Boot Support Aircraft
----------------------------------------------------------------------
SchedulerObject, SchedulerID = SCHEDULER:New( nil, BootStrapAWACS, {}, 40, 0)
SchedulerObject, SchedulerID = SCHEDULER:New( nil, BootStrapTANKER, {}, 60, 0)

----------------------------------------------------------------------
-- Poll Combat Aircraft
----------------------------------------------------------------------
SchedulerObject, SchedulerID = SCHEDULER:New( nil, PollPatrolManager(), {}, 180, (1 *(math.random(180,300))) )

----------------------------------------------------------------------
-- Blue Ground forces
----------------------------------------------------------------------
SchedulerObject, SchedulerID = SCHEDULER:New( nil, BootBlueFrontLine, {}, 60, (2 * 3600))
SchedulerObject, SchedulerID = SCHEDULER:New( nil, BootBlueSecondLine, {}, 50, (3 * 3600))

----------------------------------------------------------------------
-- Red Ground forces
----------------------------------------------------------------------
SchedulerObject, SchedulerID = SCHEDULER:New( nil, ForTheMotherLand, {}, 90, (2 * 3600))
  end
end
