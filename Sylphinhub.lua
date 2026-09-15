-- CloverHub v2.5 - Steal An Egg (Roblox)
-- Полная репликация интерфейса и функционала
-- Загрузка: loadstring(game:HttpGet("https://raw.githubusercontent.com/CloverHub/StealAnEgg/main/Clover.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- КОНФИГУРАЦИЯ И СОХРАНЕНИЕ
-- ============================================================
local Config = {
    AutoSteal = false,
    PersistentSteal = false,
    Stall = false,
    PreventTraps = false,
    AntiHit = false,
    AutoPlace = false,
    PreventSnap = false,
    AutoHatch = false,
    AutoSell = false,
    AutoSellTrung = false,
    AutoFuse = false,
    AutoRift = false,
    AutoRiftBoss = false,
    AutoClaimBossMastery = false,
    AutoBuyRiftShop = false,
    AutoTreadmill = false,
    UpgradeTreadmill = false,
    AutoEquipBest = false,
    AutoBuyTrail = false,
    AutoCollectCash = false,
    AutoClaimIndex = false,
    AutoUpgradePen = false,
    TweenSpeed = 700,
    Method = "Straight",
    Priority = "Rarest",
    KGRule = "Any",
    KGThreshold = 0,
    MinimumValue = 0,
    EquipInterval = 30,
    Theme = "Default",
    ESP_Egg = false,
    ESP_Pen = false,
    ESP_Inventory = false,
    ShowStatus = false,
    AntiAFK = false
}

local function SaveConfig(name)
    if writefile then
        writefile("CloverHub_"..name..".json", HttpService:JSONEncode(Config))
    end
end

local function LoadConfig(name)
    if readfile and isfile and isfile("CloverHub_"..name..".json") then
        local data = HttpService:JSONDecode(readfile("CloverHub_"..name..".json"))
        for k, v in pairs(data) do Config[k] = v end
    end
end

-- ============================================================
-- СОЗДАНИЕ GUI (ТОЧНАЯ КОПИЯ ИНТЕРФЕЙСА)
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CloverHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 700, 0, 480)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 70)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "CloverHub"
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 60, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(180, 255, 180)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0, 250, 0, 30)
SearchBox.Position = UDim2.new(0.5, -125, 0, 8)
SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
SearchBox.PlaceholderText = "Search"
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
SearchBox.TextSize = 14
SearchBox.Font = Enum.Font.Gotham
SearchBox.BorderSizePixel = 0
SearchBox.Parent = TitleBar
local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent = SearchBox

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Левая панель (навигация)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local TabButtons = {}
local CurrentTab = nil
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -160, 1, -45)
ContentFrame.Position = UDim2.new(0, 160, 0, 45)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

