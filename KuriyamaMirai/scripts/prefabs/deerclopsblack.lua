local brain = require "brains/deerclopsbrain"
require "stategraphs/SGdeerclops"

local assets =
{
	Asset("ANIM", "anim/deerclops_basic.zip"),
	Asset("ANIM", "anim/deerclops_actions.zip"),
	Asset("ANIM", "anim/deerclopsblack_build.zip"),
	Asset("SOUND", "sound/deerclops.fsb"),
	Asset( "IMAGE", "images/minimap/deerclopsblack.tex" ),
	Asset( "ATLAS", "images/minimap/deerclopsblack.xml" ),
}

local prefabs =
{
	"meat",
	"deerclops_eyeball",
    "collapse_small",
    "icespike_fx_1",
    "icespike_fx_2",
    "icespike_fx_3",
    "icespike_fx_4",
	"flashfx"
}

local TARGET_DIST = 30*2


local function CalcSanityAura(inst, observer)
	
	if inst.components.combat.target then
		return -TUNING.SANITYAURA_HUGE*2
	else
		return -TUNING.SANITYAURA_LARGE*2
	end
	
	return 0
end

local function RetargetFn(inst)
    return FindEntity(inst, TARGET_DIST, function(guy)
        return inst.components.combat:CanTarget(guy)
               and not guy:HasTag("prey")
               and not guy:HasTag("smallcreature")
               and (inst.components.knownlocations:GetLocation("targetbase") == nil or guy.components.combat.target == inst)
    end)
end


local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function AfterWorking(inst)
    inst.structuresDestroyed = inst.structuresDestroyed + 1
end

local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end

local function OnEntitySleep(inst)
    if inst.shouldGoAway then
        inst:Remove()
    end
    inst.structuresDestroyed = 0
end

local function OnSave(inst, data)
    data.structuresDestroyed = inst.structuresDestroyed
    data.shouldGoAway = inst.shouldGoAway
end
        
local function OnLoad(inst, data)
    if data and data.structuresDestroyed and data.shouldGoAway then
        inst.structuresDestroyed = data.structuresDestroyed
        inst.shouldGoAway = data.shouldGoAway
    end
end

local function OnSeasonChange(inst, data)
    inst.shouldGoAway = (GetSeasonManager():GetSeason() ~= SEASONS.WINTER or GetSeasonManager().incaves)
    if inst:IsAsleep() then
        OnEntitySleep(inst)
    end
end

local function OnHitOther(inst, data)
    local other = data.target
    if other and other.components.freezable then
        other.components.freezable:AddColdness(2*1.5)
        other.components.freezable:SpawnShatterFX()
    end
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(GetPlayer())
end

local function oncollide(inst, other)
    if other == nil or not other:HasTag("tree") then return end
    
    local v1 = Vector3(inst.Physics:GetVelocity())
    if v1:LengthSq() < 1 then return end

    inst:DoTaskInTime(2*FRAMES, function()
        if other and other.components.workable and other.components.workable.workleft > 0 then
            SpawnPrefab("collapse_small").Transform:SetPosition(other:GetPosition():Get())
            other.components.workable:Destroy(inst)
        end
    end)

end

local loot = {"evilblackstone","ymstone","ymquintessence","ymquintessence","ymquintessence","ymquintessence","ymquintessence","ymquintessence","ymquintessence","ymquintessence","ymquintessence","ymquintessence"}

