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
--Blu_A2G:AddDefenseCoordinate("A2G MSRE",ZONE:FindByName("A2G MSRE"):GetCoordinate())
--Blu_A2G:AddDefenseCoordinate("A2G Beslan",ZONE:FindByName("A2G Beslan"):GetCoordinate())
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
Red_A2G:AddDefenseCoordinate("A2G MSRE",ZONE:FindByName("A2G MSRE"):GetCoordinate())
Red_A2G:AddDefenseCoordinate("A2G Beslan",ZONE:FindByName("A2G Beslan"):GetCoordinate())
Red_A2G:SetDefenseRadius(92600) -- 50nm
Red_A2G:SetDefenseReactivityMedium()

----------------------------------------------------------------------
-- Blue Support Squadrons Defintions 
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading tankers")
env.info( "------------------------------------------------" )
----------------------------------------------------------------------
-- Tankers
----------------------------------------------------------------------
_TANKER_UNITS = {
  {NAME='Texaco', TACAN=12 },
  {NAME='Tanker', TACAN=14 },
}
 
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
 
--- Custom Tanker "class"
_TANKER.Tanker = {}
function _TANKER.Tanker:New( group )
 
    -- Copy the group spawned
    local self = group
   
    self.going_home = false
    self.route = self:GetTaskRoute()
   
    function self:Debug( text )
        _TANKER.DEBUG(self:GetName()..': '..text)
    end
   
    if _TANKER.DEBUG_MENU then
        self.debug_menu = MENU_COALITION_COMMAND:New(
            coalition.side.BLUE,
            'Destroy '..self:GetName(),
            _TANKER.DEBUG_MENU,
            self.Destroy,
            self
        )
    end
   
    self:Debug('hullo? Am I a tanker now?')
   
    --- Send the tanker back to its homeplate
    function self:RTB()
   
        if not self.going_home then -- check that the tanker isn't already going home
     
            self:Debug('screw you guys, I\' going home') -- let the world know
       
            -- Send the tanker to its last waypoint
            local command = self:CommandSwitchWayPoint( 2, 1 )
            self:SetCommand( command )
           
            -- Create a 5km radius zone around the home plate
            local last_wp = self.route[1]
            self.rtb_zone = ZONE_RADIUS:New(
                'rtb_'..self:GetName(),
                {x=last_wp.x, y=last_wp.y},
                20000
            )
           
            -- Wait for the tanker to enter the zone; when it's in, remove all tasks, and force it to land
            self.rtb_scheduler = SCHEDULER:New(
                self,
                function()
                    self:Debug('daddy, is it far yet ?')
                    if self and self:IsAlive() then
                        if self:IsCompletelyInZone(self.rtb_zone) then
                            self:Debug('no place like home')
                            self:ClearTasks()
                            self:RouteRTB()
                            self.rtb_scheduler:Stop()
                            self:remove_debug_menu()
                        end
                    end
                end,
                {}, 10, 10, 0, 0 )
 
            -- Wait for the tanker to stop, and remove it from the game once it has
            self.despawn_scheduler = SCHEDULER:New(self,
                function()
                    self:Debug('I am so tired...')
                    if self and self:IsAlive() then
                        local velocity = self:GetUnit(1):GetVelocity()
                        local total_speed = math.abs(velocity.x) + math.abs(velocity.y) + math.abs(velocity.z)
                        if total_speed < 3 then -- increased from 1
                            self:Debug('Goodbye, cruel world !')
                            self:Destroy()
                        end
                    end
                end,
                {}, 10, 10, 0, 0)
 
            self.going_home = true
        end
    end
   
    --- Create a zone around the first waypoint found with an "Orbit" task
    function self:ZoneFromOrbitWaypoint()
       
        -- "x" & "y" are the waypoint's location
        local x
        local y
       
        -- Iterate over all waypoints
        for _, wp_ in ipairs(self.route) do
       
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
            self:Debug('creating ')
            return ZONE_RADIUS:New(self:GetName(), {x=x, y=y}, _TANKER_REINF_RADIUS)
        end
 
    end
   
    --- Returns the fuel onboard, as a percentage
    function self:GetFuel()
        local fuel_left = self:GetUnit(1):GetFuel()
        self:Debug('I got '..fuel_left..' fuel left.')
        return fuel_left
    end
   
    --- Return the Tanker "instance"
    return self
