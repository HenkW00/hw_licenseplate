-- ESX = exports["es_extended"]:getSharedObject()

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterCommand("kenteken", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) then
        local oldPlate = GetVehicleNumberPlateText(vehicle)
        if #args > 0 then
            local newPlate = table.concat(args, " ")
            TriggerServerEvent("hw_licenseplate:ChangePlate", oldPlate, newPlate)
        else
            exports['okokNotify']:Alert("SYSTEM", "Usage: /changeplate [NEW_PLATE]", 5000, 'error')
        end
    else
        exports['okokNotify']:Alert("SYSTEM", "You are not in a vehicle.", 5000, 'error')
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
