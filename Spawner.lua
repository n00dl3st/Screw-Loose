-- Name: Spawner.lua
-- Author: n00dles
-- Date Created: 16/05/2020
----------------------------------------------------------------------
-- NOTES:
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading Spawner")
env.info( "------------------------------------------------" )

----------------------------------------------------------------------
-- Blue ground assets.
----------------------------------------------------------------------
--TODO: Generalise functions to allow passing in args 
--- Armour
-- @function spawnBlueZugFrontLineArm
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
-- @function spawnBlueZugFrontLineSam
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

----------------------------------------------------------------------
-- Red ground assets.
----------------------------------------------------------------------
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

