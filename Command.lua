-- Name: Command.lua
-- Author: n00dles
-- Date Created: 16/05/2020
----------------------------------------------------------------------
-- NOTES:
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading Command")
env.info( "------------------------------------------------" )

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

