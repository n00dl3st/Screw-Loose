-- Name: include.lua
-- Author: n00dles
-- Date Created: 11/05/2020
----------------------------------------------------------------------
-- NOTES:
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading include")
env.info( "------------------------------------------------" )
----------------------------------------------------------------------
-- Scoring
----------------------------------------------------------------------        
Scoring = SCORING:New("ScrewLoose") 

----------------------------------------------------------------------
-- ATC
----------------------------------------------------------------------    
pseudoATC=PSEUDOATC:New()
pseudoATC:Start()

--CleanUpAirports.SetCleanMissiles(true)
CleanUpAirports = CLEANUP_AIRBASE:New( { AIRBASE.Caucasus.Senaki_Kolkhi,
                                    AIRBASE.Caucasus.Kobuleti,
                                    AIRBASE.Caucasus.Sochi_Adler,
                                    AIRBASE.Caucasus.Nalchik } )

----------------------------------------------------------------------
-- Player Sets
----------------------------------------------------------------------
PlayerGroup = SET_GROUP:New()
  :FilterPrefixes("P")
  :FilterStart()

PlayerFixedWingGroup = SET_GROUP:New()
  :FilterPrefixes("P FW")
  :FilterStart()
  
PlayerRotaryGroup = SET_GROUP:New()
  :FilterPrefixes("P RW")
  :FilterStart()
  
----------------------------------------------------------------------
-- Generic Sets
----------------------------------------------------------------------
-- SAM Set
SAM_Set = SET_GROUP:New()
  :FilterPrefixes("Blue AB SAM", "Red AB SAM", "Blue Grn Anti-Air", "Red Grn Anti-Air")
  :FilterStart()

----------------------------------------------------------------------
-- Blue Sets
----------------------------------------------------------------------
-- Air detection set
Blu_EWR_Set = SET_GROUP:New()
  :FilterPrefixes({"Blue AB SAM", "Overlord", "Blue Grn Anti-Air"})
  :FilterStart()

-- Ground force detector set
Blu_A2G_Set = SET_GROUP:New()
  :FilterPrefixes({"Blue", "Blu_Air_Recce", "Blu_Helo_CAS"})
  :FilterStart()

----------------------------------------------------------------------
-- Red Sets
----------------------------------------------------------------------
Red_EWR_Set = SET_GROUP:New()
  :FilterPrefixes({"Red AB SAM", "Red Gnd EWR", "Red Grn Anti-Air", "AWACS"})
  :FilterStart()
  
-- Ground force detector set  
Red_A2G_Set = SET_GROUP:New()
  :FilterPrefixes({"Red"})
  :FilterStart()

----------------------------------------------------------------------
-- Blue Zones
----------------------------------------------------------------------
Blu_Arm_Zone = SET_ZONE:New()
  :FilterPrefixes("Blu_Arm_Zone")
  :FilterOnce()
  
Blu_Arm_SAM_Zone = SET_ZONE:New()
  :FilterPrefixes("Blu_Arm_SAM_Zone")
  :FilterOnce()
  
----------------------------------------------------------------------
-- Red Zones
----------------------------------------------------------------------
Red_Arm_Zone = SET_ZONE:New()
  :FilterPrefixes("Red_Arm_Zone")
  :FilterOnce()
  
Red_Arm_SAM_Zone = SET_ZONE:New()
  :FilterPrefixes("Red_Arm_SAM_Zone")
  :FilterOnce()

Red_Static_Zone = SET_ZONE:New()
  :FilterPrefixes("Red_Static_Zone")
  :FilterOnce()
  
Red_MSRW_Zone = SET_ZONE:New()
  :FilterPrefixes("Red_MSRW_Zone")
  :FilterOnce()
    
Red_MSRE_Zone = SET_ZONE:New()
  :FilterPrefixes("Red_MSRE_Zone")
  :FilterOnce()
----------------------------------------------------------------------
-- Blue Detection
----------------------------------------------------------------------
-- AIR
Blu_Air_Detection = DETECTION_AREAS:New(Blu_EWR_Set,55560) -- 20Nm
Blu_Air_Detection:SetFriendliesRange(148160) -- 80nm
Blu_Air_Detection:Start()

-- GROUND
Blu_Ground_Detection = DETECTION_AREAS:New(Blu_A2G_Set,1852) -- 1nm
Blu_Ground_Detection:SetFriendliesRange( 9260 ) -- 5nm -- CAS or BAI 
Blu_Ground_Detection:Start()

