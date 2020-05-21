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
--[[
2020-05-21 01:25:54.669 INFO    SCRIPTING: Error in timer function: [string "Scripts/Moose/Functional/CleanUp.lua"]:396: attempt to call method 'GetLife' (a nil value)
2020-05-21 01:25:54.669 INFO    SCRIPTING: stack traceback:
        [string "Scripts/Moose/Core/ScheduleDispatcher.lua"]:179: in function 'GetLife'
        [string "Scripts/Moose/Functional/CleanUp.lua"]:396: in function <[string "Scripts/Moose/Functional/CleanUp.lua"]:378>
        (tail call): ?
        [C]: in function 'xpcall'
        [string "Scripts/Moose/Core/ScheduleDispatcher.lua"]:224: in function <[string "Scripts/Moose/Core/ScheduleDispatcher.lua"]:168>
--]]
--CleanUpAirports = CLEANUP_AIRBASE:New( { AIRBASE.Caucasus.Senaki_Kolkhi,AIRBASE.Caucasus.Kobuleti,AIRBASE.Caucasus.Sochi_Adler,AIRBASE.Caucasus.Nalchik } )