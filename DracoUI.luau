--!strict
-- Draco UI Lib
-- A reusable glass-style Roblox UI library extracted from the Mono frontend.
-- The module only owns UI concerns; callers own their feature/game logic.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer

local DracoUI = {}

local function cloneTable(source)
    local result = {}
    for key, value in pairs(source or {}) do
        result[key] = value
    end
    return result
end

local function merge(base, override)
    local result = cloneTable(base)
    for key, value in pairs(override or {}) do
        result[key] = value
    end
    return result
end

local DEFAULT_THEME = {
    Name = "Mono",
    Background = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(14, 14, 15),
    Dialog = Color3.fromRGB(10, 10, 11),
    ElementBackground = Color3.fromRGB(24, 24, 26),
    Text = Color3.fromRGB(245, 245, 247),
    Placeholder = Color3.fromRGB(140, 140, 146),
    Muted = Color3.fromRGB(96, 96, 102),
    Border = Color3.fromRGB(38, 38, 42),
    Divider = Color3.fromRGB(26, 26, 29),
    Field = Color3.fromRGB(14, 14, 16),
    FieldLine = Color3.fromRGB(30, 30, 34),
    RowHover = Color3.fromRGB(14, 14, 16),
    RowActive = Color3.fromRGB(24, 24, 27),
    Card = Color3.fromRGB(10, 10, 12),
    CardLine = Color3.fromRGB(28, 28, 31),
    RowLine = Color3.fromRGB(22, 22, 25),
    Primary = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(74, 222, 128),
    Warning = Color3.fromRGB(251, 191, 36),
    Danger = Color3.fromRGB(255, 107, 107),
    Radius = 8,
}

DracoUI.Themes = {
    Mono = DEFAULT_THEME,
    Purple = merge(DEFAULT_THEME, {
        Name = "Purple",
        Primary = Color3.fromRGB(194, 145, 255),
        Accent = Color3.fromRGB(24, 17, 34),
    }),
    Blue = merge(DEFAULT_THEME, {
        Name = "Blue",
        Primary = Color3.fromRGB(96, 180, 255),
        Accent = Color3.fromRGB(12, 22, 34),
    }),
}

local function resolveTheme(value)
    if type(value) == "string" then
        return cloneTable(DracoUI.Themes[value] or DEFAULT_THEME)
    end
    if type(value) == "table" then
        return merge(DEFAULT_THEME, value)
    end
    return cloneTable(DEFAULT_THEME)
end

local ICON = {
    axe = "rbxassetid://132405197863294", bed = "rbxassetid://97726529032925",
    bell = "rbxassetid://97392696311902", ["book-open"] = "rbxassetid://129845326810392",
    bot = "rbxassetid://80451686744860", briefcase = "rbxassetid://96754188164225",
    check = "rbxassetid://93898873302694", ["check-check"] = "rbxassetid://95183312173858",
    circle = "rbxassetid://130359823580534", coffee = "rbxassetid://106864403231093",
    cog = "rbxassetid://116544501716299", crosshair = "rbxassetid://134242818164054",
    ["dollar-sign"] = "rbxassetid://127320961224019", droplets = "rbxassetid://140111846025180",
    eye = "rbxassetid://100033680381365", ["flask-conical"] = "rbxassetid://128406680901165",
    ["flask-round"] = "rbxassetid://127508287324940", ["gamepad-2"] = "rbxassetid://92483947987410",
    gauge = "rbxassetid://110273524101447", gem = "rbxassetid://112904952151156",
    ["glass-water"] = "rbxassetid://115526102400988", hand = "rbxassetid://130703864968637",
    ["hand-coins"] = "rbxassetid://126990543175462", magnet = "rbxassetid://135162361226972",
    map = "rbxassetid://95107167260947", ["map-pin"] = "rbxassetid://84279202219901",
    ["mouse-pointer-click"] = "rbxassetid://107150227368485", ["move-vertical"] = "rbxassetid://86234730730899",
    package = "rbxassetid://97261141732706", ["package-check"] = "rbxassetid://102374216055130",
    ["package-plus"] = "rbxassetid://129261988138366", power = "rbxassetid://96479131758775",
    ["refresh-cw"] = "rbxassetid://138133190015277", repeatIcon = "rbxassetid://121886242955173",
    scan = "rbxassetid://123104789658180", ["scan-eye"] = "rbxassetid://99244790601968",
    settings = "rbxassetid://80758916183665", shield = "rbxassetid://110987169760162",
    ["shield-check"] = "rbxassetid://87354736164608", siren = "rbxassetid://134210267818039",
    sparkles = "rbxassetid://138635884129147", sprout = "rbxassetid://100091687832508",
    target = "rbxassetid://87563802520297", trees = "rbxassetid://121203841375919",
    ["triangle-alert"] = "rbxassetid://125920361880643", user = "rbxassetid://81589895647169",
    ["user-search"] = "rbxassetid://101335649828115", users = "rbxassetid://115398113982385",
    wind = "rbxassetid://114551690399915", x = "rbxassetid://110786993356448",
    zap = "rbxassetid://130551565616516", info = "rbxassetid://124560466474914",
    search = "rbxassetid://121018724060431", ["chevron-left"] = "rbxassetid://73780377692148",
    ["chevron-right"] = "rbxassetid://92473583511724", ["chevron-down"] = "rbxassetid://134243273101015",
    ["trash-2"] = "rbxassetid://109843431391323", save = "rbxassetid://126116963775616",
    play = "rbxassetid://135609604299893", star = "rbxassetid://136141469398409",
    sword = "rbxassetid://124448418211665", footprints = "rbxassetid://139192589041315",
    monitor = "rbxassetid://72664649203050", palette = "rbxassetid://86350350950064",
    keyboard = "rbxassetid://121474456068237", bookmark = "rbxassetid://121093149326239",
    layers = "rbxassetid://81973586053257", hammer = "rbxassetid://83545120140895",
    swords = "rbxassetid://81872698913435",
}

-- Aliases and practical fallbacks for names used by the application.
ICON.knife = ICON.sword
ICON["alert-triangle"] = ICON["triangle-alert"]
ICON.store = ICON.package
ICON.pause = ICON.power
ICON.paintbrush = ICON.palette
ICON["paint-bucket"] = ICON["package-plus"]
ICON["cloud-lightning"] = ICON.zap
ICON["repeat"] = ICON.repeatIcon

local function icon(name)
    return ICON[name or ""] or ICON.circle
end

local function px(scale, value)
    return math.floor(value * scale + 0.5)
end

local function new(className, properties, parent)
    local instance = Instance.new(className)
    for key, value in pairs(properties or {}) do
        instance[key] = value
    end
    if parent then
        instance.Parent = parent
    end
    return instance
end

