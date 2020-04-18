local assets=
{
	Asset("ANIM", "anim/bloodsword.zip"),
	Asset("ANIM", "anim/swap_bloodsword.zip"),
        Asset("IMAGE", "images/inventoryimages/bloodsword.tex"),
        Asset("ATLAS", "images/inventoryimages/bloodsword.xml"),
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_bloodsword", "swap_bloodsword")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

local function onattack(inst, owner, target)
    if owner.components.health and owner.components.health:GetPercent() <= 1 then
        if owner:HasTag("lswl_moonfull") or owner:HasTag("lswl_evil") or owner:HasTag("lswl_black") then
            return
        end
        owner.components.health:DoDelta(-10)
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
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bloodsword.xml"
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("bloodsword.tex")

    anim:SetBank("bloodsword")
    anim:SetBuild("bloodsword")
    anim:PlayAnimation("idle")
    
    inst:AddTag("sharp")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(100)
    inst.components.weapon:SetRange(2)
    inst.components.weapon.onattack = onattack
   
    inst:AddTag("show_spoilage")
    
    
   inst:AddComponent("perishable")   
    inst.components.perishable:SetPerishTime(480)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "sealring"
    
inst:AddComponent("inspectable")


    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

return Prefab( "common/inventory/bloodsword", fn, assets) 
