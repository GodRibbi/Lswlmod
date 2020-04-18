require "stategraphs/SGshadowcreature"

local assets =
{
	Asset("ANIM", "anim/shadow_insanity2_basic.zip"),
	Asset( "IMAGE", "images/minimap/ym.tex" ),
	 Asset( "ATLAS", "images/minimap/ym.xml" ),
}

local prefabs = 
{
}
 
require "brains/abigailbrain"

local function Retarget(inst)

    local newtarget = FindEntity(inst, 20, function(guy)
            return  guy.components.combat and 
                    inst.components.combat:CanTarget(guy) and
                    (guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy)
    end)

    return newtarget
end

local function OnAttacked(inst, data)
    --print(inst, "OnAttacked")
    local attacker = data.attacker

    if attacker and attacker:HasTag("player") then
        inst.components.health:SetVal(0)
    else
        inst.components.combat:SetTarget(attacker)
    end
end

local function onsave(inst, data)
    if inst:HasTag("superym") then
        data.superym = true
    end
	if inst:HasTag("stophere") then
        data.stophere = true
    end
end

local function onload(inst, data)
  if data and data.superym then
           inst:AddTag("superym")
		   inst.name = ("加强妖梦")
           inst.Transform:SetScale(1.5, 1.5, 1.5)
           inst.components.health:SetMaxHealth(500)
		   inst.components.health:StartRegen(1, 2)
		   inst.components.combat:SetDefaultDamage(50)
           inst.components.combat:SetAttackPeriod(1.25)
		   end
  if data and data.stophere then
    inst:AddTag("stophere")
    inst.components.locomotor:Stop()
    inst:SetBrain(nil)
    inst.components.follower:SetLeader(nil)
  end
		   end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	inst.Transform:SetFourFaced()
	    local sounds = 
    {
        attack = "dontstarve/sanity/creature2/attack",
        attack_grunt = "dontstarve/sanity/creature2/attack_grunt",
        death = "dontstarve/sanity/creature2/die",
        idle = "dontstarve/sanity/creature2/idle",
        taunt = "dontstarve/sanity/creature2/taunt",
        appear = "dontstarve/sanity/creature2/appear",
        disappear = "dontstarve/sanity/creature2/dissappear",
    }
	inst.sounds = sounds
        inst.entity:AddMiniMapEntity()
		inst.MiniMapEntity:SetIcon("ym.tex")
		if IsDLCEnabled(CAPY_DLC) then
		MakeAmphibiousCharacterPhysics(inst, 1, .5)
	else
		MakeCharacterPhysics(inst, 1, .5)
		inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
		inst.Physics:ClearCollisionMask()
		inst.Physics:CollidesWith(COLLISION.WORLD)
		inst.Physics:CollidesWith(COLLISION.OBSTACLES)
		inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	end
    
    
    local brain = require "brains/abigailbrain"
    inst:SetBrain(brain)
    anim:SetBank("shadowcreature2")
    anim:SetBuild("shadow_insanity2_basic")
    anim:PlayAnimation("idle_loop")
	anim:SetScale(.5,.5,.5)
	anim:SetMultColour(255/255,20/255,20/255, 0.5)
    
    inst:AddTag("character")
    inst:AddTag("ym")
	inst:AddTag("companion")
	inst:AddTag("ghost")
	inst:AddTag("noauradamage")
	inst:AddTag("amphibious")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 10
    inst.components.locomotor.runspeed = 10
    
    inst:SetStateGraph("SGshadowcreature")

    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(300)
    inst.components.health:StartRegen(1, 1)

	inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(30)
    inst.components.combat:SetAttackPeriod(2.5)
    inst.components.combat:SetRetargetFunction(3, Retarget)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"ymquintessence"})

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(function(inst, item)
        if not inst:HasTag("superym") then
           if item.prefab == "evilblackstone" then
              return true
           end
           if item.prefab == "nightmarefuel" then
              return inst.components.health:GetPercent() < 1
           end
		   elseif inst:HasTag("superym") then
		   if item.prefab == "nightmarefuel" then
              return inst.components.health:GetPercent() < 1
           end
        end
        return false
    end )
    inst.components.trader.onaccept = function(inst, giver, item)
        if item.prefab == "evilblackstone" then
           inst:AddTag("superym")
		   inst.name = ("加强妖梦")
		   local fx = SpawnPrefab("flashfx")
           fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		   fx.AnimState:SetMultColour(255/255,0/255,0/255,1)
		   fx.Transform:SetScale(7,7,7)
           inst.Transform:SetScale(2, 2, 2)
           inst.components.health:SetMaxHealth(500)
		   inst.components.health:StartRegen(1, 2)
		   inst.components.combat:SetDefaultDamage(50)
           inst.components.combat:SetAttackPeriod(1.25)
		   
        end
        if item.prefab == "nightmarefuel" then
           inst.components.health:DoDelta(100)
        end
    end
	    inst.components.inspectable.getstatus = function(inst)
        if not inst:HasTag("stophere") then
           inst:AddTag("stophere")
           inst.components.locomotor:Stop()
           inst:SetBrain(nil)
           inst.components.follower:SetLeader(nil)
        else
           inst:RemoveTag("stophere")
           local brain = require "brains/abigailbrain"
           inst:SetBrain(brain)
           inst:RestartBrain()
           inst.components.follower:SetLeader(GetPlayer())
        end
		end
	inst.OnSave = onsave
    inst.OnLoad = onload
    inst:AddComponent("follower")
	local player = GetPlayer()
	if player and player.components.leader then
		player.components.leader:AddFollower(inst)
	end
    inst:ListenForEvent("attacked", OnAttacked)
	
    return inst
end

return Prefab( "common/monsters/ym", fn, assets, prefabs ) 