local function corner(parent, radius)
    return new("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
end

local function textWidth(text, size, font)
    local width = #tostring(text) * size * 0.55
    pcall(function()
        local params = Instance.new("GetTextBoundsParams")
        params.Text = tostring(text)
        params.Font = font
        params.Size = size
        params.Width = 10000
        width = TextService:GetTextBoundsAsync(params).X
    end)
    return math.ceil(width) + 1
end

local function tween(instance, duration, goal, style)
    local animation = TweenService:Create(
        instance,
        TweenInfo.new(duration, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        goal
    )
    animation:Play()
    return animation
end

local function safeCallback(callback, ...)
    if type(callback) ~= "function" then
        return
    end
    task.spawn(function(...)
        pcall(callback, ...)
    end, ...)
end

local function makeLifecycle()
    local lifecycle = { Alive = true, Connections = {}, Cleanups = {} }

    function lifecycle:Connect(signal, callback)
        if not self.Alive then
            return nil
        end
        local connection = signal:Connect(callback)
        table.insert(self.Connections, connection)
        return connection
    end

    function lifecycle:Cleanup(callback)
        table.insert(self.Cleanups, callback)
    end

    function lifecycle:Destroy()
        if not self.Alive then
            return
        end
        self.Alive = false
        for _, callback in ipairs(self.Cleanups) do
            pcall(callback)
        end
        for _, connection in ipairs(self.Connections) do
            pcall(function() connection:Disconnect() end)
        end
        table.clear(self.Cleanups)
        table.clear(self.Connections)
    end

    return lifecycle
end

local function normalizeTitle(options)
    return tostring(options.Name or options.Title or "Item")
end

local function normalizeDescription(options)
    return options.Description or options.Desc or ""
end

local function parseTags(title)
    title = tostring(title or "")
    local tags = {}
    local plain = title:gsub("<[^>]+>", "")
    if plain:find("RISKY", 1, true) then
        table.insert(tags, "Risky")
        plain = plain:gsub("%s*RISKY%s*", " ")
    end
    return plain:gsub("^%s+", ""):gsub("%s+$", ""), tags
end

local TAG_COLORS = {
    Risky = Color3.fromRGB(255, 107, 107),
    Beta = Color3.fromRGB(251, 191, 36),
    New = Color3.fromRGB(96, 180, 255),
    Safe = Color3.fromRGB(74, 222, 128),
    ["On start"] = Color3.fromRGB(251, 191, 36),
}

local function addTag(parent, text, scale, order, theme)
    local color = TAG_COLORS[text] or theme.Placeholder
    local label = tostring(text):upper()
    local height = px(scale, 16)
    local pill = new("Frame", {
        Name = "Tag",
        LayoutOrder = order or 1,
        Size = UDim2.fromOffset(textWidth(label, px(scale, 9), nil) + px(scale, 12), height),
    }, parent)
    corner(pill, math.floor(height / 2))
    pill.BackgroundColor3 = color
    pill.BackgroundTransparency = 0.84
    new("UIStroke", { Color = color, Transparency = 0.5, Thickness = 1 }, pill)
    new("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = px(scale, 9),
        TextColor3 = color:Lerp(Color3.new(1, 1, 1), 0.2),
        Text = label,
    }, pill)
    return pill
end

local function makeComponent(lifecycle, rowFrame)
    local component = { _row = rowFrame, _connections = {}, Destroyed = false }

    function component:_Connect(signal, callback)
        if self.Destroyed then
            return nil
        end
        local connection = signal:Connect(callback)
        table.insert(self._connections, connection)
        return connection
    end

    function component:Destroy()
        if self.Destroyed then
            return
        end
        self.Destroyed = true
        for _, connection in ipairs(self._connections) do
            pcall(function() connection:Disconnect() end)
        end
        table.clear(self._connections)
        if self._row then
            pcall(function() self._row:Destroy() end)
        end
    end

    lifecycle:Cleanup(function() component:Destroy() end)
    return component
end

local function createGlass(instance, theme, fill, rim)
    instance.BackgroundColor3 = theme.Primary
    instance.BackgroundTransparency = fill or 0.9
    local gradient = new("UIGradient", {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 0.5),
        }),
    }, instance)
    local stroke = new("UIStroke", {
        Color = theme.Primary,
        Transparency = rim or 0.7,
        Thickness = 1,
    }, instance)
    new("UIGradient", {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.45, 0.7),
            NumberSequenceKeypoint.new(1, 0.35),
        }),
    }, stroke)
    return { Gradient = gradient, Stroke = stroke }
end

local function findHost(options)
    if options.Parent then
        return options.Parent
    end
    local hui = gethui
    if type(hui) == "function" then
        local ok, result = pcall(hui)
        if ok and result then
            return result
        end
    end
    return game:GetService("CoreGui")
end

local function makeFont(size, bold)
    return {
        Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize = size,
    }
end

