RegisterNetEvent("plouffe_status:sendConfig", Status.Load)
RegisterNetEvent("plouffe_status:setPlayerDead", Status.SetDead)

RegisterNetEvent("plouffe_status:updateSkills", Status.UpdateSkills)
RegisterNetEvent("plouffe_status:updateStatus", Status.UpdateStatus)

RegisterNetEvent("plouffe_status:payForCare", Status.Bill)

RegisterNetEvent("plouffe_status:removeItem", Status.RemoveItem)

RegisterNetEvent("plouffe_status:rollWeed", Status.RollWeed)

AddEventHandler("playerDroped", Status.PlayerDroped)

AddEventHandler('playerDropped', function(reason)
    local playerId = source
    Status.PlayerDroped(playerId, reason)
end)

CreateThread(Status.Restart)