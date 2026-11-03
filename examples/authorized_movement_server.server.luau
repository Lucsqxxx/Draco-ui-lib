--!strict
-- Put this Script in ServerScriptService in an experience you own.
-- Replace the example user ID with your authorized developer/admin ID.
-- Server validation is required; do not trust a LocalScript permission check.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AUTHORIZED_USER_IDS: {[number]: boolean} = {
    [123456789] = true,
}

local event = ReplicatedStorage:FindFirstChild("DracoAuthorizedMovement")
if not event then
    event = Instance.new("RemoteEvent")
    event.Name = "DracoAuthorizedMovement"
    event.Parent = ReplicatedStorage
end

local function authorized(player: Player): boolean
    return AUTHORIZED_USER_IDS[player.UserId] == true
end

local function setWalkSpeed(player: Player, value: unknown)
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local speed = math.clamp(tonumber(value) or 16, 8, 32)
    humanoid.WalkSpeed = speed
end

event.OnServerEvent:Connect(function(player, action, value)
    if not authorized(player) then return end

    if action == "WalkSpeed" then
        setWalkSpeed(player, value)
    elseif action == "ResetMovement" then
        setWalkSpeed(player, 16)
    elseif action == "Fly" or action == "Noclip" then
        warn(("%s requested %s; no server handler is installed."):format(player.Name, action))
    end
end)
