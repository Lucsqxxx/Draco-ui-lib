# Draco UI Lib

Draco UI Lib is a reusable Roblox Luau UI library extracted from the glass-style
frontend in `idkMENU.luau`. It provides the same dark layout, animated tab bar,
sidebar sections, glass controls, scrolling pages, notifications, dragging,
collapsing, and optional resizing without including game automation logic.

## Runtime and installation

- Target runtime: Roblox client Luau through a `ModuleScript` and a `LocalScript`.
- Required Roblox services: `Players`, `TweenService`, `TextService`,
  `RunService`, and `UserInputService`.
- `gethui()` is optional. When available, the library uses it; otherwise it
  uses `CoreGui`.

For standard Roblox development, create a `ModuleScript` named `DracoUI` under
`ReplicatedStorage` and copy the contents of `DracoUI.luau` into it. The
loadstring example is in `examples/example.luau`; the ModuleScript API is shown
below.

## Loadstring distribution

`Draco.lua` is the generated, self-contained single-file distribution. In a
client environment that explicitly provides both `game:HttpGet` and enabled
`loadstring`, it can be loaded directly:

```lua
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
local Draco = DracoOrError

local Window = Draco:CreateWindow({
    Title = "Draco UI Lib",
})
```

The shorter equivalent is:

```lua
local Draco = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Lucsqxxx/Draco-ui-lib/main/Draco.lua"
))()
local Window = Draco:CreateWindow({ Title = "Draco UI Lib" })
```

This is not supported by ordinary Roblox Studio by default: `loadstring` is
disabled in normal client code, and HTTP access also depends on the runtime.
Use the ModuleScript installation above for standard Roblox development. Only
use the remote example in a permitted environment that explicitly supports the
required APIs.

The distribution returns the same `DracoUI` table as `require(DracoUI)`. It
does not fetch additional files, use `script` paths, or create a window while
being loaded; a window is created only when `CreateWindow` is called.

## Basic API

```lua
local DracoUI = require(game.ReplicatedStorage.DracoUI)
local window = DracoUI:CreateWindow({
    Title = "My Script",
    Subtitle = "Tools",
    Theme = "Purple", -- Mono, Purple, Blue, or a theme table
    Size = UDim2.fromOffset(600, 420),
    ToggleKey = Enum.KeyCode.RightControl,
    Resizable = true,
})
local tab = window:CreateTab({ Name = "Main", Icon = "circle" })
tab:CreateSection({ Name = "General", Icon = "settings" })
```

Controls accept `Name`/`Description`. `Title`/`Desc` and the older `Tab`,
`Section`, `Toggle`, `Slider`, `Dropdown`, `Keybind`, `Paragraph`, and `Button`
names are also accepted for incremental migration.

### Button and toggle

```lua
tab:CreateButton({
    Name = "Run",
    Description = "Run an action.",
    Icon = "play",
    Callback = function() print("clicked") end,
})

local toggle = tab:CreateToggle({
    Name = "Enabled",
    Default = false,
    Callback = function(value) print(value) end,
})
toggle:Set(true)
print(toggle:Get())
```

### Slider

```lua
tab:CreateSlider({
    Name = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Suffix = "%",
    Callback = function(value) print(value) end,
})
```

`Step` is an alias for `Increment`; values are clamped and snapped.

### Dropdown

```lua
local dropdown = tab:CreateDropdown({
    Name = "Mode",
    Options = { "Safe", "Fast", "Manual" },
    Default = "Safe",
    Callback = function(value) print(value) end,
})
dropdown:Select("Fast")
dropdown:Refresh({ "Safe", "Fast", "Manual", "Auto" })
```

Set `Multi = true` for multiple selections; the callback receives an array.
Long lists automatically receive a search box.

### Input and keybind

```lua
tab:CreateInput({
    Name = "Player name",
    Placeholder = "Enter a name...",
    Callback = function(value) print(value) end,
})
tab:CreateKeybind({
    Name = "Action key",
    Default = Enum.KeyCode.P,
    Callback = function(key) print(key) end,
})
```

Click a keybind to capture a key. `Escape` cancels and `Backspace` clears it.

### Paragraphs, groups, notifications, and cleanup