----------------------------------------------------------------------
-- Red Detection
----------------------------------------------------------------------
-- AIR
Red_Air_Detection = DETECTION_AREAS:New(Red_EWR_Set,55560) -- 20Nm
Red_Air_Detection:SetFriendliesRange(148160) -- 80nm
Red_Air_Detection:Start()

-- GROUND
Red_Ground_Detection = DETECTION_AREAS:New(Red_A2G_Set,1852) -- 1nm
Red_Ground_Detection:SetFriendliesRange( 9260 ) -- 5nm CAS or BAI
Red_Ground_Detection:Start()

env.info( "------------------------------------------------" )
env.info("          Loading blue_air")
env.info( "------------------------------------------------" )
----------------------------------------------------------------------
-- Fighter GCI Setup
----------------------------------------------------------------------
Blu_GCI = AI_A2A_DISPATCHER:New(Blu_Air_Detection)
  :SetEngageRadius(74080) -- 40Nm
  :SetDisengageRadius(370400) -- 200Nm

----------------------------------------------------------------------
-- Fighter Squadron defaults
----------------------------------------------------------------------
Blu_GCI:SetIntercept(30)
Blu_GCI:SetDefaultFuelThreshold(0.2)
Blu_GCI:SetDefaultOverhead(1)
Blu_GCI:SetDefaultGrouping(2)
Blu_GCI:SetDefaultTakeoffFromParkingHot()
Blu_GCI:SetDefaultLandingAtEngineShutdown()
  
Blu_GCI:SetTacticalDisplay(false)

----------------------------------------------------------------------
-- Fighter Squadrons Defintions 
----------------------------------------------------------------------
-- CAP Zones
Blu_CAP = ZONE_POLYGON:New("CAP Zone Blue",GROUP:FindByName("CAP Zone Blue"))
Blu_CAP2 = ZONE_POLYGON:New("CAP Zone Blue 2",GROUP:FindByName("CAP Zone Blue 2"))
Blu_CAP3 = ZONE_POLYGON:New("CAP Zone Blue 3",GROUP:FindByName("CAP Zone Blue 3"))
Blu_Helo_CAP = ZONE_POLYGON:New("CAP Zone Blue Recce",GROUP:FindByName("CAP Zone Blue Recce"))

-- Senaki-Kolkhi
Blu_GCI:SetSquadron("Kol_CAP",AIRBASE.Caucasus.Senaki_Kolkhi,{"Blue Air CAP F16", "Blue Air CAP F15"})
Blu_GCI:SetSquadronCap("Kol_CAP",Blu_CAP,3048,6096,560,750,560,1200,"BARO")
Blu_GCI:SetSquadronCapInterval("Kol_CAP",1,180,600)

-- Senaki-Kolkhi
Blu_GCI:SetSquadron("Kol_CAP2",AIRBASE.Caucasus.Senaki_Kolkhi,{"Blue Air CAP F16", "Blue Air CAP F15"})
Blu_GCI:SetSquadronCap("Kol_CAP2",Blu_CAP3,3048,6096,560,750,560,1200,"BARO")
Blu_GCI:SetSquadronCapInterval("Kol_CAP2",1,180,600)

--Stennis
Blu_GCI:SetSquadron("Sten_CAP","CVN-Stennis",{"Blue Air CAP F18"})
Blu_GCI:SetSquadronCap("Sten_CAP",Blu_CAP2,3048,6096,560,750,560,1200,"BARO")
Blu_GCI:SetSquadronCapInterval("Sten_CAP",1,180,600)

--Recce
Blu_GCI:SetSquadron("Helo_Recce","FARP London",{"Blu_Air_Recce"})
Blu_GCI:SetSquadronGrouping("Helo_Recce",1)
Blu_GCI:SetSquadronCap("Helo_Recce",Blu_Helo_CAP,76,91, 148, 250, 250, 300,"BARO")
Blu_GCI:SetSquadronCapInterval("Helo_Recce",1,180,600)

----------------------------------------------------------------------
-- Ground Attack Setup
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
-- Ground Attack Squadron defaults
----------------------------------------------------------------------
Blu_A2G:SetDefaultFuelThreshold(0.2)
Blu_A2G:SetDefaultOverhead(1)
Blu_A2G:SetDefaultGrouping(2)
Blu_A2G:SetDefaultTakeoffFromParkingHot()
Blu_A2G:SetDefaultLandingAtEngineShutdown()
Blu_A2G:SetDefaultEngageLimit(4)

