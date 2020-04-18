local assets=
{
	Asset("ANIM", "anim/glasses.zip"),
	Asset("ANIM", "anim/swap_glasses.zip"),
}

local function onequip(inst, owner) 
		owner.AnimState:OverrideSymbol("swap_hat", "swap_glasses", "swap_hat")
		owner.AnimState:Show("HAT")
		owner.AnimState:Show("HAT_HAIR")
		owner.AnimState:Hide("HAIR_NOHAT")
		owner.AnimState:Hide("HAIR")
		
		if owner:HasTag("player") then
			owner.AnimState:Hide("HEAD")
			owner.AnimState:Show("HEAD_HAIR")
		end
end

local function onunequip(inst, owner) 
		owner.AnimState:Hide("HAT")
		owner.AnimState:Hide("HAT_HAIR")
		owner.AnimState:Show("HAIR_NOHAT")
		owner.AnimState:Show("HAIR")

		if owner:HasTag("player") then
			owner.AnimState:Show("HEAD")
			owner.AnimState:Hide("HEAD_HAIR")
		end
end

local function onperish(inst)
    inst:Remove()
end

local function fn()
local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank("glasses")
		inst.AnimState:SetBuild("glasses")
		inst.AnimState:PlayAnimation("idle",true)
	    if IsDLCEnabled(CAPY_DLC) then
		    MakeInventoryFloatable(inst, "idle_water", "idle")
	    end
		inst:AddTag("hat")

		inst:AddComponent("inspectable")
	    local minimap = inst.entity:AddMiniMapEntity()
        minimap:SetIcon("glasses.tex")
        inst:AddComponent("dapperness")
        inst.components.dapperness.dapperness = 20/60
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/glasses.xml"    
		inst:AddComponent("equippable")
		inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	    inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT
        inst.components.equippable.dapperness = 20/60

		inst.components.equippable:SetOnEquip( onequip )

		inst.components.equippable:SetOnUnequip( onunequip )

    
    return inst
end

return Prefab( "common/inventory/glasses", fn, assets) 