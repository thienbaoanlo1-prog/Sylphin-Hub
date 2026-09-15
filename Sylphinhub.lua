mod made by Tâm dev
text

```lua
-- CloverHub v2.5 - Steal An Egg (Roblox) - ПОЛНАЯ ВЕРСИЯ
-- Все вкладки и функции из скриншотов
-- Загрузка: loadstring(game:HttpGet("https://raw.githubusercontent.com/CloverHub/StealAnEgg/main/Clover.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- КОНФИГУРАЦИЯ
-- ============================================================
local Config = {
    -- Steal Filter
    StealRarities = {},
    StealCategories = {},
    StealAreas = {},
    StealPriority = "Rarest",
    StealKGRule = "Any",
    StealKGThreshold = 0,
    StealMinValue = 0,
    -- Auto-Steal
    AutoSteal = false,
    Stall = false,
    PersistentSteal = false,
    PreventTraps = false,
    AntiHit = false,
    -- Auto-Place
    AutoPlace = false,
    PlaceCategories = {},
    PlaceRarities = {},
    PlaceMutations = {},
    PlaceOrder = "Back → Front",
    PreventSnap = false,
    AutoHatch = false,
    -- Pen / Treadmill / Equip
    AutoUpgradePen = false,
    AutoCollectCash = false,
    AutoClaimIndex = false,
    AutoTreadmill = false,
    UpgradeTreadmill = false,
    AntiTreadmill = false,
    AutoEquipBest = false,
    EquipInterval = 30,
    AutoBuyTrail = false,
    TrailName = "Đường mòn màu xám",
    -- Rift
    AutoRift = false,
    RiftProtectMin = 0,
    AutoRiftBoss = false,
    AutoClaimBossMastery = false,
    AutoBuyRiftShop = false,
    RiftShopItem = "",
    -- Fuse
    AutoFuse = false,
    FuseCategories = {},
    FusePreventKG = "Any",
    FuseKGThreshold = 0,
    FusePreventMinValue = 0,
    -- Sell
    AutoSellPets = false,
    SellPetCategories = {},
    SellPetRarities = {},
    SellPetMutations = {},
    SellPetKGRule = "Any",
    SellPetKGThreshold = 0,
    SellPetMinValue = 0,
    AutoSellTrung = false,
    SellTrungNoOverlap = true,
    SellTrungCategories = {},
    SellTrungRarities = {},
    SellTrungMutations = {},
    SellTrungKGRule = "Any",
    SellTrungKGThreshold = 0,
    SellTrungMinValue = 0,
    -- Server
    FindServer = false,
    -- Movement
    MovementMethod = "TP",
    StealRagdoll = true,
    MoveMethod = "Straight",
    TweenSpeed = 700,
    AutoCalibrate = false,
    -- Performance
    HidePets = false,
    RemovePenTrung = false,
    DeleteUnnecessaryModels = false,
    BlackScreen = false,
    BoostTickRate = false,
    -- ESP
    EggESP = false,
    PenESP = false,
    InventoryESP = false,
    -- Status
    ShowStatus = false,
    AntiAFK = false,
    -- Misc
    Theme = "Default"
}

-- ============================================================
-- СОХРАНЕНИЕ / ЗАГРУЗКА КОНФИГА
-- ============================================================
local ConfigFolder = "CloverHub_Configs"
if makefolder and not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local function SaveConfig(name)
    if writefile then
        writefile(ConfigFolder.."/"..name..".json", HttpService:JSONEncode(Config))
    end
end

local function LoadConfig(name)
    if readfile and isfile and isfile(ConfigFolder.."/"..name..".json") then
        local data = HttpService:JSONDecode(readfile(ConfigFolder.."/"..name..".json"))
        for k, v in pairs(data) do Config[k] = v end
    end
end

local function ListConfigs()
    local list = {}
    if listfiles then
        for _, f in pairs(listfiles(ConfigFolder)) do
            table.insert(list, f:gsub("%.json", ""))
        end
    end
    return list
end

-- ============================================================
-- ОСНОВНОЙ GUI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CloverHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 780, 0, 500)
MainFrame.Position = UDim2.new(0.5, -390, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "CloverHub"
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0, 250, 0, 28)
SearchBox.Position = UDim2.new(0.5, -125, 0, 8)
SearchBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
SearchBox.PlaceholderText = "Search"
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
SearchBox.TextSize = 14
SearchBox.Font = Enum.Font.Gotham
SearchBox.BorderSizePixel = 0
SearchBox.Parent = TitleBar
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 170, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -170, 1, -45)
ContentFrame.Position = UDim2.new(0, 170, 0, 45)
ContentFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, 0, 1, 0)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 4
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentScroll.Parent = ContentFrame

-- ============================================================
-- ФУНКЦИИ СОЗДАНИЯ ЭЛЕМЕНТОВ
-- ============================================================
local function CreateSection(parent, title, height)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, height or 60)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Text = title
    lbl.Size = UDim2.new(1, -20, 0, 25)
    lbl.Position = UDim2.new(0, 10, 0, 5)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextSize = 14
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    return frame
end

local function CreateToggle(parent, name, yPos, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Text = name
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 0, 20)
    toggle.Position = UDim2.new(1, -40, 0.5, -10)
    toggle.BackgroundColor3 = default and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(60, 60, 70)
    toggle.Text = ""
    toggle.BorderSizePixel = 0
    toggle.Parent = frame
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = default and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    circle.Parent = toggle
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(60, 60, 70)
        circle.Position = state and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
        if callback then callback(state) end
    end)
    return toggle
end

local function CreateDropdown(parent, name, yPos, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Text = name
    lbl.Size = UDim2.new(0.4, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.55, 0, 1, 0)
    btn.Position = UDim2.new(0.45, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    btn.Text = default or options[1] or "---"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local open = false
    local list = Instance.new("Frame")
    list.Size = UDim2.new(0.55, 0, 0, #options * 25)
    list.Position = UDim2.new(0.45, 0, 1, 2)
    list.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    list.BorderSizePixel = 0
    list.Visible = false
    list.ZIndex = 10
    list.Parent = frame
    Instance.new("UICorner", list).CornerRadius = UDim.new(0, 6)

    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 25)
        optBtn.Position = UDim2.new(0, 0, 0, (i-1) * 25)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        optBtn.TextSize = 12
        optBtn.Font = Enum.Font.Gotham
        optBtn.Parent = list
        optBtn.MouseButton1Click:Connect(function()
            btn.Text = opt
            list.Visible = false
            if callback then callback(opt) end
        end)
    end

    btn.MouseButton1Click:Connect(function()
        open = not open
        list.Visible = open
    end)
    return btn
end

local function CreateSlider(parent, name, yPos, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Text = name .. ": " .. tostring(default)
    lbl.Size = UDim2.new(1, 0, 0, 15)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 6)
    bar.Position = UDim2.new(0, 0, 0, 22)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    bar.BorderSizePixel = 0
    bar.Parent = frame
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
    fill.BorderSizePixel = 0
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            local val = math.floor(min + (max - min) * rel)
            lbl.Text = name .. ": " .. tostring(val)
            if callback then callback(val) end
        end
    end)
    return bar
end

-- ============================================================
-- ВКЛАДКА: HOME (уже описана)
-- ============================================================
local function LoadHomeTab()
    for _, c in pairs(ContentScroll:GetChildren()) do c:Destroy() end
    local y = 5
    -- Session
    local session = CreateSection(ContentScroll, "⏱ Session", 200)
    session.Position = UDim2.new(0, 10, 0, y)
    y = y + 210
    -- Live Stats
    local live = CreateSection(ContentScroll, "📊 Live Stats", 200)
    live.Position = UDim2.new(0, 10, 0, y)
    y = y + 210
    -- Server
    local srv = CreateSection(ContentScroll, "🌐 Server", 110)
    srv.Position = UDim2.new(0, 10, 0, y)
    local rejoin = Instance.new("TextButton")
    rejoin.Text = "🔄 Rejoin Server"
    rejoin.Size = UDim2.new(1, -20, 0, 30)
    rejoin.Position = UDim2.new(0, 10, 0, 40)
    rejoin.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    rejoin.TextColor3 = Color3.fromRGB(200, 200, 200)
    rejoin.TextSize = 13
    rejoin.Font = Enum.Font.Gotham
    rejoin.BorderSizePixel = 0
    rejoin.Parent = srv
    Instance.new("UICorner", rejoin).CornerRadius = UDim.new(0, 6)
    rejoin.MouseButton1Click:Connect(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end)
    local copy = Instance.new("TextButton")
    copy.Text = "📋 Copy Discord"
    copy.Size = UDim2.new(1, -20, 0, 30)
    copy.Position = UDim2.new(0, 10, 0, 75)
    copy.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    copy.TextColor3 = Color3.fromRGB(200, 200, 200)
    copy.TextSize = 13
    copy.Font = Enum.Font.Gotham
    copy.BorderSizePixel = 0
    copy.Parent = srv
    Instance.new("UICorner", copy).CornerRadius = UDim.new(0, 6)
    copy.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard("https://discord.gg/cloverhub") end
    end)
end

-- ============================================================
-- ВКЛАДКА: ACCOUNT
-- ============================================================
local function LoadAccountTab()
    for _, c in pairs(ContentScroll:GetChildren()) do c:Destroy() end
    local acc = CreateSection(ContentScroll, "👤 Account", 120)
    acc.Position = UDim2.new(0, 10, 0, 5)
    local logout = Instance.new("TextButton")
    logout.Text = "Log Out"
    logout.Size = UDim2.new(1, -20, 0, 30)
    logout.Position = UDim2.new(0, 10, 0, 40)
    logout.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    logout.TextColor3 = Color3.fromRGB(200, 200, 200)
    logout.TextSize = 13
    logout.Font = Enum.Font.Gotham
    logout.BorderSizePixel = 0
    logout.Parent = acc
    Instance.new("UICorner", logout).CornerRadius = UDim.new(0, 6)
    logout.MouseButton1Click:Connect(function()
        LocalPlayer:Kick("Logged out")
    end)
    local key = CreateSection(ContentScroll, "🔑 Key Status", 80)
    key.Position = UDim2.new(0, 10, 0, 135)
    local kl = Instance.new("TextLabel")
    kl.Text = "Access: free\nKey remaining: 23h 57m 55s"
    kl.Size = UDim2.new(1, -20, 1, -30)
    kl.Position = UDim2.new(0, 10, 0, 25)
    kl.BackgroundTransparency = 1
    kl.TextColor3 = Color3.fromRGB(180, 180, 180)
    kl.TextSize = 12
    kl.Font = Enum.Font.Gotham
    kl.TextXAlignment = Enum.TextXAlignment.Left
    kl.TextYAlignment = Enum.TextYAlignment.Top
    kl.Parent = key
end

-- ============================================================
-- ВКЛАДКА: EGGS (STEAL FILTER + AUTO-STEAL + AUTO-PLACE)
-- ============================================================
local function LoadEggsTab()
    for _, c in pairs(ContentScroll:GetChildren()) do c:Destroy() end
    local y = 5

    -- Steal Filter
    local sf = CreateSection(ContentScroll, "⚙ Steal Filter", 320)
    sf.Position = UDim2.new(0, 10, 0, y)
    y = y + 330
    CreateDropdown(sf, "Rarities", 35, {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret"}, "---", function(v)
        Config.StealRarities = {v}
    end)
    CreateDropdown(sf, "Categories", 70, {"Basic", "Event", "Rift", "Boss", "Special"}, "---", function(v)
        Config.StealCategories = {v}
    end)
    CreateDropdown(sf, "Areas", 105, {"Area 1", "Area 2", "Area 3", "Area 4", "Area 5"}, "---", function(v)
        Config.StealAreas = {v}
    end)
    CreateDropdown(sf, "Priority", 140, {"Rarest", "Nearest", "Most Valuable", "Random"}, "Rarest", function(v)
        Config.StealPriority = v
    end)
    CreateDropdown(sf, "KG Rule", 175, {"Any", "Below", "Above"}, "Any", function(v)
        Config.StealKGRule = v
    end)
    CreateSlider(sf, "KG Threshold", 210, 0, 1000, 0, function(v)
        Config.StealKGThreshold = v
    end)
    CreateSlider(sf, "Minimum Value", 255, 0, 1000000, 0, function(v)
        Config.StealMinValue = v
    end)

    -- Auto-Steal
    local as = CreateSection(ContentScroll, "🤖 Auto-Steal", 200)
    as.Position = UDim2.new(0, 10, 0, y)
    y = y + 210
    CreateToggle(as, "Auto-Steal", 30, false, function(v) Config.AutoSteal = v end)
    CreateToggle(as, "Stall", 65, false, function(v) Config.Stall = v end)
    CreateToggle(as, "Persistent Steal", 100, false, function(v) Config.PersistentSteal = v end)
    CreateToggle(as, "Prevent Traps", 135, false, function(v) Config.PreventTraps = v end)
    CreateToggle(as, "Anti Hit", 170, false, function(v) Config.AntiHit = v end)

    -- Auto-Place
    local ap = CreateSection(ContentScroll, "🥚 Auto-Place", 250)
    ap.Position = UDim2.new(0, 10, 0, y)
    y = y + 260
    CreateDropdown(ap, "Categories", 35, {"Basic", "Event", "Rift", "Boss", "Special"}, "---", function(v) Config.PlaceCategories = {v} end)
    CreateDropdown(ap, "Rarities", 70, {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret"}, "---", function(v) Config.PlaceRarities = {v} end)
    CreateDropdown(ap, "Mutations", 105, {"None", "Gold", "Diamond", "Rainbow", "Galaxy"}, "---", function(v) Config.PlaceMutations = {v} end)
    CreateDropdown(ap, "Order", 140, {"Back → Front", "Front → Back", "Random"}, "Back → Front", function(v) Config.PlaceOrder = v end)
    CreateToggle(ap, "Auto-Place", 175, false, function(v) Config.AutoPlace = v end)
    CreateToggle(ap, "Prevent Snap", 210, false, function(v) Config.PreventSnap = v end)
    CreateToggle(ap, "Auto-Hatch", 245, false, function(v) Config.AutoHatch = v end)
end

-- ============================================================
-- ВКЛАДКА: PROGRESSION (PEN + TREADMILL + EQUIP BEST + TRAIL)
-- ============================================================
local function LoadProgressionTab()
    for _, c in pairs(ContentScroll:GetChildren()) do c:Destroy() end
    local y = 5
    -- Pen
    local pen = CreateSection(ContentScroll, "🏠 Pen", 160)
    pen.Position = UDim2.new(0, 10, 0, y)
    CreateToggle(pen, "Nâng cấp chuồng thú cưng", 30, false, function(v) Config.AutoUpgradePen = v end)
    CreateToggle(pen, "Collect Cash", 65, false, function(v) Config.AutoCollectCash = v end)
    CreateToggle(pen, "Claim Index", 100, false, function(v) Config.AutoClaimIndex = v end)

    -- Treadmill
    local tm = CreateSection(ContentScroll, "🏃 Treadmill", 160)
    tm.Position = UDim2.new(0, 400, 0, y)
    y = y + 170
    CreateToggle(tm, "Upgrade standby", 30, false, function(v) Config.AutoTreadmill = v end)
    CreateToggle(tm, "Anti Treadmill", 65, false, function(v) Config.AntiTreadmill = v end)
    CreateToggle(tm, "Upgrade Treadmill", 100, false, function(v) Config.UpgradeTreadmill = v end)
    CreateToggle(tm, "Auto Treadmill", 135, false, function(v) Config.AutoTreadmill = v end)

    -- Equip Best
    local eq = CreateSection(ContentScroll, "🐾 Equip Best", 130)
    eq.Position = UDim2.new(0, 10, 0, y)
    CreateSlider(eq, "Interval (seconds)", 30, 1, 300, 30, function(v) Config.EquipInterval = v end)
    CreateToggle(eq, "Auto Equip Best", 75, false, function(v) Config.AutoEquipBest = v end)
    local equipBtn = Instance.new("TextButton")
    equipBtn.Text = "⚡ Equip Best"
    equipBtn.Size = UDim2.new(1, -20, 0, 25)
    equipBtn.Position = UDim2.new(0, 10, 0, 100)
    equipBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    equipBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    equipBtn.TextSize = 12
    equipBtn.Font = Enum.Font.Gotham
    equipBtn.BorderSizePixel = 0
    equipBtn.Parent = eq
    Instance.new("UICorner", equipBtn).CornerRadius = UDim.new(0, 6)

    -- Trail Shop
    local ts = CreateSection(ContentScroll, "✨ Trail Shop", 130)
    ts.Position = UDim2.new(0, 400, 0, y)
    CreateDropdown(ts, "Trails", 35, {"Đường mòn màu xám", "Đường mòn màu đỏ", "Đường mòn màu xanh", "Đường mòn cầu vồng"}, "Đường mòn màu xám", function(v) Config.TrailName = v end)
    CreateToggle(ts, "Auto Buy Trail", 75, false, function(v) Config.AutoBuyTrail = v end)
end

-- ============================================================
-- ВКЛАДКА: EVENT (RIFT + RIFT BOSS + BOSS MASTERY)
-- ============================================================
local function LoadEventTab()
    for _, c in pairs(ContentScroll:GetChildren()) do c:Destroy() end
    local y = 5
    local rift = CreateSection(ContentScroll, "🌀 Rift", 250)
    rift.Position = UDim2.new(0, 10, 0, y)
    local info = Instance.new("TextLabel")
    info.Text = "Riftborn\nParrotfish\nFinned Thresher\nSwordfish"
    info.Size = UDim2.new(1, -20, 0, 70)
    info.Position = UDim2.new(0, 10, 0, 30)
    info.BackgroundTransparency = 1
    info.TextColor3 = Color3.fromRGB(180, 180, 180)
    info.TextSize = 12
    info.Font = Enum.Font.Gotham
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.Parent = rift
    CreateSlider(rift, "Protect Minimum Value", 100, 0, 1000000, 0, function(v) Config.RiftProtectMin = v end)
    CreateToggle(rift, "Auto Rift", 145, false, function(v) Config.AutoRift = v end)

    local rb = CreateSection(ContentScroll, "⚔ Rift Boss", 100)
    rb.Position = UDim2.new(0, 400, 0, y)
    CreateToggle(rb, "Auto Attack Rift Boss", 30, false, function(v) Config.AutoRiftBoss = v end)

    local bm = CreateSection(ContentScroll, "🎁 Boss Mastery", 100)
    bm.Position = UDim2.new(0, 400, 0, y + 110)
    CreateToggle(bm, "Auto Claim Boss Mastery", 30, false, function(v) Config.AutoClaimBossMastery = v end)

    local rs = CreateSection(ContentScroll, "🎁 Rift Shop", 160)
    rs.Position = UDim2.new(0, 10, 0, y + 260)
    local tokens = Instance.new("TextLabel")
    tokens.Text = "Boss Tokens: 1200"
    tokens.Size = UDim2.new(1, -20, 0, 20)
    tokens.Position = UDim2.new(0, 10, 0, 30)
    tokens.BackgroundTransparency = 1
    tokens.TextColor3 = Color3.fromRGB(180, 180, 180)
    tokens.TextSize = 12
    tokens.Font = Enum.Font.Gotham
    tokens.TextXAlignment = Enum.TextXAlignment.Left
    tokens.Parent = rs
    CreateDropdown(rs, "Items", 55, {"Item 1", "Item 2", "Item 3", "Item 4"}, "---", function(v) Config.RiftShopItem = v end)
    CreateToggle(rs, "Auto Buy", 95, false, function(v) Config.AutoBuyRiftShop = v end)
end

-- ============================================================
-- ВКЛАДКА: FUSE
-- ============================================================
local function LoadFuseTab()
    for _, c in pairs(ContentScroll:GetChildren()) do c:Destroy() end
    local fuse = CreateSection(ContentScroll, "⚗️ Auto Fuse", 250)
    fuse.Position = UDim2.new(0, 10, 0, 5)
    CreateDropdown(fuse, "Categories", 35, {"Basic", "Event", "Rift", "Boss", "Special"}, "---", function(v) Config.FuseCategories = {v} end)
    CreateDropdown(fuse, "Prevent KG", 70, {"Any", "Below", "Above"}, "Any", function(v) Config.FusePreventKG = v end)
    CreateSlider(fuse, "KG Threshold", 105, 0, 1000, 0, function(v) Config.FuseKGThreshold = v end)
    CreateSlider(fuse, "Prevent Minimum Value", 150, 0, 1000000, 0, function(v) Config.FusePreventMinValue = v end)
    CreateToggle(fuse, "Auto Fuse", 195, false, function(v) Config.AutoFuse = v end)
end

-- ============================================================
-- ВКЛАДКА: BÁN (SELL PETS + SELL TRỨNG)
-- ============================================================
local function LoadSellTab()
    for
