-- ESX = exports["es_extended"]:getSharedObject()

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterNetEvent('hw_licenseplate:useLicensePlate')
AddEventHandler('hw_licenseplate:useLicensePlate', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle and vehicle ~= 0 then
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 8)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0)
            Wait(0)
        end
        if (GetOnscreenKeyboardResult()) then
            local result = GetOnscreenKeyboardResult()
            if result then
                TriggerServerEvent('hw_licenseplate:ChangePlate', GetVehicleNumberPlateText(vehicle), result)
            end
        end
    else
        exports['okokNotify']:Alert("SYSTEM", "You are not in a vehicle.", 5000, 'error')
    end
end)

RegisterCommand("kenteken", function(source, args, rawCommand)
    if Config.Debug then
        print("Config.Test is currently:", Config.Test) -- Debug print to check the value of Config.Test
    end
    if Config.Test then
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if DoesEntityExist(vehicle) then
            local oldPlate = GetVehicleNumberPlateText(vehicle)
            if #args > 0 then
                local newPlate = table.concat(args, " ")
                local playerIdentifier = GetPlayerServerId(PlayerId())
                TriggerServerEvent("hw_licenseplate:ChangePlate", oldPlate, newPlate, playerIdentifier)
            else
                exports['okokNotify']:Alert("SYSTEM", "Usage: /changeplate [NEW_PLATE]", 5000, 'error')
            end
        else
            exports['okokNotify']:Alert("SYSTEM", "You are not in a vehicle.", 5000, 'error')
        end
    else
        exports['okokNotify']:Alert("SYSTEM", "Test Mode is disabled", 5000, 'error')
    end
end, false)

RegisterNetEvent("hw_licenseplate:Result")
AddEventHandler("hw_licenseplate:Result", function(ownsVehicle)
    if ownsVehicle then
        exports['okokNotify']:Alert("SYSTEM", "You own the vehicle.", 5000, 'info')
    else
        exports['okokNotify']:Alert("SYSTEM", "You do not own this vehicle.", 5000, 'error')
    end
end)

RegisterNetEvent('hw_licenseplate:UpdatePlateClient')
AddEventHandler('hw_licenseplate:UpdatePlateClient', function(newPlate)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle and vehicle ~= 0 then
        SetVehicleNumberPlateText(vehicle, newPlate)
        exports['okokNotify']:Alert("Vehicle", "Plate updated to: " .. newPlate, 5000, 'success')
    else
        exports['okokNotify']:Alert("Vehicle", "You are not in a vehicle.", 5000, 'error')
    end
end)
