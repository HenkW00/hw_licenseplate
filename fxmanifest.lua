fx_version 'adamant'
game 'gta5'

author 'HenkW'
description 'ESX Licenseplate with okokNotify'
version '1.0.1'

client_scripts {
	'client/main.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
	'server/version.lua'
}

shared_scripts {
	'config.lua'
}

dependency {
	'okokNotify',
	'es_extended'
}

shared_script '@es_extended/imports.lua'