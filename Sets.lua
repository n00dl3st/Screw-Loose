-- Name: Sets.lua
-- Author: n00dles
-- Date Created: 16/05/2020
----------------------------------------------------------------------
-- NOTES:
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading Sets")
env.info( "------------------------------------------------" )
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