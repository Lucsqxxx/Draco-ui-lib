--!strict
-- Live theme and responsive-layout showcase for compatible loadstring runtimes.

local URL = "https://raw.githubusercontent.com/Lucsqxxx/Draco-ui-lib/main/Draco.lua"
local fetched, sourceOrError = pcall(function() return game:HttpGet(URL) end)
assert(fetched and type(sourceOrError) == "string" and #sourceOrError > 0,
    "Draco download failed: " .. tostring(sourceOrError))
assert(type(loadstring) == "function", "This example requires loadstring")
local chunk, compileError = loadstring(sourceOrError)
assert(type(chunk) == "function", "Draco compilation failed: " .. tostring(compileError))
local loaded, DracoOrError = pcall(chunk)
assert(loaded and type(DracoOrError) == "table" and DracoOrError.IsDracoUI,
    "Draco initialization failed: " .. tostring(DracoOrError))
local Draco = DracoOrError

local Window = Draco:CreateWindow({
    Title = "Draco Theme Showcase",
    Subtitle = "Live themes and responsive layout",
    Theme = "System",
    Persist = true,
    PersistenceKey = "ThemeShowcase",
    Responsive = true,
    Resizable = true,
})

local Main = Window:CreateTab({ Name = "Preview", Icon = "monitor" })
Main:CreateSection({ Name = "Controls", Icon = "settings" })
Main:CreateParagraph({
    Name = "Try every theme",
    Description = "Theme changes apply immediately. Resize the panel or rotate the screen to preview responsive behavior.",
})

local Appearance = Window:CreateTab({ Name = "Appearance", Icon = "palette" })
Appearance:CreateSection({ Name = "Themes", Icon = "sparkles" })

Appearance:CreateDropdown({
    Name = "Theme",
    Options = { "System", "Mono", "Purple", "Blue", "Light", "Ocean", "Crimson", "AMOLED" },
    Default = "System",
    Callback = function(value)
        Window:SetTheme(value)
        Window:Notify({
            Title = "Theme changed",
            Description = tostring(value),
            Type = "success",
            Duration = 2,
        })
    end,
})

Appearance:CreateToggle({
    Name = "Reduced motion",
    Description = "Use this option when animation is distracting or expensive.",
    Default = false,
    Callback = function(value)
        Window:Notify({
            Title = "Reduced motion",
            Description = value and "Enabled for the next window." or "Disabled for the next window.",
            Type = "info",
            Duration = 2,
        })
    end,
})

Appearance:CreateButton({
    Name = "Show notification states",
    Icon = "bell",
    Callback = function()
        Window:Notify({ Title = "Success", Description = "Everything is ready.", Type = "success" })
        Window:Notify({ Title = "Warning", Description = "This is a warning.", Type = "warning" })
        Window:Notify({ Title = "Error", Description = "This is an error.", Type = "error" })
    end,
})
