local assets=
{
	Asset("ANIM", "anim/bloodsword.zip"),
	Asset("ANIM", "anim/swap_bloodblacksword.zip"),
        Asset("IMAGE", "images/inventoryimages/bloodblacksword.tex"),
        Asset("ATLAS", "images/inventoryimages/bloodblacksword.xml"),
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_bloodblacksword", "swap_bloodsword")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
		if IsDLCEnabled(CAPY_DLC) then
		MakeInventoryFloatable(inst, "idle_water", "idle")
	end
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bloodblacksword.xml"
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("bloodblacksword.tex")

    anim:SetBank("bloodsword")
    anim:SetBuild("bloodsword")
    anim:PlayAnimation("idle")
    
    inst:AddTag("sharp")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(100)
    inst.components.weapon:SetRange(2)
   
    inst:AddComponent("dapperness")
    inst.components.dapperness.dapperness = -20/60
	
    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT
	inst.components.equippable.dapperness = -20/60
    
    return inst
end

return Prefab( "common/inventory/bloodblacksword", fn, assets) 