Blu_A2G:SetTacticalDisplay(false)

----------------------------------------------------------------------
-- Ground Attack Squadrons Defintions 
----------------------------------------------------------------------
-- Senaki-Kolkhi
Blu_A2G:SetSquadron("Senaki_BAI",AIRBASE.Caucasus.Senaki_Kolkhi,{"Blue Air BAI F16 Mav", "Blue Air BAI F16 GBU", "Blue Air BAI F16 CBU"})
Blu_A2G:SetSquadronBai("Senaki_BAI")

Blu_A2G:SetSquadron("Senaki_SEAD",AIRBASE.Caucasus.Senaki_Kolkhi,{"Blue Air BAI F16 SEAD", "Blue Air BAI F16 Mav"})
Blu_A2G:SetSquadronSead("Senaki_SEAD")

-- Stennis
Blu_A2G:SetSquadron("Sten_BAI","CVN-Stennis",{"Blue Air BAI F18 Mav", "Blue Air BAI F18 GBU", "Blue Air BAI F18 MK82"})
Blu_A2G:SetSquadronBai("Sten_BAI")

Blu_A2G:SetSquadron("Sten_SEAD","CVN-Stennis",{"Blue Air BAI F18 SEAD", "Blue Air BAI F18 Mav"})
Blu_A2G:SetSquadronSead("Sten_SEAD")

-- FARP
Blu_A2G:SetSquadron("Helo_BAI","FARP London",{"Blu_Helo_CAS"})
Blu_A2G:SetSquadronGrouping("Helo_BAI",1)
Blu_A2G:SetSquadronBaiPatrol("Helo_BAI", Blu_Helo_CAP, 76, 91, 148, 250, 250, 300)
Blu_A2G:SetSquadronPatrolInterval("Helo_BAI", 2, 180, 600, 1, "BAI")

env.info( "------------------------------------------------" )
env.info("          Loading red_air")
env.info( "------------------------------------------------" )
----------------------------------------------------------------------
-- Fighter GCI Setup
----------------------------------------------------------------------
Red_GCI = AI_A2A_DISPATCHER:New(Red_Air_Detection)
  :SetEngageRadius(74080) -- 40Nm
  :SetDisengageRadius(370400) -- 200Nm

----------------------------------------------------------------------
-- Fighter Squadron defaults
----------------------------------------------------------------------
Red_GCI:SetIntercept(30)
Red_GCI:SetDefaultFuelThreshold(0.2)
Red_GCI:SetDefaultOverhead(1)
Red_GCI:SetDefaultGrouping(2)
Red_GCI:SetDefaultTakeoffFromParkingHot()
Red_GCI:SetDefaultLandingAtEngineShutdown()

Red_GCI:SetTacticalDisplay(false)

----------------------------------------------------------------------
-- Fighter Squadrons Defintions 
----------------------------------------------------------------------
-- CAP Zones
Red_CAP = ZONE_POLYGON:New("CAP Zone Red",GROUP:FindByName("CAP Zone Red"))
Red_CAP2 = ZONE_POLYGON:New("CAP Zone Red 2",GROUP:FindByName("CAP Zone Red 2"))
Red_CAP3 = ZONE_POLYGON:New("CAP Zone Red 3",GROUP:FindByName("CAP Zone Red 3"))
Red_Helo_CAP = ZONE_POLYGON:New("CAP Zone Red Recce",GROUP:FindByName("CAP Zone Red Recce"))


-- Sochi
Red_GCI:SetSquadron("Novo_CAP",AIRBASE.Caucasus.Sochi_Adler,
  {"Red Air CAP Su27","Red Air CAP Mig21","Red Air CAP Mig23","Red Air CAP Mig29A","Red Air CAP Mig29S","Red Air CAP Su30"})
Red_GCI:SetSquadronCap("Novo_CAP",Red_CAP,3048,6096,560,750,560,1200,"BARO")
Red_GCI:SetSquadronCapInterval("Novo_CAP",1,180,600)

-- Nal
Red_GCI:SetSquadron("Bes_CAP",AIRBASE.Caucasus.Nalchik,
  {"Red Air CAP Su27","Red Air CAP Mig21","Red Air CAP Mig23","Red Air CAP Mig29A","Red Air CAP Mig29S","Red Air CAP Su30"})
