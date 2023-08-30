-- Thankyou for downloading my script. Join my RP server today at: discord.gg/resolutionnetworks!
-- ~ Mysto

-- NOTE I HAVE CODED IN A FUNCTION WHERE THE CAMERA LOCKS ONTO THE PLAYER AND THEY DON'T HAVE THE FREEDOM TO LOOK AROUND
-- SIMPLY UNCOMMENT THE FUNCTIONS IN RELATION TO TRUNKCAM AND THEIR RELATIVE CALLS TO KEEP THIS FEATURE IN. IF NOT, PLAYER
-- CAN LOOK AROUND EVERYWHERE WHEN IN THE TRUNK.
 
--█░█ ▄▀█ █▀█ █ ▄▀█ █▄▄ █░░ █▀▀ █▀   ▄▀█ █▄░█ █▀▄   █▀▀ █▀█ █▄░█ █▀ ▀█▀ ▄▀█ █▄░█ ▀█▀ █▀
--▀▄▀ █▀█ █▀▄ █ █▀█ █▄█ █▄▄ ██▄ ▄█   █▀█ █░▀█ █▄▀   █▄▄ █▄█ █░▀█ ▄█ ░█░ █▀█ █░▀█ ░█░ ▄█

local inTrunk = false

--█▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█ █▀
--█▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█ ▄█

-- uncomment this function if you want the camera to lock onto the player
--[[local cam = nil 
function trunkCam()
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        local plyPed = PlayerPedId()
        SetCamCoord(cam, GetEntityCoords(plyPed))
        SetCamRot(cam, 0.0, 0.0, 0.0)
        SetCamActive(cam,  true)
        RenderScriptCams(true,  false,  0,  true,  true)
        SetCamCoord(cam, GetEntityCoords(plyPed))
    end
    AttachCamToEntity(cam, PlayerPedId(), 0.0, -2.5, 1.0, true)
    SetCamRot(cam, -30.0, 0.0, GetEntityHeading(PlayerPedId()))
end]]

-- uncomment this function if you want the camera to lock onto the player
--[[function disableCam()
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
end]]

function getInTrunk(veh)
    local model = GetEntityModel(veh)
    if not DoesVehicleHaveDoor(veh, 6) and DoesVehicleHaveDoor(veh, 5) and IsThisModelACar(model) then
        SetVehicleDoorOpen(veh, 5, 1)
        local plyPed = PlayerPedId()

        local d1,d2 = GetModelDimensions(model)

        local trunkDic = "fin_ext_p1-7"
        local trunkAnim = "cs_devin_dual-7"
        LoadAnimDict(trunkDic)

        SetBlockingOfNonTemporaryEvents(plyPed, true)                   
        DetachEntity(plyPed)
        ClearPedTasks(plyPed)
        ClearPedSecondaryTask(plyPed)
        ClearPedTasksImmediately(plyPed)
        TaskPlayAnim(plyPed, trunkDic, trunkAnim, 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)

        AttachEntityToEntity(plyPed, veh, 0, -0.1,d1["y"]+0.85,d2["z"]-0.87, 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
        inTrunk = true
        trunkVeh = veh

        TriggerEvent('QBCore:Notify', 'You are in the trunk. Press "F" to get out.', 'success', 5000)

        while inTrunk do
            -- Make sure to uncomment the below call as well if you are wanting to use the trunk feature.
            --trunkCam()
            Citizen.Wait(0)

            if IsControlJustReleased(0, 23) then
                inTrunk = false
                SetVehicleDoorShut(veh, 5, false)  
            end

            if not IsEntityPlayingAnim(plyPed, trunkDic, trunkAnim, 3) then
                TaskPlayAnim(plyPed, trunkDic, trunkAnim, 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
            end

            if not DoesEntityExist(veh) then
                inTrunk = false
            end
        end

        RemoveAnimDict(trunkDic)
        SetVehicleDoorOpen(veh, 5, 1, 0)
        -- Make sure to uncomment the below call as well if you are wanting to use the trunk feature.
        --disableCam()
        DetachEntity(plyPed)
        Citizen.Wait(10)

        if DoesEntityExist(veh) then 
            local dropPosition = GetOffsetFromEntityInWorldCoords(veh, 0.0,d1["y"]-0.6,0.0)
            SetEntityCoords(plyPed,dropPosition["x"],dropPosition["y"],dropPosition["z"])
        else
            ClearPedTasks(plyPed)
            local plyCoords = GetEntityCoords(plyPed)
            SetEntityCoords(plyped, plyCoords.x, plyCoords.y, plyCoords.x+2)
        end

        trunkVeh = nil
    end
end


function VehicleInFront()
    local plyPed = PlayerPedId()
    local pos = GetEntityCoords(plyPed)
    local entityWorld = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 3.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, plyPed, 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
   -- Simple print statements to ensure that the script is functioning as it should. No need to uncomment this.
    --[[if result then 
        print("Detected vehicle: " .. GetEntityModel(result)) 
    else 
        print("No vehicle detected") 
    end]]
    return result
end

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do RequestAnimDict(dict) Citizen.Wait(5); end
end

--█▀▀ █░█ █▀▀ █▄░█ ▀█▀   █░█ ▄▀█ █▄░█ █▀▄ █░░ █▀▀ █▀█ █▀
--██▄ ▀▄▀ ██▄ █░▀█ ░█░   █▀█ █▀█ █░▀█ █▄▀ █▄▄ ██▄ █▀▄ ▄█

RegisterNetEvent('mysto_hideintrunk:open')
AddEventHandler('mysto_hideintrunk:open', function(entity)
    if GetEntityType(entity) == 2 then
        SetCarBootOpen(entity)
    end
end)

RegisterNetEvent('mysto_hideintrunk:hide')
AddEventHandler('mysto_hideintrunk:hide', function(entity)
    if GetEntityType(entity) == 2 then
        getInTrunk(entity)
    end
end)

--█▀▀ ▀▄▀ █▀█ █▀█ █▀█ ▀█▀ █▀
--██▄ █░█ █▀▀ █▄█ █▀▄ ░█░ ▄█

exports('getIntoTrunk', function(vehicle)
    getInTrunk(vehicle)
end)