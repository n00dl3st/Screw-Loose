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
local pseudoATC=PSEUDOATC:New()
pseudoATC:Start()

local CleanUpAirports = CLEANUP_AIRBASE:New( { AIRBASE.Caucasus.Kobuleti,
                                AIRBASE.Caucasus.Senaki_Kolkhi,
                                AIRBASE.Caucasus.Sukhumi_Babushara,
                                AIRBASE.Caucasus.Gudauta,
                                AIRBASE.Caucasus.Sochi_Adler,
                                AIRBASE.Caucasus.Maykop_Khanskaya
                                } )

--CleanUpAirports:SetCleanMissiles(true)