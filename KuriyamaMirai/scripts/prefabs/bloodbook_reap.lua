local assets =
{
	Asset("ANIM", "anim/bloodbook.zip"),
        Asset("ATLAS", "images/inventoryimages/bloodbook_reap.xml")
}
local function onfinished(inst)
c_give("bloodbook")		
inst:Remove()
end
local function onread(inst, reader, target)
	if reader.components.health and reader.components.health:GetPercent() <= 1 then
        reader.components.health:DoDelta(-50)
    local pos = Vector3(inst.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 30)
    for k,v in pairs(ents) do
        if v.components.pickable and v.prefab ~= "flower" then
           v.components.pickable:Pick(GetPlayer())
        end
        if v.components.crop then
           v.components.crop:Harvest(GetPlayer())
        end
    end
		if reader.components.talker then
            reader.components.talker:Say(TUNING.BLOODBOOK_REAPSAY)
        end
		return true
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
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("bloodbook_reap.tex")
    inst.AnimState:SetBank("bloodbook")
    inst.AnimState:SetBuild("bloodbook")
    inst.AnimState:PlayAnimation("idle")
    inst:AddComponent("inspectable")
	inst:AddComponent("book")
    inst.components.book.onread = onread
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.finiteuses:SetOnFinished( onfinished )
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst:AddComponent("inventoryitem")  
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bloodbook_reap.xml"    
    return inst
end

return Prefab("common/inventory/bloodbook_reap", fn, assets) 