Red_GCI:SetSquadronCap("Bes_CAP",Red_CAP2,3048,6096,560,750,560,1200,"BARO")
Red_GCI:SetSquadronCapInterval("Bes_CAP",1,180,600)

--Ad
Red_GCI:SetSquadron("Ad_CAP","Ad Kuznet",{"Red Air CAP SU33"})
Red_GCI:SetSquadronTakeoffInAir("Ad_CAP",3048)
Red_GCI:SetSquadronCap("Ad_CAP",Red_CAP3,3048,6096,560,750,560,1200,"BARO")
Red_GCI:SetSquadronCapInterval("Ad_CAP",1,180,600)

----------------------------------------------------------------------
-- Ground Attack Setup
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
-- Ground Attack Squadron defaults
----------------------------------------------------------------------
Red_A2G:SetDefaultFuelThreshold(0.2)
Red_A2G:SetDefaultOverhead(1)
Red_A2G:SetDefaultGrouping(2)
Red_A2G:SetDefaultTakeoffFromParkingHot()
Red_A2G:SetDefaultLandingAtEngineShutdown()
Red_A2G:SetDefaultEngageLimit(3)

Red_A2G:SetTacticalDisplay(false)
----------------------------------------------------------------------
-- Ground Attack Squadrons Defintions 
----------------------------------------------------------------------
-- Vody
Red_A2G:SetSquadron("Red_Vody_BAI",AIRBASE.Caucasus.Sochi_Adler,
{"Red Air BAI Su34", "Red Air BAI Mig21", "Red Air BAI Mig23", "Red Air BAI SU25T", "Red Air BAI Mig29A", "Red Air BAI Mig29S"})
Red_A2G:SetSquadronBai("Red_Vody_BAI")

Red_A2G:SetSquadron("Red_Vody_SEAD",AIRBASE.Caucasus.Sochi_Adler,
{"Red Air SEAD Su34", "Red Air SEAD Mig27K", "Red Air SEAD Su25T", "Red Air SEAD Su30"})
Red_A2G:SetSquadronSead("Red_Vody_SEAD")

-- Nal
Red_A2G:SetSquadron("Red_nal_BAI",AIRBASE.Caucasus.Nalchik,
{"Red Air BAI Su34", "Red Air BAI Mig21", "Red Air BAI Mig23", "Red Air BAI SU25T", "Red Air BAI Mig29A", "Red Air BAI Mig29S"})
Red_A2G:SetSquadronBai("Red_nal_BAI")

Red_A2G:SetSquadron("Red_Nal_SEAD",AIRBASE.Caucasus.Nalchik,
{"Red Air SEAD Su34", "Red Air SEAD Mig27K", "Red Air SEAD Su25T", "Red Air SEAD Su30"})
Red_A2G:SetSquadronSead("Red_Nal_SEAD")

-- FARP
Red_A2G:SetSquadron("Red_Helo_BAI","FARP Skala",{"Red_Helo_CAS Ka50", "Red_Helo_CAS_Mi24", "Red_Helo_CAS_Mi28", "Red_Helo_CAS_Mi8"})
Red_A2G:SetSquadronGrouping("Red_Helo_BAI",1)
Red_A2G:SetSquadronBaiPatrol("Red_Helo_BAI", Red_Helo_CAP, 76, 91, 148, 250, 250, 300)
Red_A2G:SetSquadronPatrolInterval("Red_Helo_BAI", 2, 180, 600, 1, "BAI")

----------------------------------------------------------------------
-- Code to control spawning ground assets.
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading blue_spawner")
env.info( "------------------------------------------------" )
--TODO: Generalise functions to allow passing in args 
--- Armour
-- @function spawnBluArm
-- @param #none
function spawnBlueZugFrontLineArm()
Blu_Arm_Proxy = SPAWN:NewWithAlias("Blu_Arm_Proxy", "Blue Grn Armour")
  :InitRandomizeZones(Blu_Arm_Zone:GetSetObjects())
  :InitRandomizePosition(true)
  :InitRandomizeTemplatePrefixes("Blu_Gnd_Armour")
  :InitHeading( 270, 330 )
  :InitLimit( 50, 12 )     -- NOTE: Tune 
  :SpawnScheduled( 10, 0.5 )  -- NOTE: Tune
end
spawnBlueZugFrontLineArm()

