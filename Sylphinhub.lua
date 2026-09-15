-- Auto Farm Egg + Steal Speed Slider для Steal An Egg (Roblox)
-- Автоматически собирает ближайшие яйца + регулировка скорости кражи
-- Загрузка: скопировать в экзекьютор и выполнить

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- КОНФИГ
-- ============================================================
local Config = {
    AutoFarm = false,
    StealSpeed = 20,     -- studs/sec (регулируется слайдером)
    MoveSpeed = 16,      -- обычная скорость ходьбы
    TeleportMode = "TP", -- "TP" / "Tween" / "Walk"
    EggRadius = 500,     -- радиус поиска яиц
    RarityFilter = {}    -- пусто = все яйца
}

-- ============================================================
-- ПОИСК REMOTE ДЛЯ КРАЖИ
-- ============================================================
local function FindRemote(name)
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and v.Name:lower():find(name:lower()) then
            return v
        end
    end
    return nil
end

local StealRemote = FindRemote("StealEgg") or FindRemote("Steal") or FindRemote("PickupEgg") or FindRemote("CollectEgg")
local HatchRemote = FindRemote("HatchEgg") or FindRemote("Hatch")

-- ============================================================
-- ФУНКЦИИ ЯИЦ
-- ============================================================
local function GetEggs()
    local eggs = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and (v.Name:find("Egg") or v.Name:find("Trứng")) then
            if v:FindFirstChildWhichIsA("BasePart") then
                table.insert(eggs, v)
            end
        end
    end
    return eggs
end

local function GetEggRarity(egg)
    return egg:GetAttribute("Rarity") or egg:GetAttribute("RarityName") or "Common"
end

local function GetEggPosition(egg)
    if egg.PrimaryPart then return egg.PrimaryPart.Position end
    local part = egg:FindFirstChildWhichIsA("BasePart")
    return part and part.Position or nil
end

local function FilterEgg(egg)
    if #Config.RarityFilter == 0 then return true end
    return table.find(Config.RarityFilter, GetEggRarity(egg)) ~= nil
end

local function GetNearestEgg()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position
    local best, bestDist = nil, Config.EggRadius
    for _, egg in pairs(GetEggs()) do
        if not FilterEgg(egg) then continue end
        local pos = GetEggPosition(egg)
        if pos then
            local dist = (pos - myPos).Magnitude
            if dist < bestDist then
                best = egg
                bestDist = dist
            end
        end
    end
    return best
end

-- ============================================================
-- ДВИЖЕНИЕ К ЯЙЦУ (с регулируемой скоростью)
-- ============================================================
local function MoveToEgg(egg)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    local hrp = char.HumanoidRootPart
    local targetPos = GetEggPosition(egg)
    if not targetPos then return false end

    if Config.TeleportMode == "TP" then
        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
        return true
    elseif Config.TeleportMode == "Tween" then
        local dist = (targetPos - hrp.Position).Magnitude
        local duration = dist / Config.StealSpeed
        local tween = game:GetService("TweenService"):Create(
            hrp,
            TweenInfo.new(duration, Enum.EasingStyle.Linear),
            {CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))}
        )
        tween:Play()
        tween.Completed:Wait()
        return true
    elseif Config.TeleportMode == "Walk" then
        char.Humanoid.WalkSpeed = Config.StealSpeed
        char.Humanoid:MoveTo(targetPos)
        return true
    end
    return false
end

-- ============================================================
-- ОСНОВНОЙ ЦИКЛ AUTO-FARM
-- ============================================================
task.spawn(function()
    while true do
        task.wait(0.1)
        if Config.AutoFarm then
            local egg = GetNearestEgg()
            if egg then
                MoveToEgg(egg)
                -- Попытка вызвать Remote для кражи
                if StealRemote then
                    pcall(function()
                        StealRemote:FireServer(egg)
                    end)
                end
                -- Проверка: если яйцо исчезло — продолжаем
                task.wait(0.05)
            end
        end
    end
end)

-- Поддержание скорости ходьбы
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    if Config.AutoFarm and Config.TeleportMode == "Walk" then
        char.Humanoid.WalkSpeed = Config.StealSpeed
    elseif not Config.AutoFarm then
        char.Humanoid.WalkSpeed = Config.MoveSpeed
    end
end)

-- ============================================================
-- GUI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EggFarmSpeed"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 280)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "Egg Farm + Steal Speed"
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -35, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Кнопка AUTO FARM
local FarmBtn = Instance.new("TextButton")
FarmBtn.Size = UDim2.new(1, -30, 0, 35)
FarmBtn.Position = UDim2.new(0, 15, 0, 50)
FarmBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
FarmBtn.Text = "▶ START AUTO FARM"
FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmBtn.TextSize = 13
FarmBtn.Font = Enum.Font.GothamBold
FarmBtn.BorderSizePixel = 0
FarmBtn.Parent = MainFrame
Instance.new("UICorner", FarmBtn).CornerRadius = UDim.new(0, 8)
FarmBtn.MouseButton1Click:Connect(function()
    Config.AutoFarm = not Config.AutoFarm
    if Config.AutoFarm then
        FarmBtn.Text = "■ STOP AUTO FARM"
        FarmBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    else
        FarmBtn.Text = "▶ START AUTO FARM"
        FarmBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    end
end)

-- Слайдер Steal Speed
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Text = "Steal Speed: " .. Config.StealSpeed .. " studs/s"
SpeedLabel.Size = UDim2.new(1, -30, 0, 20)
SpeedLabel.Position = UDim2.new(0, 15, 0, 95)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
SpeedLabel.TextSize = 12
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = MainFrame

