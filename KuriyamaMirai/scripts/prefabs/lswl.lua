local MakePlayerCharacter = require "prefabs/player_common"

local assets = {

        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wilson.fsb" ),
        Asset( "ANIM", "anim/beard.zip" ),
		Asset("SOUNDPACKAGE", "sound/lswl.fev"),
        Asset("SOUND", "sound/lswl.fsb"),

        Asset( "ANIM", "anim/lswl.zip" ),
		Asset( "ANIM", "anim/lswl_black.zip" ),
}

local prefabs = {
}

local function onattacking(inst, attacker, target)
	if  inst:HasTag("lswl_attack") and inst:HasTag("lswl_canattack") then
			inst.components.health:DoDelta(-(inst.components.exp.levelpoint*2))
            inst.components.talker:Say(TUNING.LSWLATTACKINGSAY)
			local bloodstorm = SpawnPrefab("bloodstorm")
			bloodstorm.Transform:SetPosition(inst.components.combat.target.Transform:GetWorldPosition())
			bloodstorm.AnimState:SetMultColour(255/255,0/255,0/255,1)
			bloodstorm.Transform:SetScale(3,3,3)
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
			inst.components.playercontroller:ShakeCamera(inst, "FULL", 0.5, 0.02, 1.5, 30)
            local pos = Vector3(inst.components.combat.target.Transform:GetWorldPosition())
            local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 5)
            for k,v in pairs(ents) do
                if v:HasTag("monster") or v:HasTag("animal") or v:HasTag("insect") or v.prefab == "beefalo" or v.prefab == "babybeefalo" or v.prefab == "bunnyman" or v.prefab == "pigman" or v.prefab == "pigguard"
                   or v.prefab == "merm" or v.prefab == "monkey" or v.prefab == "tallbird" or v.prefab == "walrus" or v.prefab == "little_walrus" or v.prefab == "wasphive"
                   or v.prefab == "beehive" or v.prefab == "koalefant_summer" or v.prefab == "koalefant_winter" or v.prefab == "lureplant" or v.prefab == "penguin"
                   or v.prefab == "perd" or v.prefab == "rocky" or v.prefab == "slurper" or v.prefab == "snurtle" or v.prefab == "slurtle" or v.prefab == "slurtlehole"
                   or v.prefab == "spiderden" or v.prefab == "spiderden_2" or v.prefab == "spiderden_3" or v:HasTag("pig")then
				   v.components.health:DoDelta(-(inst.components.exp.levelpoint*10))
				   local expnum=math.ceil(v.components.health:GetMaxHealth()*0.05)
		if inst.components.exp.currenttimepiont+expnum< inst.components.exp.maxtimepiont then
			inst.components.talker:Say((inst.components.exp.currenttimepiont+expnum)..'/'..(inst.components.exp.maxtimepiont))
		end
		inst.components.exp:DoDelta(expnum)
				local blood = SpawnPrefab("splash")
                blood.Transform:SetPosition(v.Transform:GetWorldPosition())
                blood.AnimState:SetMultColour(255/255,0/255,0/255,1)
                blood.Transform:SetScale(2, 2, 2)
                end
				end
				inst:RemoveTag("lswl_attack")
				inst:RemoveTag("lswl_canattack")
				inst.type = 1
				end
if inst:HasTag("lswl_black") then
    local blood = SpawnPrefab("bloodsplatter")
    blood.Transform:SetPosition(inst.components.combat.target.Transform:GetWorldPosition())
    blood.AnimState:SetMultColour(255/255,0/255,0/255,1)
	blood.Transform:SetScale(2, 2, 2)
end
end
			
local function attacking(inst)
	if inst:HasTag("lswl_canattack") then
		inst:AddTag("lswl_attack")
		inst.components.talker:Say(TUNING.LSWLBEGANFIGHTINGSAY)
		inst.SoundEmitter:PlaySound("lswl/bgm/fight")
	elseif not inst:HasTag("lswl_canattack") then 
		inst.components.talker:Say(TUNING.LSWLFINISHFIGHTINGSAY)
end
end

local function noattacking(inst)
	inst:RemoveTag("lswl_attack")
	inst.components.talker:Say(TUNING.LSWLCANCELFIGHTINGSAY)
end

local function isholdingbloodsickle(inst)
	local inventory = inst.components.inventory
	for k,v in pairs(inventory.equipslots) do
        if v.prefab == "bloodbat" then
            return true
        end
    end
end

local function onworked(inst, data)
	local action = data.target.components.workable.action
	if isholdingbloodsickle(inst) and data.target and data.target.components.workable then
		inst.components.health:DoDelta(-2)
	end		
end

local start_inv = {
	"sealring",
	"bloodbook",
	"glasses",
}


local function healthon(inst)
	local hunger_percent = inst.components.hunger:GetPercent()
	if hunger_percent < 0.1 then
		inst.components.talker:Say(TUNING.LSWLHUNGERHEALTHSAY)
		return
	end
        inst.components.talker:Say(TUNING.LSWLBEGANHEATHSAY)
		inst.components.locomotor.walkspeed = 2
	    inst.components.locomotor.runspeed = 3
	    inst.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE * 10 *((inst.components.exp.levelpoint * 0.04) + 1)
        inst.components.health:StartRegen(1 *((inst.components.exp.levelpoint * 0.04) + 1), 1)
        inst:AddTag("lswl_health")
        inst:RemoveTag("lswl")
		inst.healthfx = SpawnPrefab("healthfx")
		inst.healthfx.entity:SetParent(inst.entity)
		inst.healthfx.Transform:SetPosition(0, 0.5, 0)
		inst.healthfx.Transform:SetScale(4, 4, 4)
		inst.healthfx.AnimState:PushAnimation("healthfx", true)

end

local function healthoff(inst)
        inst.components.talker:Say(TUNING.LSWLFINISHHEALTHSAY)     
	    inst.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE * 2
        inst.components.health:StartRegen(1, 5)
		inst.components.locomotor.walkspeed = 4
	    inst.components.locomotor.runspeed = 6
        inst:AddTag("lswl")
        inst:RemoveTag("lswl_health")
		if inst.healthfx then inst.healthfx:Remove() inst.healthfx = nil end
end

