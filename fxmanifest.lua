fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'HenkW'
description 'ESX Vehicle license plate script using okokNotify'
version '1.0.9'

client_scripts {
	'client/main.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
	'server/version.lua'
}

shared_scripts {
	'config.lua',
	'@es_extended/imports.lua'
}

escrow_ignore {
    'config.lua',
    'fxmanifest.lua',
    'README.MD'
}

dependencies {
	'hw_utils'
}

server_scripts { '@mysql-async/lib/MySQL.lua' }