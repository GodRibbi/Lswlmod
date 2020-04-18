local assets =
{
	Asset("ANIM", "anim/ymquintessence.zip"),
        Asset("ATLAS", "images/inventoryimages/ymquintessence.xml")
}
local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	if IsDLCEnabled(CAPY_DLC) then
		MakeInventoryFloatable(inst, "idle_water", "idle")
	end
    inst.AnimState:SetBank("ymquintessence")
    inst.AnimState:SetBuild("ymquintessence")
    inst.AnimState:PlayAnimation("idle")
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")  
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ymquintessence.xml"    
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    return inst
end

return Prefab("common/inventory/ymquintessence", fn, assets) 
