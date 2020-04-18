local assets =
{
	 Asset("ANIM", "anim/thecurseblood.zip"),
     Asset("ATLAS", "images/inventoryimages/thecurseblood.xml"),
	 Asset("IMAGE", "images/inventoryimages/thecurseblood.tex"),
}
local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	if IsDLCEnabled(CAPY_DLC) then
		MakeInventoryFloatable(inst, "idle_water", "idle")
	end
	inst:AddTag("meat")
    inst.AnimState:SetBank("thecurseblood")
    inst.AnimState:SetBuild("thecurseblood")
    inst.AnimState:PlayAnimation("idle")
	inst:AddComponent("edible")
    inst.components.edible.healthvalue = -50
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = -20
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst:AddComponent("inspectable")
    inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(2400)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "nightmarefuel"
    inst:AddComponent("inventoryitem")  
    inst.components.inventoryitem.atlasname = "images/inventoryimages/thecurseblood.xml"    
    return inst
end

return Prefab("common/inventory/thecurseblood", fn, assets) 