local function fn(Sim)
    
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
    local s  = 2.5
    inst.Transform:SetScale(s,s,s)
	shadow:SetSize( 6*2, 3.5*2 )
    inst.Transform:SetFourFaced()
    
    inst.structuresDestroyed = 0
    inst.shouldGoAway = false
	        inst.entity:AddMiniMapEntity()
		inst.MiniMapEntity:SetIcon("deerclopsblack.tex")
			if IsDLCEnabled(CAPY_DLC) then
		MakeAmphibiousCharacterPhysics(inst,  1000, .5)
	else
		MakeCharacterPhysics(inst, 1000, .5)
		inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
		inst.Physics:ClearCollisionMask()
		inst.Physics:CollidesWith(COLLISION.WORLD)
		inst.Physics:CollidesWith(COLLISION.OBSTACLES)
		inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	end
    inst.Physics:SetCollisionCallback(oncollide)

    local Light = inst.entity:AddLight()
	inst.Light:SetRadius(1);
	inst.Light:SetFalloff(.75);
	inst.Light:SetIntensity(.75);
	inst.Light:SetColour(255/255,0/255,0/255);
    inst.Light:Enable(true)
	
	inst:AddTag("epic")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("deerclopsblack")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")
	inst:AddTag("amphibious")

    anim:SetBank("deerclops")
    anim:SetBuild("deerclopsblack_build")
    anim:PlayAnimation("idle_loop", true)
    
    ------------------------------------------

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 3*1.5 
    
    ------------------------------------------
    inst:SetStateGraph("SGdeerclops")

    ------------------------------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura


    MakeLargeBurnableCharacter(inst, "swap_fire")
    MakeHugeFreezableCharacter(inst, "deerclops_body")
    inst.components.freezable:SetResistance(6)

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.DEERCLOPS_HEALTH*4)

    ------------------
    
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.DEERCLOPS_DAMAGE*3)
    inst.components.combat.playerdamagepercent = .5
    inst.components.combat:SetRange(TUNING.DEERCLOPS_ATTACK_RANGE*2)
    inst.components.combat:SetAreaDamage(TUNING.DEERCLOPS_AOE_RANGE*1.5, TUNING.DEERCLOPS_AOE_SCALE*1.5)
    inst.components.combat.hiteffectsymbol = "deerclops_body"
    inst.components.combat:SetAttackPeriod(TUNING.DEERCLOPS_ATTACK_PERIOD*1.5)
    inst.components.combat:SetRetargetFunction(3, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    
    ------------------------------------------
	
 
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    
------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    
    ------------------------------------------

    inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()
    ------------------------------------------
    inst:AddComponent("knownlocations")
    inst:SetBrain(brain)
    
    inst:ListenForEvent("working", AfterWorking)
	inst:ListenForEvent("entitysleep", OnEntitySleep)
	inst:ListenForEvent("seasonChange", function() OnSeasonChange(inst) end, GetWorld() )
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onhitother", OnHitOther)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
	
	inst:DoPeriodicTask(10,function ()
	inst.components.locomotor:Stop()
    inst.AnimState:PlayAnimation("taunt")
    inst:DoTaskInTime(2, function() 
	local names = {"crawlinghorror","terrorbeak"}
    name = names[math.random(#names)]
	local gx = 2
	local player = inst
    local pt = Vector3(player.Transform:GetWorldPosition())
    local nummerms = math.random(gx)
    local ground = GetWorld()
        for k = 1, nummerms do
            local theta = 1 * 2 * PI
            local radius = 3
            local result_offset = FindValidPositionByFan(theta, radius, nummerms, function(offset)
                local x,y,z = (pt + offset):Get()
                local ents = TheSim:FindEntities(x,y,z , 1)
                return not next(ents) 
            end)
            if result_offset and ground.Map:GetTileAtPoint((pt + result_offset):Get()) ~= GROUND.IMPASSABLE then
                local shadow = SpawnPrefab(name)
                shadow.Transform:SetPosition((pt + result_offset):Get())
                shadow.components.combat.target = GetPlayer()
				shadow:AddComponent("lootdropper")
                shadow.components.lootdropper:SetLoot({})
                GetPlayer().components.playercontroller:ShakeCamera(inst, "FULL", 0.2, 0.02, .25, 40)
                local fx = SpawnPrefab("flashfx")
                local pos = pt + result_offset
                fx.Transform:SetPosition(pos.x, pos.y, pos.z)
				fx.AnimState:SetMultColour(255/255,0/255,0/255,1)
				fx.Transform:SetScale(7,7,7)
            end
        end
    end)
	end)
    return inst
end

return Prefab( "common/monsters/deerclopsblack", fn, assets, prefabs) 
