local cachedLicenses = {}

Citizen.CreateThread(function() 
    PerformHttpRequest("https://fivem.dk/defender/all", function(statusCode, text, headers)
        if statusCode == 200 or statusCode == 304 then
            if text ~= nil and text ~= "" then
                for i,k in pairs(json.decode(text)) do
                    for x,b in pairs(k) do
                        if x == "steam_id" or x == "xbox_id" or x == "live_id" or x == "license_id" or x == "discord_id" then
                            if b ~= "null" and b ~= nil then
                                table.insert(cachedLicenses, b)
                            end
                        end
                    end
                end
                print("[FiveM Defender] Cache has been loaded.")
            else
                print("[FiveM Defender] Failed to load cache.")
            end
        else
            print("[FiveM Defender] Failed to load cache.")
        end
    end, 'GET', '')
end)

local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local identifiers = GetPlayerIdentifiers(player)
    local found          = false

    deferrals.defer()

    Wait(0)
    deferrals.update("[FiveM Defender] Checking identifiers...")

    for k,v in pairs(identifiers) do
        print(v)
        for i,identifier in pairs(cachedLicenses) do
            if v == identifier then
                if not checkBypass(v) then
                    found = true
                    print("[FiveM Defender] " .. v .. " excluded due to confirmed modding.")
                    deferrals.done("[FiveM Defender] You are excluded from this server due to modding.")
                else
                    print('[FiveM Defender] ' .. v .. ' was a modder, but was allowed access to the server because you set them up in your bypass.')
                end
                break;
            end
        end
    end
    Wait(1000)
    if not found then deferrals.done() end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        PerformHttpRequest("https://fivem.dk/defender/version", function(err, text, headers)
            if text == '1.3' then
                print("[FiveM Defender] The script is up to date")
            else
                print("\27[31m [FiveM Defender] OUTDATED - Download newest version from: https://github.com/Ezague/FiveM-Defender-Script \27[0m")
            end
        end, 'GET', '')
    end
end)

function checkBypass(identifier)
    for k,v in pairs(Config.Bypass) do
        if v == identifier then
            return true
        end
    end
    return false
end
