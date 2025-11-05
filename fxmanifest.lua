fx_version "cerulean"
game "gta5"
lua54 "yes"
use_experimental_fxv2_oal "yes"

author "Patchflow"
description "Modern Blackmarket System"
version "1.0.0"

ui_page "web/dist/index.html"
--ui_page "http://localhost:3000/"

shared_scripts {
	"@ox_lib/init.lua",
	"shared/**/*.lua",
}

client_scripts {
	"client/nui.lua",
	"client/target.lua"
}

server_scripts {
	"server/main.lua"
}

files {
	"locales/*.json",
	"config/config.lua",
	"web/dist/**/*",
	"server/framework/*.lua",
	"server/logger.lua"
}

ox_libs {
	"locale",
}
