name = "Kuriyama Mirai"
description = "mod文件夹里有详细简介"
author = "走出现有幼稚"
version = "1.0"

forumthread = ""

api_version = 6
--dst_api_version = 10 -- line added for forum thread; is not like this in mod currently

dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = false
shipwrecked_compatible = true
hamlet_compatible = true

--all_clients_require_mod = false
--client_only_mod = false

--server_filter_tags = {"metabolizer", "hunger", "rate", "metabolism"}

priority = 0

icon_atlas = "modicon.xml"
icon = "modicon.tex"

local op = {
            {description="A", data = 97},
            {description="B", data = 98},
            {description="C", data = 99},
            {description="D", data = 100},
            {description="E", data = 101},
            {description="F", data = 102},
            {description="G", data = 103},
            {description="H", data = 104},
            {description="I", data = 105},
            {description="J", data = 106},
            {description="K", data = 107},
            {description="L", data = 108},
            {description="M", data = 109},
            {description="N", data = 110},
            {description="O", data = 111},
            {description="P", data = 112},
            {description="Q", data = 113},
            {description="R", data = 114},
            {description="S", data = 115},
            {description="T", data = 116},
            {description="U", data = 117},
            {description="V", data = 118},
            {description="W", data = 119},
            {description="X", data = 120},
            {description="Y", data = 121},
            {description="Z", data = 122}
        }
configuration_options =
{
	{
		name = "LEVEL_KEY",
		label = "检查等级\nExamining level",
		hover = "检查等级\nExamining level",
		options = op ,
		default = 117, --U
	},
		{
		name = "HEALTH_KEY",
		label = "治疗模式\nHealthy key",
		hover = "治疗模式\nHealthy key",
		options = op ,
		default = 105, --I
	},
		{
		name = "ATTACK_KEY",
		label = "鲜血华尔兹\nHealthy key",
		hover = "鲜血华尔兹\nHealthy key",
		options = op ,
		default = 104, --H
	},
		{
		name = "BLACK_KEY",
		label = "黑化\nBlack key",
		hover = "黑化\nBlack key",
		options = op ,
		default = 111, --O
	},
			{
		name = "Language",
 		label = "语言\nLanguage",
		hover = "语言\nLanguage",
        options =   {
		{description = "简体中文", data = true},
        {description = "English", data = false},
                    }, 
		default = false, --中文
	}
       }