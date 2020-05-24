-- Name: Zones.lua
-- Author: n00dles
-- Date Created: 16/05/2020
----------------------------------------------------------------------
-- NOTES:
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading Zones")
env.info( "------------------------------------------------" )
----------------------------------------------------------------------
-- Blue Ground Forces Zones
----------------------------------------------------------------------
Blu_FrontLine = SET_ZONE:New()
  :FilterPrefixes("Blu_FrontLine")
  :FilterOnce()

Blu_SecondLine = SET_ZONE:New()
  :FilterPrefixes("Blu_SecondLine")
  :FilterOnce()

Blu_Arm_SAM_Zone = SET_ZONE:New()
  :FilterPrefixes("Blu_Arm_SAM_Zone")
  :FilterOnce()

----------------------------------------------------------------------
-- Blue Helo Zones
----------------------------------------------------------------------
HeloCASZone = SET_ZONE:New()
  :FilterPrefixes("HeloCASZone")
  :FilterOnce()

  ----------------------------------------------------------------------
-- Blue CAP Zones
----------------------------------------------------------------------
--  BlueCAPZone = SET_ZONE:New()
--  :FilterPrefixes("BlueCAPZone")
--  :FilterOnce()

----------------------------------------------------------------------
-- Blue Polygon Zones
----------------------------------------------------------------------
-- Do I wanna bother with this? ballache?

----------------------------------------------------------------------
-- Red Spawn Zones
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

--[[[
----------------------------------------------------------------------
-- Blue Fighter Squadron Zones 
----------------------------------------------------------------------
-- CAP Zones
Blu_CAP = ZONE_POLYGON:New("CAP Zone Blue",GROUP:FindByName("CAP Zone Blue"))
Blu_CAP2 = ZONE_POLYGON:New("CAP Zone Blue 2",GROUP:FindByName("CAP Zone Blue 2"))
Blu_CAP3 = ZONE_POLYGON:New("CAP Zone Blue 3",GROUP:FindByName("CAP Zone Blue 3"))
Blu_Helo_CAP = ZONE_POLYGON:New("HeloCASZone",GROUP:FindByName("HeloCASZone"))

----------------------------------------------------------------------
-- Red Fighter Squadron Zones 
----------------------------------------------------------------------
-- CAP Zones
Red_CAP = ZONE_POLYGON:New("CAP Zone Red",GROUP:FindByName("CAP Zone Red"))
Red_CAP2 = ZONE_POLYGON:New("CAP Zone Red 2",GROUP:FindByName("CAP Zone Red 2"))
Red_CAP3 = ZONE_POLYGON:New("CAP Zone Red 3",GROUP:FindByName("CAP Zone Red 3"))
Red_Helo_CAP = ZONE_POLYGON:New("CAP Zone Red Recce",GROUP:FindByName("CAP Zone Red Recce"))
--]]

----------------------------------------------------------------------
-- Assignment/zone Table
----------------------------------------------------------------------
-- Table of assignment/zone pairs for use with Dispatchers
-- TODO need to build this list dynamically..... Some day.... maintaining stactic lists is teh gayz
BattleZones = {}
BattleZones["BlueFrontLine"] = Blu_FrontLine
BattleZones["BlueSecondLine"] = Blu_SecondLine
BattleZones["ForTheMotherLand"] = Red_Arm_Zone