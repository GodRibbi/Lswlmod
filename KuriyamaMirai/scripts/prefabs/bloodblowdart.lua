local assets=
{
	Asset("ANIM", "anim/bloodblowdart.zip"),
	Asset("ANIM", "anim/swap_bloodblowdart.zip"),
    Asset("IMAGE", "images/inventoryimages/bloodblowdart.tex"),
    Asset("ATLAS", "images/inventoryimages/bloodblowdart.xml"),
}

local prefabs = 
{
    "impact",
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_bloodblowdart", "swap_blowdart")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end
local function onhit(inst, attacker, target)
    local impactfx = SpawnPrefab("impact")
    if impactfx and attacker then
       local follower = impactfx.entity:AddFollower()
       follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0 )
        impactfx:FacePoint(attacker.Transform:GetWorldPosition())
    end
    if inst.prefab == "blowdart_walrus" then
       inst:Remove()
    else
       attacker.components.inventory:Equip(inst)
    end
	end
local function onthrown(inst, data)
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
end
local function onattack(inst, owner, target)
    if owner.components.health and owner.components.health:GetPercent() <= 1 then
        if owner:HasTag("lswl_moonfull") or owner:HasTag("lswl_evil") or owner:HasTag("lswl_black")then
            return
        end
        owner.components.health:DoDelta(-20)
    end
end
local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    		if IsDLCEnabled(CAPY_DLC) then
		MakeInventoryFloatable(inst, "idle_water", "idle")
	end
	
    anim:SetBank("bloodblowdart")
    anim:SetBuild("bloodblowdart")
    anim:PlayAnimation("idle_blood")


    inst:AddTag("blowdart")
    inst:AddTag("sharp")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(8, 10)
    
    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(60)
    inst.components.projectile:SetOnHitFn(onhit)
	inst.components.weapon:SetDamage(50)
	inst.components.weapon.onattack = onattack
    inst:ListenForEvent("onthrown", onthrown)
    -------
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/bloodblowdart.xml"
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip) 
	inst:AddComponent("perishable")   
    inst.components.perishable:SetPerishTime(480)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "sealring"
    inst:AddTag("show_spoilage")
    
    return inst
end

return Prefab( "common/inventory/bloodblowdart", fn, assets, prefabs)
