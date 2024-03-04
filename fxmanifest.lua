fx_version 'adamant'
game 'gta5'

author 'Maxime'
description 'AMRP KENTEKENPLAAT'
version '1.0.0'

client_scripts {
	'client/main.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}

shared_scripts {
	'config.lua'
}

shared_script '@es_extended/imports.lua'