```lua
local paragraph = tab:CreateParagraph({ Name = "Status", Description = "Ready" })
paragraph:SetDescription("Running")
paragraph:SetDesc("The alias is supported too.")
tab:CreateGroup("Advanced")

window:Notify({
    Title = "Status",
    Description = "Saved successfully.",
    Icon = "check",
    Duration = 3,
})

window:Toggle()
window:Show()
window:Hide()
window:SelectTab("Main")
window:SetUIScale(0.9)
window:Destroy()
```

Destroying the window disconnects registered control/input connections and
removes its GUI. Recreating a window with the same `GuiName` removes the old
GUI first.

## Themes

Built-in themes are `Mono`, `Purple`, and `Blue`. Register a custom theme:

```lua
DracoUI:CreateTheme("Custom", {
    Primary = Color3.fromRGB(255, 100, 200),
    Accent = Color3.fromRGB(30, 10, 25),
})
local window = DracoUI:CreateWindow({ Theme = "Custom" })
```

Theme fields include `Background`, `Accent`, `Text`, `Placeholder`, `Muted`,
`Border`, `Divider`, `Field`, `Card`, `CardLine`, `Primary`, and `Radius`.

## Rebuilding the distribution

Edit `DracoUI.luau`, then regenerate and verify the committed artifact:

```bash
python3 tools/build_distribution.py
python3 tools/test_distribution.py --luau /path/to/luau
```

The build embeds a SHA-256 fingerprint of the source. The verifier fails when
`Draco.lua` is missing or stale and checks that the distribution has no local
`require`/`script` dependency, has the expected source fingerprint, and returns
the public API. `test_distribution.py` also compiles the artifact and runs a
Roblox-shaped Luau smoke test for loading, window creation, callbacks, and
reload cleanup. The smoke test does not replace an in-engine Roblox test.

After the checks pass, publish the generated artifact together with its source
and tooling. From the repository root:

```bash
git add Draco.lua DracoUI.luau README.md tools
git commit -m "feat: add loadstring distribution"
git push origin main
```

Then verify the exact raw URL before sharing it:

```bash
curl --fail --location \
  https://raw.githubusercontent.com/Lucsqxxx/Draco-ui-lib/main/Draco.lua \
  >/dev/null
```

## Relationship to the original script

`idkMENU.luau` is an application entry point. It contains game-specific state,
remote/event handling, automation loops, and the original embedded frontend.
`DracoUI.luau` contains only the reusable UI layer. It does not execute game
logic, remote calls, executor helpers, anti-cheat-sensitive features, or preset
storage.

The original file remains the legacy frontend entry point because this project
has no Roblox place tree or ModuleScript packaging metadata. Use
`examples/example.luau` as the isolated library consumer. Once the module is
installed in a Roblox place, the application's frontend can be replaced with
`require(DracoUI)` without moving its game-specific callbacks into the library.

## Known limitations

- This filesystem `.luau` file must be copied into a Roblox `ModuleScript` (or
  loaded by a compatible Luau runner).
- The optional `gethui()` path is guarded; standard Roblox uses `CoreGui`.
- Rendering, mouse/touch input, and Roblox instance behavior require an
  in-engine client test. The repository test covers parsing and a Roblox-shaped
  runtime smoke test, not actual rendering.
- Theme changes apply to newly created windows; existing windows keep their
  colors to avoid rebuilding live controls.

## Troubleshooting remote loading

- **HTTP failure:** verify the URL, repository visibility, branch name, and
  that the runtime permits outbound HTTP requests. Try opening the raw URL in a
  browser to confirm the file is published.
- **`loadstring` is nil:** the current runtime does not enable dynamic code
  loading. Use the ModuleScript integration instead; the library cannot enable
  this capability itself.
- **Compilation error:** ensure the fetched response is the contents of
  `Draco.lua`, not an HTML error page. Rebuild with
  `python3 tools/build_distribution.py` and run the verifier.
- **Initialization error:** check the runtime is a Roblox client and that the
  required services (`Players`, `TweenService`, `TextService`, `RunService`,
  and `UserInputService`) are available. Loading returns the API only; call
  `Draco:CreateWindow(...)` afterward.
- **Duplicate windows after reload:** call `Window:Destroy()` before manually
  reloading old code. `CreateWindow` also destroys the library's prior active
  window and disconnects its tracked connections.