--- SAM
-- @function spawnBluSam
-- @param #none
function spawnBlueZugFrontLineSam()
Blu_Arm_SAM_Proxy = SPAWN:NewWithAlias("Blu_Arm_SAM_Proxy", "Blue Grn Anti-Air")
  :InitRandomizeZones(Blu_Arm_SAM_Zone:GetSetObjects())
  :InitRandomizePosition(true)
  :InitRandomizeTemplatePrefixes("Blu_Gnd_SAM")
  :InitHeading( 270, 330 )
  :InitLimit( 15, 5 )     -- NOTE: Tune 
  :SpawnScheduled( 10, 0.5 )  -- NOTE: Tune
end
spawnBlueZugFrontLineSam()

env.info( "------------------------------------------------" )
env.info("          Loading red_spawner")
env.info( "------------------------------------------------" )
--TODO: Generalise functions to allow passing in args 
--- Armour
-- @function spawnRedArm
-- @param #none
function spawnRedZugFrontLineArm()
  RedZugFrontLineArm_Proxy = SPAWN:NewWithAlias("Red_Arm_Proxy", "Red Grn Armour")
    :InitRandomizeZones(Red_Arm_Zone:GetSetObjects())
    :InitRandomizePosition(true)
    :InitRandomizeTemplatePrefixes("Red_Gnd_Armour")
    :InitHeading( 120, 180 )
    :InitRandomizeRoute( 3, 1, 200 )
    :InitLimit( 50, 12 )     -- NOTE: Tune 
    :SpawnScheduled( 10, 0.5 )  -- NOTE: Tune
end
spawnRedZugFrontLineArm()

--- SAM
-- @function spawnRedSam
-- @param #none
function spawnRedZugFrontLineSam()
  Red_Arm_SAM_Proxy = SPAWN:NewWithAlias("Red_Arm_SAM_Proxy", "Red Grn Anti-Air")
    :InitRandomizeZones(Red_Arm_SAM_Zone:GetSetObjects())
    :InitRandomizePosition(true)
    :InitRandomizeTemplatePrefixes("Red_Gnd_SAM")
    :InitHeading( 120, 180 )
    :InitLimit( 15, 5 )     -- NOTE: Tune 
    :SpawnScheduled( 10, 0.5 )  -- NOTE: Tune
end
spawnRedZugFrontLineSam()

--- Statics
-- @function spawnRedArm
-- @param #none
function spawnRedStaticArm()
  RedStaticArm_Proxy = SPAWN:NewWithAlias("Red_Arm_Static_Proxy", "Red Grn Def")
    :InitRandomizeZones(Red_Static_Zone:GetSetObjects())
    :InitRandomizePosition(true)
    :InitRandomizeTemplatePrefixes("Red_Gnd_Armour")
    :InitHeading( 0, 360 )
    :InitLimit( 50, 10 )     -- NOTE: Tune 
    :SpawnScheduled( 1800, 0.5 )  -- NOTE: Tune
end
spawnRedStaticArm()

--- MSR West
-- @function spawnRedArm
-- @param #none
function spawnRedMSRWestArm()
  RedMSRWestArm_Proxy = SPAWN:NewWithAlias("Red_Arm_MSRW_Proxy", "Red Grn MSR")
    :InitRandomizeZones(Red_MSRW_Zone:GetSetObjects())
    :InitRandomizePosition(true)
    :InitRandomizeTemplatePrefixes("Red_Gnd_Armour")
    :InitHeading( 0, 360 )
    :InitRandomizeRoute( 1, 1, 200 )
    :InitLimit( 50, 12 )     -- NOTE: Tune 
    :SpawnScheduled( 1800, 0.5 )  -- NOTE: Tune
end
spawnRedMSRWestArm()

--- MSR East
-- @function spawnRedArm
-- @param #none
--function spawnRedMSREastArm()
--  Red_Arm_Heavy_Proxy = SPAWN:NewWithAlias("Red_Arm_MSRE_Proxy", "Red Grn Armour")
--   :InitRandomizeZones(Red_MSRE_Zone:GetSetObjects())
--    :InitRandomizePosition(true)
--    :InitRandomizeTemplatePrefixes("Red_Gnd_Armour")
--    :InitHeading( 0, 360 )
--    :InitRandomizeRoute( 1, 1, 1000 )
--    :InitLimit( 20, 12 )     -- NOTE: Tune 
--    :SpawnScheduled( 190, .5 )  -- NOTE: Tune
--end
--spawnRedMSREastArm()
----------------------------------------------------------------------
-- Support Squadrons Defintions 
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading AWACS")
env.info( "------------------------------------------------" ) 
-- Blue AWACS
-- Setup the AWACS Patrol and escort
--- AWACS
-- @function spawnAWACS
-- @param #none
function spawnAWACS()
  AWACSGroup = SPAWN
            :New("Overlord")
            :InitRepeatOnEngineShutDown()
            :Spawn()
  local tempRoute = GROUP:FindByName("Overlord"):CopyRoute(0, 0, true, 100)
  AWACSGroup:Route(tempRoute)
  AWACSGroup:EnRouteTaskAWACS()
