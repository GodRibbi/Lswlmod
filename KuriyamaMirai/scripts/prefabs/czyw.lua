local assets =
{
	 Asset("ANIM", "anim/czyw.zip"),
     Asset("ATLAS", "images/inventoryimages/czyw.xml"),
	 Asset("IMAGE", "images/inventoryimages/czyw.tex"),
}
local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	if IsDLCEnabled(CAPY_DLC) then
		MakeInventoryFloatable(inst, "idle_water", "idle")
	end
    inst.AnimState:SetBank("czyw")
    inst.AnimState:SetBuild("czyw")
    inst.AnimState:PlayAnimation("idle")
	inst:AddComponent("edible")
    inst.components.edible.healthvalue = 50
    inst.components.edible.hungervalue = -25
    inst.components.edible.sanityvalue = 10
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst:AddComponent("inspectable")
    inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(9600)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spidergland"
    inst:AddComponent("inventoryitem")  
    inst.components.inventoryitem.atlasname = "images/inventoryimages/czyw.xml"    
    return inst
end

return Prefab("common/inventory/czyw", fn, assets) 