end
 
 
--- Declare a Finite State Machine "class" to manage the tankers
_TANKER.FSM = {
    previous_tankers = {}
}
 
 
function _TANKER.FSM:Debug( text )
    _TANKER.DEBUG('FSM: '..self.template_name..': '..text)
end
 
function _TANKER.FSM:New( template )
   
    -- Inherit from MOOSE's FSM
    local self = BASE:Inherit( self, FSM:New() )
   
    -- Template name is the name of the group in the ME to copy from
    self.template_name = template.NAME
    self.tacan_channel = template.TACAN
   
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
        self.group = _TANKER.Tanker:New(self.spawner:Spawn())
   
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
        self.spawner = SPAWN:New(self.template_name)
    end
   
    -- Triggered when there is no *active* tanker
    function self:OnEnterNO_TANKER(from, event, to)
        self:Debug('no tanker available; spawning new tanker')
       
        self:SpawnNewTanker()
       
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
 
-- Start the tanker module
do
 
    _TANKER.INFO('TANKER: INIT: START')
   
    -- Iterate over all the tanker templates
    for _, unit in ipairs( _TANKER_UNITS ) do
   
        _TANKER.DEBUG('INIT: initializing tanker unit: '..unit.NAME)
       
        -- Create the FSM
        local fsm = _TANKER.FSM:New(unit)
       
        -- Add it for sanity's sake
        _TANKER._fsm[unit.NAME] = fsm
       
        -- And start it
        fsm:Ready()
    end
       
    _TANKER.INFO('TANKER: INIT: DONE')
 
end

