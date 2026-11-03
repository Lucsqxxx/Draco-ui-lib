-- Roblox-like smoke harness used by tools/test_distribution.py.
-- It deliberately models only the APIs needed to exercise initialization,
-- window creation, callbacks, and cleanup. Rendering still needs Roblox.

local function signal()
    local value = { Connections = {} }
    function value:Connect(callback)
        local connection = { Connected = true, Callback = callback }
        function connection:Disconnect()
            self.Connected = false
        end
        table.insert(self.Connections, connection)
        return connection
    end
    function value:Once(callback)
        local connection
        connection = self:Connect(function(...)
            if connection.Connected then
                connection:Disconnect()
                callback(...)
            end
        end)
        return connection
    end
    function value:Fire(...)
        for _, connection in ipairs(self.Connections) do
            if connection.Connected then
                connection.Callback(...)
            end
        end
    end
    return value
end

local function vector2(x, y)
    return setmetatable({ X = x or 0, Y = y or 0 }, {
        __sub = function(left, right) return vector2(left.X - right.X, left.Y - right.Y) end,
        __div = function(left, right) return vector2(left.X / right, left.Y / right) end,
    })
end

local function enumType(name)
    return setmetatable({}, {
        __index = function(self, key)
            local item = { Name = key, EnumType = name, __enumItem = true }
            rawset(self, key, item)
            return item
        end,
    })
end

local Enum = {
    Font = enumType("Font"),
    KeyCode = enumType("KeyCode"),
    UserInputType = enumType("UserInputType"),
    EasingStyle = enumType("EasingStyle"),
    EasingDirection = enumType("EasingDirection"),
    AutomaticSize = enumType("AutomaticSize"),
    SortOrder = enumType("SortOrder"),
    FillDirection = enumType("FillDirection"),
    HorizontalAlignment = enumType("HorizontalAlignment"),
    VerticalAlignment = enumType("VerticalAlignment"),
    TextXAlignment = enumType("TextXAlignment"),
    TextTruncate = enumType("TextTruncate"),
    ZIndexBehavior = enumType("ZIndexBehavior"),
}

local function fakeColor(r, g, b)
    local color = { R = r or 0, G = g or 0, B = b or 0 }
    function color:Lerp(other, alpha)
        return fakeColor(
            self.R + (other.R - self.R) * alpha,
            self.G + (other.G - self.G) * alpha,
            self.B + (other.B - self.B) * alpha
        )
    end
    return color
end

local Color3 = {
    fromRGB = function(r, g, b) return fakeColor(r / 255, g / 255, b / 255) end,
    new = function(r, g, b) return fakeColor(r, g, b) end,
}

local function udim(scale, offset)
    return { Scale = scale or 0, Offset = offset or 0 }
end

local UDim = { new = function(scale, offset) return udim(scale, offset) end }
local UDim2 = {
    fromOffset = function(x, y) return { X = udim(0, x), Y = udim(0, y) } end,
    fromScale = function(x, y) return { X = udim(x, 0), Y = udim(y, 0) } end,
    new = function(xs, xo, ys, yo) return { X = udim(xs, xo), Y = udim(ys, yo) } end,
}

local Vector2 = { new = function(x, y) return vector2(x, y) end }
local NumberSequence = { new = function(value) return value end }
local NumberSequenceKeypoint = { new = function(time, value) return { Time = time, Value = value } end }
local TweenInfo = { new = function(...) return { ... } end }

local eventNames = {
    MouseEnter = true, MouseLeave = true, MouseButton1Click = true,
    InputBegan = true, InputChanged = true, InputEnded = true,
    FocusLost = true,
}

local instanceMethods = {}
local function makeInstance(className)
    local object = {
        ClassName = className,
        Name = className,
        Children = {},
        _signals = {},
        _destroyed = false,
        AbsoluteSize = vector2(640, 420),
        AbsolutePosition = vector2(0, 0),
    }
    setmetatable(object, {
        __index = function(self, key)
            if instanceMethods[key] then return instanceMethods[key] end
            if eventNames[key] then
                self._signals[key] = self._signals[key] or signal()
                return self._signals[key]
            end
            return nil
        end,
        __newindex = function(self, key, value)
            if key == "Parent" then
                local old = rawget(self, "_parent")
                if old then
                    for index, child in ipairs(old.Children) do
                        if child == self then table.remove(old.Children, index) break end
                    end
                end
                rawset(self, "_parent", value)
                if value then table.insert(value.Children, self) end
            else
                rawset(self, key, value)
            end
        end,
    })
    return object
end

function instanceMethods:GetChildren()
    return self.Children
end

function instanceMethods:GetPropertyChangedSignal(name)
    self._signals[name] = self._signals[name] or signal()
    return self._signals[name]
end

function instanceMethods:Destroy()
    if self._destroyed then return end
    self._destroyed = true
    for _, child in ipairs(self.Children) do
        child:Destroy()
    end
    table.clear(self.Children)
    self.Parent = nil
end

function instanceMethods:FindFirstChild(name, recursive)
    for _, child in ipairs(self.Children) do
        if child.Name == name then return child end
        if recursive then
            local nested = child:FindFirstChild(name, true)
            if nested then return nested end
        end
    end
    return nil