local function blackon(inst, data)
	local health_percent = inst.components.health:GetPercent()
	if health_percent < 0.3 then
		inst.components.talker:Say(TUNING.LSWLCANCELBLACKSAY)
		return
	end
	    inst.type = 2
	    inst.components.health:DoDelta(-100)
		inst.components.talker:Say(TUNING.LSWLUNHAPPYSAY)
		--inst.SoundEmitter:KillSound()
		inst.SoundEmitter:PlaySound("lswl/bgm/unhappy")
        inst.SoundEmitter:PlaySound("lswl/bgm/blackbgm","blackmusic")
	    inst.components.sanity.night_drain_mult = 0
	    inst.components.sanity.neg_aura_mult = 0
        inst.components.health:StartRegen(-2, 1)
		inst.components.locomotor.walkspeed = (4 * (1 + inst.components.exp.levelpoint / 100))
	    inst.components.locomotor.runspeed = (6 * (1 + inst.components.exp.levelpoint / 100))
		inst.components.combat:AddDamageModifier("lswl", inst.components.exp.levelpoint / 100)
		--inst.components.combat.damagemultiplier = (1 + inst.components.exp.levelpoint / 100)
		local Light = inst.entity:AddLight()
		inst.Light:SetRadius(1.1)
		inst.Light:SetFalloff(0.7)
		inst.Light:SetIntensity(0.5)
		inst.Light:SetColour(255/255,20/255,20/255)
		inst.Light:Enable(true)
		inst.aureole = SpawnPrefab("aureole")
		inst.aureole.entity:SetParent(inst.entity)
		inst.aureole.Transform:SetPosition(0, 1.2, 0)
		inst.aureole.AnimState:SetMultColour(255/255,0/255,0/255,1)
		inst.aureole.AnimState:PushAnimation("aureole", true)
        inst:AddTag("lswl_black")
		inst:AddTag("lswl_canattack")
        inst:RemoveTag("lswl")
		inst.AnimState:SetBuild("lswl_black")
end

local function blackoff(inst, data)
	    inst.type = 0
	    inst.components.sanity:DoDelta(-50)
        inst.components.talker:Say(TUNING.LSWLFINISHBLACKSAY)
        inst.SoundEmitter:KillSound("blackmusic")
	    inst.components.sanity.night_drain_mult = 2
	    inst.components.sanity.neg_aura_mult = 2
        inst.components.health:StartRegen(1, 5)
		inst.components.locomotor.walkspeed = 4
		inst.components.locomotor.runspeed = 6
		inst.components.combat:AddDamageModifier("lswl", 0)
		--inst.components.combat.damagemultiplier = 1
		local Light = inst.entity:AddLight()
		inst.Light:SetRadius(0)
		inst.Light:SetFalloff(0)
		inst.Light:SetIntensity(0)
		inst.Light:SetColour(0,0,0)
		inst.Light:Enable(false)
		if inst.aureole then inst.aureole:Remove() inst.aureole = nil end
        inst:AddTag("lswl")
		inst:RemoveTag("lswl_canattack")
        inst:RemoveTag("lswl_black")
		inst.AnimState:SetBuild("lswl")
end






local function onkill(inst, data)
	local v = data.victim
	if v:HasTag("monster") or v:HasTag("animal") or v:HasTag("insect") or v.prefab == "beefalo" or v.prefab == "babybeefalo" or v.prefab == "bunnyman" or v.prefab == "pigman" or v.prefab == "pigguard"
	or v.prefab == "merm" or v.prefab == "monkey" or v.prefab == "tallbird" or v.prefab == "walrus" or v.prefab == "little_walrus" or v.prefab == "wasphive"
	or v.prefab == "beehive" or v.prefab == "koalefant_summer" or v.prefab == "koalefant_winter" or v.prefab == "lureplant" or v.prefab == "penguin"
	or v.prefab == "perd" or v.prefab == "rocky" or v.prefab == "slurper" or v.prefab == "snurtle" or v.prefab == "slurtle" or v.prefab == "slurtlehole"
	or v.prefab == "spiderden" or v.prefab == "spiderden_2" or v.prefab == "spiderden_3" or v:HasTag("pig")then
		local expnum=math.ceil(v.components.health:GetMaxHealth()*0.05)
		if inst.components.exp.currenttimepiont+expnum< inst.components.exp.maxtimepiont then
			inst.components.talker:Say((inst.components.exp.currenttimepiont+expnum)..'/'..(inst.components.exp.maxtimepiont))
		end
		inst.components.exp:DoDelta(expnum)
	end
    -- if victim:HasTag("epic") and not victim:HasTag("tree") and not victim:HasTag("spiderqueen") then
		
	-- 	if inst.components.exp.currenttimepiont+180< inst.components.exp.maxtimepiont then
	-- 		inst.components.talker:Say((inst.components.exp.currenttimepiont+180)..'/'..(inst.components.exp.maxtimepiont))
	-- 	end
	-- 	inst.components.exp:DoDelta(180)
    -- elseif victim:HasTag("spiderqueen") or victim:HasTag("tree") then
		
	-- 	if inst.components.exp.currenttimepiont+60< inst.components.exp.maxtimepiont then
	-- 		inst.components.talker:Say((inst.components.exp.currenttimepiont+60)..'/'..(inst.components.exp.maxtimepiont))
	-- 	end
	-- 	inst.components.exp:DoDelta(60)
    -- elseif victim:HasTag("warg") then
		
	-- 	if inst.components.exp.currenttimepiont+40< inst.components.exp.maxtimepiont then
	-- 		inst.components.talker:Say((inst.components.exp.currenttimepiont+40)..'/'..(inst.components.exp.maxtimepiont))
	-- 	end
	-- 	inst.components.exp:DoDelta(40)
    -- elseif victim:HasTag("chess") then
		
	-- 	if inst.components.exp.currenttimepiont+14< inst.components.exp.maxtimepiont then
	-- 		inst.components.talker:Say((inst.components.exp.currenttimepiont+14)..'/'..(inst.components.exp.maxtimepiont))
	-- 	end
	-- 	inst.components.exp:DoDelta(14)
    -- elseif victim:HasTag("merm") or victim.prefab == "worm" or victim.prefab == "tentacle" then
		
	-- 	if inst.components.exp.currenttimepiont+20< inst.components.exp.maxtimepiont then
	-- 		inst.components.talker:Say((inst.components.exp.currenttimepiont+20)..'/'..(inst.components.exp.maxtimepiont))
	-- 	end
	-- 	inst.components.exp:DoDelta(20)
    -- elseif victim:HasTag("warlus") or victim:HasTag("mossling") or victim:HasTag("guard") or victim.prefab == "krampus" or victim:HasTag("tallbird") or victim:HasTag("dragoon") then
		
	-- 	if inst.components.exp.currenttimepiont+10< inst.components.exp.maxtimepiont then
	-- 		inst.components.talker:Say((inst.components.exp.currenttimepiont+10)..'/'..(inst.components.exp.maxtimepiont))
	-- 	end
	-- 	inst.components.exp:DoDelta(10)
    -- elseif victim:HasTag("spider") or victim:HasTag("hound") or victim:HasTag("snake") or victim:HasTag("sharx") then
		
	-- 	if inst.components.exp.currenttimepiont+6< inst.components.exp.maxtimepiont then
	-- 		inst.components.talker:Say((inst.components.exp.currenttimepiont+6)..'/'..(inst.components.exp.maxtimepiont))
	-- 	end
	-- 	inst.components.exp:DoDelta(6)
	-- elseif victim:HasTag("frog") or victim:HasTag("bat") or victim:HasTag("flup") then
	-- 	if inst.components.exp.currenttimepiont+2< inst.components.exp.maxtimepiont then
	-- 		inst.components.talker:Say((inst.components.exp.currenttimepiont+2)..'/'..(inst.components.exp.maxtimepiont))
	-- 	end
	-- 	inst.components.exp:DoDelta(2)
	if v:HasTag("shadow") then
		inst:DoTaskInTime(0,function(inst)
			if v.prefab == "terrorbeak" then
				inst.components.sanity:DoDelta(-33)
			else
				inst.components.sanity:DoDelta(-15)
			end
			end)
    end
