--!strict
-- Put this LocalScript in StarterPlayerScripts in an experience you own.
-- Install authorized_movement_server.server.luau in ServerScriptService first.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local URL = "https://raw.githubusercontent.com/Lucsqxxx/Draco-ui-lib/main/Draco.lua"
local fetched, sourceOrError = pcall(function()
    return game:HttpGet(URL)
end)
assert(fetched and type(sourceOrError) == "string" and #sourceOrError > 0,
    "Draco download failed: " .. tostring(sourceOrError))
assert(type(loadstring) == "function", "This example requires an explicitly supported loadstring runtime")
local chunk, compileError = loadstring(sourceOrError)
assert(type(chunk) == "function", "Draco compilation failed: " .. tostring(compileError))
local initialized, DracoOrError = pcall(chunk)
assert(initialized and type(DracoOrError) == "table" and DracoOrError.IsDracoUI,
    "Draco initialization failed: " .. tostring(DracoOrError))

local Draco = DracoOrError
local movementEvent = ReplicatedStorage:WaitForChild("DracoAuthorizedMovement")

local Window = Draco:CreateWindow({
    Title = "Authorized Movement Tools",
    Subtitle = "For your own Roblox experience",
    Theme = "Ocean",
    Responsive = true,
    ReducedMotion = true,
})

local tab = Window:CreateTab({ Name = "Movement", Icon = "move-vertical" })
tab:CreateSection({ Name = "Authorized controls", Icon = "shield-check" })

tab:CreateParagraph({
    Name = "Server-authorized only",
    Description = "The server decides who can use these controls. Replace the example user ID in the server script.",
})

tab:CreateSlider({
    Name = "WalkSpeed",
    Description = "Server clamps this value between 8 and 32.",
    Min = 8,
    Max = 32,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        movementEvent:FireServer("WalkSpeed", value)
    end,
})

tab:CreateButton({
    Name = "Reset movement",
    Icon = "refresh-cw",
    Callback = function()
        movementEvent:FireServer("ResetMovement")
        Window:Notify({
            Title = "Movement reset",
            Description = "The server restored WalkSpeed to 16.",
            Type = "success",
            Duration = 2,
        })
    end,
})

tab:CreateButton({
    Name = "Fly extension point",
    Icon = "wind",
    Callback = function()
        movementEvent:FireServer("Fly", true)
        Window:Notify({
            Title = "Server handler required",
            Description = "Fly is intentionally not implemented by this client template.",
            Type = "warning",
            Duration = 3,
        })
    end,
})

tab:CreateButton({
    Name = "Noclip extension point",
    Icon = "shield",
    Callback = function()
        movementEvent:FireServer("Noclip", true)
        Window:Notify({
            Title = "Server handler required",
            Description = "Noclip is intentionally not implemented by this client template.",
            Type = "warning",
            Duration = 3,
        })
    end,
})
