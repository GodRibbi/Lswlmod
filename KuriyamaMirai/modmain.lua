local require = GLOBAL.require
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local STRINGS = GLOBAL.STRINGS
local ACTIONS = GLOBAL.ACTIONS
local TECH = GLOBAL.TECH
local TUNING = GLOBAL.TUNING


TUNING.LSWLSETTING1 = "Examining level"
TUNING.LSWLSETTING2 = "Healthy key"
TUNING.LSWLSETTING3 = "Blood waltz"
TUNING.LSWLSETTING4 = "Black key"

local LAN = GetModConfigData('Language')
if LAN then
    STRINGS.CHARACTERS.LSWL = require "speech_lswl_c"
	require 'strings_lswl_c'
	modimport ("scripts/tuning_lswl_c.lua")
	require 'tuning_lswl_c'
	TUNING.lswllan = true
else
    STRINGS.CHARACTERS.LSWL = require "speech_lswl_e"
	require 'strings_lswl_e'
	modimport ("scripts/tuning_lswl_e.lua")
	require 'tuning_lswl_e'
	TUNING.lswllan = false
end


PrefabFiles = {
   "lswl",
   "bloodsword",
   "bloodblacksword",
   "bloodbat",
   "sealring",
   "bloodbook",
   "thecurseblood",
   "lswlsscarf",
   "glasses",
   "bloodblowdart",
   --"bloodicebox",
   "bloodbook_reap",
   "bloodbook_plus",
   --"bloodbook_summon",
   "lifestone",
   "czyw",
   "lswlfx",
   --"shadowcreature_sea",
   --"shadowcreature",
   "ym",
   "ymquintessence",
   "ymstone",
    "deerclopsblack",
    "evilblackstone",
	--"lswl_flowerpot"
}
Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/lswl.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/lswl.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/lswl.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/lswl.xml" ),
	

    Asset( "IMAGE", "bigportraits/lswl.tex" ),
    Asset( "ATLAS", "bigportraits/lswl.xml" ),
	
    Asset("SOUNDPACKAGE", "sound/lswl.fev"),
    Asset("SOUND", "sound/lswl.fsb"),
	
	Asset( "IMAGE", "images/minimap/lswl.tex" ),
	Asset( "ATLAS", "images/minimap/lswl.xml" ),

	 Asset("ANIM", "anim/deerclopsblack_build.zip"),
	 
     Asset("ANIM", "anim/bloodsplatter.zip"),
	 Asset("ANIM", "anim/bloodstorm.zip"),
	 Asset("ANIM", "anim/lswl_health.zip"),
	 Asset("ANIM", "anim/aureole.zip"),
	 Asset("ANIM", "anim/flashfx.zip"),
	 Asset("ANIM", "anim/potfx.zip"),
	 Asset("ANIM", "anim/healthfx.zip"),
	 
	 Asset("ANIM", "anim/bloodsword.zip"),
     Asset("ANIM", "anim/swap_bloodsword.zip"),
	 Asset("ANIM", "anim/swap_bloodblacksword.zip"),
	 
	 Asset("ANIM", "anim/bloodbat.zip"),
     Asset("ANIM", "anim/swap_bloodbat.zip"),
	 
	 Asset("ANIM", "anim/lswl's scarf.zip"),
     Asset("ANIM", "anim/swap_lswl's scarf.zip"),
	 
	 Asset("ANIM", "anim/glasses.zip"),
     Asset("ANIM", "anim/swap_glasses.zip"),
	 
	 Asset("ANIM", "anim/bloodblowdart.zip"),
     Asset("ANIM", "anim/swap_bloodblowdart.zip"),
	 
	 --Asset("ANIM", "anim/bloodicebox.zip"),
	 --Asset("ANIM", "anim/lswl_flowerpot.zip"),
     --Asset("ANIM", "anim/ui_chest_4x4.zip"),	

	 Asset( "IMAGE", "images/minimap/bloodbook_reap.tex" ),
	 Asset( "ATLAS", "images/minimap/bloodbook_reap.xml" ),
	 
	 Asset( "IMAGE", "images/minimap/ym.tex" ),
	 Asset( "ATLAS", "images/minimap/ym.xml" ),
	 
	 Asset( "IMAGE", "images/minimap/deerclopsblack.tex" ),
	 Asset( "ATLAS", "images/minimap/deerclopsblack.xml" ),
	 
	 Asset( "IMAGE", "images/minimap/bloodblacksword.tex" ),
	 Asset( "ATLAS", "images/minimap/bloodblacksword.xml" ),
	 
	 Asset( "IMAGE", "images/minimap/evilblackstone.tex" ),
	 Asset( "ATLAS", "images/minimap/evilblackstone.xml" ),
	 
	 Asset( "IMAGE", "images/minimap/bloodbook_plus.tex" ),
	 Asset( "ATLAS", "images/minimap/bloodbook_plus.xml" ),
	 
	 --Asset( "IMAGE", "images/minimap/bloodbook_summon.tex" ),
	 --Asset( "ATLAS", "images/minimap/bloodbook_summon.xml" ),
	 
	 Asset( "IMAGE", "images/minimap/bloodsword.tex" ),
	 Asset( "ATLAS", "images/minimap/bloodsword.xml" ),
	 
	 --Asset( "IMAGE", "images/minimap/bloodicebox.tex" ),
	 --Asset( "ATLAS", "images/minimap/bloodicebox.xml" ),
	 
	 Asset( "IMAGE", "images/minimap/bloodbat.tex" ),
	 Asset( "ATLAS", "images/minimap/bloodbat.xml" ),
	 
	 Asset( "IMAGE", "images/minimap/sealring.tex" ),
	 Asset( "ATLAS", "images/minimap/sealring.xml" ),
	 
     Asset( "IMAGE", "images/minimap/bloodbook.tex" ),
	 Asset( "ATLAS", "images/minimap/bloodbook.xml" ),
	 
	 Asset( "IMAGE", "images/minimap/glasses.tex" ),
	 Asset( "ATLAS", "images/minimap/glasses.xml" ),
	 
	 Asset( "IMAGE", "images/minimap/bloodblowdart.tex" ),
	 Asset( "ATLAS", "images/minimap/bloodblowdart.xml" ),
	
	 Asset( "IMAGE", "images/inventoryimages/evilblackstone.tex" ),
	 Asset( "ATLAS", "images/inventoryimages/evilblackstone.xml" ),
	 
	 --Asset("IMAGE", "images/inventoryimages/lswl_flowerpot.tex"),
	 --Asset("ATLAS", "images/inventoryimages/lswl_flowerpot.xml"),

	 Asset( "IMAGE", "images/inventoryimages/bloodblacksword.tex" ),
	 Asset( "ATLAS", "images/inventoryimages/bloodblacksword.xml" ),
	 
	 Asset( "IMAGE", "images/inventoryimages/bloodbook_reap.tex" ),
	 Asset( "ATLAS", "images/inventoryimages/bloodbook_reap.xml" ),
	 
	 Asset( "IMAGE", "images/inventoryimages/bloodbook_plus.tex" ),
	 Asset( "ATLAS", "images/inventoryimages/bloodbook_plus.xml" ),
	 
	 --Asset( "IMAGE", "images/inventoryimages/bloodbook_summon.tex" ),
	 --Asset( "ATLAS", "images/inventoryimages/bloodbook_summon.xml" ),
	
	 Asset( "IMAGE", "images/inventoryimages/bloodsword.tex" ),
	 Asset( "ATLAS", "images/inventoryimages/bloodsword.xml" ),
	 
	 --Asset( "IMAGE", "images/inventoryimages/bloodicebox.tex" ),
	 --Asset( "ATLAS", "images/inventoryimages/bloodicebox.xml" ),
	 
	 Asset( "IMAGE", "images/inventoryimages/glasses.tex" ),
	 Asset( "ATLAS", "images/inventoryimages/glasses.xml" ),
	 
	 Asset( "IMAGE", "images/inventoryimages/lswlsscarf.tex" ),
	 Asset( "ATLAS", "images/inventoryimages/lswlsscarf.xml" ),
	 
	 Asset( "IMAGE", "images/inventoryimages/bloodbat.tex" ),
	 Asset( "ATLAS", "images/inventoryimages/bloodbat.xml" ),
	
	 Asset( "IMAGE", "images/inventoryimages/bloodbook.tex" ),
	 Asset( "ATLAS", "images/inventoryimages/bloodbook.xml" ),
	 
     Asset( "IMAGE", "images/inventoryimages/sealring.tex" ),
	 Asset( "ATLAS", "images/inventoryimages/sealring.xml" ),
	 
	 Asset( "IMAGE", "images/inventoryimages/thecurseblood.tex" ),
	 Asset( "ATLAS", "images/inventoryimages/thecurseblood.xml" ),
	 
	 Asset( "IMAGE", "images/inventoryimages/czyw.tex" ),
	 Asset( "ATLAS", "images/inventoryimages/czyw.xml" ),
	 
	 Asset( "IMAGE", "images/inventoryimages/bloodblowdart.tex" ),
	 Asset( "ATLAS", "images/inventoryimages/bloodblowdart.xml" ),
	 	 
	 Asset( "IMAGE", "images/inventoryimages/lifestone.tex" ),
	 Asset( "ATLAS", "images/inventoryimages/lifestone.xml" ),
	 
	 Asset( "IMAGE", "images/inventoryimages/ymstone.tex" ),
	 Asset( "ATLAS", "images/inventoryimages/ymstone.xml" ),
	 
	 Asset( "IMAGE", "images/inventoryimages/ymquintessence.tex" ),
	 Asset( "ATLAS", "images/inventoryimages/ymquintessence.xml" ),
	 
	 Asset( "IMAGE", "images/tab/blood_tab.tex" ),
	 Asset( "ATLAS", "images/tab/blood_tab.xml" ),
	 
}