end



local function onsave(inst, data)
    data.hunger_percent = inst.components.hunger:GetPercent()
    data.health_percent = inst.components.health:GetPercent()
	data.sanity_percent = inst.components.sanity:GetPercent()
	data.type = inst.type
end
local function types(inst)
    if inst.type == 2 then
	    blackon(inst)
	end
	if inst.type == 1 then
		blackon(inst)
		inst:RemoveTag("lswl_canattack")
	end
end

local function onload(inst, data)
    if data and data.hunger_percent and data.health_percent and data.sanity_percent and data.type then
        inst.components.hunger:SetPercent(data.hunger_percent)
        inst.components.health:SetPercent(data.health_percent)
		inst.components.sanity:SetPercent(data.sanity_percent)
		inst.type = data.type
		types(inst)
    end
end

local function lswlStats(inst)
	if (GetClock():IsNight() and (GetClock():GetMoonPhase() == "full")) and not GetWorld():IsCave() then
		if inst:HasTag("lswl_black") then 
	    inst.type = 0
        inst.components.health:StartRegen(1, 5)
        inst:AddTag("lswl")
		inst:RemoveTag("lswl_canattack")
        inst:RemoveTag("lswl_black")
		elseif inst:HasTag("lswl_health") then 
			healthoff(inst)
		end
	    inst:AddTag("lswl_moonfull")
		inst.components.talker:Say(TUNING.LSWLJJDBF)
		inst.components.sanity:DoDelta(-50)
	    inst.components.sanity.night_drain_mult = 100
	    inst.components.sanity.neg_aura_mult = 100
		inst.components.locomotor.walkspeed = 12
		inst.components.locomotor.runspeed = 18
		inst.components.combat:AddDamageModifier("lswl", 2)
		--inst.components.combat.damagemultiplier = 3
        inst:RemoveTag("lswl")
		inst.AnimState:SetBuild("lswl_black")
		local Light = inst.entity:AddLight()
		inst.Light:SetRadius(25);
		inst.Light:SetFalloff(.7);
		inst.Light:SetIntensity(.7);
		inst.Light:SetColour(255/255,20/255,20/255);
		inst.Light:Enable(true)
		inst.aureole = SpawnPrefab("aureole")
		inst.aureole.entity:SetParent(inst.entity)
		inst.aureole.Transform:SetPosition(0, 1.2, 0)
		inst.aureole.AnimState:SetMultColour(255/255,0/255,0/255,1)
		inst.aureole.AnimState:PushAnimation("aureole", true)
	if math.random()< .1 and inst.components.exp.levelpoint >= 100 then 
		inst:AddTag("lswl_evil")
		--inst.SoundEmitter:KillSound()
		inst.SoundEmitter:PlaySound("lswl/bgm/moonbgm","moonmusic")
		local ground = GetWorld()
		local player = GetPlayer()
		local pt0 = inst:GetPosition()
 	    local x = pt0.x+(math.random(100)-math.random(100))
 	    local z = pt0.z+(math.random(100)-math.random(100))
		local deerclopsblack = SpawnPrefab("deerclopsblack")
 	    deerclopsblack.Transform:SetPosition(x,0,z)
		deerclopsblack.components.combat.target = player
		GetPlayer().components.playercontroller:ShakeCamera(inst, "FULL", 0.5, 0.02, 2, 40)
	elseif inst.components.exp.levelpoint <= 100 then
		--inst.SoundEmitter:KillSound()
		inst.SoundEmitter:PlaySound("lswl/bgm/moonbgm","moonmusic")
		inst.full= inst:DoPeriodicTask(5,function ()
		local names = {"crawlinghorror","terrorbeak"}
   	    local gw = names[math.random(#names)]
		local gx = math.floor(inst.components.exp.levelpoint/25) + 1
		local player = GetPlayer()
    	local pt = Vector3(player.Transform:GetWorldPosition())
    	local nummerms = math.random(gx)
    	local ground = GetWorld()
        for k = 1, nummerms do
            local theta = 1 * 2 * PI
            local radius = 12
            local result_offset = FindValidPositionByFan(theta, radius, nummerms, function(offset)
                local x,y,z = (pt + offset):Get()
                local ents = TheSim:FindEntities(x,y,z , 1)
                return not next(ents) 
            end)
            if result_offset and ground.Map:GetTileAtPoint((pt + result_offset):Get()) ~= GROUND.IMPASSABLE then
                local shadow = SpawnPrefab(gw)
                shadow.Transform:SetPosition((pt + result_offset):Get())
                shadow.components.combat.target = player
				shadow:AddComponent("lootdropper")
                shadow.components.lootdropper:SetLoot({"ymquintessence"})
                GetPlayer().components.playercontroller:ShakeCamera(inst, "FULL", 0.2, 0.02, .25, 40)
                local fx = SpawnPrefab("collapse_small")
                local pos = pt + result_offset
                fx.Transform:SetPosition(pos.x, pos.y, pos.z)
            end
        end
    end)
	end
	else 
	    if inst:HasTag("lswl_moonfull") then 
			inst:RemoveTag("lswl_moonfull")
			inst.SoundEmitter:KillSound("moonmusic")
			inst.components.talker:Say(TUNING.LSWLENDSAY)
			inst.components.sanity:DoDelta(50)
	    	inst.components.sanity.night_drain_mult = 2
	   		inst.components.sanity.neg_aura_mult = 2
			inst.components.locomotor.walkspeed = 4
	    	inst.components.locomotor.runspeed = 6
			inst.components.combat:AddDamageModifier("lswl", 0)
        	inst:AddTag("lswl")
			inst.AnimState:SetBuild("lswl")
			local Light = inst.entity:AddLight()
			inst.Light:SetRadius(0)
			inst.Light:SetFalloff(0)
			inst.Light:SetIntensity(0)
			inst.Light:SetColour(0,0,0)
			inst.Light:Enable(false)
			if inst.aureole then 
				inst.aureole:Remove() 
				inst.aureole = nil 
			end
			if not inst:HasTag("lswl_evil") and inst.full ~= nil then
				inst.full:Cancel() 
				inst.full = nil 
			elseif inst.HasTag("lswl_evil") then
		inst:RemoveTag("lswl_evil")
		inst.SoundEmitter:KillSound("moonmusic")
		local po = Vector3(inst.Transform:GetWorldPosition())
        local ent = TheSim:FindEntities(po.x,po.y,po.z, 1000)
        for k,v in pairs(ent) do
                if v:HasTag("shadowcreature") then
                   v:Remove()
        end
		end
		local po = Vector3(inst.Transform:GetWorldPosition())
        local ent = TheSim:FindEntities(po.x,po.y,po.z, 1000)
        for k,v in pairs(ent) do
                if v:HasTag("deerclopsblack") then
				    v.components.locomotor:Stop()
                    v.AnimState:PlayAnimation("taunt")
                    v:DoTaskInTime(2, function() 
					v:Remove()
				end)
        end
		end
		end
		local po = Vector3(inst.Transform:GetWorldPosition())
        local ent = TheSim:FindEntities(po.x,po.y,po.z, 1000)
        for k,v in pairs(ent) do
                if v:HasTag("shadowcreature") then
                   v:Remove()
        end
		end
		elseif inst:HasTag("lswl_evil") and not inst:HasTag("lswl_moonfull") then
		inst:RemoveTag("lswl_evil")
		inst.SoundEmitter:KillSound("blackmusic")
		local po = Vector3(inst.Transform:GetWorldPosition())
        local ent = TheSim:FindEntities(po.x,po.y,po.z, 1000)
        for k,v in pairs(ent) do
                if v:HasTag("shadowcreature") then
                   v:Remove()
        end
		end
		local po = Vector3(inst.Transform:GetWorldPosition())
        local ent = TheSim:FindEntities(po.x,po.y,po.z, 1000)
        for k,v in pairs(ent) do
                if v:HasTag("deerclopsblack") then
				    v.components.locomotor:Stop()
                    v.AnimState:PlayAnimation("taunt")
                    v:DoTaskInTime(1.5, function() 
					v:Remove()
				end)
        end
		end
		end
	end
end

local function onupdate(inst)
    local level = inst.components.exp.levelpoint
    inst.components.health:SetMaxHealth(200 + level * (500 - 200) / inst.components.exp.maxlevel)
    inst.components.hunger:SetMax(150 + level * (350 - 150) / inst.components.exp.maxlevel)
	inst.components.exp.maxtimepiont = level * 5 + 100
	if inst.components.exp.levelpoint >= 10 then
		local bloodsword = Recipe("bloodsword", {Ingredient("sealring", 1,"images/inventoryimages/sealring.xml"),Ingredient("thecurseblood", 2,"images/inventoryimages/thecurseblood.xml"),}, RECIPETABS.BLOODTAB, TECH.SCIENCE_ONE)
		bloodsword.atlas = "images/inventoryimages/bloodsword.xml"
		local bloodbook_reap = Recipe("bloodbook_reap", {Ingredient("bloodbook", 1,"images/inventoryimages/bloodbook.xml"),Ingredient("thecurseblood", 2,"images/inventoryimages/thecurseblood.xml"),Ingredient("papyrus", 2),}, RECIPETABS.BLOODTAB, TECH.MAGIC_TWO)
		bloodbook_reap.atlas = "images/inventoryimages/bloodbook_reap.xml"
end
	if inst.components.exp.levelpoint >= 25 then
		local czyw = Recipe("czyw", {Ingredient("spidergland", 4),Ingredient("berries_cooked", 1),}, RECIPETABS.BLOODTAB, TECH.SCIENCE_ONE)
		czyw.atlas = "images/inventoryimages/czyw.xml"
		local bloodblowdart = Recipe("bloodblowdart", {Ingredient("sealring", 1,"images/inventoryimages/sealring.xml"),Ingredient("thecurseblood", 2,"images/inventoryimages/thecurseblood.xml"),}, RECIPETABS.BLOODTAB,TECH.SCIENCE_TWO)
		bloodblowdart.atlas = "images/inventoryimages/bloodblowdart.xml"
end
	if inst.components.exp.levelpoint >= 50 then
		local lifestone = Recipe("lifestone", {Ingredient("rocks", 2),Ingredient("livinglog", 2),Ingredient("thecurseblood", 2,"images/inventoryimages/thecurseblood.xml"),}, RECIPETABS.BLOODTAB, TECH.MAGIC_THREE,nil,nil,nil,2)
		lifestone.atlas = "images/inventoryimages/lifestone.xml"
		local bloodicebox = Recipe("bloodicebox", {Ingredient("gears", 10),Ingredient("bluegem", 10),Ingredient("thecurseblood", 20,"images/inventoryimages/thecurseblood.xml"),}, RECIPETABS.BLOODTAB, TECH.SCIENCE_TWO, "icebox_placer")
		bloodicebox.atlas = "images/inventoryimages/bloodicebox.xml"
end
	if inst.components.exp.levelpoint >= 75 then
	local bluegem = Recipe("bluegem", {Ingredient("ice", 4),Ingredient("thecurseblood", 5,"images/inventoryimages/thecurseblood.xml"),}, RECIPETABS.BLOODTAB, TECH.MAGIC_THREE)
	local redgem = Recipe("redgem", {Ingredient("charcoal", 2),Ingredient("thecurseblood", 5,"images/inventoryimages/thecurseblood.xml"),}, RECIPETABS.BLOODTAB, TECH.MAGIC_THREE)
end
	if inst.components.exp.levelpoint >= 100 then
		--local bloodbook_summon = Recipe("bloodbook_summon", {Ingredient("bloodbook", 1,"images/inventoryimages/bloodbook.xml"),Ingredient("thecurseblood", 50,"images/inventoryimages/thecurseblood.xml"),Ingredient("papyrus", 2),}, RECIPETABS.BLOODTAB, TECH.MAGIC_TWO)
	   -- bloodbook_summon.atlas = "images/inventoryimages/bloodbook_summon.xml"
		local ymstone = Recipe("ymstone", {Ingredient("ymquintessence", 10,"images/inventoryimages/ymquintessence.xml"),Ingredient("thecurseblood", 10,"images/inventoryimages/thecurseblood.xml"),Ingredient("purplegem", 5),}, RECIPETABS.BLOODTAB, TECH.MAGIC_TWO)
		ymstone.atlas = "images/inventoryimages/ymstone.xml"
		if SaveGameIndex:IsModeShipwrecked() then
			local bloodblacksword = Recipe("bloodblacksword", {Ingredient("bloodsword", 1,"images/inventoryimages/bloodsword.xml"),Ingredient("thecurseblood", 100,"images/inventoryimages/thecurseblood.xml"),Ingredient("evilblackstone", 10,"images/inventoryimages/evilblackstone.xml")}, RECIPETABS.BLOODTAB,TECH.OBSIDIAN_TWO)
			bloodblacksword.atlas = "images/inventoryimages/bloodblacksword.xml"			
		else
			local bloodblacksword = Recipe("bloodblacksword", {Ingredient("bloodsword", 1,"images/inventoryimages/bloodsword.xml"),Ingredient("thecurseblood", 100,"images/inventoryimages/thecurseblood.xml"),Ingredient("evilblackstone", 10,"images/inventoryimages/evilblackstone.xml")}, RECIPETABS.BLOODTAB, TECH.ANCIENT_FOUR)
			bloodblacksword.atlas = "images/inventoryimages/bloodblacksword.xml"
		end
end
end

local function checktag(inst)
	local hunger_percent=inst.components.hunger:GetPercent()
	local health_percent=inst.components.health:GetPercent()
	if hunger_percent<=0.1 and inst:HasTag("lswl_health") then
		healthoff(inst)
	elseif health_percent<=0.1 and inst:HasTag("lswl_black") then
		blackoff(inst)
	end
end
local function levelupmax(inst)
	if math.random()< .05 or inst.levelupmaxsay==1 then 
		inst.components.talker:Say("前辈终于轮到我来保护你啦，可是你在哪啊")
		inst.levelupmaxsay = 0
	end
end

local function levelup(inst)
	inst.levelupmaxsay=1
	inst.components.talker:Say(TUNING.LSWLLEVELSAY.. (inst.components.exp.levelpoint))
end
local function GoInsane(inst)
	if inst.components.sanity:IsCrazy() then
		if inst.components.sanitymonsterspawner then
			inst.components.sanitymonsterspawner:UpdateMonsters(20)
			inst.components.sanitymonsterspawner:UpdateMonsters(20)
			inst.components.sanitymonsterspawner:UpdateMonsters(20)
			inst.components.sanitymonsterspawner:UpdateMonsters(20)
		end
	end
	
end

local fn = function(inst)
	inst.soundsname = "willow"
	inst:AddComponent("exp")
	inst.MiniMapEntity:SetIcon( "lswl.tex" )
	inst.components.exp:SetUpdateFn(onupdate)
	inst:DoTaskInTime(0,function(inst)
		inst.components.exp:ApplyUpgrades()
		end)
	inst.AnimState:SetBuild("lswl")
	inst.type = 0
	inst.levelupmaxsay = 0
	inst.OnSave = onsave
    inst.OnLoad = onload
	inst.components.sanity:SetMax(50)
	inst.components.health:StartRegen(1, 5)
    inst.components.combat.damagemultiplier = 1
	inst.components.hunger.hungerrate = 2 * TUNING.WILSON_HUNGER_RATE
	inst.components.sanity.night_drain_mult = 2
	inst.components.sanity.neg_aura_mult = 2
	
	inst.components.locomotor.walkspeed = 4
	inst.components.locomotor.runspeed = 6
    inst:AddTag("lswl")
	inst:AddComponent("eater")
	inst.components.eater.EatMEAT = inst.components.eater.Eat
	function inst.components.eater:Eat( food )
		if self:CanEat(food) then
			if food.components.edible.foodtype == "MEAT" then
				local expfood = math.ceil(food.components.edible.hungervalue*0.05 + food.components.edible.healthvalue*0.25)
				if inst.components.exp.currenttimepiont+expfood< inst.components.exp.maxtimepiont then
					inst.components.talker:Say((inst.components.exp.currenttimepiont+expfood)..'/'..(inst.components.exp.maxtimepiont))
				end
				inst.components.exp:DoDelta(expfood)
			end
			if food.prefab == "monstermeat" then
			        food.components.edible.hungervalue = 28.125
					food.components.edible.healthvalue = -20
					food.components.edible.sanityvalue = -7.5
			elseif food.prefab == "cookedmonstermeat" then
			        food.components.edible.hungervalue = 28.125
					food.components.edible.healthvalue = -3
					food.components.edible.sanityvalue = -5
			elseif food.prefab == "monstermeat_dried" then
			        food.components.edible.hungervalue = 28.125
					food.components.edible.healthvalue = -3
					food.components.edible.sanityvalue = -2.5
			elseif food.prefab == "monsterlasagna" then
					food.components.edible.healthvalue = -20
					food.components.edible.sanityvalue = -10
			elseif food.prefab == "meat" then
			        food.components.edible.hungervalue = 25*1.5
					food.components.edible.sanityvalue = -5
			elseif food.prefab == "cookedmeat" then
			        food.components.edible.hungervalue = 25*1.5
			elseif food.prefab == "meat_dried" then
			        food.components.edible.hungervalue = 25*1.5
					food.components.edible.sanityvalue = 7.5
			elseif food.prefab == "drumstick" then
			        food.components.edible.hungervalue = 12.5*1.5
					food.components.edible.sanityvalue = -5
			elseif food.prefab == "drumstick_cooked" then
			        food.components.edible.hungervalue = 12.5*1.5
			elseif food.prefab == "plantmeat" then
			        food.components.edible.hungervalue = 12.5*1.5
					food.components.edible.sanityvalue = -5
			elseif food.prefab == "plantmeat_cooked" then
			        food.components.edible.hungervalue = 18.75*1.5
			elseif food.prefab == "cookedsmallmeat" then
			        food.components.edible.hungervalue = 12.5*1.5
			elseif food.prefab == "smallmeat_dried" then
			        food.components.edible.hungervalue = 12.5*1.5
					food.components.edible.sanityvalue = 5
			elseif food.prefab == "fish" then
			        food.components.edible.hungervalue = 12.5*1.5
			elseif food.prefab == "fish_cooked" then
			        food.components.edible.hungervalue = 12.5*1.5
			elseif food.prefab == "froglegs" then
			        food.components.edible.hungervalue = 12.5*1.5
					food.components.edible.sanityvalue = -5
			elseif food.prefab == "froglegs_cooked" then
			        food.components.edible.hungervalue = 12.5*1.5
			elseif food.prefab == "batwing" then
			        food.components.edible.hungervalue = 12.5*1.5
					food.components.edible.sanityvalue = -5
			elseif food.prefab == "batwing_cooked" then
			        food.components.edible.hungervalue = 18.75*1.5
			elseif food.prefab == "tallbirdegg" then
			        food.components.edible.hungervalue = 25*1.5
			elseif food.prefab == "tallbirdegg_cracked" then
			        food.components.edible.hungervalue = 25*1.5
			elseif food.prefab == "tallbirdegg_cooked" then
			        food.components.edible.hungervalue = 37.5*1.5
			elseif food.prefab == "bird_egg" then
			        food.components.edible.hungervalue = 9.375*1.5
			elseif food.prefab == "bird_egg_cooked" then
			        food.components.edible.hungervalue = 12.5*1.5
			elseif food.prefab == "trunk_cooked" then
			        food.components.edible.hungervalue = 75*1.5
			elseif food.prefab == "trunk_winter" then
			        food.components.edible.hungervalue = 37.5*1.5
			elseif food.prefab == "trunk_summer" then
			        food.components.edible.hungervalue = 37.5*1.5
			elseif food.prefab == "blue_cap_cooked" then
					food.components.edible.sanityvalue = 1
			elseif food.prefab == "green_cap_cooked" then
					food.components.edible.sanityvalue = 1.5
			elseif food.prefab == "watermelon" then
					food.components.edible.sanityvalue = 0.5
			elseif food.prefab == "watermelon_cooked" then
					food.components.edible.sanityvalue = 0.75
			elseif food.prefab == "cactus_meat_cooked" then
					food.components.edible.sanityvalue = 1.5
			elseif food.prefab == "cactus_flower" then
					food.components.edible.sanityvalue = 0.5
			elseif food.prefab == "goatmilk" then
					food.components.edible.sanityvalue = 1
			elseif food.prefab == "butterflymuffin" then
					food.components.edible.sanityvalue = 0.5
			elseif food.prefab == "frogglebunwich" then
			        food.components.edible.hungervalue = 37.5*1.5
					food.components.edible.sanityvalue = 2.5
			elseif food.prefab == "honeyham" then
			        food.components.edible.hungervalue = 75*1.5
					food.components.edible.sanityvalue = 2.5
			elseif food.prefab == "dragonpie" then
					food.components.edible.sanityvalue = 0.5
			elseif food.prefab == "taffy" then
					food.components.edible.sanityvalue = 1.5
		    elseif food.prefab == "pumpkincookie" then
					food.components.edible.sanityvalue = 1.5
			elseif food.prefab == "kabobs" then
			        food.components.edible.hungervalue = 37.5*1.5
					food.components.edible.sanityvalue = 2.5
			elseif food.prefab == "mandrakesoup" then
					food.components.edible.sanityvalue = 0.5
			elseif food.prefab == "baconeggs" then
			        food.components.edible.hungervalue = 75*1.5
					food.components.edible.sanityvalue = 2.5
			elseif food.prefab == "bonestew" then
			        food.components.edible.hungervalue = 150*1.5
					food.components.edible.sanityvalue = 2.5
			elseif food.prefab == "perogies" then
			        food.components.edible.hungervalue = 37.5*1.5
					food.components.edible.sanityvalue = 2.5
			elseif food.prefab == "ratatouille" then
					food.components.edible.sanityvalue = 0.5
			elseif food.prefab == "fruitmedley" then
					food.components.edible.sanityvalue = 0.5
			elseif food.prefab == "fishtacos" then
			        food.components.edible.hungervalue = 37.5*1.5
					food.components.edible.sanityvalue = 2.5
			elseif food.prefab == "waffles" then
			        food.components.edible.hungervalue = 37.5*1.5
					food.components.edible.sanityvalue = 2.5
			elseif food.prefab == "turkeydinner" then
			        food.components.edible.hungervalue = 75*1.5
					food.components.edible.sanityvalue = 2.5
			elseif food.prefab == "fishsticks" then
			        food.components.edible.hungervalue = 37.5*1.5
					food.components.edible.sanityvalue = 2.5
			elseif food.prefab == "stuffedeggplant" then
					food.components.edible.sanityvalue = 0.5
			elseif food.prefab == "honeynuggets" then
			        food.components.edible.hungervalue = 37.5*1.5
					food.components.edible.sanityvalue = 2.5
			elseif food.prefab == "meatballs" then
			        food.components.edible.hungervalue = 62.5*1.5
					food.components.edible.sanityvalue = 2.5
			elseif food.prefab == "jammypreserves" then
					food.components.edible.sanityvalue = 0.5
			elseif food.prefab == "unagi" then
			        food.components.edible.hungervalue = 18.75*1.5
					food.components.edible.sanityvalue = 2.5
			elseif food.prefab == "flowersalad" then
					food.components.edible.sanityvalue = 0.5
			elseif food.prefab == "icecream" then
					food.components.edible.sanityvalue = 25
			elseif food.prefab == "watermelonicle" then
					food.components.edible.sanityvalue = 2
			elseif food.prefab == "trailmix" then
					food.components.edible.sanityvalue = 0.5
			elseif food.prefab == "hotchili" then
			        food.components.edible.hungervalue = 37.5*1.5
			elseif food.prefab == "guacamole" then
			        food.components.edible.hungervalue = 37.5*1.5
					food.components.edible.sanityvalue = 5
			elseif food.prefab == "doydoyegg" then
			        food.components.edible.hungervalue = 25*1.5
			elseif food.prefab == "doydoyegg_cooked" then
			        food.components.edible.hungervalue = 37.5*1.5
			elseif food.prefab == "fish_med" then
			        food.components.edible.hungervalue = 25*1.5
			elseif food.prefab == "blubber" then
			        food.components.edible.hungervalue = 10*1.5
			elseif food.prefab == "fish_raw_small_cooked" then
			        food.components.edible.hungervalue = 12.5*1.5
			elseif food.prefab == "fish_raw_small" then
			        food.components.edible.hungervalue = 12.5*1.5
			elseif food.prefab == "fish_raw" then
			        food.components.edible.hungervalue = 25*1.5
			elseif food.prefab == "fish_med_cooked" then
			        food.components.edible.hungervalue = 25*1.5
			elseif food.prefab == "limpets_cooked" then
			        food.components.edible.hungervalue = 12.5*1.5
			elseif food.prefab == "limpets" then
			        food.components.edible.hungervalue = 12.5*1.5
					food.components.edible.sanityvalue = -5
			elseif food.prefab == "mussel_cooked" then
			        food.components.edible.hungervalue = 12.5*1.5
			elseif food.prefab == "mussel" then
			        food.components.edible.hungervalue = 12.5*1.5
					food.components.edible.sanityvalue = -5
			elseif food.prefab == "Jellyfish_dead" then
			        food.components.edible.hungervalue = 10*1.5
			elseif food.prefab == "Jellyfish_cooked" then
			        food.components.edible.hungervalue = 18.75*1.5
			elseif food.prefab == "jellyjerky" then
			        food.components.edible.hungervalue = 18.75*1.5
			elseif food.prefab == "shark_fin" then
			        food.components.edible.hungervalue = 25*1.5
					food.components.edible.sanityvalue = -7.5
			elseif food.prefab == "tropical_fish" then
			        food.components.edible.hungervalue = 12.5*1.5
			elseif food.prefab == "Lobster_dead" then
			        food.components.edible.hungervalue = 12.5*1.5
			elseif food.prefab == "Lobster_dead_cooked" then
			        food.components.edible.hungervalue = 12.5*1.5
			elseif food.prefab == "coral_brain" then
					food.components.edible.sanityvalue = 25
			elseif food.prefab == "bananapop" then
					food.components.edible.sanityvalue = 3.3
			elseif food.prefab == "sharkfinsoup" then
			        food.components.edible.hungervalue = 12.5*1.5
					food.components.edible.sanityvalue = -5
			elseif food.prefab == "californiaroll" then
			        food.components.edible.hungervalue = 25*1.5
					food.components.edible.sanityvalue = 5
			elseif food.prefab == "seafoodgumbo" then
			        food.components.edible.hungervalue = 37.5*1.5
					food.components.edible.sanityvalue = 10
			elseif food.prefab == "bisque" then
			        food.components.edible.hungervalue = 18.75*1.5
					food.components.edible.sanityvalue = 2.5
			elseif food.prefab == "ceviche" then
			        food.components.edible.hungervalue = 25*1.5
					food.components.edible.sanityvalue = 2.5
			elseif food.prefab == "jellyopop" then
			        food.components.edible.hungervalue = 12.5*1.5
			elseif food.prefab == "lobsterbisque" then
			        food.components.edible.hungervalue = 25*1.5
					food.components.edible.sanityvalue = 2.5
			elseif food.prefab == "lobsterdinner" then
			        food.components.edible.hungervalue = 37.5*1.5
					food.components.edible.sanityvalue = 25
			elseif food.prefab == "surfnturf" then
			        food.components.edible.hungervalue = 37.5*1.5
					food.components.edible.sanityvalue = 33/2
			elseif food.prefab == "dragoonheart" then
			        food.components.edible.hungervalue = 25*1.5
					food.components.edible.sanityvalue = -5
			end
		end
	return inst.components.eater:EatMEAT(food)
	end
	inst:AddComponent("reader")
	RECIPETABS["BLOODTAB"] = {str = "BLOOD", sort=999, icon = "blood_tab.tex", icon_atlas = "images/tab/blood_tab.xml"}
	local bloodbat = Recipe("bloodbat", {Ingredient("sealring", 1,"images/inventoryimages/sealring.xml"),Ingredient("thecurseblood", 2,"images/inventoryimages/thecurseblood.xml")}, RECIPETABS.BLOODTAB, TECH.NONE, RECIPE_GAME_TYPE.COMMON)
	bloodbat.atlas = "images/inventoryimages/bloodbat.xml"
	local lswlsscarf = Recipe("lswlsscarf", {Ingredient("beefalowool", 8),Ingredient("silk", 4),Ingredient("feather_robin_winter", 4),}, RECIPETABS.BLOODTAB, TECH.SCIENCE_TWO)
    lswlsscarf.atlas = "images/inventoryimages/lswlsscarf.xml"
	local bloodbook_plus = Recipe("bloodbook_plus", {Ingredient("bloodbook", 1,"images/inventoryimages/bloodbook.xml"),Ingredient("thecurseblood", 2,"images/inventoryimages/thecurseblood.xml"),Ingredient("papyrus", 2),}, RECIPETABS.BLOODTAB, TECH.MAGIC_TWO)
    bloodbook_plus.atlas = "images/inventoryimages/bloodbook_plus.xml"
	-- if SaveGameIndex:IsModeShipwrecked() then
	-- local lswl_flowerpot = Recipe("lswl_flowerpot", {Ingredient("petals", 5),Ingredient("butterflywings", 5),Ingredient("boards", 2),}, RECIPETABS.BLOODTAB, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.COMMON, "lswl_flowerpot_placer")
    -- lswl_flowerpot.atlas = "images/inventoryimages/lswl_flowerpot.xml"
	-- else
	-- local lswl_flowerpot = Recipe("lswl_flowerpot", {Ingredient("petals", 5),Ingredient("butterflywings", 5),Ingredient("boards", 2),}, RECIPETABS.BLOODTAB, TECH.SCIENCE_TWO, "lswl_flowerpot_placer")
    -- lswl_flowerpot.atlas = "images/inventoryimages/lswl_flowerpot.xml"
	-- end
    TheInput:AddKeyUpHandler(lswl_LEVEL_KEY, function()
		inst.components.talker:Say("Lv:".. (inst.components.exp.levelpoint).."\n"..
		(inst.components.exp.currenttimepiont)..'/'..(inst.components.exp.maxtimepiont))
	end)
	TheInput:AddKeyUpHandler(lswl_HEALTH_KEY, function()
		if inst:HasTag("lswl") then 
			healthon(inst) 
		elseif inst:HasTag("lswl_health") then 
			healthoff(inst)
        elseif inst:HasTag("lswl_black") then
            inst.components.talker:Say(TUNING.LSWLUNHAPPYSAY)
        elseif inst:HasTag("lswl_moonfull") then 
			inst.components.talker:Say(TUNING.LSWLJJDBF)			
	    end
    end)
	TheInput:AddKeyUpHandler(lswl_BLACK_KEY, function()
		if inst.components.exp.levelpoint >= 50 then
		    if inst:HasTag("lswl") then 
			    blackon(inst) 
		    elseif inst:HasTag("lswl_health") then 
			    inst.components.talker:Say(TUNING.LSWLCHARGINGSAY)	
	        end
		elseif inst:HasTag("lswl") or inst:HasTag("lswl_health") then 
			inst.components.talker:Say(TUNING.LSWLLOWPOWERSAY)
		elseif inst:HasTag("lswl_moonfull") then 
			inst.components.talker:Say(TUNING.LSWLJJDBF)
	    end
	end)
	TheInput:AddKeyUpHandler(lswl_ATTACK_KEY, function()
	if inst.components.exp.levelpoint >= 75 then
		if inst:HasTag("lswl") then		
			inst.components.talker:Say(TUNING.LSWLLOWPOWERSAY)  
		elseif inst:HasTag("lswl_black")then
            if not inst:HasTag("lswl_attack") then 			
			    attacking(inst)
            elseif inst:HasTag("lswl_attack") then 
			    noattacking(inst)
			end
		elseif inst:HasTag("lswl_health") then 
			    inst.components.talker:Say(TUNING.LSWLCHARGINGSAY)	
	    end
	elseif inst:HasTag("lswl") or inst:HasTag("lswl_health") then 
			inst.components.talker:Say(TUNING.LSWLLOWPOWERSAY)
	elseif inst:HasTag("lswl_moonfull") then 
			inst.components.talker:Say(TUNING.LSWLJJDBF)
	elseif inst:HasTag("lswl_black") then
		inst.components.talker:Say(TUNING.LSWLLOWPOWERSAY)
	    end
	end)
    inst:ListenForEvent("working", onworked)
	inst:ListenForEvent("onhitother", onattacking)
	inst:ListenForEvent("levelup", levelup)
	inst:ListenForEvent("levelupmax", levelupmax)
	inst:ListenForEvent("killed",onkill)
	inst:ListenForEvent("healthdelta",checktag)
	inst:ListenForEvent("hungerdelta", checktag)
	inst:ListenForEvent("goinsane", GoInsane)
	inst:ListenForEvent( "daytime", function() lswlStats(inst) end , GetWorld())
	inst:ListenForEvent( "dusktime", function() lswlStats(inst) end , GetWorld())
	inst:ListenForEvent( "nighttime", function() lswlStats(inst) end , GetWorld())
		TUNING.SANITY_TINY = 1
	
end

return MakePlayerCharacter("lswl",prefabs, assets, fn, start_inv)
-- local function isanimals(target)
	-- 	return (target:HasTag("animal") or target:HasTag("bird") or target:HasTag("insect") or target:HasTag("smallfish"))
	-- end
	
	-- local function iskillers(target)
	-- 	return (target:HasTag("killer") or target:HasTag("rocky") or target:HasTag("tallbird") or target:HasTag("mosquito") or target:HasTag("epic") or target:HasTag("mossling") or target:HasTag("whale")) 
	-- end
	
	-- local function applyupgrades(inst)	        
	-- 	local upgrades = math.min(inst.level, level_max)
	-- 	local hunger_percent = inst.components.hunger:GetPercent()
	-- 	local health_percent = inst.components.health:GetPercent()
	-- 	inst.components.hunger.max = math.ceil (150 + upgrades * (350 - 150) / level_max)
	-- 	inst.components.health.maxhealth = math.ceil (200 + upgrades * (500 - 200) / level_max)      
	-- 	inst.components.talker:Say(TUNING.LSWLLEVELSAY.. (inst.level))
	-- 	if inst.level == 100 then
	-- 		inst.components.talker:Say("我好强啊，但前辈你在哪？")
	-- 	end
	
	-- 	    if inst.level >= 10 then
	-- 		    local bloodsword = Recipe("bloodsword", {Ingredient("sealring", 1,"images/inventoryimages/sealring.xml"),Ingredient("thecurseblood", 2,"images/inventoryimages/thecurseblood.xml"),}, RECIPETABS.BLOODTAB, TECH.SCIENCE_ONE)
	--             bloodsword.atlas = "images/inventoryimages/bloodsword.xml"
	-- 			local bloodbook_reap = Recipe("bloodbook_reap", {Ingredient("bloodbook", 1,"images/inventoryimages/bloodbook.xml"),Ingredient("thecurseblood", 2,"images/inventoryimages/thecurseblood.xml"),Ingredient("papyrus", 2),}, RECIPETABS.BLOODTAB, TECH.MAGIC_TWO)
	--             bloodbook_reap.atlas = "images/inventoryimages/bloodbook_reap.xml"
	-- 	end
	-- 		if inst.level >= 25 then
	-- 			local czyw = Recipe("czyw", {Ingredient("spidergland", 4),Ingredient("berries_cooked", 1),}, RECIPETABS.BLOODTAB, TECH.SCIENCE_ONE)
	--             czyw.atlas = "images/inventoryimages/czyw.xml"
	-- 			local bloodblowdart = Recipe("bloodblowdart", {Ingredient("sealring", 1,"images/inventoryimages/sealring.xml"),Ingredient("thecurseblood", 2,"images/inventoryimages/thecurseblood.xml"),}, RECIPETABS.BLOODTAB,TECH.SCIENCE_TWO)
	--             bloodblowdart.atlas = "images/inventoryimages/bloodblowdart.xml"
	-- 	end
	-- 	    if inst.level >= 50 then
	-- 	        local lifestone = Recipe("lifestone", {Ingredient("rocks", 2),Ingredient("livinglog", 2),Ingredient("thecurseblood", 2,"images/inventoryimages/thecurseblood.xml"),}, RECIPETABS.BLOODTAB, TECH.MAGIC_THREE,nil,nil,nil,2)
	--             lifestone.atlas = "images/inventoryimages/lifestone.xml"
	-- 			if SaveGameIndex:IsModeShipwrecked() then
	-- 	        local bloodicebox = Recipe("bloodicebox", {Ingredient("gears", 10),Ingredient("bluegem", 10),Ingredient("thecurseblood", 20,"images/inventoryimages/thecurseblood.xml"),}, RECIPETABS.BLOODTAB, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.COMMON, "icebox_placer")
	--             bloodicebox.atlas = "images/inventoryimages/bloodicebox.xml"
	-- 			else
	-- 		    local bloodicebox = Recipe("bloodicebox", {Ingredient("gears", 10),Ingredient("bluegem", 10),Ingredient("thecurseblood", 20,"images/inventoryimages/thecurseblood.xml"),}, RECIPETABS.BLOODTAB, TECH.SCIENCE_TWO, "icebox_placer")
	--             bloodicebox.atlas = "images/inventoryimages/bloodicebox.xml"
	-- 			end
	-- 	end
	-- 		if inst.level >= 75 then
	--         local bluegem = Recipe("bluegem", {Ingredient("ice", 4),Ingredient("thecurseblood", 5,"images/inventoryimages/thecurseblood.xml"),}, RECIPETABS.BLOODTAB, TECH.MAGIC_THREE)
	-- 		local redgem = Recipe("redgem", {Ingredient("charcoal", 2),Ingredient("thecurseblood", 5,"images/inventoryimages/thecurseblood.xml"),}, RECIPETABS.BLOODTAB, TECH.MAGIC_THREE)
	-- 	end
	-- 		if inst.level >= 100 then
	--         	--local bloodbook_summon = Recipe("bloodbook_summon", {Ingredient("bloodbook", 1,"images/inventoryimages/bloodbook.xml"),Ingredient("thecurseblood", 50,"images/inventoryimages/thecurseblood.xml"),Ingredient("papyrus", 2),}, RECIPETABS.BLOODTAB, TECH.MAGIC_TWO)
	--             --bloodbook_summon.atlas = "images/inventoryimages/bloodbook_summon.xml"
	-- 			local ymstone = Recipe("ymstone", {Ingredient("ymquintessence", 10,"images/inventoryimages/ymquintessence.xml"),Ingredient("thecurseblood", 10,"images/inventoryimages/thecurseblood.xml"),Ingredient("purplegem", 5),}, RECIPETABS.BLOODTAB, TECH.MAGIC_TWO)
	--             ymstone.atlas = "images/inventoryimages/ymstone.xml"
	-- 			local bloodblacksword = Recipe("bloodblacksword", {Ingredient("bloodsword", 1,"images/inventoryimages/bloodsword.xml"),Ingredient("thecurseblood", 100,"images/inventoryimages/thecurseblood.xml"),Ingredient("evilblackstone", 10,"images/inventoryimages/evilblackstone.xml")}, RECIPETABS.BLOODTAB, TECH.ANCIENT_FOUR)
	--             bloodblacksword.atlas = "images/inventoryimages/bloodblacksword.xml"
	-- 	end
	-- 		inst.components.health:SetPercent(health_percent)
	-- 		inst.components.hunger:SetPercent(hunger_percent)
	-- end