----------------------------------------------------------------------
-- NOTES:
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading awacs")
env.info( "------------------------------------------------" )
----------------------------------------------------------------------
-- Preamble, var defs, debug
----------------------------------------------------------------------
-- Unit arry
_AWACS_UNITS = {
  {NAME='Overlord'},
  {NAME='AWACS'}
}

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

  -- Copy ME awacs group
  local self = group  
  
  -- define and init rtb flag
  self.rtb = false
  -- copy ME route from unit
  self.route = self:GetTaskRoute()
  
  ----------------------------------------------------------------------
  -- function Debug
  ----------------------------------------------------------------------
  -- add debug function to unit
  -- @function [parent=#self] Debug
  -- @param #debugtext
  function self:Debug(debugtext)
    _AWACS.DEBUG(self:GetName()..': '..debugtext)
  end


  if _AWACS.DEBUG_MENU then
    self.debug_menu = MENU_COALITION_COMMAND:New(
        coalition.side.BLUE,
        'Destroy '..self:GetName(),
        _AWACS.DEBUG_MENU,
        self.Destroy,
        self
    )
  end
  
  self:Debug('AWACS init')

  ----------------------------------------------------------------------
  -- function RTB
  ----------------------------------------------------------------------
  -- RTB function
  -- @function [parent=#self] RTB
  -- @param #none
  function self:RTB()
    
    -- check rtb flag
    if not self.rtb then
      self:Debug('RTB')
      
      -- send awacs to last waypoint
      local command = self:CommandSwithcWayPoint(2,1)
      self:SetCommand(command)
      
      -- create zone around airbase, to enable stripping commands and force landing
      local last_wp = self.route[1] -- TODO check array index in debugger
      self.rtb_zone = ZONE_RADIUS:New(
        'rtb_'..self:GetName(),
        {x=last_wp.x, y=last_wp.y},
        20000
      )
      
      ----------------------------------------------------------------------
      -- Schedule in zone check
      ----------------------------------------------------------------------
      -- check group in zone, strip all tasks
      self.rtb_scheduler = SCHEDULER:New(self,
        function()
          self:Debug('Are we there yet?')
          if self and self:IsAlive() then
            if self:IsCompletelyInZone(self.rtb_zone) then
              self:Debug('In rtb zone')
              self:ClearTasks()
              self:RouteRTB()
              self.rtb_scheduler:Stop()
              self:remove_debug_menu()
            end
          end
        end, -- remeber  , !!!! this block is an arg list!!
        {}, 10, 10, 0, 0)
        
        ----------------------------------------------------------------------
        -- Schedule shutdown check
        ----------------------------------------------------------------------
        -- when unit stopped despawn
        self.despawn_scheduler = SCHEDULER:New(self,
          function()
            self:Debug('Engines shutdown')
            if self and self:IsAlive() then
              local velocity = self:GetUnit(1):GetVelocity()
              local total_speed = math.abs(velocity.x) + math.abs(velocity.y) + math.abs(velocity.z)
              if total_speed < 3 then
                self:Debug('removing unit')
                self:Destroy()
              end
            end
          end, -- remeber  , !!!! this block is an arg list!!
        {}, 10, 10, 0, 0)
        
      -- set RTB flag
      self.rtb = true
    end
  end

  ----------------------------------------------------------------------
  -- function Get orbit wp and create zone to mark it
  ----------------------------------------------------------------------
  -- create zone round orbit wp
  -- @function [parent=#self] ZoneFromOrbitWaypoint
  -- @param #none
  function self:ZoneFromOrbitWaypoint()
    -- vars to store x,y coords
    local x
    local y
    
    -- iterate over wp's
    for _, wp_ in ipairs(self.route) do
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
      self:Debug('creating ')
      return ZONE_RADIUS:New(self:GetName(),{x=x, y=y},_AWACS_ONSTATION_RADIUS)
    end
  end
 
  ----------------------------------------------------------------------
  -- function Fuel check
  ----------------------------------------------------------------------
  -- obtain fuel to gauge remaining sortie
  -- @function [parent=#self] GetFuel
  -- @param #none
  function self:GetFuel()
    local fuel_left = self:GetUnit(1):GetFuel()
    self:Debug('Fuel Remaining: '..fuel_left)
    return fuel_left
  end
  -- return awacs instance
  return self
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
-- function define new FSN instance
----------------------------------------------------------------------
-- @function [parent=#_AWACS.FSM] Debug
-- @param #template
function _AWACS.FSM:New(template)
  -- inherit from moose FSM
  local self = BASE:Inherit(self, FSM:New())

  -- copy template group from ME UNIT
  self.template_name = template.NAME

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
    self.group = _AWACS.Awacs:New(self.spawner:Spawn())
  end

  function self:OnLeaveINIT(From, event, to)
    self:Debug('init FSM')
    self:Debug('creating spawner')
    self.spawner = SPAWN:New(self.template_name)
  end

  function self:OnEnterNO_AWACS(from, event, to)
    self:Debug('No AWACS avilable, spawning new AWACS')
    self:SpawnNewAWACS()

    if from == 'INIT' then
        self:Debug('capturing orbit zone')
        local zone = self.group:ZoneFromOrbitWaypoint()

        if zone == nil then
          self:Failure('No orbit WP found'..self.template_name)
        end

      self.zone = zone
    end

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
do 
  _AWACS.INFO('AWACS: INIT: Start')
  for _, unit in ipairs(_AWACS_UNITS) do
    _AWACS.DEBUG('INIT: AWACS unt: '..unit.NAME)
    local fsm = _AWACS.FSM:New(unit)
    _AWACS._fsm[unit.NAME] = fsm
    fsm:Ready()
  end
  _AWACS.INFO('AWACS: Init: Done')
end