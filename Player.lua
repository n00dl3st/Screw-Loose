-- Name: Player.lua
-- Author: n00dles
-- Date Created: 16/05/2020
----------------------------------------------------------------------
-- NOTES:
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading Player")
env.info( "------------------------------------------------" )

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
-- Scoring
----------------------------------------------------------------------        
Scoring = SCORING:New("DynaMis") 
