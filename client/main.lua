ESX = exports["es_extended"]:getSharedObject()

-- Use License Plate Item
RegisterNetEvent('hw_licenseplate:useLicensePlate')
AddEventHandler('hw_licenseplate:useLicensePlate', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle ~= 0 then
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 8)
        while UpdateOnscreenKeyboard() == 0 do
            DisableAllControlActions(0)
            Wait(0)
        end
        local result = GetOnscreenKeyboardResult()
        if result then
            TriggerServerEvent('hw_licenseplate:ChangePlate', GetVehicleNumberPlateText(vehicle), result)
        end
    else
        exports['okokNotify']:Alert("SYSTEM", "You are not in a vehicle.", 5000, 'error')
    end
end)

-- Custom Command for Testing (if needed)
RegisterCommand("kenteken", function(source, args, rawCommand)
    if Config.Test then
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle ~= 0 then
            local oldPlate = GetVehicleNumberPlateText(vehicle)
            if #args > 0 then
                local newPlate = table.concat(args, " ")
                TriggerServerEvent("hw_licenseplate:ChangePlate", oldPlate, newPlate)
            else
                exports['okokNotify']:Alert("SYSTEM", "Usage: /kenteken [NEW_PLATE]", 5000, 'error')
            end
        else
            exports['okokNotify']:Alert("SYSTEM", "You are not in a vehicle.", 5000, 'error')
        end
    else
        exports['okokNotify']:Alert("SYSTEM", "Test Mode is disabled", 5000, 'error')
    end
end, false)

-- Handle License Plate Change Result
RegisterNetEvent("hw_licenseplate:Result")
AddEventHandler("hw_licenseplate:Result", function(ownsVehicle)
    if ownsVehicle then
        exports['okokNotify']:Alert("SYSTEM", "You own the vehicle.", 5000, 'info')
    else
        exports['okokNotify']:Alert("SYSTEM", "You do not own this vehicle.", 5000, 'error')
    end
end)

-- Update Vehicle License Plate Visually
RegisterNetEvent('hw_licenseplate:UpdatePlateClient')
AddEventHandler('hw_licenseplate:UpdatePlateClient', function(newPlate)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        SetVehicleNumberPlateText(vehicle, newPlate)
        exports['okokNotify']:Alert("Vehicle", "Plate updated to: " .. newPlate, 5000, 'success')
    else
        exports['okokNotify']:Alert("Vehicle", "You are not in a vehicle.", 5000, 'error')
    end
end)