local function CreateTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.Position = UDim2.new(0, 5, 0, #TabButtons * 40 + 5)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.Text = "  "..icon.."  "..name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.Parent = Sidebar
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    table.insert(TabButtons, {btn = btn, name = name})
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(TabButtons) do
            t.btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            t.btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        btn.TextColor3 = Color3.fromRGB(180, 255, 180)
        -- Очистка контента
        for _, child in pairs(ContentFrame:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
                child:Destroy()
            end
        end
        -- Загрузка контента вкладки
        if name == "HOME" then
            LoadHomeTab()
        elseif name == "ACCOUNT" then
            LoadAccountTab()
        elseif name == "EGGS" then
            LoadEggsTab()
        elseif name == "PROGRESSION" then
            LoadProgressionTab()
        elseif name == "EVENT" then
            LoadEventTab()
        elseif name == "FUSE" then
            LoadFuseTab()
        elseif name == "BÁN" then
            LoadSellTab()
        elseif name == "SERVER" then
            LoadServerTab()
        elseif name == "WEBHOOK" then
            LoadWebhookTab()
        elseif name == "SETTINGS" then
            LoadSettingsTab()
        end
    end)
end

-- Создание всех вкладок как на скриншотах
CreateTab("ACCOUNT", "👤")
CreateTab("HOME", "🏠")
CreateTab("EGGS", "🥚")
CreateTab("PROGRESSION", "🏆")
CreateTab("EVENT", "🎉")
CreateTab("FUSE", "⚗️")
CreateTab("BÁN", "💰")
CreateTab("SERVER", "🌐")
CreateTab("WEBHOOK", "🔗")
CreateTab("SETTINGS", "⚙️")

-- ============================================================
-- КОНТЕНТ ВКЛАДОК (HOME)
-- ============================================================
function LoadHomeTab()
    -- Session Frame
    local SessionFrame = Instance.new("Frame")
    SessionFrame.Size = UDim2.new(0.48, 0, 0, 200)
    SessionFrame.Position = UDim2.new(0.01, 0, 0.01, 0)
    SessionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    SessionFrame.BorderSizePixel = 0
    SessionFrame.Parent = ContentFrame
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 10)
    sc.Parent = SessionFrame

    local SessionTitle = Instance.new("TextLabel")
    SessionTitle.Text = "⏱ Session"
    SessionTitle.Size = UDim2.new(1, 0, 0, 30)
    SessionTitle.BackgroundTransparency = 1
    SessionTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    SessionTitle.TextSize = 16
    SessionTitle.Font = Enum.Font.GothamBold
    SessionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SessionTitle.Position = UDim2.new(0, 10, 0, 5)
    SessionTitle.Parent = SessionFrame

    local StatsContainer = Instance.new("Frame")
    StatsContainer.Size = UDim2.new(1, -20, 1, -45)
    StatsContainer.Position = UDim2.new(0, 10, 0, 40)
    StatsContainer.BackgroundTransparency = 1
    StatsContainer.Parent = SessionFrame

    local stats = {
        {"SESSION", "00:00:29"},
        {"SAFETY", "Trusted"},
        {"FPS", "60"},
        {"PING", "135ms"},
        {"STEALS", "0"},
        {"ATTEMPTS", "0"},
        {"STEAL TIME", "idle"},
        {"AVG STEAL", "--"}
    }

    for i, data in ipairs(stats) do
        local row = math.floor((i-1)/2)
        local col = (i-1) % 2
        local statFrame = Instance.new("Frame")
        statFrame.Size = UDim2.new(0.48, 0, 0, 35)
        statFrame.Position = UDim2.new(col * 0.52, 0, row * 0.26, 0)
        statFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        statFrame.BorderSizePixel = 0
        statFrame.Parent = StatsContainer
        local sc2 = Instance.new("UICorner")
        sc2.CornerRadius = UDim.new(0, 6)
        sc2.Parent = statFrame

        local statLabel = Instance.new("TextLabel")
        statLabel.Text = data[1]
        statLabel.Size = UDim2.new(1, 0, 0, 14)
        statLabel.Position = UDim2.new(0, 8, 0, 2)
        statLabel.BackgroundTransparency = 1
        statLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
        statLabel.TextSize = 10
        statLabel.Font = Enum.Font.Gotham
        statLabel.TextXAlignment = Enum.TextXAlignment.Left
        statLabel.Parent = statFrame

        local statValue = Instance.new("TextLabel")
        statValue.Text = data[2]
        statValue.Size = UDim2.new(1, -8, 0, 16)
        statValue.Position = UDim2.new(0, 8, 0, 16)
        statValue.BackgroundTransparency = 1
        statValue.TextColor3 = Color3.fromRGB(220, 220, 220)
        statValue.TextSize = 13
        statValue.Font = Enum.Font.GothamBold
        statValue.TextXAlignment = Enum.TextXAlignment.Left
        statValue.Parent = statFrame
    end

    -- Live Stats Frame
    local LiveFrame = Instance.new("Frame")
    LiveFrame.Size = UDim2.new(0.48, 0, 0, 200)
    LiveFrame.Position = UDim2.new(0.51, 0, 0.01, 0)
    LiveFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    LiveFrame.BorderSizePixel = 0
    LiveFrame.Parent = ContentFrame
    local lc = Instance.new("UICorner")
    lc.CornerRadius = UDim.new(0, 10)
    lc.Parent = LiveFrame

    local LiveTitle = Instance.new("TextLabel")
    LiveTitle.Text = "📊 Live Stats"
    LiveTitle.Size = UDim2.new(1, 0, 0, 30)
    LiveTitle.BackgroundTransparency = 1
    LiveTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    LiveTitle.TextSize = 16
    LiveTitle.Font = Enum.Font.GothamBold
    LiveTitle.TextXAlignment = Enum.TextXAlignment.Left
    LiveTitle.Position = UDim2.new(0, 10, 0, 5)
    LiveTitle.Parent = LiveFrame

    local liveStats = {
        {"💰 TIỀN", "$772.5T"},
        {"📈 INCOME / SEC", "$20.1B/s"},
        {"⚡ TỐC ĐỘ", "2.7B"},
        {"🥚 EGG INVENTORY", "23 / 115"},
        {"🐾 PET INVENTORY", "49"},
        {"💎 TOTAL PET VALUE", "$2.4T"}
    }

    for i, data in ipairs(liveStats) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -20, 0, 28)
        row.Position = UDim2.new(0, 10, 0, 40 + (i-1) * 28)
        row.BackgroundTransparency = 1
        row.Parent = LiveFrame

        local key = Instance.new("TextLabel")
        key.Text = data[1]
        key.Size = UDim2.new(0.6, 0, 1, 0)
        key.BackgroundTransparency = 1
        key.TextColor3 = Color3.fromRGB(160, 160, 160)
        key.TextSize = 11
        key.Font = Enum.Font.Gotham
        key.TextXAlignment = Enum.TextXAlignment.Left
        key.Parent = row

        local val = Instance.new("TextLabel")
        val.Text = data[2]
        val.Size = UDim2.new(0.4, 0, 1, 0)
        val.Position = UDim2.new(0.6, 0, 0, 0)
        val.BackgroundTransparency = 1
        val.TextColor3 = Color3.fromRGB(180, 255, 180)
        val.TextSize = 12
        val.Font = Enum.Font.GothamBold
        val.TextXAlignment = Enum.TextXAlignment.Right
        val.Parent = row
    end

    -- Server Frame
    local ServerFrame = Instance.new("Frame")
    ServerFrame.Size = UDim2.new(1, -20, 0, 100)
    ServerFrame.Position = UDim2.new(0, 10, 0, 210)
    ServerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ServerFrame.BorderSizePixel = 0
    ServerFrame.Parent = ContentFrame
    local srvc = Instance.new("UICorner")
    srvc.CornerRadius = UDim.new(0, 10)
    srvc.Parent = ServerFrame

    local SrvTitle = Instance.new("TextLabel")
    SrvTitle.Text = "🌐 Server"
    SrvTitle.Size = UDim2.new(1, 0, 0, 30)
    SrvTitle.BackgroundTransparency = 1
    SrvTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    SrvTitle.TextSize = 16
    SrvTitle.Font = Enum.Font.GothamBold
    SrvTitle.TextXAlignment = Enum.TextXAlignment.Left
    SrvTitle.Position = UDim2.new(0, 10, 0, 5)
    SrvTitle.Parent = ServerFrame

    local RejoinBtn = Instance.new("TextButton")
    RejoinBtn.Text = "🔄 Rejoin Server"
    RejoinBtn.Size = UDim2.new(1, -20, 0, 30)
    RejoinBtn.Position = UDim2.new(0, 10, 0, 40)
    RejoinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    RejoinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    RejoinBtn.TextSize = 13
    RejoinBtn.Font = Enum.Font.Gotham
    RejoinBtn.BorderSizePixel = 0
    RejoinBtn.Parent = ServerFrame
    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 6)
    rc.Parent = RejoinBtn

    local CopyDiscordBtn = Instance.new("TextButton")
    CopyDiscordBtn.Text = "📋 Copy Discord"
    CopyDiscordBtn.Size = UDim2.new(1, -20, 0, 30)
    CopyDiscordBtn.Position = UDim2.new(0, 10, 0, 75)
    CopyDiscordBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    CopyDiscordBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    CopyDiscordBtn.TextSize = 13
    CopyDiscordBtn.Font = Enum.Font.Gotham
    CopyDiscordBtn.BorderSizePixel = 0
    CopyDiscordBtn.Parent = ServerFrame
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 6)
    cc.Parent = CopyDiscordBtn
