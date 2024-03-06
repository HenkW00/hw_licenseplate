-- ESX = exports["es_extended"]:getSharedObject()

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

local function contains(table, val)
    for index, value in ipairs(table) do
        if value == val then
            return true
        end
    end
    return false
end

RegisterServerEvent("hw_licenseplate:Check")
AddEventHandler("hw_licenseplate:Check", function(plate)
    local _source = source 
    print("Checking vehicle ownership. Plate: " .. tostring(plate))

    if not plate then
        print("Plate is nil. Check aborted.")
        return
    end

    MySQL.Async.fetchScalar("SELECT COUNT(*) FROM owned_vehicles WHERE plate = @plate", {["@plate"] = plate}, function(result)
        if result and tonumber(result) > 0 then
            TriggerClientEvent("hw_licenseplate:Result", _source, true)
        else
            TriggerClientEvent("hw_licenseplate:Result", _source, false)
        end
    end)
end)

function isPlateBlacklisted(plate, blacklistedWords)
    for _, word in ipairs(blacklistedWords) do
        if string.match(plate:lower(), word:lower()) then
            return true
        end
    end
    return false
end

ESX.RegisterUsableItem('license_plate', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        TriggerClientEvent('hw_licenseplate:useLicensePlate', playerId)
        if Config.Debug then
            print("^0[^1DEBUG^0] ^5Player: ^3" .. playerId .. "^5 used a ^3license plate^0")
        end
    end
end)

RegisterServerEvent("hw_licenseplate:ChangePlate")
AddEventHandler("hw_licenseplate:ChangePlate", function(oldPlate, newPlate)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if Config.Debug then
        print("^0[^1DEBUG^0] ^5Player: ^3" .. playerId .. "^5 attempting to change plate from ^3" .. oldPlate .. "^5 to ^3" .. newPlate)
    end

    local plateItem = xPlayer.getInventoryItem('license_plate')
    if not plateItem or plateItem.count < 1 then
        TriggerClientEvent('okokNotify:Alert', playerId, "SYSTEM", "You need a 'license_plate' item to change your plate.", 5000, 'error')
        return
    end

    if not oldPlate or not newPlate or #newPlate > 8 or isPlateBlacklisted(newPlate, Config.BlacklistedWords) then
        local errorMessage = "Invalid parameters for plate change."
        if #newPlate > 8 then
            errorMessage = "The license plate cannot exceed 8 characters."
        elseif isPlateBlacklisted(newPlate, Config.BlacklistedWords) then
            errorMessage = "The license plate contains prohibited words. Please choose another one."
        end
        TriggerClientEvent('okokNotify:Alert', playerId, "SYSTEM", errorMessage, 5000, 'error')
        return
    end

    local playerGroup = xPlayer.getGroup()
    if playerGroup ~= Config.Group then
        TriggerClientEvent('okokNotify:Alert', playerId, "SYSTEM", "You do not have permission to use this command.", 5000, 'error')
            if Config.Debug then
                print("^0[^1DEBUG^0] ^5Player: ^3" .. playerId .. "^5 tried to use this command but hasnt permission for it!^0")
            end
        return
    end

    MySQL.Async.fetchScalar("SELECT COUNT(*) FROM owned_vehicles WHERE plate = @plate", {
        ["@plate"] = newPlate
    }, function(count)
        if count > 0 then
            TriggerClientEvent('okokNotify:Alert', playerId, "SYSTEM", "This license plate is already in use. Please choose another one.", 5000, 'error')
        else
            MySQL.Async.execute("UPDATE owned_vehicles SET plate = @newPlate WHERE owner = @owner AND plate = @oldPlate", {
                ["@newPlate"] = newPlate,
                ["@owner"] = xPlayer.identifier,
                ["@oldPlate"] = oldPlate
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    xPlayer.removeInventoryItem('license_plate', 1)
                    TriggerClientEvent('okokNotify:Alert', playerId, "SYSTEM", "License plate updated from " .. oldPlate .. " to " .. newPlate, 5000, 'success')
                    TriggerClientEvent('hw_licenseplate:UpdatePlateClient', playerId, newPlate)
                else
                    TriggerClientEvent('okokNotify:Alert', playerId, "SYSTEM", "Failed to update license plate. Please try again.", 5000, 'error')
                    if Config.Debug then
                        print("^0[^1DEBUG^0] ^5Player: ^3" .. playerId .. "^5 failed to use a ^3license plate^0")
                    end
                end
            end)
        end
    end)
end)