local SpeedBar = Instance.new("Frame")
SpeedBar.Size = UDim2.new(1, -30, 0, 8)
SpeedBar.Position = UDim2.new(0, 15, 0, 120)
SpeedBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SpeedBar.BorderSizePixel = 0
SpeedBar.Parent = MainFrame
Instance.new("UICorner", SpeedBar).CornerRadius = UDim.new(1, 0)

local SpeedFill = Instance.new("Frame")
SpeedFill.Size = UDim2.new((Config.StealSpeed - 1) / 499, 0, 1, 0) -- 1..500
SpeedFill.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
SpeedFill.BorderSizePixel = 0
SpeedFill.Parent = SpeedBar
Instance.new("UICorner", SpeedFill).CornerRadius = UDim.new(1, 0)

local dragging = false
SpeedBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local rel = math.clamp((input.Position.X - SpeedBar.AbsolutePosition.X) / SpeedBar.AbsoluteSize.X, 0, 1)
        SpeedFill.Size = UDim2.new(rel, 0, 1, 0)
        local val = math.floor(1 + (500 - 1) * rel)
        Config.StealSpeed = val
        SpeedLabel.Text = "Steal Speed: " .. val .. " studs/s"
        -- Мгновенно применяем к персонажу при Walk-режиме
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") and Config.TeleportMode == "Walk" then
            char.Humanoid.WalkSpeed = val
        end
    end
end)

-- Выбор режима движения
local ModeLabel = Instance.new("TextLabel")
ModeLabel.Text = "Режим движения:"
ModeLabel.Size = UDim2.new(1, -30, 0, 20)
ModeLabel.Position = UDim2.new(0, 15, 0, 145)
ModeLabel.BackgroundTransparency = 1
ModeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
ModeLabel.TextSize = 12
ModeLabel.Font = Enum.Font.Gotham
ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
ModeLabel.Parent = MainFrame

local ModeButtons = {}
local function CreateModeButton(name, xPos, mode)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 95, 0, 30)
    btn.Position = UDim2.new(0, xPos, 0, 170)
    btn.BackgroundColor3 = Config.TeleportMode == mode and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(50, 50, 60)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Parent = MainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    table.insert(ModeButtons, {btn = btn, mode = mode})
    btn.MouseButton1Click:Connect(function()
        Config.TeleportMode = mode
        for _, m in pairs(ModeButtons) do
            m.btn.BackgroundColor3 = (m.mode == mode) and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(50, 50, 60)
        end
    end)
end
CreateModeButton("TP", 15, "TP")
CreateModeButton("Tween", 115, "Tween")
CreateModeButton("Walk", 215, "Walk")

-- Радиус поиска
local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Text = "Радиус поиска: " .. Config.EggRadius .. " studs"
RadiusLabel.Size = UDim2.new(1, -30, 0, 20)
RadiusLabel.Position = UDim2.new(0, 15, 0, 215)
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
RadiusLabel.TextSize = 12
RadiusLabel.Font = Enum.Font.Gotham
RadiusLabel.TextXAlignment = Enum.TextXAlignment.Left
RadiusLabel.Parent = MainFrame

local RadiusBar = Instance.new("Frame")
RadiusBar.Size = UDim2.new(1, -30, 0, 8)
RadiusBar.Position = UDim2.new(0, 15, 0, 240)
RadiusBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
RadiusBar.BorderSizePixel = 0
RadiusBar.Parent = MainFrame
Instance.new("UICorner", RadiusBar).CornerRadius = UDim.new(1, 0)

local RadiusFill = Instance.new("Frame")
RadiusFill.Size = UDim2.new(Config.EggRadius / 2000, 0, 1, 0)
RadiusFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
RadiusFill.BorderSizePixel = 0
RadiusFill.Parent = RadiusBar
Instance.new("UICorner", RadiusFill).CornerRadius = UDim.new(1, 0)

local draggingR = false
RadiusBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingR = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingR = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingR and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local rel = math.clamp((input.Position.X - RadiusBar.AbsolutePosition.X) / RadiusBar.AbsoluteSize.X, 0, 1)
        RadiusFill.Size = UDim2.new(rel, 0, 1, 0)
        local val = math.floor(100 + (2000 - 100) * rel)
        Config.EggRadius = val
        RadiusLabel.Text = "Радиус поиска: " .. val .. " studs"
    end
end)

-- Инфо-строка
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Text = "Найдено яиц: 0 | Remote: " .. (StealRemote and StealRemote.Name or "не найден")
InfoLabel.Size = UDim2.new(1, -30, 0, 20)
InfoLabel.Position = UDim2.new(0, 15, 0, 255)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(120, 220, 120)
InfoLabel.TextSize = 11
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.Parent = MainFrame

-- Обновление счётчика яиц
task.spawn(function()
    while true do
        task.wait(1)
        local count = #GetEggs()
        InfoLabel.Text = "Найдено яиц: " .. count .. " | Remote: " .. (StealRemote and StealRemote.Name or "не найден")
    end
end)

-- Хоткей: RightShift — вкл/выкл Auto Farm
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Config.AutoFarm = not Config.AutoFarm
        if Config.AutoFarm then
            FarmBtn.Text = "■ STOP AUTO FARM"
            FarmBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        else
            FarmBtn.Text = "▶ START AUTO FARM"
            FarmBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        end
    end
end)

-- Уведомление
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Egg Farm загружен",
    Text = "RightShift — вкл/выкл | Слайдер скорости работает",
    Duration = 5
})
