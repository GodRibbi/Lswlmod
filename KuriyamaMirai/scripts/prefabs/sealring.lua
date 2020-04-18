local assets =
{
	Asset("ANIM", "anim/sealring.zip"),
        Asset("ATLAS", "images/inventoryimages/sealring.xml")
}
local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	if IsDLCEnabled(CAPY_DLC) then
		MakeInventoryFloatable(inst, "idle_water", "idle")
	end
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("sealring.tex")
    inst.AnimState:SetBank("sealring")
    inst.AnimState:SetBuild("sealring")
    inst.AnimState:PlayAnimation("idle")
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")  
    inst.components.inventoryitem.atlasname = "images/inventoryimages/sealring.xml"    
    return inst
end

return Prefab("common/inventory/sealring", fn, assets) 
