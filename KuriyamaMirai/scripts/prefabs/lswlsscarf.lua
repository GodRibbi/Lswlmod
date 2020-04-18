local assets=
{
	Asset("ANIM", "anim/lswl's scarf.zip"),
	Asset("ANIM", "anim/swap_lswl's scarf.zip"),
	Asset("ATLAS", "images/inventoryimages/lswlsscarf.xml"),
}
	local function generic_perish(inst)
		inst:Remove()
	end
local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "swap_lswl's scarf", "swap_body")
    inst.components.fueled:StartConsuming()
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst.components.fueled:StopConsuming()
end

local function onperish(inst)
    inst:Remove()
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    	if IsDLCEnabled(CAPY_DLC) then
		MakeInventoryFloatable(inst, "idle_water", "idle")
	end
    inst.AnimState:SetBank("lswl's scarf")
    inst.AnimState:SetBuild("lswl's scarf")
    inst.AnimState:PlayAnimation("idle",true)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/lswlsscarf.xml" 
	
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

    inst:AddComponent("insulator")
    inst.components.insulator.insulation = TUNING.INSULATION_LARGE
	

	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = "USAGE"
	inst.components.fueled:InitializeFuelLevel(TUNING.TRUNKVEST_PERISHTIME)
	inst.components.fueled:SetDepletedFn(generic_perish)

    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

return Prefab( "common/inventory/lswlsscarf", fn, assets) 