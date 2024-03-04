# Vehicle Ownership System for FiveM

This script provides functionalities for checking the ownership of vehicles and updating vehicle license plates in a FiveM server.

## Installation

1. Copy the `server.lua`, `client.lua`, and `config.lua` files into your resource folder.
2. Add `start your_resource_name` to your server.cfg.
3. Ensure you have MySQL-Async installed and properly configured as this script depends on it for database operations.

## Usage

- To check vehicle ownership, this is handled automatically in the background. 
- To change a vehicle's license plate, use the command `/changeplate [NEW_PLATE]` in-game.

## Configuration

Edit the `config.lua` file to match your database schema and any other preferences.

## Dependencies

- MySQL-Async
