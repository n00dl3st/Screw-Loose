-- Name: Airports.lua
-- Author: n00dles
-- Date Created: 16/05/2020
----------------------------------------------------------------------
-- NOTES:
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading Airports")
env.info( "------------------------------------------------" )
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