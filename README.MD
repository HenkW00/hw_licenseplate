# HW Scripts | Licenseplate Changer

## Introduction
This script provides a vehicle license plate system for FiveM servers. Players can change the license plate of their owned vehicles using in-game items or commands.

## :white_check_mark: Features
- Players can change the license plate of their owned vehicles.
- Supports blacklisting certain words from being used in license plates.
- Includes a debug mode for testing purposes.
- Provides visual notifications for various actions.

## :tools: Installation
1. Ensure you have [es_extended](https://github.com/ESX-Org/es_extended) installed and properly configured on your server.
2. Copy the `hw_licenseplate` folder into your server's `resources` directory.
3. Import the SQL file `hw_licenseplate.sql` into your database.
4. Add `ensure hw_licenseplate` to your `server.cfg` file.

## :globe_with_meridians: Dependencies
- [MySQL](https://github.com/brtknr/mysql-async)
- [es_extended](https://github.com/ESX-Org/es_extended)
- [okokNotify](https://forum.cfx.re/t/okoknotify-standalone-paid/3907758)

## :white_check_mark: Usage
### In-Game Commands
- `/kenteken [NEW_PLATE]`: Change the license plate of the vehicle you're currently in. (Requires test mode enabled)

### In-Game Items
- `license_plate`: Use this item to change the license plate of a vehicle.

## Configuration
The configuration options can be found in `config.lua`:

- `Debug`: Enable or disable debug mode for logging.
- `Test`: Enable or disable test mode for using the `/kenteken` command.

If help is needed, you can contact me via discord.
Link for that you can find in console upon restarting the script, otherwise just search for HenkW00 on google/github/CFX

Enjoy the script, i hope you like it! :heart: