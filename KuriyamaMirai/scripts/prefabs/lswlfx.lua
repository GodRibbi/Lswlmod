local assets_bloodstorm =
{
Asset("ANIM", "anim/lswl_health.zip"),
}

local assets_flashfx =
{
Asset("ANIM", "anim/flashfx.zip"),
}

local assets_lswl_health =
{
Asset("ANIM", "anim/lswl_health.zip"),
}

local assets_bloodsplatter =
{
Asset("ANIM", "anim/bloodsplatter.zip"),
}

local assets_aureole =
{
Asset("ANIM", "anim/aureole.zip"),
}

local assets_potfx =
{
Asset("ANIM", "anim/potfx.zip"),
}

local assets_healthfx =
{
Asset("ANIM", "anim/healthfx.zip"),
}

local function fn_bloodstorm()
local inst = CreateEntity()
local trans = inst.entity:AddTransform()
local anim = inst.entity:AddAnimState()

anim:SetBank("bloodstorm")
anim:SetBuild("bloodstorm")
anim:PlayAnimation("bloodstorm")
    inst:AddTag("FX")
	inst:AddTag("NOCLICK")

inst:ListenForEvent("animover", function() inst:Remove() end)

return inst
end

local function fn_bloodsplatter()
local inst = CreateEntity()
local trans = inst.entity:AddTransform()
local anim = inst.entity:AddAnimState()
    inst:AddTag("FX")
	inst:AddTag("NOCLICK")
anim:SetBank("bloodsplatter")
anim:SetBuild("bloodsplatter")
anim:PlayAnimation("bloodsplatter")

inst:ListenForEvent("animover", function() inst:Remove() end)

return inst
end

local function fn_aureole()
local inst = CreateEntity()
local trans = inst.entity:AddTransform()
local anim = inst.entity:AddAnimState()
    inst:AddTag("FX")
	inst:AddTag("NOCLICK")
anim:SetBank("aureole")
anim:SetBuild("aureole")
anim:PushAnimation("aureole", true)
trans:SetScale(3, 3, 3)

return inst
end

local function fn_healthfx()
local inst = CreateEntity()
local trans = inst.entity:AddTransform()
local anim = inst.entity:AddAnimState()
    inst:AddTag("FX")
	inst:AddTag("NOCLICK")
anim:SetBank("healthfx")
anim:SetBuild("healthfx")
anim:PushAnimation("healthfx", true)
trans:SetScale(3, 3, 3)

return inst
end

local function fn_potfx()
local inst = CreateEntity()
local trans = inst.entity:AddTransform()
local anim = inst.entity:AddAnimState()
    inst:AddTag("FX")
	inst:AddTag("NOCLICK")
anim:SetBank("potfx")
anim:SetBuild("potfx")
anim:PushAnimation("potfx", true)

return inst
end

local function fn_flashfx()
local inst = CreateEntity()
local trans = inst.entity:AddTransform()
local anim = inst.entity:AddAnimState()
    inst:AddTag("FX")
	inst:AddTag("NOCLICK")
anim:SetBank("flashfx")
anim:SetBuild("flashfx")
anim:PushAnimation("flashfx", true)
inst:ListenForEvent("animover", function() inst:Remove() end)

return inst
end

local function fn_lswl_health()
local inst = CreateEntity()
local trans = inst.entity:AddTransform()
local anim = inst.entity:AddAnimState()
    inst:AddTag("FX")
	inst:AddTag("NOCLICK")
anim:SetBank("lswl_health")
anim:SetBuild("lswl_health")
anim:PlayAnimation("lswl_health")

inst:DoTaskInTime(1, inst.Remove)

return inst
end

return Prefab( "lswl_health", fn_lswl_health, assets_lswl_health),
	Prefab( "bloodstorm", fn_bloodstorm, assets_bloodstorm),
	Prefab( "bloodsplatter", fn_bloodsplatter, assets_bloodsplatter),
	Prefab( "aureole", fn_aureole, assets_aureole),
	Prefab( "potfx", fn_potfx, assets_potfx),
	Prefab( "healthfx", fn_healthfx, assets_healthfx),
	Prefab( "flashfx", fn_flashfx, assets_flashfx)