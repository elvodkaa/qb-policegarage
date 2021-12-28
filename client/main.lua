local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local pedspawned = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function(Player)
    PlayerData =  QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
     PlayerJob = job
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k, v in pairs(Config.Pedlocation) do
			local pos = GetEntityCoords(PlayerPedId())	
			local dist = #(v.Cords - pos)
			if dist < 40 and pedspawned == false then
				TriggerEvent('spawn:ped',v.Cords,v.h)
				pedspawned = true
			end
			if dist >= 35 then
				pedspawned = false
				DeletePed(npc)
			end
		end
	end
end)

RegisterNetEvent('spawn:ped')
AddEventHandler('spawn:ped',function(coords,heading)
	local hash = GetHashKey('ig_trafficwarden')
	if not HasModelLoaded(hash) then
		RequestModel(hash)
		Wait(10)
	end
	while not HasModelLoaded(hash) do 
		Wait(10)
	end
    pedspawned = true
	npc = CreatePed(5, hash, coords, heading, false, false)
	FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
	loadAnimDict("amb@world_human_cop_idles@male@idle_b") 
	while not TaskPlayAnim(npc, "amb@world_human_cop_idles@male@idle_b", "idle_e", 8.0, 1.0, -1, 17, 0, 0, 0, 0) do
	Wait(1000)
	end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function closeMenuFull()
    exports['qb-menu']:closeMenu()
end

RegisterNetEvent('qb-policegarage:garage')
AddEventHandler('qb-policegarage:garage', function(pd)
    local vehicle = pd.vehicle
    local coords = { ['x'] = 431.32, ['y'] = -984.99, ['z'] = 25.7, ['h'] = 174.13 } -- 431.32, -984.99, 25.7
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetVehicleNumberPlateText(veh, "ZULU"..tostring(math.random(1000, 9999)))
        exports['qb-fuel']:SetFuel(veh, 100.0)
        SetEntityHeading(veh, coords.h)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)     
end)

RegisterNetEvent('qb-policegarage:storecar')
AddEventHandler('qb-policegarage:storecar', function()
QBCore.Functions.Notify('Vehicle Stored!')
local car = GetVehiclePedIsIn(PlayerPedId(),true)
DeleteVehicle(car)
DeleteEntity(car)
end)

RegisterNetEvent('garage:menu', function()
    exports['qb-menu']:openMenu({
        {
            header = "Police Garage",
            txt = ""
        },
        {
            header = "Charger",
            txt = "Police Charger",
            params = {
                event = "qb-policegarage:garage",
                args = {
                    vehicle = 'police',
                    
                }
            }
        },
        {
            header = "Store Vehicle",
            txt = "Store Vehicle Inside Garage",
            params = {
                event = "qb-policegarage:storecar",
                args = {
                    
                }
            }
        },
        {
            header = "Close (esc)",
            txt = "",
            params = {
                event = "qb-menu:closeMenu",
                args = {
                    
                }
            }
        },
        
    })
end)


