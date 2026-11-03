--!strict
-- Run this from a compatible client Luau environment that provides both
-- game:HttpGet and enabled loadstring. Standard Roblox Studio should use the
-- ModuleScript installation documented in README.md instead.

local URL = "https://raw.githubusercontent.com/Lucsqxxx/Draco-ui-lib/main/Draco.lua"
local fetched, sourceOrError = pcall(function()
    return game:HttpGet(URL)
end)
assert(fetched and type(sourceOrError) == "string" and #sourceOrError > 0,
    "Draco download failed: " .. tostring(sourceOrError))

local compile = loadstring
assert(type(compile) == "function", "Draco requires an environment with loadstring enabled")
local compiled, chunkOrError = pcall(compile, sourceOrError)
assert(compiled and type(chunkOrError) == "function",
    "Draco compilation failed: " .. tostring(chunkOrError))
local initialized, DracoOrError = pcall(chunkOrError)
assert(initialized and type(DracoOrError) == "table" and DracoOrError.IsDracoUI,
    "Draco initialization failed: " .. tostring(DracoOrError))
local DracoUI = DracoOrError

local Window = DracoUI:CreateWindow({
    Title = "Draco UI Lib",
    Subtitle = "Example Interface",
    Theme = "Purple",
    Size = UDim2.fromOffset(600, 420),
    ToggleKey = Enum.KeyCode.RightControl,
    Resizable = true,
})

local MainTab = Window:CreateTab({ Name = "Main", Icon = "circle" })
MainTab:CreateSection({ Name = "General", Icon = "settings" })

MainTab:CreateButton({
    Name = "Example Button",
    Description = "Execute an example action.",
    Callback = function()
        Window:Notify({
            Title = "Draco UI Lib",
            Description = "The button callback ran.",
            Duration = 3,
            Icon = "check",
        })
    end,
})

MainTab:CreateToggle({
    Name = "Example Toggle",
    Default = false,
    Callback = function(value) print("Toggle:", value) end,
})

MainTab:CreateSlider({
    Name = "Example Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Callback = function(value) print("Slider:", value) end,
})

MainTab:CreateDropdown({
    Name = "Example Dropdown",
    Options = { "Option 1", "Option 2", "Option 3" },
    Default = "Option 1",
    Callback = function(value) print("Selected:", value) end,
})

MainTab:CreateInput({
    Name = "Example Input",
    Placeholder = "Enter text...",
    Callback = function(value) print("Input:", value) end,
})

MainTab:CreateKeybind({
    Name = "Example Keybind",
    Default = Enum.KeyCode.P,
    Callback = function(key) print("Keybind:", key) end,
})

Window:Notify({
    Title = "Draco UI Lib",
    Description = "The interface is working!",
    Duration = 3,
})
