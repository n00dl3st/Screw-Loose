-- Name: Detection.lua
-- Author: n00dles
-- Date Created: 16/05/2020
----------------------------------------------------------------------
-- NOTES:
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading Detection")
env.info( "------------------------------------------------" )

----------------------------------------------------------------------
-- Blue Detection
----------------------------------------------------------------------
-- AIR
Blu_Air_Detection = DETECTION_AREAS:New(Blu_EWR_Set,55560) -- 20Nm
Blu_Air_Detection:SetFriendliesRange(148160) -- 80nm
Blu_Air_Detection:Start()

-- GROUND
Blu_Ground_Detection = DETECTION_AREAS:New(Blu_A2G_Set,1852) -- 1nm
Blu_Ground_Detection:SetFriendliesRange( 9260 ) -- 5nm -- CAS or BAI 
Blu_Ground_Detection:Start()

----------------------------------------------------------------------
-- Red Detection
----------------------------------------------------------------------
-- AIR
Red_Air_Detection = DETECTION_AREAS:New(Red_EWR_Set,55560) -- 20Nm
Red_Air_Detection:SetFriendliesRange(148160) -- 80nm
Red_Air_Detection:Start()

-- GROUND
Red_Ground_Detection = DETECTION_AREAS:New(Red_A2G_Set,1852) -- 1nm
Red_Ground_Detection:SetFriendliesRange( 9260 ) -- 5nm CAS or BAI
Red_Ground_Detection:Start()

----------------------------------------------------------------------
-- Blue Designation
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading Designation")
env.info( "------------------------------------------------" )
BlueRecceDesignation = DESIGNATE:New( Blufor_CC, Blu_Ground_Detection, PlayerGroup )
-- This sets the threat level prioritization on
BlueRecceDesignation:SetThreatLevelPrioritization( true )
-- Set the possible laser codes.
BlueRecceDesignation:GenerateLaserCodes()
--BlueRecceDesignation:AddMenuLaserCode( 1113, "Lase with %d for Su-25T" )
--BlueRecceDesignation:AddMenuLaserCode( 1680, "Lase with %d for A-10A" )
-- Start the detection process in 5 seconds.
BlueRecceDesignation:__Detect( -5 )