end

local Instance = {
    new = function(className) return makeInstance(className) end,
}

local host = makeInstance("CoreGui")
local camera = makeInstance("Camera")
camera.ViewportSize = vector2(1000, 700)
local services = {
    Players = { LocalPlayer = makeInstance("Player") },
    RunService = { RenderStepped = signal() },
    UserInputService = {
        InputBegan = signal(), InputChanged = signal(), InputEnded = signal(),
        GetMouseLocation = function() return vector2(0, 0) end,
    },
    CoreGui = host,
}

services.TweenService = {
    Create = function(_, target, _, goal)
        local animation = { Completed = signal() }
        function animation:Play()
            for key, value in pairs(goal) do target[key] = value end
        end
        return animation
    end,
}
services.TextService = {
    GetTextBoundsAsync = function(_, params) return vector2(#tostring(params.Text or "") * 7, 14) end,
}

local game = {
    GetService = function(_, name)
        if name == "CoreGui" then return host end
        if name == "TweenService" or name == "TextService" then return services[name] end
        return services[name]
    end,
    HttpGet = function(_, url)
        assert(url == "https://raw.githubusercontent.com/Lucsqxxx/Draco-ui-lib/main/Draco.lua")
        return DISTRIBUTION
    end,
}
local workspace = { CurrentCamera = camera }

local environment = getfenv()
environment.Enum = Enum
environment.Color3 = Color3
environment.UDim = UDim
environment.UDim2 = UDim2
environment.Vector2 = Vector2
environment.NumberSequence = NumberSequence
environment.NumberSequenceKeypoint = NumberSequenceKeypoint
environment.TweenInfo = TweenInfo
environment.Instance = Instance
environment.game = game
environment.workspace = workspace
environment.task = {
    spawn = function(callback, ...) callback(...) end,
    defer = function(callback, ...) callback(...) end,
    delay = function() end,
    wait = function() end,
}
environment.typeof = function(value)
    return type(value) == "table" and value.__enumItem and "EnumItem" or type(value)
end

local function assertApi(api)
    assert(type(api) == "table" and api.IsDracoUI == true, "distribution did not return Draco API")
    assert(type(api.CreateWindow) == "function", "Draco API is missing CreateWindow")
end

local function run(source)
    local compile, compileError = loadstring(source)
    assert(compile, "distribution failed to compile: " .. tostring(compileError))
    local ok, api = pcall(compile)
    assert(ok, "distribution failed to initialize: " .. tostring(api))
    assertApi(api)

    local callbackCount = 0
    local window = api:CreateWindow({ Title = "Smoke Test" })
    local tab = window:CreateTab({ Name = "Main", Icon = "circle" })
    tab:CreateSection({ Name = "General" })
    local button = tab:CreateButton({ Callback = function() callbackCount += 1 end })
    local toggle = tab:CreateToggle({ Default = false, Callback = function() callbackCount += 1 end })
    local slider = tab:CreateSlider({ Min = 0, Max = 10, Default = 1, Callback = function() callbackCount += 1 end })
    local dropdown = tab:CreateDropdown({ Options = { "A", "B" }, Default = "A", Callback = function() callbackCount += 1 end })
    local input = tab:CreateInput({ Default = "ready", Callback = function() callbackCount += 1 end })
    local keybind = tab:CreateKeybind({ Default = Enum.KeyCode.P })
    local paragraph = tab:CreateParagraph({ Description = "Ready" })

    assert(host:FindFirstChild("DracoUI") ~= nil, "window was not parented")
    assert(toggle:Get() == false, "toggle default failed")
    toggle:Set(true)
    slider:Set(7)
    dropdown:Select("B")
    input:Set("done", true)
    paragraph:SetDescription("Updated")
    keybind:Set(Enum.KeyCode.Q, false)
    assert(toggle:Get() == true and slider:Get() == 7, "component setters failed")
    assert(dropdown:Get() == "B" and input:Get() == "done", "component values failed")
    assert(callbackCount >= 4, "component callbacks did not run")
    assert(type(button.Destroy) == "function", "button component is invalid")

    window:Destroy()
    assert(host:FindFirstChild("DracoUI") == nil, "window cleanup failed")

    local second = api:CreateWindow({ Title = "Second" })
    local otherApiChunk = assert(loadstring(source))
    local okOther, otherApi = pcall(otherApiChunk)
    assert(okOther, "second load failed: " .. tostring(otherApi))
    local third = otherApi:CreateWindow({ Title = "Third" })
    assert(second.Gui.Parent == nil, "reloading did not destroy the previous window")
    assert(host:FindFirstChild("DracoUI") == third.Gui, "reload created an unexpected GUI")
    third:Destroy()
    assert(host:FindFirstChild("DracoUI") == nil, "reloaded window cleanup failed")
end

local fetched = game:HttpGet("https://raw.githubusercontent.com/Lucsqxxx/Draco-ui-lib/main/Draco.lua")
assert(type(fetched) == "string" and #fetched > 0, "HTTP retrieval returned no source")
run(fetched)
print("Luau smoke test passed")
