local assets =
{
	Asset("ANIM", "anim/ymstone.zip"),
        Asset("ATLAS", "images/inventoryimages/ymstone.xml")
}

local function ondropped(inst)
	local Light = inst.entity:AddLight()
		inst.Light:SetRadius(.25);
		inst.Light:SetFalloff(.7);
		inst.Light:SetIntensity(.5);
		inst.Light:SetColour(255/255,0/255,255/255);
inst.Light:Enable(true)
end

local function ondeath(inst, deadthing)
    if inst and deadthing and inst.components.inventoryitem and inst:IsValid() and deadthing:IsValid() and inst.components.inventoryitem.owner == nil and not deadthing:HasTag("wall") then
            GetPlayer().components.sanity:DoDelta(-25)
            local ym = SpawnPrefab("ym")
            ym.Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")
            inst:Remove()
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	if IsDLCEnabled(CAPY_DLC) then
		MakeInventoryFloatable(inst, "idle_water", "idle")
	end
    inst.AnimState:SetBank("ymstone")
    inst.AnimState:SetBuild("ymstone")
    inst.AnimState:PlayAnimation("idle", true)
	local Light = inst.entity:AddLight()
		inst.Light:SetRadius(0)
		inst.Light:SetFalloff(0)
		inst.Light:SetIntensity(0)
		inst.Light:SetColour(0,0,0)
		inst.Light:Enable(false)
	inst:ListenForEvent("entity_death", function(world, data) ondeath(inst, data.inst) end, GetWorld())
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")  
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ymstone.xml"    
	inst:ListenForEvent("ondropped",  ondropped)
    return inst
end

return Prefab("common/inventory/ymstone", fn, assets) 
