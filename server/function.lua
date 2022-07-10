local Auth = exports.plouffe_lib:Get("Auth")
local Utils = exports.plouffe_lib:Get("Utils")
local Callback = exports.plouffe_lib:Get("Callback")

local cache = {}
local uniques = {}

setmetatable(uniques, {
    __newindex = function(self,k,v)
        rawset(self, k, v)
        rawset(cache, v, {})
    end
})

setmetatable(cache, {
    __index = uniques,

    __call = function(self, playerId)
        local identifier = self[playerId]

        if not identifier then
            return
        end

        return self[identifier] or {}
    end
})

function Status.Restart()
    Wait(3000)
    local players = GetPlayers()

    for k,v in pairs(players) do
        local playerId = tonumber(v)
        local registred, key = Auth:Register(playerId)
        local data = Status:Get()

        data.auth = key
        data.Current = Status.LoadPlayerData(playerId)

        TriggerClientEvent("plouffe_status:getConfig", playerId, data)
    end
end

function Status.Load()
    local playerId = source
    local registred, key = Auth:Register(playerId)

    if registred then
        local data = Status:Get()

        data.auth = key
        data.Current = Status.LoadPlayerData(playerId)

        TriggerClientEvent("plouffe_status:getConfig",playerId, data)
    else
        TriggerClientEvent("plouffe_status:getConfig",playerId,nil)
    end
end

function Status:Get()
    local data = {}
    for k,v in pairs(self) do
        if type(v) ~= "function" then
            data[k] = v
        end
    end

    return data
end

function Status.SetUnique(playerId, unique)
    uniques[playerId] = unique
end
exports("SetUnique", Status.SetUnique)

function Status.LoadPlayerData(playerId)
    local identifier = cache[playerId]

    if not identifier then
        return
    end

    local data = json.decode(GetResourceKvpString(("status_%s"):format(identifier))) or {
        status = {
            Hunger = 1000,
            Thirst = 1000,
            Stress = 0,
            Fatigue = 0,
            Drunk = 0,
            Drug = 0,
            Armour = 0,
            Health = 200
        }
    }

    cache[identifier] = data

    return data
end

function Status.SavePlayerData(playerId)
    local identifier = cache[playerId]
    local data = cache(playerId)
    SetResourceKvp(("status_%s"):format(identifier), json.encode(data))

    cache[identifier] = nil
end

function Status.PlayerDroped(playerId, reason)
    if uniques[playerId] then
        Status.SavePlayerData(playerId)
    end
end

function Status.Set(playerId, key, val)
    local identifier = cache[playerId]

    if not identifier or not key then
        return print(("Player %s has a nil value identifier: %s key: %s"):format(playerId, identifier, key))
    end

    cache[identifier][key] = val
end

function Status.SetDead(auth, state)
    local playerId = source

    if not Auth:Validate(playerId, auth) then
        return
    end

    Status.Set(playerId, "dead", state)
end

function Status.UpdateStatus(auth,status)
    local playerId = source

    if not Auth:Validate(playerId, auth) then
        return
    end

    Status.Set(playerId, "status", status)
end

function Status.UpdateSkills(auth,skills)
    local playerId = source

    if not Auth:Validate(playerId, auth) then
        return
    end

    Status.Set(playerId, "skills", skills)
end

function Status.Bill(auth)
    local playerId = source

    if not Auth:Validate(playerId, auth) then
        return
    end

    exports.plouffe_society:Bill(playerId, {
        label = "Hopital",
        reason = "Hopital - Soins",
        amount = 250
    })
end

function Status.RemoveItem(item, amount)
    local playerId = source
    exports.ox_inventory:RemoveItem(playerId, item, amount)
end

function Status.UseSpecific(playerId, data)
    if data.name == "cigar_pack" then
        local description = data.metadata and  data.metadata.description or data.description
        local one, two = 10, (description:len() - 8)
        local amountLeft = description:sub(one, two)

        amountLeft = tonumber(amountLeft)

        if not amountLeft or amountLeft and amountLeft <= 0 then
            return exports.ox_inventory:RemoveItem(playerId,data.name,1,nil,data.slot)
        end

        amountLeft -= 1

        local metadata = data.metadata or {}
        metadata.description = ("Contiens %s cigares"):format(amountLeft)

        if amountLeft <= 0 then
            exports.ox_inventory:RemoveItem(playerId,data.name,1,nil,data.slot)
        end

        exports.ox_inventory:SetMetadata(playerId, data.slot, metadata)
        exports.ox_inventory:AddItem(playerId, "cigar", 1)
    elseif data.name == "cigarette_pack" then
        local description = data.metadata and  data.metadata.description or data.description
        local one, two = 10, (description:len() - 10)
        local amountLeft = description:sub(one, two)

        amountLeft = tonumber(amountLeft)

        if not amountLeft or amountLeft and amountLeft <= 0 then
            return exports.ox_inventory:RemoveItem(playerId,data.name,1,nil,data.slot)
        end

        amountLeft -= 1

        local metadata = data.metadata or {}
        metadata.description = ("Contiens %s cigarette"):format(amountLeft)

        if amountLeft <= 0 then
            exports.ox_inventory:RemoveItem(playerId,data.name,1,nil,data.slot)
        end

        exports.ox_inventory:SetMetadata(playerId, data.slot, metadata)
        exports.ox_inventory:AddItem(playerId, "cigarette", 1)
    end
end
exports("UseSpecific", Status.UseSpecific)

function Status.RevivePlayer(playerId)
    Callback:ClientCallback(playerId, "plouffe_status:revive", 5000, function()
        Status.Set(playerId, "dead", false)
    end)
end
exports("RevivePlayer", Status.RevivePlayer)

function Status.HealPlayer(playerId)
    Callback:ClientCallback(playerId, "plouffe_status:heal", 5000, function(status)
        Status.Set(playerId, "status", status)
    end)
end
exports("HealPlayer", Status.HealPlayer)

function Status.SetStatus(playerId, key, val)
    Callback:ClientCallback(playerId, "plouffe_status:setStatus", 5000, function(status)
        Status.Set(playerId, "status", status)
    end, {key = key, val = val})
end
exports("SetStatus", Status.SetStatus)

function Status.RollWeed(auth, slot)
    local playerId = source

    if not Auth:Validate(playerId, auth) then
        return
    end

    local data = exports.ox_inventory:GetSlot(playerId, slot)
    local ouncebag = exports.ox_inventory:Search(playerId, "count", "ouncebag")

    if data.count > ouncebag then
        return Utils:Notify(playerId, ("Vous avez besoin de %s ziplock"):format(data.count))
    end

    exports.ox_inventory:RemoveItem(playerId, "weed", data.count, nil, slot)
    exports.ox_inventory:RemoveItem(playerId, "ouncebag", data.count)
    exports.ox_inventory:AddItem(playerId, "ounceweed", data.count)
end