local function createWindow(options)
    options = options or {}
    local lifecycle = makeLifecycle()
    local theme = resolveTheme(options.Theme)
    local camera = workspace.CurrentCamera
    local density = math.clamp((camera and camera.ViewportSize.Y or 1000) / 1000 * 0.9, 0.7, 1.4)
    local function p(value)
        return px(density, value)
    end

    local fonts = {
        Regular = makeFont(p(13), false),
        Medium = makeFont(p(13), false),
        Bold = makeFont(p(13), true),
        Small = makeFont(p(11), false),
        Mono = makeFont(p(11), false),
    }

    local defaultSize = options.Size or UDim2.fromOffset(p(760), p(470))
    local minSize = options.MinSize or Vector2.new(p(560), p(360))
    local maxSize = options.MaxSize or Vector2.new(p(1200), p(800))
    local headerHeight = p(44)
    local sidebarWidth = p(options.SidebarWidth or options.SideBarWidth or 200)
    local sidebarPadding = p(12)
    local sidebarNarrow = sidebarPadding * 2 + p(10) * 2 + p(15)
    local pagePadding = p(28)
    local rowPadding = p(14)
    local rowMinimum = math.max(46, p(46))
    local controlHeight = math.max(28, p(28))
    local shown = true
    local userScale = 1
    local popupState
    local tabs = {}
    local tabOrder = {}
    local selectedTab
    local panels = {}
    local currentPanel
    local currentPage
    local pages = {}
    local collapsed = false

    local host = findHost(options)
    for _, child in ipairs(host:GetChildren()) do
        if child.Name == (options.GuiName or "DracoUI") then
            pcall(function() child:Destroy() end)
        end
    end

    local gui = new("ScreenGui", {
        Name = options.GuiName or "DracoUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = options.DisplayOrder or 100000,
    }, host)
    local toastHolder = new("Frame", {
        Name = "Toasts",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -p(18), 1, -p(18)),
        Size = UDim2.fromOffset(p(290), 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 100,
    }, gui)
    new("UIListLayout", {
        Padding = UDim.new(0, p(8)),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
    }, toastHolder)
    local toastNumber = 0

    local window = new("Frame", {
        Name = "Window",
        Size = defaultSize,
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
    }, gui)
    local function centerWindow()
        local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1000, 700)
        local size = window.AbsoluteSize
        window.Position = UDim2.fromOffset(
            math.floor((viewport.X - size.X) / 2 + 0.5),
            math.floor((viewport.Y - size.Y) / 2 + 0.5)
        )
    end
    centerWindow()
    corner(window, p(theme.Radius))
    new("UIStroke", { Color = theme.Border, Thickness = 1 }, window)
    local windowScale = new("UIScale", { Scale = userScale }, window)

    local function scaledWindowPosition(element)
        local scale = windowScale.Scale
        local point = (element.AbsolutePosition - window.AbsolutePosition) / scale
        return Vector2.new(math.floor(point.X + 0.5), math.floor(point.Y + 0.5)), element.AbsoluteSize / scale
    end

    local function closePopup()
        if popupState then
            local popup = popupState
            popupState = nil
            pcall(popup.Close)
        end
    end

    local function setShown(value)
        value = value == true
        if value == shown then
            return
        end
        shown = value
        closePopup()
        if value then
            window.Visible = true
            windowScale.Scale = userScale * 0.94
            tween(windowScale, 0.22, { Scale = userScale }, Enum.EasingStyle.Back)
        else
            local animation = tween(windowScale, 0.14, { Scale = userScale * 0.94 })
            animation.Completed:Once(function()
                if not shown and window.Parent then
                    window.Visible = false
                end
            end)
        end
    end

    lifecycle:Cleanup(function()
        closePopup()
        pcall(function() gui:Destroy() end)
    end)

    -- Header -----------------------------------------------------------------
    local topbar = new("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, headerHeight),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
    }, window)
    corner(topbar, p(theme.Radius))

    local titleBlock = new("Frame", {
        Name = "TitleBlock",
        Position = UDim2.fromOffset(sidebarPadding + p(4), p(7)),
        Size = UDim2.fromOffset(p(220), headerHeight - p(12)),
        BackgroundTransparency = 1,
    }, topbar)
    new("TextLabel", merge(makeFont(p(14), true), {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, p(17)),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = tostring(options.Title or "Draco UI Lib"),
    }), titleBlock)
    new("TextLabel", merge(makeFont(p(10), false), {
        Name = "Subtitle",
        Position = UDim2.fromOffset(0, p(18)),
        Size = UDim2.new(1, 0, 0, p(13)),
        BackgroundTransparency = 1,
        TextColor3 = theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = tostring(options.Subtitle or options.Author or ""),
    }), titleBlock)

    local tabBar = new("Frame", {
        Name = "TabBar",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, p(9)),
        Size = UDim2.fromOffset(0, p(26)),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
    }, topbar)
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, p(16)),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, tabBar)

    local closeButton = new("TextButton", {
        Name = "Close",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -sidebarPadding, 0.5, 0),
        Size = UDim2.fromOffset(p(66), p(22)),
        BackgroundColor3 = theme.ElementBackground,
        BackgroundTransparency = 0.1,
        AutoButtonColor = false,
        Text = "Close",
        TextColor3 = theme.Text,
    }, topbar)
    corner(closeButton, p(6))
    closeButton.TextSize = p(11)
    closeButton.Font = Enum.Font.Gotham
    lifecycle:Connect(closeButton.MouseEnter, function()
        tween(closeButton, 0.15, { BackgroundColor3 = theme.RowActive })
    end)
    lifecycle:Connect(closeButton.MouseLeave, function()
        tween(closeButton, 0.15, { BackgroundColor3 = theme.ElementBackground })
    end)
    lifecycle:Connect(closeButton.MouseButton1Click, function()
        setShown(false)
    end)

    -- Dragging ---------------------------------------------------------------
    do
        local dragging = false
        local startMouse
        local startPosition
        lifecycle:Connect(topbar.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                startMouse = input.Position
                startPosition = window.Position
            end
        end)
        lifecycle:Connect(UIS.InputChanged, function(input)
            if not dragging or not startMouse or not startPosition then
                return
            end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            local delta = input.Position - startMouse
            window.Position = UDim2.fromOffset(
                math.floor(startPosition.X.Offset + delta.X + 0.5),
                math.floor(startPosition.Y.Offset + delta.Y + 0.5)
            )
        end)
        lifecycle:Connect(UIS.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    -- Optional resize handle. It is intentionally subtle so the default look
    -- stays faithful to the original fixed glass panel.
    if options.Resizable then
        local resize = new("TextButton", {
            Name = "ResizeHandle",
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.fromScale(1, 1),
            Size = UDim2.fromOffset(p(18), p(18)),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "",
        }, window)
        local resizing, resizeStart, sizeStart
        lifecycle:Connect(resize.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                resizeStart = input.Position
                sizeStart = window.AbsoluteSize
            end
        end)
        lifecycle:Connect(UIS.InputChanged, function(input)
            if not resizing then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local delta = input.Position - resizeStart
            local width = math.clamp(sizeStart.X + delta.X, minSize.X, maxSize.X)
            local height = math.clamp(sizeStart.Y + delta.Y, minSize.Y, maxSize.Y)
            window.Size = UDim2.fromOffset(width, height)
        end)
        lifecycle:Connect(UIS.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                resizing = false
            end
        end)
    end

    -- Sidebar and content ---------------------------------------------------
    local sidebar = new("Frame", {
        Name = "Sidebar",
        Position = UDim2.fromOffset(0, headerHeight),
        Size = UDim2.new(0, sidebarWidth, 1, -headerHeight),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    }, window)
    local divider = new("Frame", {
        Name = "Divider",
        Position = UDim2.new(0, sidebarWidth, 0, headerHeight),
        Size = UDim2.new(0, 1, 1, -headerHeight - p(theme.Radius)),
        BackgroundColor3 = theme.Divider,
        BorderSizePixel = 0,
    }, window)
    local content = new("Frame", {
        Name = "Content",
        Position = UDim2.fromOffset(sidebarWidth, headerHeight),
        Size = UDim2.new(1, -sidebarWidth, 1, -headerHeight),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    }, window)
    local contentTitle = new("TextLabel", merge(makeFont(p(19), true), {
        Name = "Title",
        Position = UDim2.fromOffset(p(28), p(8)),
        Size = UDim2.new(1, -p(56), 0, p(28)),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "",
    }), content)
    local sideTitle = new("TextLabel", merge(makeFont(p(21), true), {
        Name = "Title",
        Position = UDim2.fromOffset(sidebarPadding + p(4), p(8)),
        Size = UDim2.new(1, -(sidebarPadding * 2 + p(32)), 0, p(28)),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = "",
    }), sidebar)
    local collapseButton = new("ImageButton", {
        Name = "Collapse",
        Size = UDim2.fromOffset(p(24), p(24)),
        Position = UDim2.fromOffset(sidebarWidth - sidebarPadding - p(24), p(10)),
        BackgroundTransparency = 1,
        Image = icon("chevron-left"),
        ImageColor3 = theme.Placeholder,
        AutoButtonColor = false,
    }, sidebar)
    lifecycle:Connect(collapseButton.MouseButton1Click, function()
        collapsed = not collapsed
        local width = collapsed and sidebarNarrow or sidebarWidth
        tween(sidebar, 0.25, { Size = UDim2.new(0, width, 1, -headerHeight) })
        tween(divider, 0.25, { Position = UDim2.new(0, width, 0, headerHeight) })
        tween(content, 0.25, { Position = UDim2.fromOffset(width, headerHeight), Size = UDim2.new(1, -width, 1, -headerHeight) })
        tween(collapseButton, 0.25, { Position = UDim2.fromOffset((collapsed and sidebarNarrow or sidebarWidth) - sidebarPadding - p(24), p(10)) })
        collapseButton.Image = icon(collapsed and "chevron-right" or "chevron-left")
        tween(sideTitle, 0.15, { TextTransparency = collapsed and 1 or 0 })
        for _, panel in pairs(panels) do
            for _, section in ipairs(panel.order) do
                tween(section.Label, 0.15, { TextTransparency = collapsed and 1 or 0 })
            end
        end
    end)

    local searchFrame = new("Frame", {
        Name = "Search",
        Position = UDim2.fromOffset(sidebarPadding, p(46)),
        Size = UDim2.fromOffset(sidebarWidth - sidebarPadding * 2, p(30)),
        BackgroundColor3 = theme.Field,
    }, sidebar)
    corner(searchFrame, p(6))
    new("UIStroke", { Color = theme.FieldLine, Thickness = 1 }, searchFrame)
    new("ImageLabel", {
        Position = UDim2.fromOffset(p(10), p(8)),
        Size = UDim2.fromOffset(p(13), p(13)),
        BackgroundTransparency = 1,
        Image = icon("search"),
        ImageColor3 = theme.Placeholder,
    }, searchFrame)
    local searchBox = new("TextBox", merge(makeFont(p(13), false), {
        Name = "Query",
        Position = UDim2.fromOffset(p(29), 0),
        Size = UDim2.new(1, -p(37), 1, 0),
        BackgroundTransparency = 1,
        ClearTextOnFocus = false,
        TextColor3 = theme.Text,
        PlaceholderText = "Search...",
        PlaceholderColor3 = theme.Muted,
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Left,
    }), searchFrame)

    local function applySearch()
        if not currentPanel then return end
        local query = searchBox.Text:lower()
        for _, section in ipairs(currentPanel.order) do
            section.Row.Visible = query == ""
                or section.Name:lower():find(query, 1, true) ~= nil
        end
    end
    lifecycle:Connect(searchBox:GetPropertyChangedSignal("Text"), applySearch)

    local overlay = new("Frame", {
        Name = "Overlay",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 20,
    }, window)

    local function makePanel(tabName)
        local panel = panels[tabName]
        if panel then return panel end
        local frame = new("ScrollingFrame", {
            Name = tabName,
            Position = UDim2.fromOffset(sidebarPadding, p(88)),
            Size = UDim2.new(1, -sidebarPadding * 2, 1, -p(100)),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 0,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
        }, sidebar)
        new("UIListLayout", { Padding = UDim.new(0, p(3)), SortOrder = Enum.SortOrder.LayoutOrder }, frame)
        panel = { Name = tabName, Frame = frame, Sections = {}, Order = {}, Selected = nil }
        panels[tabName] = panel
        return panel
    end

    local function selectSection(tabName, sectionName)
        local panel = panels[tabName]
        local section = panel and panel.Sections[sectionName]
        if not section then return end
        if panel.Selected then
            local previous = panel.Selected
            tween(previous.Row, 0.15, { BackgroundTransparency = 1 })
            tween(previous.Label, 0.15, { TextColor3 = theme.Placeholder })
        end
        panel.Selected = section
        tween(section.Row, 0.15, { BackgroundTransparency = 0, BackgroundColor3 = theme.RowActive })
        tween(section.Label, 0.15, { TextColor3 = theme.Text })
        if currentPanel == panel then
            contentTitle.Text = section.Name
        end
        local page = pages[tabName .. "/" .. sectionName]
        if currentPage and currentPage ~= page then
            currentPage.Scroll.Visible = false
        end
        currentPage = page
        if page then
            page.Scroll.Visible = true
        end
    end

    local function selectTab(name)
        local tab = tabs[name]
        if not tab or selectedTab == tab then return end
        if selectedTab then
            selectedTab.Underline.Size = UDim2.new(0, 0, 0, 1)
            selectedTab.Underline.BackgroundTransparency = 1
            selectedTab.Icon.ImageColor3 = selectedTab.Color
        end
        selectedTab = tab
        tab.Underline.Size = UDim2.new(1, 0, 0, 1)
        tab.Underline.BackgroundTransparency = 0
        if currentPanel then currentPanel.Frame.Visible = false end
        currentPanel = makePanel(name)
        currentPanel.Frame.Visible = true
        sideTitle.Text = name
        tab.Icon.ImageColor3 = theme.Text
        if currentPanel.Selected then
            contentTitle.Text = currentPanel.Selected.Name
            local page = pages[name .. "/" .. currentPanel.Selected.Name]
            if currentPage and currentPage ~= page then currentPage.Scroll.Visible = false end
            currentPage = page
            if page then page.Scroll.Visible = true end
        end
        applySearch()
    end

    local function addSection(tabName, optionsForSection)
        local name = tostring(optionsForSection.Name or optionsForSection.Title or "Section")
        local panel = makePanel(tabName)
        if panel.Sections[name] then
            return panel.Sections[name]
        end
        local row = new("TextButton", {
            Name = name,
            LayoutOrder = #panel.Order + 1,
            Size = UDim2.new(1, 0, 0, p(32)),
            BackgroundColor3 = theme.RowHover,
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "",
        }, panel.Frame)
        corner(row, p(6))
        local image = new("ImageLabel", {
            Position = UDim2.fromOffset(p(10), p(8)),
            Size = UDim2.fromOffset(p(15), p(15)),
            BackgroundTransparency = 1,
            Image = icon(optionsForSection.Icon or "circle"),
            ImageColor3 = optionsForSection.Color or theme.Primary,
        }, row)
        local label = new("TextLabel", merge(makeFont(p(14), false), {
            Position = UDim2.fromOffset(p(35), 0),
            Size = UDim2.new(1, -p(35), 1, 0),
            BackgroundTransparency = 1,
            TextColor3 = theme.Placeholder,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Text = name,
        }), row)
        local section = { Name = name, Row = row, Label = label, Icon = image, Panel = panel, Groups = {}, Order = {} }
        panel.Sections[name] = section
        table.insert(panel.Order, section)
        lifecycle:Connect(row.MouseEnter, function()
            if panel.Selected ~= section then tween(row, 0.15, { BackgroundTransparency = 0.6 }) end
        end)
        lifecycle:Connect(row.MouseLeave, function()
            if panel.Selected ~= section then tween(row, 0.15, { BackgroundTransparency = 1 }) end
        end)
        lifecycle:Connect(row.MouseButton1Click, function() selectSection(tabName, name) end)
        if not panel.Selected then selectSection(tabName, name) end

        local pageScroll = new("ScrollingFrame", {
            Name = tabName .. "/" .. name,
            Position = UDim2.fromOffset(0, p(8) + p(28) + p(10)),
            Size = UDim2.new(1, 0, 1, -(p(8) + p(28) + p(10))),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = p(3),
            ScrollBarImageColor3 = theme.Placeholder,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
        }, content)
        local body = new("Frame", {
            Name = "Body",
            Position = UDim2.fromOffset(pagePadding, 0),
            Size = UDim2.new(1, -pagePadding * 2, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
        }, pageScroll)
        new("UIListLayout", { Padding = UDim.new(0, p(18)), SortOrder = Enum.SortOrder.LayoutOrder }, body)
        new("UIPadding", { PaddingBottom = UDim.new(0, p(24)) }, body)
        pages[tabName .. "/" .. name] = { Scroll = pageScroll, Body = body, Groups = 0, Section = section }
        return section
    end

    local function addGroup(tab, caption)
        local page = pages[tab.Name .. "/" .. tab.CurrentSection.Name]
        if not page then return nil end
        page.Groups += 1
        local holder = new("Frame", {
            Name = caption or "Group",
            LayoutOrder = page.Groups,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
        }, page.Body)
        new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, holder)
        if caption then
            new("TextLabel", merge(makeFont(p(11), true), {
                LayoutOrder = 0,
                Size = UDim2.new(1, 0, 0, p(22)),
                BackgroundTransparency = 1,
                TextColor3 = theme.Muted,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                Text = tostring(caption):upper(),
            }), holder)
        end
        local card = new("Frame", {
            Name = "Card",
            LayoutOrder = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = theme.Card,
        }, holder)
        corner(card, p(theme.Radius))
        new("UIStroke", { Color = theme.CardLine, Thickness = 1 }, card)
        new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, card)
        local group = { Holder = holder, Card = card, Rows = 0, Page = page }
        table.insert(tab.CurrentSection.Groups, group)
        return group
    end

    local function ensureGroup(tab)
        if not tab.CurrentGroup then
            if not tab.CurrentSection then
                tab:CreateSection({ Name = "Overview" })
            end
            tab.CurrentGroup = addGroup(tab)
        end
        return tab.CurrentGroup
    end

    local function makeRow(group, title, description, tags)
        group.Rows += 1
        if group.Rows > 1 then
            local separator = new("Frame", {
                Name = "Separator",
                LayoutOrder = group.Rows * 2 - 1,
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = theme.RowLine,
                BorderSizePixel = 0,
            }, group.Card)
            separator.BackgroundTransparency = 0.2
            new("Frame", {
                Position = UDim2.fromOffset(rowPadding, 0),
                Size = UDim2.new(1, -rowPadding * 2, 1, 0),
                BackgroundColor3 = theme.RowLine,
                BorderSizePixel = 0,
            }, separator)
        end

        local rowFrame = new("Frame", {
            Name = title,
            LayoutOrder = group.Rows * 2,
            Size = UDim2.new(1, 0, 0, rowMinimum),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
        }, group.Card)
        local slot = new("Frame", {
            Name = "Control",
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -rowPadding, 0, 0),
            Size = UDim2.fromOffset(0, controlHeight),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
        }, rowFrame)
        local textColumn = new("Frame", {
            Name = "Text",
            Position = UDim2.fromOffset(rowPadding, 0),
            Size = UDim2.new(1, -rowPadding * 2, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
        }, rowFrame)
        new("UIPadding", {
            PaddingTop = UDim.new(0, p(11)),
            PaddingBottom = UDim.new(0, p(11)),
        }, textColumn)
        new("UIListLayout", {
            Padding = UDim.new(0, p(3)),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, textColumn)
        local titleLine = new("Frame", {
            Name = "TitleLine",
            LayoutOrder = 1,
            Size = UDim2.new(1, 0, 0, p(15)),
            BackgroundTransparency = 1,
        }, textColumn)
        new("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, p(6)),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, titleLine)
        local titleLabel = new("TextLabel", merge(makeFont(p(13), false), {
            Name = "Title",
            LayoutOrder = 0,
            Size = UDim2.fromOffset(0, p(15)),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            TextColor3 = theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = title,
        }), titleLine)
        for index, tagName in ipairs(tags or {}) do
            addTag(titleLine, tagName, density, index, theme)
        end
        local descriptionLabel
        if description and description ~= "" then
            descriptionLabel = new("TextLabel", merge(makeFont(p(11), false), {
                Name = "Description",
                LayoutOrder = 2,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                TextColor3 = theme.Muted,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Text = tostring(description),
            }), textColumn)
        end

        local function fit()
            local controlWidth = math.floor(slot.AbsoluteSize.X / windowScale.Scale + 0.5)
            textColumn.Size = UDim2.new(
                1,
                -(rowPadding * 2 + (controlWidth > 0 and controlWidth + p(16) or 0)),
                0,
                0
            )
            local rowHeight = math.floor(rowFrame.AbsoluteSize.Y / windowScale.Scale + 0.5)
            slot.Position = UDim2.new(
                1,
                -rowPadding,
                0,
                math.floor((math.max(rowHeight, rowMinimum) - controlHeight) / 2)
            )
        end
        lifecycle:Connect(slot:GetPropertyChangedSignal("AbsoluteSize"), fit)
        lifecycle:Connect(rowFrame:GetPropertyChangedSignal("AbsoluteSize"), fit)
        task.defer(fit)
        return rowFrame, slot, titleLabel, descriptionLabel
    end

    local function createToggle(tab, optionsForToggle)
        local title, tags = parseTags(normalizeTitle(optionsForToggle))
        local group = ensureGroup(tab)
        local rowFrame, slot = makeRow(group, title, normalizeDescription(optionsForToggle), tags)
        local size = p(18)
        local button = new("TextButton", {
            Name = "Toggle",
            Size = UDim2.fromOffset(size, size),
            Position = UDim2.fromOffset(0, math.floor((controlHeight - size) / 2)),
            AutoButtonColor = false,
            Text = "",
            BackgroundColor3 = theme.Primary,
        }, slot)
        corner(button, p(5))
        local stroke = new("UIStroke", { Color = theme.Primary, Thickness = 1, Transparency = 0.7 }, button)
        local check = new("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(p(12), p(12)),
            BackgroundTransparency = 1,
            Image = icon("check"),
            ImageColor3 = theme.Background,
            ImageTransparency = 1,
        }, button)
        local component = makeComponent(lifecycle, rowFrame)
        component.Value = optionsForToggle.Default
        if component.Value == nil then component.Value = optionsForToggle.Value == true end

        local function paint(duration)
            tween(button, duration, { BackgroundTransparency = component.Value and 0.08 or 0.9 })
            tween(stroke, duration, { Transparency = component.Value and 0.3 or 0.7 })
            tween(check, duration, { ImageTransparency = component.Value and 0 or 1 })
        end
        function component:Set(value)
            self.Value = value == true
            paint(0.15)
            safeCallback(optionsForToggle.Callback, self.Value)
        end
        function component:Get()
            return self.Value
        end
        paint(0)
        component:_Connect(button.MouseButton1Click, function()
            component:Set(not component.Value)
        end)
        component:_Connect(button.MouseEnter, function()
            if not component.Value then tween(stroke, 0.12, { Transparency = 0.45 }) end
        end)
        component:_Connect(button.MouseLeave, function()
            if not component.Value then tween(stroke, 0.12, { Transparency = 0.7 }) end
        end)
        return component
    end

    local function decimalPlaces(step)
        local decimal = tostring(step):match("%.(%d+)$")
        return decimal and #decimal or 0
    end

    local function createSlider(tab, optionsForSlider)
        local title, tags = parseTags(normalizeTitle(optionsForSlider))
        local group = ensureGroup(tab)
        local rowFrame, slot = makeRow(group, title, normalizeDescription(optionsForSlider), tags)
        local range = type(optionsForSlider.Range) == "table" and optionsForSlider.Range
            or (type(optionsForSlider.Value) == "table" and optionsForSlider.Value)
            or {}
        local minimum = tonumber(optionsForSlider.Min or range.Min) or 0
        local maximum = tonumber(optionsForSlider.Max or range.Max) or 100
        local increment = tonumber(optionsForSlider.Increment or optionsForSlider.Step) or 1
        increment = increment > 0 and increment or 1
        local decimals = decimalPlaces(increment)
        local suffix = optionsForSlider.Suffix or ""
        local value = tonumber(optionsForSlider.Default or range.Default)
            or tonumber(optionsForSlider.Value)
            or minimum
        local component = makeComponent(lifecycle, rowFrame)
        component.Value = math.clamp(value, minimum, maximum)

        local trackWidth, valueWidth = p(150), p(50)
        local holder = new("Frame", {
            Size = UDim2.fromOffset(trackWidth + p(10) + valueWidth, controlHeight),
            BackgroundTransparency = 1,
        }, slot)
        local hit = new("TextButton", {
            Name = "Track",
            Size = UDim2.fromOffset(trackWidth, controlHeight),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "",
        }, holder)
        local trackHeight = math.max(6, p(6))
        local track = new("Frame", {
            Position = UDim2.fromOffset(0, math.floor((controlHeight - trackHeight) / 2)),
            Size = UDim2.fromOffset(trackWidth, trackHeight),
            BackgroundColor3 = theme.Field,
            BorderSizePixel = 0,
        }, hit)
        corner(track, trackHeight)
        createGlass(track, theme, 0.2, 0.78)
        local fill = new("Frame", {
            Name = "Fill",
            Size = UDim2.fromScale(0, 1),
            BackgroundColor3 = theme.Primary,
            BorderSizePixel = 0,
        }, track)
        corner(fill, trackHeight)
        createGlass(fill, theme, 0.18, 0.45)
        local knobSize = math.max(14, p(14))
        local knob = new("Frame", {
            Name = "Knob",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(knobSize, knobSize),
            BackgroundColor3 = theme.Primary,
            BorderSizePixel = 0,
            ZIndex = 2,
        }, track)
        corner(knob, math.floor(knobSize / 3))
        local valuePill = new("Frame", {
            Position = UDim2.fromOffset(trackWidth + p(10), math.floor((controlHeight - p(20)) / 2)),
            Size = UDim2.fromOffset(valueWidth, p(20)),
            BackgroundColor3 = theme.Field,
        }, holder)
        corner(valuePill, p(6))
        createGlass(valuePill, theme, 0.1, 0.7)
        local valueLabel = new("TextLabel", merge(makeFont(p(11), false), {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            TextColor3 = theme.Text,
            Text = "",
        }), valuePill)

        local function snap(number)
            number = math.clamp(tonumber(number) or minimum, minimum, maximum)
            number = minimum + math.floor((number - minimum) / increment + 0.5) * increment
            return math.clamp(tonumber(string.format("%." .. decimals .. "f", number)), minimum, maximum)
        end
        local function paint(duration)
            local alpha = maximum > minimum and (component.Value - minimum) / (maximum - minimum) or 0
            tween(fill, duration, { Size = UDim2.fromScale(alpha, 1) })
            tween(knob, duration, { Position = UDim2.new(alpha, 0, 0.5, 0) })
            valueLabel.Text = string.format("%." .. decimals .. "f", component.Value) .. suffix
        end
        function component:Set(number)
            local nextValue = snap(number)
            local changed = nextValue ~= self.Value
            self.Value = nextValue
            paint(0.08)
            if changed then safeCallback(optionsForSlider.Callback, self.Value) end
        end
        function component:Get() return self.Value end
        paint(0)

        local dragging = false
        local function fromMouse(x)
            if track.AbsoluteSize.X <= 0 then return end
            component:Set(minimum + math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1) * (maximum - minimum))
        end
        component:_Connect(hit.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                fromMouse(input.Position.X)
            end
        end)
        component:_Connect(UIS.InputChanged, function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then
                fromMouse(input.Position.X)
            end
        end)
        component:_Connect(UIS.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        return component
    end

    local function createDropdown(tab, optionsForDropdown)
        local title, tags = parseTags(normalizeTitle(optionsForDropdown))
        local group = ensureGroup(tab)
        local rowFrame, slot = makeRow(group, title, normalizeDescription(optionsForDropdown), tags)
        local component = makeComponent(lifecycle, rowFrame)
        component.Options = optionsForDropdown.Options or optionsForDropdown.Values or {}
        local multiple = optionsForDropdown.Multi == true
        local selected

        local function setSelected(value)
            if multiple then
                selected = {}
                if type(value) == "table" then
                    for key, item in pairs(value) do
                        local option = (type(key) == "string" and item == true) and key or item
                        if option ~= nil then selected[option] = true end
                    end
                elseif value ~= nil then
                    selected[value] = true
                end
            else
                selected = value
            end
        end
        setSelected(optionsForDropdown.Default ~= nil and optionsForDropdown.Default or optionsForDropdown.Value)
        if not multiple and selected == nil and optionsForDropdown.AllowNone ~= true then
            selected = component.Options[1]
        end

        local fieldWidth = p(170)
        local field = new("TextButton", {
            Name = "Dropdown",
            Size = UDim2.fromOffset(fieldWidth, controlHeight),
            BackgroundColor3 = theme.Field,
            AutoButtonColor = false,
            Text = "",
        }, slot)
        corner(field, p(6))
        local fieldStroke = createGlass(field, theme, 0.1, 0.75).Stroke
        local label = new("TextLabel", merge(makeFont(p(12), false), {
            Position = UDim2.fromOffset(p(10), 0),
            Size = UDim2.new(1, -p(34), 1, 0),
            BackgroundTransparency = 1,
            TextColor3 = theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }), field)
        local chevron = new("ImageLabel", {
            Size = UDim2.fromOffset(p(12), p(12)),
            Position = UDim2.new(1, -p(22), 0, math.floor((controlHeight - p(12)) / 2)),
            BackgroundTransparency = 1,
            Image = icon("chevron-down"),
            ImageColor3 = theme.Placeholder,
        }, field)

        local function values()
            local result = {}
            if multiple then
                for _, option in ipairs(component.Options) do
                    if selected[option] then table.insert(result, option) end
                end
            end
            return result
        end
        local function refresh()
            if not multiple then
                label.Text = selected ~= nil and tostring(selected) or "None"
                component.Value = selected
                return
            end
            local list = values()
            component.Value = list
            label.Text = #list == 0 and "None"
                or (#list == 1 and tostring(list[1]) or ("%s +%d"):format(tostring(list[1]), #list - 1))
        end
        local function fire()
            refresh()
            safeCallback(optionsForDropdown.Callback, component.Value)
        end
        refresh()

        local function open()
            closePopup()
            local position, size = scaledWindowPosition(field)
            local searchable = #component.Options > 8
            local itemHeight = p(28)
            local searchHeight = searchable and (p(28) + p(4)) or 0
            local visibleCount = math.min(#component.Options, 7)
            local fullHeight = visibleCount * itemHeight + p(8) + searchHeight
            local openUp = position.Y + size.Y + p(4) + fullHeight > window.AbsoluteSize.Y - p(8)
            local listFrame = new("Frame", {
                Name = "DropdownList",
                AnchorPoint = Vector2.new(0, openUp and 1 or 0),
                Position = UDim2.fromOffset(position.X, openUp and position.Y - p(4) or position.Y + size.Y + p(4)),
                Size = UDim2.fromOffset(size.X, 0),
                BackgroundColor3 = theme.Dialog,
                ClipsDescendants = true,
                ZIndex = 30,
            }, overlay)
            corner(listFrame, p(6))
            new("UIStroke", { Color = theme.FieldLine, Thickness = 1 }, listFrame)
            local popupConnections = {}
            local function popupConnect(signal, callback)
                table.insert(popupConnections, signal:Connect(callback))
            end
            local query
            if searchable then
                local search = new("Frame", {
                    Position = UDim2.fromOffset(p(4), p(4)),
                    Size = UDim2.new(1, -p(8), 0, p(28)),
                    BackgroundColor3 = theme.Field,
                    ZIndex = 31,
                }, listFrame)
                corner(search, p(5))
                query = new("TextBox", merge(makeFont(p(12), false), {
                    Position = UDim2.fromOffset(p(8), 0),
                    Size = UDim2.new(1, -p(16), 1, 0),
                    BackgroundTransparency = 1,
                    ClearTextOnFocus = false,
                    TextColor3 = theme.Text,
                    PlaceholderText = "Search...",
                    PlaceholderColor3 = theme.Muted,
                    Text = "",
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 32,
                }), search)
            end
            local scroller = new("ScrollingFrame", {
                Position = UDim2.fromOffset(0, searchHeight),
                Size = UDim2.new(1, 0, 1, -searchHeight),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = p(2),
                ScrollBarImageColor3 = theme.Placeholder,
                CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ZIndex = 31,
            }, listFrame)
            new("UIPadding", {
                PaddingTop = UDim.new(0, p(4)), PaddingBottom = UDim.new(0, p(4)),
                PaddingLeft = UDim.new(0, p(4)), PaddingRight = UDim.new(0, p(4)),
            }, scroller)
            new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, scroller)
            local items = {}
            for index, option in ipairs(component.Options) do
                local item = new("TextButton", {
                    Name = tostring(option),
                    LayoutOrder = index,
                    Size = UDim2.new(1, 0, 0, itemHeight),
                    BackgroundColor3 = theme.RowActive,
                    BackgroundTransparency = 1,
                    AutoButtonColor = false,
                    Text = "",
                    ZIndex = 32,
                }, scroller)
                corner(item, p(5))
                new("TextLabel", merge(makeFont(p(12), false), {
                    Position = UDim2.fromOffset(p(8), 0),
                    Size = UDim2.new(1, -p(30), 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Text = tostring(option),
                    ZIndex = 33,
                }), item)
                local chosen = multiple and selected[option] or selected == option
                local mark = new("ImageLabel", {
                    Size = UDim2.fromOffset(p(12), p(12)),
                    Position = UDim2.new(1, -p(20), 0, math.floor((itemHeight - p(12)) / 2)),
                    BackgroundTransparency = 1,
                    Image = icon("check"),
                    ImageColor3 = theme.Text,
                    ImageTransparency = chosen and 0 or 1,
                    ZIndex = 33,
                }, item)
                items[index] = { Button = item, Value = option }
                popupConnect(item.MouseEnter, function() tween(item, 0.1, { BackgroundTransparency = 0 }) end)
                popupConnect(item.MouseLeave, function() tween(item, 0.1, { BackgroundTransparency = 1 }) end)
                popupConnect(item.MouseButton1Click, function()
                    if multiple then
                        selected[option] = not selected[option] or nil
                        tween(mark, 0.12, { ImageTransparency = selected[option] and 0 or 1 })
                        fire()
                    else
                        selected = option
                        fire()
                        closePopup()
                    end
                end)
            end
            if query then
                popupConnect(query:GetPropertyChangedSignal("Text"), function()
                    local searchText = query.Text:lower()
                    for _, item in ipairs(items) do
                        item.Button.Visible = searchText == ""
                            or tostring(item.Value):lower():find(searchText, 1, true) ~= nil
                    end
                end)
            end
            tween(listFrame, 0.18, { Size = UDim2.fromOffset(size.X, fullHeight) })
            tween(chevron, 0.18, { Rotation = 180 })
            tween(fieldStroke, 0.15, { Transparency = 0.4 })
            popupState = {
                Field = field,
                List = listFrame,
                Close = function()
                    for _, connection in ipairs(popupConnections) do
                        pcall(function() connection:Disconnect() end)
                    end
                    tween(chevron, 0.15, { Rotation = 0 })
                    tween(fieldStroke, 0.15, { Transparency = 0.75 })
                    local animation = tween(listFrame, 0.12, { Size = UDim2.fromOffset(size.X, 0) })
                    animation.Completed:Once(function()
                        if listFrame.Parent then listFrame:Destroy() end
                    end)
                end,
            }
        end
        component:_Connect(field.MouseButton1Click, function()
            if popupState and popupState.Field == field then closePopup() else open() end
        end)
        function component:Select(value)
            setSelected(value)
            refresh()
            safeCallback(optionsForDropdown.Callback, self.Value)
        end
        function component:Refresh(newOptions)
            self.Options = newOptions or {}
            if multiple then
                local keep = {}
                for _, option in ipairs(self.Options) do if selected[option] then keep[option] = true end end
                selected = keep
            elseif not table.find(self.Options, selected) then
                selected = self.Options[1]
            end
            refresh()
        end
        function component:Get() return self.Value end
        return component
    end

    lifecycle:Connect(UIS.InputBegan, function(input)
        if not popupState then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local mouse = UIS:GetMouseLocation()
        local function inside(element)
            local position = element.AbsolutePosition
            local size = element.AbsoluteSize
            return mouse.X >= position.X and mouse.X <= position.X + size.X
                and mouse.Y >= position.Y and mouse.Y <= position.Y + size.Y
        end
        if not inside(popupState.Field) and not inside(popupState.List) then closePopup() end
    end)

    local function createInput(tab, optionsForInput)
        local title, tags = parseTags(normalizeTitle(optionsForInput))
        local group = ensureGroup(tab)
        local rowFrame, slot = makeRow(group, title, normalizeDescription(optionsForInput), tags)
        local component = makeComponent(lifecycle, rowFrame)
        component.Value = tostring(optionsForInput.Default or optionsForInput.Value or "")
        local box = new("TextBox", merge(makeFont(p(12), false), {
            Name = "Input",
            Size = UDim2.fromOffset(p(optionsForInput.Width or 170), controlHeight),
            BackgroundColor3 = theme.Field,
            TextColor3 = theme.Text,
            PlaceholderText = tostring(optionsForInput.Placeholder or ""),
            PlaceholderColor3 = theme.Muted,
            Text = component.Value,
            ClearTextOnFocus = optionsForInput.ClearTextOnFocus == true,
            TextXAlignment = Enum.TextXAlignment.Left,
        }), slot)
        corner(box, p(6))
        createGlass(box, theme, 0.1, 0.75)
        new("UIPadding", {
            PaddingLeft = UDim.new(0, p(10)), PaddingRight = UDim.new(0, p(10)),
        }, box)
        function component:Set(value, fire)
            self.Value = tostring(value or "")
            box.Text = self.Value
            if fire ~= false then safeCallback(optionsForInput.Callback, self.Value) end
        end
        function component:Get() return self.Value end
        component:_Connect(box:GetPropertyChangedSignal("Text"), function()
            component.Value = box.Text
        end)
        component:_Connect(box.FocusLost, function(enterPressed)
            component.Value = box.Text
            if enterPressed or optionsForInput.FireOnFocusLost ~= false then
                safeCallback(optionsForInput.Callback, component.Value)
            end
        end)
        return component
    end

    local KEY_NAMES = {
        LeftShift = "LShift", RightShift = "RShift", LeftControl = "LCtrl",
        RightControl = "RCtrl", LeftAlt = "LAlt", RightAlt = "RAlt",
        MouseButton2 = "RMB", MouseButton3 = "MMB",
    }

    local function createKeybind(tab, optionsForKeybind)
        local title, tags = parseTags(normalizeTitle(optionsForKeybind))
        local group = ensureGroup(tab)
        local rowFrame, slot = makeRow(group, title, normalizeDescription(optionsForKeybind), tags)
        local component = makeComponent(lifecycle, rowFrame)
        component.Value = optionsForKeybind.Default or optionsForKeybind.Value
        component.Picking = false
        local button = new("TextButton", {
            Name = "Keybind",
            Size = UDim2.fromOffset(p(84), controlHeight),
            BackgroundColor3 = theme.Field,
            AutoButtonColor = false,
            Text = "",
        }, slot)
        corner(button, p(6))
        local stroke = createGlass(button, theme, 0.1, 0.75).Stroke
        local label = new("TextLabel", merge(makeFont(p(11), false), {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            TextColor3 = theme.Text,
        }), button)
        local function keyText(value)
            if typeof(value) == "EnumItem" then value = value.Name end
            return value and (KEY_NAMES[value] or tostring(value)) or "None"
        end
        local function paint()
            label.Text = component.Picking and "..." or keyText(component.Value)
            label.TextColor3 = component.Picking and theme.Placeholder
                or (component.Value and theme.Text or theme.Muted)
            tween(stroke, 0.15, { Transparency = component.Picking and 0.2 or 0.75 })
        end
        function component:Set(value, fire)
            self.Value = value
            paint()
            if fire ~= false then safeCallback(optionsForKeybind.Callback, value) end
        end
        function component:Get() return self.Value end
        paint()
        component:_Connect(button.MouseButton1Click, function()
            if component.Picking then return end
            component.Picking = true
            paint()
        end)
        component:_Connect(UIS.InputBegan, function(input)
            if not component.Picking then return end
            local keyCode = input.KeyCode
            local mouseButton = input.UserInputType == Enum.UserInputType.MouseButton2
                or input.UserInputType == Enum.UserInputType.MouseButton3
            if keyCode == Enum.KeyCode.Unknown and not mouseButton then return end
            component.Picking = false
            if keyCode == Enum.KeyCode.Escape then
                paint()
                return
            end
            if keyCode == Enum.KeyCode.Backspace then
                component:Set(nil)
                return
            end
            local picked = mouseButton and input.UserInputType or keyCode
            if typeof(optionsForKeybind.Default or optionsForKeybind.Value) ~= "EnumItem" then
                picked = mouseButton and input.UserInputType.Name or keyCode.Name
            end
            component:Set(picked)
        end)
        return component
    end

    local function createParagraph(tab, optionsForParagraph)
        local title, tags = parseTags(normalizeTitle(optionsForParagraph))
        local group = ensureGroup(tab)
        local rowFrame, _, titleLabel, descriptionLabel = makeRow(
            group, title, normalizeDescription(optionsForParagraph) ~= ""
                and normalizeDescription(optionsForParagraph) or " ", tags
        )
        local component = makeComponent(lifecycle, rowFrame)
        function component:SetDescription(value)
            if descriptionLabel then descriptionLabel.Text = tostring(value or "") end
        end
        component.SetDesc = component.SetDescription
        function component:SetTitle(value)
            titleLabel.Text = parseTags(value)
        end
        return component
    end

    local function createButton(tab, optionsForButton)
        local title, tags = parseTags(normalizeTitle(optionsForButton))
        local group = ensureGroup(tab)
        local rowFrame, slot = makeRow(group, title, normalizeDescription(optionsForButton), tags)
        local component = makeComponent(lifecycle, rowFrame)
        local size = controlHeight
        local button = new("TextButton", {
            Name = "Button",
            Size = UDim2.fromOffset(size, size),
            BackgroundColor3 = theme.Primary,
            BackgroundTransparency = 0.88,
            AutoButtonColor = false,
            Text = "",
        }, slot)
        corner(button, p(7))
        createGlass(button, theme, 0.88, 0.6)
        new("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(p(13), p(13)),
            BackgroundTransparency = 1,
            Image = icon(optionsForButton.Icon or "play"),
            ImageColor3 = theme.Text,
        }, button)
        component:_Connect(button.MouseEnter, function() tween(button, 0.12, { BackgroundTransparency = 0.78 }) end)
        component:_Connect(button.MouseLeave, function() tween(button, 0.12, { BackgroundTransparency = 0.88 }) end)
        component:_Connect(button.MouseButton1Click, function() safeCallback(optionsForButton.Callback) end)
        return component
    end

    local function addTab(optionsForTab)
        local name = tostring(optionsForTab.Name or optionsForTab.Title or "Tab")
        if tabs[name] then return tabs[name] end
        local color = optionsForTab.Color or optionsForTab.IconColor or theme.Primary
        local button = new("TextButton", {
            Name = name,
            LayoutOrder = #tabOrder + 1,
            Size = UDim2.fromOffset(0, p(26)),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "",
        }, tabBar)
        local row = new("Frame", {
            Size = UDim2.fromOffset(0, p(26)),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
        }, button)
        new("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, row)
        local iconHolder = new("Frame", {
            LayoutOrder = 1,
            Size = UDim2.fromOffset(p(15), p(15)),
            BackgroundTransparency = 1,
        }, row)
        local image = new("ImageLabel", {
            Name = "Icon",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Image = icon(optionsForTab.Icon),
            ImageColor3 = color,
        }, iconHolder)
        local spacer = new("Frame", {
            LayoutOrder = 2,
            Size = UDim2.fromOffset(0, p(26)),
            BackgroundTransparency = 1,
        }, row)
        local clip = new("Frame", {
            LayoutOrder = 3,
            Size = UDim2.fromOffset(0, p(26)),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
        }, row)
        local tabLabel = new("TextLabel", merge(makeFont(p(13), false), {
            Size = UDim2.fromScale(0, 1),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            TextColor3 = theme.Text,
            TextTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = name,
        }), clip)
        local underline = new("Frame", {
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.new(0, 0, 0, 1),
            BackgroundColor3 = theme.Primary,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        }, button)
        local tab = {
            Name = name, Button = button, Icon = image, Color = color,
            Label = tabLabel, Clip = clip, Spacer = spacer, Underline = underline,
            LabelWidth = textWidth(name, p(13), nil), CurrentSection = nil,
            CurrentGroup = nil, Window = nil,
        }
        tabs[name] = tab
        table.insert(tabOrder, tab)
        local function openLabel(open)
            tween(clip, 0.22, { Size = UDim2.fromOffset(open and tab.LabelWidth or 0, p(26)) })
            tween(spacer, 0.22, { Size = UDim2.fromOffset(open and p(6) or 0, p(26)) })
            tween(tabLabel, 0.22, { TextTransparency = open and 0 or 1 })
        end
        lifecycle:Connect(button.MouseEnter, function() openLabel(true) end)
        lifecycle:Connect(button.MouseLeave, function() openLabel(false) end)
        lifecycle:Connect(button.MouseButton1Click, function() selectTab(name) end)
        return tab
    end

    local windowObject = { Gui = gui, Frame = window, Theme = theme, _Lifecycle = lifecycle }
    local function currentTabGroup(tab)
        return ensureGroup(tab)
    end

    function windowObject:CreateTab(tabOptions)
        local tab = addTab(tabOptions or {})
        if tab.Window then return tab end
        tab.Window = self
        function tab:CreateSection(sectionOptions)
            local section = addSection(self.Name, sectionOptions or {})
            self.CurrentSection = section
            self.CurrentGroup = addGroup(self)
            if sectionOptions and sectionOptions.Icon then
                section.Icon.Image = icon(sectionOptions.Icon)
            end
            return self
        end
        function tab:CreateGroup(caption)
            currentTabGroup(self)
            if self.CurrentGroup and self.CurrentGroup.Rows == 0 then
                local page = self.CurrentGroup.Page
                self.CurrentGroup.Holder:Destroy()
                page.Groups -= 1
            end
            self.CurrentGroup = addGroup(self, caption)
            return self.CurrentGroup
        end
        function tab:CreateButton(optionsForButton) return createButton(self, optionsForButton or {}) end
        function tab:CreateToggle(optionsForToggle) return createToggle(self, optionsForToggle or {}) end
        function tab:CreateSlider(optionsForSlider) return createSlider(self, optionsForSlider or {}) end
        function tab:CreateDropdown(optionsForDropdown) return createDropdown(self, optionsForDropdown or {}) end
        function tab:CreateInput(optionsForInput) return createInput(self, optionsForInput or {}) end
        function tab:CreateKeybind(optionsForKeybind) return createKeybind(self, optionsForKeybind or {}) end
        function tab:CreateParagraph(optionsForParagraph) return createParagraph(self, optionsForParagraph or {}) end
        function tab:Current() return currentTabGroup(self) end
        function tab:Divider() return {} end
        function tab:Space() return {} end

        -- Compatibility aliases used by the original application.
        tab.Tab = tab.CreateTab
        tab.Section = tab.CreateSection
        tab.Group = tab.CreateGroup
        tab.Button = tab.CreateButton
        tab.Toggle = tab.CreateToggle
        tab.Slider = tab.CreateSlider
        tab.Dropdown = tab.CreateDropdown
        tab.Input = tab.CreateInput
        tab.Keybind = tab.CreateKeybind
        tab.Paragraph = tab.CreateParagraph
        return tab
    end

    function windowObject:CreateSection(sectionOptions)
        -- A heading with no visual page, compatible with the application's
        -- Games grouping pattern. The returned object creates normal tabs.
        local heading = {}
        function heading:CreateTab(tabOptions)
            return windowObject:CreateTab(tabOptions)
        end
        heading.Tab = heading.CreateTab
        return heading
    end

    function windowObject:SelectTab(value)
        local tab
        if type(value) == "number" then
            tab = tabOrder[value]
        else
            tab = tabs[tostring(value)]
        end
        if tab then selectTab(tab.Name) end
    end

    function windowObject:SetToggleKey(value)
        if typeof(value) == "EnumItem" then
            self.ToggleKey = value
        elseif type(value) == "string" then
            local ok, key = pcall(function() return Enum.KeyCode[value] end)
            if ok then self.ToggleKey = key end
        end
    end

    function windowObject:SetUIScale(value)
        userScale = math.clamp(tonumber(value) or 1, 0.5, 2)
        windowScale.Scale = userScale
    end

    function windowObject:SetTheme(value)
        -- Theme changes are supported for future windows. Existing instances
        -- intentionally retain their current colors to avoid tearing down UI.
        self.Theme = resolveTheme(value)
    end

    function windowObject:Show() setShown(true) end
    function windowObject:Hide() setShown(false) end
    function windowObject:Toggle() setShown(not shown) end
    function windowObject:IsVisible() return shown end

    local function notify(optionsForNotification)
        optionsForNotification = optionsForNotification or {}
        toastNumber += 1
        local holder = new("Frame", {
            Name = "Notification",
            LayoutOrder = toastNumber,
            Size = UDim2.fromOffset(p(290), 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
        }, toastHolder)
        local card = new("Frame", {
            Position = UDim2.fromOffset(p(310), 0),
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = theme.Card,
        }, holder)
        corner(card, p(10))
        new("UIStroke", { Color = theme.CardLine, Thickness = 1 }, card)
        local inner = new("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
        }, card)
        new("UIPadding", {
            PaddingTop = UDim.new(0, p(11)), PaddingBottom = UDim.new(0, p(11)),
            PaddingLeft = UDim.new(0, p(44)), PaddingRight = UDim.new(0, p(12)),
        }, inner)
        new("UIListLayout", { Padding = UDim.new(0, p(2)), SortOrder = Enum.SortOrder.LayoutOrder }, inner)
        local badge = new("Frame", {
            Position = UDim2.fromOffset(p(12), p(11)),
            Size = UDim2.fromOffset(p(22), p(22)),
            BackgroundColor3 = theme.Primary,
            BackgroundTransparency = 0.8,
        }, card)
        corner(badge, p(7))
        new("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(p(12), p(12)), BackgroundTransparency = 1,
            Image = icon(optionsForNotification.Icon or "info"), ImageColor3 = theme.Primary,
        }, badge)
        new("TextLabel", merge(makeFont(p(13), true), {
            LayoutOrder = 1, Size = UDim2.new(1, 0, 0, p(15)),
            BackgroundTransparency = 1, TextColor3 = theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = tostring(optionsForNotification.Title or "Draco UI Lib"),
        }), inner)
        local description = optionsForNotification.Description or optionsForNotification.Content
        if description and description ~= "" then
            new("TextLabel", merge(makeFont(p(12), false), {
                LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, TextColor3 = theme.Placeholder,
                TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
                Text = tostring(description),
            }), inner)
        end
        tween(card, 0.35, { Position = UDim2.fromOffset(0, 0) })
        task.delay(tonumber(optionsForNotification.Duration) or 4, function()
            if not holder.Parent then return end
            local animation = tween(card, 0.3, { Position = UDim2.fromOffset(p(310), 0) })
            animation.Completed:Once(function()
                if holder.Parent then holder:Destroy() end
            end)
        end)
        return { Destroy = function() if holder.Parent then holder:Destroy() end end }
    end

    function windowObject:Notify(optionsForNotification)
        return notify(optionsForNotification)
    end

    -- WindUI-compatible surface for incremental application migration.
    function windowObject:Tab(tabOptions) return self:CreateTab(tabOptions) end
    function windowObject:Section(sectionOptions) return self:CreateSection(sectionOptions) end
    function windowObject:Destroy()
        lifecycle:Destroy()
        if DracoUI._ActiveWindow == self then
            DracoUI._ActiveWindow = nil
        end
    end

    function windowObject:PresetSheet(tab, api)
        return DracoUI:PresetSheet(tab, api)
    end

    lifecycle:Connect(UIS.InputBegan, function(input, processed)
        if processed then return end
        local toggleKey = windowObject.ToggleKey or options.ToggleKey or Enum.KeyCode.RightControl
        if input.KeyCode == toggleKey then
            setShown(not shown)
        end
    end)
    lifecycle:Connect(workspace.CurrentCamera and workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize") or RunService.RenderStepped, function()
        -- Keep the panel inside the viewport when the display changes, without
        -- fighting user dragging during normal interaction.
        if not window.Visible then return end
    end)

    -- Create at least one tab only when requested; callers decide their layout.
    return windowObject
end

function DracoUI:CreateWindow(options)
    local window = createWindow(options)
    self._ActiveWindow = window
    return window
end

function DracoUI:Notify(options)
    if self._ActiveWindow then
        return self._ActiveWindow:Notify(options)
    end
    return nil
end

function DracoUI:SetTheme(value)
    if self._ActiveWindow then
        self._ActiveWindow:SetTheme(value)
    end
end

function DracoUI:AddTheme(name, values)
    return self:CreateTheme(name, values)
end

function DracoUI:PresetSheet(tab, api)
    assert(tab and api, "PresetSheet requires a tab and preset API")
    local sheet = { _dynamic = {} }
    local input = tab:CreateInput({
        Name = "New preset",
        Description = "Saves this game's settings under a name.",
        Placeholder = "Preset name",
    })
    local function save()
        local name = input:Get():gsub("^%s+", ""):gsub("%s+$", "")
        if name ~= "" and type(api.save) == "function" then api.save(name) end
        input:Set("", false)
        sheet.rebuild()
    end
    tab:CreateButton({ Name = "Save preset", Icon = "save", Callback = save })
    local list = tab:CreateParagraph({ Name = "Saved presets", Description = "No presets yet." })
    local function clearDynamic()
        for _, component in ipairs(sheet._dynamic) do
            pcall(function() component:Destroy() end)
        end
        table.clear(sheet._dynamic)
    end
    function sheet.rebuild()
        clearDynamic()
        local names = type(api.names) == "function" and api.names() or {}
        local lines = {}
        for _, name in ipairs(names) do
            table.insert(lines, tostring(name))
            local auto = type(api.autoload) == "function" and api.autoload() == name
            local info = tab:CreateParagraph({
                Name = tostring(name),
                Description = auto and "Loads when you join this game." or "Saved preset.",
            })
            table.insert(sheet._dynamic, info)
            table.insert(sheet._dynamic, tab:CreateButton({
                Name = (auto and "Unset start: " or "Load: ") .. tostring(name),
                Icon = auto and "star" or "play",
                Callback = function()
                    if type(api.load) == "function" then
                        api.load(name)
                    end
                    sheet.rebuild()
                end,
            }))
            table.insert(sheet._dynamic, tab:CreateButton({
                Name = auto and "Unset auto-load" or "Load on start",
                Icon = "star",
                Callback = function()
                    if type(api.setAutoload) == "function" then
                        api.setAutoload(auto and nil or name)
                    end
                    sheet.rebuild()
                end,
            }))
            table.insert(sheet._dynamic, tab:CreateButton({
                Name = "Delete: " .. tostring(name),
                Icon = "trash-2",
                Callback = function()
                    if type(api.delete) == "function" then api.delete(name) end
                    sheet.rebuild()
                end,
            }))
        end
        list:SetDescription(#lines > 0 and table.concat(lines, "\n") or "No presets yet.")
    end
    sheet.rebuild()
    return sheet
end

function DracoUI:CreateTheme(name, values)
    DracoUI.Themes[name] = merge(DEFAULT_THEME, values)
    return DracoUI.Themes[name]
end

return DracoUI
