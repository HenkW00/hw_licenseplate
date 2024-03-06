ESX = exports["es_extended"]:getSharedObject()

-- Utility function to trim strings
local function trim(s)
    return s and s:match("^%s*(.-)%s*$") or ''
end

-- Function to check if a value is in a table (list)
local function contains(table, val)
    for index, value in ipairs(table) do
        if value == val then
            return true
        end
    end
    return false
end

-- Check vehicle ownership based on license plate
RegisterServerEvent("hw_licenseplate:Check")
AddEventHandler("hw_licenseplate:Check", function(plate)
    local _source = source 
    print("Checking vehicle ownership. Plate: " .. tostring(plate))

    if not plate or plate == '' then
        print("Plate is nil. Check aborted.")
        TriggerClientEvent("hw_licenseplate:Result", _source, false)
        return
    end

    MySQL.Async.fetchScalar("SELECT COUNT(*) FROM owned_vehicles WHERE plate = @plate", {
        ["@plate"] = trim(plate)
    }, function(result)
        TriggerClientEvent("hw_licenseplate:Result", _source, result and tonumber(result) > 0)
    end)
end)

-- Function to check if the plate contains blacklisted words
function isPlateBlacklisted(plate, blacklistedWords)
    plate = plate:lower()
    for _, word in ipairs(blacklistedWords) do
        if plate:find(word:lower(), 1, true) then
            return true
        end
    end
    return false
end

-- Register usable item
ESX.RegisterUsableItem('license_plate', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    TriggerClientEvent('hw_licenseplate:useLicensePlate', playerId)
end)

-- Main event to change the license plate
RegisterServerEvent("hw_licenseplate:ChangePlate")
AddEventHandler("hw_licenseplate:ChangePlate", function(oldPlate, newPlate)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    oldPlate = trim(oldPlate):upper()
    newPlate = trim(newPlate):upper()

    if #newPlate > 8 or isPlateBlacklisted(newPlate, Config.BlacklistedWords) then
        TriggerClientEvent('okokNotify:Alert', playerId, "SYSTEM", "Invalid or blacklisted new plate.", 5000, 'error')
        return
    end

    MySQL.Async.fetchScalar("SELECT COUNT(*) FROM owned_vehicles WHERE plate = @newPlate", {
        ["@newPlate"] = newPlate
    }, function(count)
        if count > 0 then
            TriggerClientEvent('okokNotify:Alert', playerId, "SYSTEM", "New plate already in use.", 5000, 'error')
        else
            MySQL.Async.execute("UPDATE owned_vehicles SET plate = @newPlate WHERE plate = @oldPlate AND owner = @owner", {
                ["@newPlate"] = newPlate,
                ["@owner"] = xPlayer.identifier,
                ["@oldPlate"] = oldPlate
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    xPlayer.removeInventoryItem('license_plate', 1)
                    TriggerClientEvent('okokNotify:Alert', playerId, "SYSTEM", "Plate changed successfully.", 5000, 'success')
                    TriggerClientEvent('hw_licenseplate:UpdatePlateClient', playerId, newPlate)
                else
                    TriggerClientEvent('okokNotify:Alert', playerId, "SYSTEM", "Plate change failed. Verify the current plate and ownership.", 5000, 'error')
                end
            end)
        end
    end)
end)