local function LswlMaxwellIntro(inst)
    if GLOBAL.GetPlayer().prefab == "lswl" then
        inst.components.maxwelltalker.speeches.SANDBOX_1 =
        {
            appearsound = "dontstarve/maxwell/disappear",	
            voice = "dontstarve/maxwell/talk_LP_world3",
            appearanim = "appear3",
            idleanim = "idle3_loop",
            dialogpreanim = "dialog3_pre",
            dialoganim ="dialog3_loop",
            dialogpostanim = "dialog3_pst",
            disappearanim = "disappear3",
            disableplayer = true,
            skippable = true,
            {
                string = STRINGS.LSWL_INTRO_MAXWELL_1,
                wait = 2.5,
                anim = nil,
                sound = nil,
            },
            {
                string = STRINGS.LSWL_INTRO_MAXWELL_2,
                wait = 4,
                anim = nil,
                sound = nil,
            },
            {
                string = STRINGS.LSWL_INTRO_MAXWELL_3,
                wait = 3.5,
                anim = nil,
                sound = nil,
            },
        }
    end
end
AddPrefabPostInit("maxwellintro", LswlMaxwellIntro)

table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "lswl")

local function GetConfig(s,default)
	local c=GetModConfigData(s)
	if c==nil then
		c=default
	end
	if type(c)=="table" then
		c=c.option_data
	end
	return c