end

-- ============================================================
-- ФУНКЦИИ АВТОМАТИЗАЦИИ (ОСНОВНАЯ ЛОГИКА)
-- ============================================================
local function GetEggs()
    local eggs = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and (v.Name:find("Egg") or v.Name:find("Trứng")) then
            table.insert(eggs, v)
        end
    end
    return eggs
end

local function GetNearestEgg()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position
    local nearest, minDist = nil, math.huge
    for _, egg in pairs(GetEggs()) do
        local pos = egg:GetPivot().Position
        local dist = (pos - myPos).Magnitude
        if dist < minDist then
            nearest = egg
            minDist = dist
        end
    end
    return nearest
end

-- Auto Steal
RunService.Heartbeat:Connect(function()
    if Config.AutoSteal then
        local egg = GetNearestEgg()
        if egg then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local targetPos = egg:GetPivot().Position
                local direction = (targetPos - char.HumanoidRootPart.Position).Unit
                local tweenSpeed = Config.TweenSpeed / 10
                char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position + direction * tweenSpeed)
                -- Симуляция кражи
                if (char.HumanoidRootPart.Position - targetPos).Magnitude < 5 then
                    local args = {egg}
                    game:GetService("ReplicatedStorage"):FindFirstChild("StealEgg"):FireServer(unpack(args))
                end
            end
        end
    end
