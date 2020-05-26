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
-- Blue Cap Zones
----------------------------------------------------------------------
BlueHeloZone = SET_ZONE:New()
  :FilterPrefixes("HeloCASZone")
  :FilterOnce()

  ----------------------------------------------------------------------
-- Blue CAP Zones
----------------------------------------------------------------------
BlueCAPZone = SET_ZONE:New()
  :FilterPrefixes("BlueCAPZone")
  :FilterOnce()

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

  ----------------------------------------------------------------------
-- Blue CAP Zones
----------------------------------------------------------------------
RedCAPZone = SET_ZONE:New()
  :FilterPrefixes("RedCAPZone")
  :FilterOnce()

----------------------------------------------------------------------
-- Assignment/zone Table
----------------------------------------------------------------------
-- Table of assignment/zone pairs for use with Dispatchers
-- TODO need to build this list dynamically..... Some day.... maintaining stactic lists is teh gayz
BattleZones = {}
BattleZones["BlueFrontLine"] = Blu_FrontLine
BattleZones["BlueSecondLine"] = Blu_SecondLine
BattleZones["ForTheMotherLand"] = Red_Arm_Zone