end

GLOBAL.lswl_LEVEL_KEY = GetModConfigData("LEVEL_KEY")
GLOBAL.lswl_HEALTH_KEY = GetModConfigData("HEALTH_KEY")
GLOBAL.lswl_ATTACK_KEY = GetModConfigData("ATTACK_KEY")
GLOBAL.lswl_BLACK_KEY = GetModConfigData("BLACK_KEY")
AddMinimapAtlas("images/minimap/lswl.xml")
AddMinimapAtlas("images/minimap/bloodsword.xml")
AddMinimapAtlas("images/minimap/sealring.xml")
AddMinimapAtlas("images/minimap/bloodbook.xml")
AddMinimapAtlas("images/minimap/bloodbat.xml")
AddMinimapAtlas("images/minimap/glasses.xml")
AddMinimapAtlas("images/minimap/bloodblowdart.xml")
--AddMinimapAtlas("images/minimap/bloodicebox.xml")
AddMinimapAtlas("images/minimap/bloodbook_reap.xml")
AddMinimapAtlas("images/minimap/bloodbook_plus.xml")
--AddMinimapAtlas("images/minimap/bloodbook_summon.xml")
AddMinimapAtlas("images/minimap/evilblackstone.xml")
AddMinimapAtlas("images/minimap/bloodblacksword.xml")
AddMinimapAtlas("images/minimap/ym.xml")
AddMinimapAtlas("images/minimap/deerclopsblack.xml")
AddModCharacter("lswl")