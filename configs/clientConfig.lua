local ready = false
Status = {Visual = {}, Specific = {}}

AddEventHandler("ooc_core:playerloaded", function()
	if ready then
		return
	end
	
	TriggerServerEvent("plouffe_status:sendConfig")
end)

RegisterNetEvent("plouffe_status:getConfig",function(list)
	if not list then
		while true do
			Status = nil
		end
	else
		for k,v in pairs(list) do
			Status[k] = v
		end

		Status:Start()
	end
end)