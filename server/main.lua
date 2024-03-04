-- ESX = exports["es_extended"]:getSharedObject()

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

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

function isPlateBlacklisted(plate)
    for _, word in ipairs(Config.BlacklistedWords) do
        if string.match(plate:lower(), "%" .. word:lower() .. "%") then
            return true
        end
    end
    return false
end

RegisterServerEvent("hw_licenseplate:ChangePlate")
AddEventHandler("hw_licenseplate:ChangePlate", function(oldPlate, newPlate)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if not oldPlate or not newPlate or #newPlate > 8 or isPlateBlacklisted(newPlate) then
        TriggerClientEvent('okokNotify:Alert', playerId, "Error", "Invalid or inappropriate license plate.", 5000, 'error')
        return
    end

    MySQL.Async.fetchScalar("SELECT COUNT(*) FROM owned_vehicles WHERE plate = @plate", {
        ["@plate"] = newPlate
    }, function(count)
        if count > 0 then
            TriggerClientEvent('okokNotify:Alert', playerId, "Error", "License plate is already in use.", 5000, 'error')
        else
            MySQL.Async.execute("UPDATE owned_vehicles SET plate = @newPlate WHERE owner = @owner AND plate = @oldPlate", {
                ["@newPlate"] = newPlate,
                ["@owner"] = xPlayer.identifier,
                ["@oldPlate"] = oldPlate
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    TriggerClientEvent('okokNotify:Alert', playerId, "Success", "License plate changed successfully.", 5000, 'success')
                else
                    TriggerClientEvent('okokNotify:Alert', playerId, "Error", "Failed to change license plate.", 5000, 'error')
                end
            end)
        end
    end)
end)