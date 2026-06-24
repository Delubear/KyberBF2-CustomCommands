
local AdminEnv = os.getenv("CUSTOM_COMMANDS_ADMINS") or ""
local AdminPlayerIds = {}
for admin in string.gmatch(AdminEnv, '([^,]+)') do
    table.insert(AdminPlayerIds, admin:match("^%s*(.-)%s*$"):lower())
end

local pluginPrefix <const> = "[Custom Commands] "

table.contains = function(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

string.split = function(str, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

EventManager.Listen("ServerPlayer:SendMessage", function(player, message)
    if message:len() < 2 then return end
    local messageSplit = string.split(message)

    if #messageSplit <= 0 then return end
    if messageSplit[1]:len() < 3 then return end
    if messageSplit[1]:sub(1, 1) ~= '!' and messageSplit[1]:sub(1, 1) ~= '/' then return end

    local command = messageSplit[1]:lower():sub(2)

    -- A command is attempted to be executed; dont send to everyone
    EventManager.SetCancelled(true)

    if command == "swapteam" or command == "swap" or command == "st" then
        if not player.isSpawned then
            player:SetTeam((math.fmod(player.team, 2)) + 1)
            Console.Execute(string.format("Kyber.Broadcast Player %s has swapped to team %d", player.name, player.team))
        else
            print(pluginPrefix .. string.format("Player %s attempted to swap teams while alive, but is not allowed to.", player.name))
        end
    elseif command == "skip" then
        if table.contains(AdminPlayerIds, tostring(player.playerId):lower()) then
            Console.Execute("Kyber.Broadcast Round skipped by admin " .. player.name)
            Console.Execute("Kyber.restart")
        else
            print(pluginPrefix .. string.format("Player %s attempted to skip the round, but is not an admin.", player.name))
        end
    elseif command == "givepoints" or command == "gp" then
        if table.contains(AdminPlayerIds, tostring(player.playerId):lower()) then
            if #messageSplit >= 3 then
                local targetPlayerName = messageSplit[2]
                local points = tonumber(messageSplit[3])
                if points then
                    targetPlayer = PlayerManager.GetPlayer(targetPlayerName)
                    targetPlayer:GiveBattlepoints(points)
                    Console.Execute(string.format("Kyber.Broadcast Admin %s gave %d points to %s", player.name, points, targetPlayerName))
                else
                    Console.Execute(string.format("Kyber.Broadcast Invalid points value. Usage: /givepoints playerName points"))
                end
            else
                local points = tonumber(messageSplit[2]) or 4000
                if points then
                    Console.Execute(string.format("Kyber.Broadcast Admin %s gave %d points to %s", player.name, points, player.name))
                    player:GiveBattlepoints(points)
                end
            end
        else
            print(pluginPrefix .. string.format("Player %s attempted to add points, but is not an admin.", player.name))
        end
    else
        return
    end

    -- A command was successfully executed
end)