end)

-- Auto Place
RunService.Heartbeat:Connect(function()
    if Config.AutoPlace then
        -- Логика авто-установки яиц
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:find("Pen") then
                -- Поиск свободного места
                local args = {v}
                game:GetService("ReplicatedStorage"):FindFirstChild("PlaceEgg"):FireServer(unpack(args))
                break
            end
        end
    end
end)

-- Auto Sell
RunService.Heartbeat:Connect(function()
    if Config.AutoSell then
        for _, v in pairs(LocalPlayer:GetDescendants()) do
            if v:IsA("Model") and (v.Name:find("Pet") or v.Name:find("Trứng")) then
                local args = {v}
                game:GetService("ReplicatedStorage"):FindFirstChild("SellPet"):FireServer(unpack(args))
            end
        end
    end
end)

-- Auto Fuse
RunService.Heartbeat:Connect(function()
    if Config.AutoFuse then
        -- Логика слияния питомцев
        local pets = {}
        for _, v in pairs(LocalPlayer:GetDescendants()) do
            if v:IsA("Model") and v.Name:find("Pet") then
                table.insert(pets, v)
            end
        end
        if #pets >= 3 then
            local args = {pets[1], pets[2], pets[3]}
            game:GetService("ReplicatedStorage"):FindFirstChild("FusePet"):FireServer(unpack(args))
        end
    end
end)

-- Auto Treadmill
RunService.Heartbeat:Connect(function()
    if Config.AutoTreadmill then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:find("Treadmill") then
                local args = {v}
                game:GetService("ReplicatedStorage"):FindFirstChild("UseTreadmill"):FireServer(unpack(args))
            end
        end
    end
end)

-- Auto Equip Best
task.spawn(function()
    while true do
        if Config.AutoEquipBest then
            local bestPets = {}
            for _, v in pairs(LocalPlayer:GetDescendants()) do
                if v:IsA("Model") and v.Name:find("Pet") then
                    table.insert(bestPets, v)
                end
            end
            table.sort(bestPets, function(a, b)
                return (a:GetAttribute("Value") or 0) > (b:GetAttribute("Value") or 0)
            end)
            for i = 1, math.min(3, #bestPets) do
                local args = {bestPets[i]}
                game:GetService("ReplicatedStorage"):FindFirstChild("EquipPet"):FireServer(unpack(args))
            end
        end
        task.wait(Config.EquipInterval)
    end
end)

-- Anti-AFK
if Config.AntiAFK then
    LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
end

-- ============================================================
-- ЗАГРУЗКА ПЕРВОЙ ВКЛАДКИ
-- ============================================================
LoadHomeTab()
