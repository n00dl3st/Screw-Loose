-- Name: Squadron.lua
-- Author: n00dles
-- Date Created: 16/05/2020
----------------------------------------------------------------------
-- NOTES:
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading Squadrons")
env.info( "------------------------------------------------" )

--[[
----------------------------------------------------------------------
-- Blue Fighter Squadron defaults
----------------------------------------------------------------------
Blu_GCI:SetIntercept(30)
Blu_GCI:SetDefaultFuelThreshold(0.2)
Blu_GCI:SetDefaultOverhead(1)
Blu_GCI:SetDefaultGrouping(2)
Blu_GCI:SetDefaultTakeoffFromParkingHot()
Blu_GCI:SetDefaultLandingAtEngineShutdown()

Blu_GCI:SetTacticalDisplay(false)

----------------------------------------------------------------------
-- Blue Fighter Squadrons Defintions 
----------------------------------------------------------------------
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
-- Blue Ground Attack Squadron defaults
----------------------------------------------------------------------
Blu_A2G:SetDefaultFuelThreshold(0.2)
Blu_A2G:SetDefaultOverhead(1)
Blu_A2G:SetDefaultGrouping(2)
Blu_A2G:SetDefaultTakeoffFromParkingHot()
Blu_A2G:SetDefaultLandingAtEngineShutdown()
Blu_A2G:SetDefaultEngageLimit(4)

Blu_A2G:SetTacticalDisplay(false)

----------------------------------------------------------------------
-- Blue Ground Attack Squadrons Defintions 
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
Blu_A2G:SetSquadronGrouping("Helo_BAI",2)
Blu_A2G:SetSquadronBaiPatrol("Helo_BAI", Blu_Helo_CAP, 76, 91, 148, 250, 250, 300)
Blu_A2G:SetSquadronPatrolInterval("Helo_BAI", 2, 180, 600, 1, "BAI")


----------------------------------------------------------------------
-- Red Fighter Squadron defaults
----------------------------------------------------------------------
Red_GCI:SetIntercept(30)
Red_GCI:SetDefaultFuelThreshold(0.2)
Red_GCI:SetDefaultOverhead(1)
Red_GCI:SetDefaultGrouping(2)
Red_GCI:SetDefaultTakeoffFromParkingHot()
Red_GCI:SetDefaultLandingAtEngineShutdown()

Red_GCI:SetTacticalDisplay(false)

----------------------------------------------------------------------
-- Red Fighter Squadrons Defintions 
----------------------------------------------------------------------
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
-- Red Ground Attack Squadron defaults
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
Red_A2G:SetSquadron("Red_Helo_BAI","FARP Vetka",{"Red_Helo_CAS Ka50", "Red_Helo_CAS_Mi24", "Red_Helo_CAS_Mi28", "Red_Helo_CAS_Mi8"})
Red_A2G:SetSquadronGrouping("Red_Helo_BAI",2)
Red_A2G:SetSquadronBaiPatrol("Red_Helo_BAI", Red_Helo_CAP, 76, 91, 148, 250, 250, 300)
Red_A2G:SetSquadronPatrolInterval("Red_Helo_BAI", 2, 180, 600, 1, "BAI")

--]]