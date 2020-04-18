local assets =
{
	Asset("ANIM", "anim/bloodbook.zip"),
        Asset("ATLAS", "images/inventoryimages/bloodbook.xml")
}
local function onread(inst, reader, target)
	if reader.components.health and reader.components.health:GetPercent() <= 1 then
        reader.components.health:DoDelta(-20)
        c_give("thecurseblood")
		if reader.components.talker then
            reader.components.talker:Say(TUNING.BLOODBOOKSAY)
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
    minimap:SetIcon("bloodbook.tex")
    inst.AnimState:SetBank("bloodbook")
    inst.AnimState:SetBuild("bloodbook")
    inst.AnimState:PlayAnimation("idle")
    inst:AddComponent("inspectable")
	inst:AddComponent("book")
    inst.components.book.onread = onread
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst:AddComponent("inventoryitem")  
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bloodbook.xml" 
    return inst
end

return Prefab("common/inventory/bloodbook", fn, assets) 
