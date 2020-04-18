local assets =
{
	Asset("ANIM", "anim/lifestone.zip"),
        Asset("ATLAS", "images/inventoryimages/lifestone.xml")
}
local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	if IsDLCEnabled(CAPY_DLC) then
		MakeInventoryFloatable(inst, "idle_water", "idle")
	end
    inst.AnimState:SetBank("lifestone")
    inst.AnimState:SetBuild("lifestone")
    inst.AnimState:PlayAnimation("idle")
    inst:AddComponent("inspectable")
	local function OnDeploy (inst, pt)
    SpawnPrefab("rock1").Transform:SetPosition(pt.x, pt.y, pt.z)
    inst:Remove()
end
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy
    inst:AddComponent("inventoryitem")  
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lifestone.xml"    
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    return inst
end

return Prefab("common/inventory/lifestone", fn, assets) 
