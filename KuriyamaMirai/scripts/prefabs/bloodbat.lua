local assets=
{
	Asset("ANIM", "anim/bloodbat.zip"),
	Asset("ANIM", "anim/swap_bloodbat.zip"),
        Asset("IMAGE", "images/inventoryimages/bloodbat.tex"),
        Asset("ATLAS", "images/inventoryimages/bloodbat.xml"),
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_bloodbat", "swap_bloodbat")
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
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bloodbat.xml"
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("bloodbat.tex")

    anim:SetBank("bloodbat")
    anim:SetBuild("bloodbat")
    anim:PlayAnimation("idle")
    
    inst:AddComponent("tool")
	inst.components.tool:SetAction(ACTIONS.MINE, 2)
    inst.components.tool:SetAction(ACTIONS.CHOP, 4)
	inst.components.tool:SetAction(ACTIONS.DIG)
	inst.components.tool:SetAction(ACTIONS.HAMMER)
    if ACTIONS.HACK ~= nil then
        inst.components.tool:SetAction(ACTIONS.HACK, 2)
    end
	
    inst:AddTag("sharp")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(10)
   
    inst:AddTag("show_spoilage")
    
    
   inst:AddComponent("perishable")   
    inst.components.perishable:SetPerishTime(960)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "sealring"
    
inst:AddComponent("inspectable")


    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

return Prefab( "common/inventory/bloodbat", fn, assets) 