end
spawnAWACS()
--- Escorts
-- @function spawnAWACSEscort
-- @param #none
function spawnAWACSEscort()
  AWACSEscortGroup = SPAWN
            :New("AWACS Escort")
            :InitRepeatOnEngineShutDown()
            :Spawn()
  local escortVec3d = POINT_VEC3:New(-50,0,-100)
  local escortTask = AWACSEscortGroup:TaskEscort(AWACSGroup, escortVec3d, nil, 74080, {"Air"})
  AWACSEscortGroup:PushTask(escortTask, 2)
end
spawnAWACSEscort()

-- Red AWACS
-- Setup the AWACS Patrol and escort
--- AWACS
-- @function spawnAWACS
-- @param #none
function spawnAWACS()
  AWACSGroup = SPAWN
            :New("AWACS")
            :InitRepeatOnEngineShutDown()
            :Spawn()
  local tempRoute = GROUP:FindByName("AWACS"):CopyRoute(0, 0, true, 100)
  AWACSGroup:Route(tempRoute)
  AWACSGroup:EnRouteTaskAWACS()
end
spawnAWACS()
--- Escorts
-- @function spawnAWACSEscort
-- @param #none
function spawnAWACSEscort()
  AWACSEscortGroup = SPAWN
            :New("Red AWACS Escort")
            :InitRepeatOnEngineShutDown()
            :Spawn()
  local escortVec3d = POINT_VEC3:New(-50,0,-100)
  local escortTask = AWACSEscortGroup:TaskEscort(AWACSGroup, escortVec3d, nil, 74080, {"Air"})
  AWACSEscortGroup:PushTask(escortTask, 2)
end
spawnAWACSEscort()

env.info( "------------------------------------------------" )
env.info("          Loading tankers")
env.info( "------------------------------------------------" ) 

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
-- Blufor Command
----------------------------------------------------------------------
Blufor_HQ = GROUP:FindByName( "Blufor_HQ" )
Blufor_CC = COMMANDCENTER:New( Blufor_HQ, "MotherHen" )

----------------------------------------------------------------------
-- Opfor Command
----------------------------------------------------------------------
Opfor_HQ = GROUP:FindByName( "Opfor_HQ" )
Opfor_CC = COMMANDCENTER:New( Opfor_HQ, "SnowFall" )
----------------------------------------------------------------------
-- SAM Defensive actions
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading SAM C&C")
env.info( "------------------------------------------------" )

SAM_Defence = SEAD:New({"Blue AB SAM", "Blue Grn Anti-Air", "Red AB SAM", "Red Grn Anti-Air"})

--SCHEDULER:New( nil, function()
--   SAM_Set:ForEachGroup(
--   function( MooseGroup )
--    local chance = math.random(1,99)
--     if chance > 75 then
--        MooseGroup:OptionAlarmStateRed()
--        env.info("*********** SAM: ON ***********")
--     else
--        MooseGroup: OptionAlarmStateGreen()
--        env.info("*********** SAM: Off ***********")
--     end
--    end)
--end, {},1, 120)
----------------------------------------------------------------------
-- Blue Designation
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading Designation")
env.info( "------------------------------------------------" )
BlueRecceDesignation = DESIGNATE:New( Blufor_CC, Blu_Ground_Detection, PlayerGroup )
-- This sets the threat level prioritization on
BlueRecceDesignation:SetThreatLevelPrioritization( true )
-- Set the possible laser codes.
BlueRecceDesignation:GenerateLaserCodes()
--BlueRecceDesignation:AddMenuLaserCode( 1113, "Lase with %d for Su-25T" )
--BlueRecceDesignation:AddMenuLaserCode( 1680, "Lase with %d for A-10A" )
-- Start the detection process in 5 seconds.
BlueRecceDesignation:__Detect( -5 )






