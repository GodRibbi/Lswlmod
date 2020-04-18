local assets =
{
	Asset("ANIM", "anim/evilblackstone.zip"),
        Asset("ATLAS", "images/inventoryimages/evilblackstone.xml")
}
local function ondropped(inst)
	local Light = inst.entity:AddLight()
		inst.Light:SetRadius(.25);
		inst.Light:SetFalloff(.7);
		inst.Light:SetIntensity(.5);
		inst.Light:SetColour(255/255,255/255,255/255);
inst.Light:Enable(true)
end
local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	if IsDLCEnabled(CAPY_DLC) then
		MakeInventoryFloatable(inst, "idle_water", "idle")
	end
    inst.AnimState:SetBank("evilblackstone")
    inst.AnimState:SetBuild("evilblackstone")
    inst.AnimState:PlayAnimation("idle", true)
	    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("evilblackstone.tex")
	local Light = inst.entity:AddLight()
		inst.Light:SetRadius(0)
		inst.Light:SetFalloff(0)
		inst.Light:SetIntensity(0)
		inst.Light:SetColour(0,0,0)
		inst.Light:Enable(false)
		inst:AddComponent("inspectable")
		inst:AddComponent("tradable")
    inst:AddComponent("inventoryitem")  
    inst.components.inventoryitem.atlasname = "images/inventoryimages/evilblackstone.xml"
	inst:ListenForEvent("ondropped",  ondropped)
    return inst
end

return Prefab("common/inventory/evilblackstone", fn, assets) 
