--!strict
-- Place DracoUI.luau in ReplicatedStorage as a ModuleScript named DracoUI,
-- then require it from a LocalScript.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DracoUI = require(ReplicatedStorage:WaitForChild("DracoUI"))

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
