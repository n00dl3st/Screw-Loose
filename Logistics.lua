-- Name: Logistics.lua
-- Author: n00dles
-- Date Created: 17/05/2020
----------------------------------------------------------------------
-- NOTES:
----------------------------------------------------------------------
env.info( "------------------------------------------------" )
env.info("          Loading Logistics")
env.info( "------------------------------------------------" )

-- LOGISTICS object class
LOGISTICS = {}

-- blue warehoses
LOGISTICS.Ocham = WAREHOUSE:New(STATIC:FindByName("Blue WH Ocham"), "Ochamchira")   --Functional.LOGISTICS#LOGISTICS

-- start process
LOGISTICS.Ocham:Start()

-- Stock
LOGISTICS.Ocham:AddAsset("Blu_Gnd_Arm_APC", 3)
LOGISTICS.Ocham:AddAsset("Blu_Gnd_SAM_APC", 3)
LOGISTICS.Ocham:AddAsset("Blu_Gnd_Arm_APC2", 3)
LOGISTICS.Ocham:AddAsset("Blu_Gnd_Arm_Lite", 3)
LOGISTICS.Ocham:AddAsset("Blu_Gnd_Arm_Heavy", 3)
LOGISTICS.Ocham:AddAsset("Blu_Gnd_Arm_Arty", 3)
LOGISTICS.Ocham:AddAsset("Blu_Gnd_Arm_Lite2", 3)
LOGISTICS.Ocham:AddAsset("Blu_Gnd_Arm_Heavy2", 3)
LOGISTICS.Ocham:AddAsset("Blu_Gnd_SAM_Rol", 3)
LOGISTICS.Ocham:AddAsset("Blu_Gnd_SAM_AAA", 3)
LOGISTICS.Ocham:AddAsset("Blu_Gnd_SAM_IR", 3)
LOGISTICS.Ocham:AddAsset("Blu_Gnd_Infantry", 5)
LOGISTICS.Ocham:AddAsset("Blu_Gnd_Infantry_Manpad", 5)

local BlueAreasOfOperations = Blu_Arm_Zone:GetSetObjects()

-- Creat explosion at an object.
local function Explosion(object, power)
  power=power or 1000
  if object and object:IsAlive() then
    object:GetCoordinate():Explosion(power)
  end
end  

for i=1,3 do
    local time=(i-1)*60+10
    --LOGISTICS.Ocham:__AddRequest(time, LOGISTICS.Ocham, WAREHOUSE.Descriptor.CATEGORY, Group.Category.GROUND, 10, nil, nil, nil, "FrontLine")
    LOGISTICS.Ocham:__AddRequest(time, LOGISTICS.Ocham, WAREHOUSE.Descriptor.CATEGORY, Group.Category.GROUND, 3, nil, nil, nil, "FrontLine")
end

-- Take care of the spawned units.
function LOGISTICS.Ocham:OnAfterSelfRequest(From,Event,To,groupset,request)
    local groupset=groupset --Core.Set#SET_GROUP
    local request=request   --Functional.LOGISTICS#LOGISTICS.Pendingitem
    
    -- Get assignment of this request.
    local assignment=LOGISTICS.Ocham:GetAssignment(request)
    
    if assignment=="FrontLine" then
      for _,group in pairs(groupset:GetSet()) do
        local group=group --Wrapper.Group#GROUP
        local AO = BlueAreasOfOperations[math.random(1, table.getn(BlueAreasOfOperations))]
        -- Route group to Battle zone.
        local ToCoord=(AO:GetRandomPointVec2())
        group:Activate()
        group:RouteGroundTo(ToCoord, group:GetSpeedMax()*0.8)
        -- After 3-5 minutes we create an explosion to destroy the group.
        -- SCHEDULER:New(nil, Explosion, {group, 50}, math.random(180, 300))
      end
    end
  end

  -- An asset has died ==> request resupply for it.
function LOGISTICS.Ocham:OnAfterAssetDead(From, Event, To, asset, request)
    local asset=asset       --Functional.LOGISTICS#LOGISTICS.Assetitem
    local request=request   --Functional.LOGISTICS#LOGISTICS.Pendingitem
    -- Get assignment.
    local assignment=LOGISTICS.Ocham:GetAssignment(request)
    -- Request resupply for dead asset from down stream.
    --LOGISTICS.Ocham:AddRequest(LOGISTICS.Ocham, WAREHOUSE.Descriptor.ATTRIBUTE, asset.attribute, 1, nil, nil, nil, "Resupply")
    
    -- Send asset to Battle zone either now or when they arrive.
    LOGISTICS.Ocham:AddRequest(LOGISTICS.Ocham, WAREHOUSE.Descriptor.ATTRIBUTE, asset.attribute, 1, nil, nil, nil, assignment)
  end