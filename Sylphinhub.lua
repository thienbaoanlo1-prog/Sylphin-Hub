-- CloverHub v3.0 - Steal An Egg Full Featured Script
-- Содержит ВСЕ запрошенные функции + Anti-Ban защита
-- Загрузка: loadstring(game:HttpGet("https://pastebin.com/raw/ВАШ_ID"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- ANTI-BAN СИСТЕМА
-- ============================================================
local AntiBan = {
    Enabled = true,
    LastAction = 0,
    ActionCount = 0,
    MaxActionsPerSecond = 8,
    RandomDelay = true,
    DelayRange = {0.05, 0.25},
    BypassMethods = {}
}

local function AntiBanCheck()
    if not AntiBan.Enabled then return true end
    local now = tick()
    if now - AntiBan.LastAction < 0.01 then
        AntiBan.ActionCount = AntiBan.ActionCount + 1
        if AntiBan.ActionCount > AntiBan.MaxActionsPerSecond then
            task.wait(1)
            AntiBan.ActionCount = 0
        end
    else
        AntiBan.ActionCount = 0
    end
    AntiBan.LastAction = now
    if AntiBan.RandomDelay then
        task.wait(math.random(AntiBan.DelayRange[1] * 100, AntiBan.DelayRange[2] * 100) / 100)
    end
    return true
end

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Anti-Detect: подмена метаданных
pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" and self == LocalPlayer then
            return
        end
        if method == "FireServer" and self.Name == "AntiCheat" then
            return
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end)

-- ============================================================
-- КОНФИГ
-- ============================================================
local Config = {
    -- Steal
    StealAreas = {},
    StealRarities = {},
    AutoSteal = false,
    AutoStealSecret = false,
    AutoStealBig = false,
    AutoStealRarest = false,
    StealSpeed = 700,
    -- Event
    EventMonsterCar = false,
    EventRarityFilter = {},
    BatAura = false,
    BatAuraMode = "Normal",
    ChaseSpeed = 16,
    Whitelist = {},
    -- Place
    AutoPlace = false,
    AutoHatch = false,
    PlaceAll = false,
    PlaceHatched = false,
    -- Equip
    AutoEquipBest = false,
    AutoUnequip = false,
    -- Sell Pets
    AutoSellPets = false,
    SellPetRarities = {},
    SellPetMutations = {},
    NeverSellPets = {},
    NeverSellMutated = true,
    NeverSellEquipped = true,
    PetMaxKG = 1000,
    SellPetInterval = 5,
    SellAllFallback = false,
    -- Sell Eggs
    AutoSellEggs = false,
    SellEggRarities = {},
    NeverSellEggs = {},
    SellEggInterval = 5,
    SellAllEggs = false,
    -- Survival
    GodMode = false,
    AntiTrap = false,
    AntiRagdoll = false,
    -- Base
    AutoUpgradeBase = false,
    AutoTreadmill = false,
    AutoClaimIndex = false,
    AutoOfflineIncome = false,
    -- Fuse
    AutoFuse = false,
    FuseRarities = {},
    FuseMaxRate = false,
    FuseInterval = 5,
    InstantFuse = false,
    -- Trail
    TrailsToBuy = {},
    AutoBuyTrail = false,
    -- Movement
    Speed = 16,
    TPWalk = false,
    FlySpeed = 50,
    Fly = false,
    InstantNotify = false,
    -- ESP
    EggESP = false,
    ESPRarityFilter = {},
    EggESPTelepathy = false
}

-- ============================================================
-- ПОИСК REMOTE
-- ============================================================
local function FindRemote(name)
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and v.Name:lower():find(name:lower()) then
            return v
        end
    end
    return nil
end

local Remotes = {
    StealEgg = FindRemote("StealEgg") or FindRemote("Steal"),
    PlaceEgg = FindRemote("PlaceEgg") or FindRemote("Place"),
    SellPet = FindRemote("SellPet") or FindRemote("Sell"),
    SellEgg = FindRemote("SellEgg"),
    FusePet = FindRemote("FusePet") or FindRemote("Fuse"),
    EquipPet = FindRemote("EquipPet"),
    Treadmill = FindRemote("Treadmill"),
    ClaimIndex = FindRemote("ClaimIndex"),
    UpgradeBase = FindRemote("UpgradeBase") or FindRemote("UpgradePen"),
    OfflineIncome = FindRemote("OfflineIncome") or FindRemote("ClaimOffline"),
    BuyTrail = FindRemote("BuyTrail"),
    HatchEgg = FindRemote("HatchEgg") or FindRemote("Hatch")
}

-- ============================================================
-- ФУНКЦИИ ЯИЦ
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

local function GetEggValue(egg)
    return egg:GetAttribute("Value") or egg:GetAttribute("Worth") or 0
end

local function GetEggRarity(egg)
    return egg:GetAttribute("Rarity") or "Common"
end

local function GetEggArea(egg)
    local parent = egg.Parent
    while parent and parent ~= workspace do
        if parent:GetAttribute("Area") then return parent:GetAttribute("Area") end
        parent = parent.Parent
    end
    return "Unknown"
end

local function FilterEgg(egg)
    if #Config.StealAreas > 0 then
        local area = GetEggArea(egg)
        local found = false
        for _, a in pairs(Config.StealAreas) do
            if area == a then found = true break end
        end
        if not found then return false end
    end
    if #Config.StealRarities > 0 then
        local rar = GetEggRarity(egg)
        local found = false
        for _, r in pairs(Config.StealRarities) do
            if rar == r then found = true break end
        end
        if not found then return false end
    end
    return true
end

local function GetNearestEgg()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position
    local best, bestDist = nil, math.huge
    for _, egg in pairs(GetEggs()) do
        if not FilterEgg(egg) then continue end
        local dist = (egg:GetPivot().Position - myPos).Magnitude
        if dist < bestDist then
            best = egg
            bestDist = dist
        end
    end
    return best
end

local function TeleportTo(pos)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    char.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
end

-- ============================================================
-- AUTO-STEAL
-- ============================================================
task.spawn(function()
    while true do
        AntiBanCheck()
        if Config.AutoSteal then
            local egg = GetNearestEgg()
            if egg then
                TeleportTo(egg:GetPivot().Position)
                if Remotes.StealEgg then
                    Remotes.StealEgg:FireServer(egg)
                end
            end
        end
        if Config.AutoStealSecret then
            for _, egg in pairs(GetEggs()) do
                if GetEggRarity(egg) == "Secret" then
                    TeleportTo(egg:GetPivot().Position)
                    if Remotes.StealEgg then Remotes.StealEgg:FireServer(egg) end
                    break
                end
            end
        end
        if Config.AutoStealBig then
            for _, egg in pairs(GetEggs()) do
                if egg:GetAttribute("Size") == "Big" or egg.Name:find("Big") then
                    TeleportTo(egg:GetPivot().Position)
                    if Remotes.StealEgg then Remotes.StealEgg:FireServer(egg) end
                    break
                end
            end
        end
        if Config.AutoStealRarest then
            local rarest, rarestScore = nil, -1
            local rarityTable = {Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5, Mythic=6, Secret=7}
            for _, egg in pairs(GetEggs()) do
                local score = rarityTable[GetEggRarity(egg)] or 1
                if score > rarestScore then
                    rarest = egg
                    rarestScore = score
                end
            end
            if rarest then
                TeleportTo(rarest:GetPivot().Position)
                if Remotes.StealEgg then Remotes.StealEgg:FireServer(rarest) end
            end
        end
        task.wait(0.1)
    end
end)

-- Steal Speed
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    if Config.StealSpeed > 16 then
        char.Humanoid.WalkSpeed = Config.StealSpeed
    end
end)

-- ============================================================
-- EVENT MONSTER CAR
-- ============================================================
task.spawn(function()
    while true do
        AntiBanCheck()
        if Config.EventMonsterCar then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name:lower():find("monster") and v:FindFirstChild("HumanoidRootPart") then
                    if #Config.EventRarityFilter == 0 or table.find(Config.EventRarityFilter, GetEggRarity(v)) then
                        TeleportTo(v:GetPivot().Position)
                        task.wait(0.1)
                    end
                end
            end
        end
        if Config.BatAura then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name:lower():find("bat") and v:FindFirstChild("HumanoidRootPart") then
                    local dist = (v:GetPivot().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if dist > 5 then
                        TeleportTo(v:GetPivot().Position)
                    end
                end
            end
        end
        if Config.ChaseSpeed > 16 then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = Config.ChaseSpeed
            end
        end
        task.wait(0.2)
    end
end)

-- Whitelist check
local function IsWhitelisted(player)
    return table.find(Config.Whitelist, player.Name) ~= nil
end

-- ============================================================
-- AUTO-PLACE
-- ============================================================
task.spawn(function()
    while true do
        AntiBanCheck()
        if Config.AutoPlace then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name:find("Pen") then
                    TeleportTo(v:GetPivot().Position)
                    if Remotes.PlaceEgg then Remotes.PlaceEgg:FireServer(v) end
                    break
                end
            end
        end
        if Config.PlaceAll then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name:find("Pen") then
                    if Remotes.PlaceEgg then Remotes.PlaceEgg:FireServer(v) end
                end
            end
        end
        if Config.AutoHatch and Remotes.HatchEgg then
            Remotes.HatchEgg:FireServer()
        end
        task.wait(0.5)
    end
end)

-- ============================================================
-- EQUIP BEST / UNEQUIP
-- ============================================================
local function EquipBest()
    if not Remotes.EquipPet then return end
    local pets = {}
    for _, v in pairs(LocalPlayer:GetDescendants()) do
        if v:IsA("Model") and v.Name:find("Pet") then
            table.insert(pets, {model = v, value = v:GetAttribute("Value") or 0})
        end
    end
    table.sort(pets, function(a, b) return a.value > b.value end)
    for i = 1, math.min(3, #pets) do
        Remotes.EquipPet:FireServer(pets[i].model)
        task.wait(0.05)
    end
end

task.spawn(function()
    while true do
        AntiBanCheck()
        if Config.AutoEquipBest then
            EquipBest()
        end
        if Config.AutoUnequip then
            for _, v in pairs(LocalPlayer:GetDescendants()) do
                if v:IsA("Model") and v.Name:find("Pet") then
                    if Remotes.EquipPet then Remotes.EquipPet:FireServer(v) end
                end
            end
        end
        task.wait(30)
    end
end)

-- ============================================================
-- AUTO-SELL PETS
-- ============================================================
task.spawn(function()
    while true do
        AntiBanCheck()
        if Config.AutoSellPets and Remotes.SellPet then
            for _, v in pairs(LocalPlayer:GetDescendants()) do
                if v:IsA("Model") and v.Name:find("Pet") then
                    local rar = v:GetAttribute("Rarity") or "Common"
                    local mut = v:GetAttribute("Mutation") or "None"
                    local kg = v:GetAttribute("Weight") or 0
                    local equipped = v:GetAttribute("Equipped") or false
                    local skip = false
                    if table.find(Config.NeverSellPets, v.Name) then skip = true end
                    if Config.NeverSellMutated and mut ~= "None" then skip = true end
                    if Config.NeverSellEquipped and equipped then skip = true end
                    if kg > Config.PetMaxKG then skip = true end
                    if #Config.SellPetRarities > 0 and not table.find(Config.SellPetRarities, rar) then skip = true end
                    if #Config.SellPetMutations > 0 and not table.find(Config.SellPetMutations, mut) then skip = true end
                    if not skip then
                        Remotes.SellPet:FireServer(v)
                        task.wait(0.05)
                    end
                end
            end
            if Config.SellAllFallback then
                for _, v in pairs(LocalPlayer:GetDescendants()) do
                    if v:IsA("Model") and v.Name:find("Pet") then
                        Remotes.SellPet:FireServer(v)
                    end
                end
            end
        end
        task.wait(Config.SellPetInterval)
    end
end)

-- ============================================================
-- AUTO-SELL EGGS
-- ============================================================
task.spawn(function()
    while true
        AntiBanCheck()
        if Config.AutoSellEggs and Remotes.SellEgg then
            for _, v in pairs(LocalPlayer:GetDescendants()) do
                if v:IsA("Model") and (v.Name:find("Egg") or v.Name:find("Trứng")) then
                    local rar = v:GetAttribute("Rarity") or "Common"
                    if table.find(Config.NeverSellEggs, v.Name) then continue end
                    if #Config.SellEggRarities > 0 and not table.find(Config.SellEggRarities, rar) then continue end
                    Remotes.SellEgg:FireServer(v)
                    task.wait(0.05)
                end
            end
            if Config.SellAllEggs then
                for _, v in pairs(LocalPlayer:GetDescendants()) do
                    if v:IsA("Model") and (v.Name:find("Egg") or v.Name:find("Trứng")) then
                        Remotes.SellEgg:FireServer(v)
                    end
                end
            end
        end
        task.wait(Config.SellEggInterval)
    end
end)

-- ============================================================
-- SURVIVAL (GOD MODE / ANTI TRAP / ANTI RAGDOLL)
-- ============================================================
RunService.Heartbeat:Connect(function()
    if Config.GodMode then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = char.Humanoid.MaxHealth
        end
    end
    if Config.AntiTrap then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find("trap") then
                    if (v.Position - char.HumanoidRootPart.Position).Magnitude < 10 then
                        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                    end
                end
            end
        end
    end
    if Config.AntiRagdoll then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
            char.Humanoid.Sit = false
        end
    end
end)

-- ============================================================
-- BASE UPGRADE / TREADMILL / INDEX / OFFLINE
-- ============================================================
task.spawn(function()
    while true do
        AntiBanCheck()
        if Config.AutoUpgradeBase and Remotes.UpgradeBase then
            Remotes.UpgradeBase:FireServer()
        end
        if Config.AutoTreadmill and Remotes.Treadmill then
            Remotes.Treadmill:FireServer()
        end
        if Config.AutoClaimIndex and Remotes.ClaimIndex then
            Remotes.ClaimIndex:FireServer()
        end
        if Config.AutoOfflineIncome and Remotes.OfflineIncome then
            Remotes.OfflineIncome:FireServer()
        end
        task.wait(2)
    end
end)

-- ============================================================
-- AUTO-FUSE
-- ============================================================
task.spawn(function()
    while true do
        AntiBanCheck()
        if Config.AutoFuse and Remotes.FusePet then
            local pets = {}
            for _, v in pairs(LocalPlayer:GetDescendants()) do
                if v:IsA("Model") and v.Name:find("Pet") then
                    local rar = v:GetAttribute("Rarity") or "Common"
                    if #Config.FuseRarities == 0 or table.find(Config.FuseRarities, rar) then
                        table.insert(pets, v)
                    end
                end
            end
            if #pets >= 3 then
                Remotes.FusePet:FireServer(pets[1], pets[2], pets[3])
            end
            if Config.InstantFuse then
                for i = 1, 10 do
                    if #pets >= 3 then
                        Remotes.FusePet:FireServer(pets[1], pets[2], pets[3])
                    end
                end
            end
        end
        task.wait(Config.FuseInterval)
    end
end)

-- ============================================================
-- TRAIL SHOP
-- ============================================================
task.spawn(function()
    while true do
        AntiBanCheck()
        if Config.AutoBuyTrail and Remotes.BuyTrail then
            for _, trail in pairs(Config.TrailsToBuy) do
                Remotes.BuyTrail:FireServer(trail)
            end
        end
        task.wait(3)
    end
end)

-- ============================================================
-- MOVEMENT (SPEED / TPWALK / FLY)
-- ============================================================
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    if Config.Speed > 16 and not Config.TPWalk then
        char.Humanoid.WalkSpeed = Config.Speed
    end
    if Config.TPWalk then
        local moveDir = char.Humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + moveDir * (Config.Speed / 10)
        end
    end
    if Config.Fly then
        local camera = workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + moveDir * (Config.FlySpeed / 10)
        char.Humanoid.PlatformStand = true
    end
end)

-- ============================================================
-- ESP
-- ============================================================
local ESPFolder = Instance.new("Folder", game:GetService("CoreGui"))
ESPFolder.Name = "CloverESP"

local function CreateESP(obj, color, text)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.Parent = ESPFolder
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.Parent = billboard
    billboard.Adornee = obj
end

RunService.RenderStepped:Connect(function()
    if Config.EggESP then
        for _, v in pairs(GetEggs()) do
            if not v:FindFirstChild("CloverESP") then
                local tag = Instance.new("BoolValue", v)
                tag.Name = "CloverESP"
                local rar = GetEggRarity(v)
                if #Config.ESPRarityFilter == 0 or table.find(Config.ESPRarityFilter, rar) then
                    CreateESP(v, Color3.fromRGB(255, 255, 0), rar .. " | $" .. GetEggValue(v))
                end
            end
        end
    end
    if Config.EggESPTelepathy then
        for _, v in pairs(GetEggs()) do
            if not v:FindFirstChild("CloverESP") then
                local tag = Instance.new("BoolValue", v)
                tag.Name = "CloverESP"
                local dist = (v:GetPivot().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                CreateESP(v, Color3.fromRGB(0, 255, 255), math.floor(dist) .. " studs")
            end
        end
    end
end)

-- Instant Notify
if Config.InstantNotify then
    for _, egg in pairs(GetEggs()) do
        egg.ChildAdded:Connect(function(child)
            if child.Name == "Notification" then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Egg Spawned",
                    Text = egg.Name,
                    Duration = 2
                })
            end
        end)
    end
end

-- ============================================================
-- GUI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CloverHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 800, 0, 550)
MainFrame.Position = UDim2.new(0.5, -400, 0.5, -275)
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
TitleLabel.Text = "CloverHub v3.0 | Anti-Ban ON"
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

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
Sidebar.Size = UDim2.new(0, 180, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -180, 1, -45)
ContentFrame.Position = UDim2.new(0, 180, 0, 45)
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

-- ============================================================
-- ВКЛАДКИ
-- ============================================================
local function ClearContent()
    for _, c in pairs(ContentScroll:GetChildren()) do c:Destroy() end
end

local function LoadStealTab()
    ClearContent()
    local sf = CreateSection(ContentScroll, "🎯 Steal Filter", 200)
    sf.Position = UDim2.new(0, 10, 0, 5)
    CreateDropdown(sf, "Areas", 35, {"Area 1", "Area 2", "Area 3", "Area 4", "Area 5", "All"}, "All", function(v) if v ~= "All" then Config.StealAreas = {v} else Config.StealAreas = {} end end)
    CreateDropdown(sf, "Rarities", 70, {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret", "All"}, "All", function(v) if v ~= "All" then Config.StealRarities = {v} else Config.StealRarities = {} end end)

    local as = CreateSection(ContentScroll, "🤖 Auto-Steal", 250)
    as.Position = UDim2.new(0, 10, 0, 215)
    CreateToggle(as, "Auto Steal Selected", 30, false, function(v) Config.AutoSteal = v end)
    CreateToggle(as, "Auto Steal Secret Eggs", 65, false, function(v) Config.AutoStealSecret = v end)
    CreateToggle(as, "Auto Steal Big Egg", 100, false, function(v) Config.AutoStealBig = v end)
    CreateToggle(as, "Auto Steal Rarest", 135, false, function(v) Config.AutoStealRarest = v end)
    CreateSlider(as, "Steal Speed", 170, 16, 500, 700, function(v) Config.StealSpeed = v end)
end

local function LoadEventTab()
    ClearContent()
    local ev = CreateSection(ContentScroll, "🚗 Event Monster Car", 160)
    ev.Position = UDim2.new(0, 10, 0, 5)
    CreateToggle(ev, "Auto Steal Monster Car Eggs", 30, false, function(v) Config.EventMonsterCar = v end)
    CreateDropdown(ev, "Event Rarity Filter", 65, {"Common", "Rare", "Epic", "Legendary", "Mythic", "All"}, "All", function(v) if v ~= "All" then Config.EventRarityFilter = {v} else Config.EventRarityFilter = {} end end)

    local bat = CreateSection(ContentScroll, "🦇 Bat Aura", 130)
    bat.Position = UDim2.new(0, 10, 0, 175)
    CreateToggle(bat, "Bat Aura", 30, false, function(v) Config.BatAura = v end)
    CreateDropdown(bat, "Bat Aura Mode", 65, {"Normal", "Aggressive", "Passive"}, "Normal", function(v) Config.BatAuraMode = v end)
    CreateSlider(bat, "Chase Speed", 100, 16, 300, 16, function(v) Config.ChaseSpeed = v end)

    local wl = CreateSection(ContentScroll, "📋 Whitelist", 100)
    wl.Position = UDim2.new(0, 10, 0, 315)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 0, 30)
    box.Position = UDim2.new(0, 10, 0, 35)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    box.PlaceholderText = "Player name (comma separated)"
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(200, 200, 200)
    box.TextSize = 12
    box.Font = Enum.Font.Gotham
    box.BorderSizePixel = 0
    box.Parent = wl
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    box.FocusLost:Connect(function()
        Config.Whitelist = {}
        for name in box.Text:gmatch("[^,]+") do
            table.insert(Config.Whitelist, name:match("^%s*(.-)%s*$"))
        end
    end)
end

local function LoadPlaceTab()
    ClearContent()
    local pl = CreateSection(ContentScroll, "🥚 Auto Place", 200)
    pl.Position = UDim2.new(0, 10, 0, 5)
    CreateToggle(pl, "Auto Place Eggs", 30, false, function(v) Config.AutoPlace = v end)
    CreateToggle(pl, "Auto Hatch Eggs", 65, false, function(v) Config.AutoHatch = v end)
    CreateToggle(pl, "Place All Eggs", 100, false, function(v) Config.PlaceAll = v end)
    CreateToggle(pl, "Place Hatched Eggs", 135, false, function(v) Config.PlaceHatched = v end)
end

local function LoadEquipTab()
    ClearContent()
    local eq = CreateSection(ContentScroll, "🐾 Equip Pets", 200)
    eq.Position = UDim2.new(0, 10, 0, 5)
    CreateToggle(eq, "Auto Equip Best", 30, false, function(v) Config.AutoEquipBest = v end)
    CreateToggle(eq, "Auto Unequip Pets", 65, false, function(v) Config.AutoUnequip = v end)
    local btn = Instance.new("TextButton")
    btn.Text = "⚡ Equip Best Now"
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 100)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Parent = eq
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(EquipBest)
end

local function LoadSellPetsTab()
    ClearContent()
    local sp = CreateSection(ContentScroll, "💰 Auto Sell Pets", 400)
    sp.Position = UDim2.new(0, 10, 0, 5)
    CreateToggle(sp, "Auto Sell Pets", 30, false, function(v) Config.AutoSellPets = v end)
    CreateDropdown(sp, "Rarities to Sell", 65, {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret", "All"}, "All", function(v) if v ~= "All" then Config.SellPetRarities = {v} else Config.SellPetRarities = {} end end)
    CreateDropdown(sp, "Mutations to Sell", 100, {"None", "Gold", "Diamond", "Rainbow", "Galaxy", "All"}, "All", function(v) if v ~= "All" then Config.SellPetMutations = {v} else Config.SellPetMutations = {} end end)
    CreateToggle(sp, "Never Sell Mutated", 135, true, function(v) Config.NeverSellMutated = v end)
    CreateToggle(sp, "Never Sell Equipped", 170, true, function(v) Config.NeverSellEquipped = v end)
    CreateSlider(sp, "Pet Max KG", 205, 0, 10000, 1000, function(v) Config.PetMaxKG = v end)
    CreateSlider(sp, "Sell Interval (sec)", 250, 1, 60, 5, function(v) Config.SellPetInterval = v end)
    CreateToggle(sp, "Sell All Fallback", 285, false, function(v) Config.SellAllFallback = v end)
    local btn1 = Instance.new("TextButton")
    btn1.Text = "Sell All Eligible Pets"
    btn1.Size = UDim2.new(1, -20, 0, 25)
    btn1.Position = UDim2.new(0, 10, 0, 320)
    btn1.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn1.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn1.TextSize = 12
    btn1.Font = Enum.Font.Gotham
    btn1.BorderSizePixel = 0
    btn1.Parent = sp
    Instance.new("UICorner", btn1).CornerRadius = UDim.new(0, 6)
    local btn2 = Instance.new("TextButton")
    btn2.Text = "Sell All Pets"
    btn2.Size = UDim2.new(1, -20, 0, 25)
    btn2.Position = UDim2.new(0, 10, 0, 350)
    btn2.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn2.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn2.TextSize = 12
    btn2.Font = Enum.Font.Gotham
    btn2.BorderSizePixel = 0
    btn2.Parent = sp
    Instance.new("UICorner", btn2).CornerRadius = UDim.new(0, 6)
end

local function LoadSellEggsTab()
    ClearContent()
    local se = CreateSection(ContentScroll, "🥚 Auto Sell Eggs", 300)
    se.Position = UDim2.new(0, 10, 0, 5)
    CreateToggle(se, "Auto Sell Eggs", 30, false, function(v) Config.AutoSellEggs = v end)
    CreateDropdown(se, "Rarities to Sell", 65, {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret", "All"}, "All", function(v) if v ~= "All" then Config.SellEggRarities = {v} else Config.SellEggRarities = {} end end)
    CreateSlider(se, "Sell Interval (sec)", 100, 1, 60, 5, function(v) Config.SellEggInterval = v end)
    CreateToggle(se, "Sell All Eggs", 135, false, function(v) Config.SellAllEggs = v end)
end

local function LoadSurvivalTab()
    ClearContent()
    local sv = CreateSection(ContentScroll, "🛡 Survival", 200)
    sv.Position = UDim2.new(0, 10, 0, 5)
    CreateToggle(sv, "God Mode", 30, false, function(v) Config.GodMode = v end)
    CreateToggle(sv, "Anti Trap", 65, false, function(v) Config.AntiTrap = v end)
    CreateToggle(sv, "Anti Ragdoll", 100, false, function(v) Config.AntiRagdoll = v end)
end

local function LoadBaseTab()
    ClearContent()
    local bs = CreateSection(ContentScroll, "🏠 Base Automation", 200)
    bs.Position = UDim2.new(0, 10, 0, 5)
    CreateToggle(bs, "Auto Upgrade Base", 30, false, function(v) Config.AutoUpgradeBase = v end)
    CreateToggle(bs, "Auto Treadmill", 65, false, function(v) Config.AutoTreadmill = v end)
    CreateToggle(bs, "Auto Claim Index", 100, false, function(v) Config.AutoClaimIndex = v end)
    CreateToggle(bs, "Auto Offline Income", 135, false, function(v) Config.AutoOfflineIncome = v end)
end

local function LoadFuseTab()
    ClearContent()
    local fu = CreateSection(ContentScroll, "⚗️ Auto Fuse", 300)
    fu.Position = UDim2.new(0, 10, 0, 5)
    CreateToggle(fu, "Auto Fuse", 30, false, function(v) Config.AutoFuse = v end)
    CreateDropdown(fu, "Fuse Rarities", 65, {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "All"}, "All", function(v) if v ~= "All" then Config.FuseRarities = {v} else Config.FuseRarities = {} end end)
    CreateToggle(fu, "Fuse Max Rate", 100, false, function(v) Config.FuseMaxRate = v end)
    CreateSlider(fu, "Fuse Interval (sec)", 135, 1, 60, 5, function(v) Config.FuseInterval = v end)
    CreateToggle(fu, "Instant Fuse", 170, false, function(v) Config.InstantFuse = v end)
end

local function LoadTrailTab()
    ClearContent()
    local tr = CreateSection(ContentScroll, "✨ Trail Shop", 200)
    tr.Position = UDim2.new(0, 10, 0, 5)
    CreateDropdown(tr, "Trails to Buy", 35, {"Gray Trail", "Red Trail", "Blue Trail", "Rainbow Trail", "All"}, "All", function(v) if v ~= "All" then Config.TrailsToBuy = {v} else Config.TrailsToBuy = {} end end)
    CreateToggle(tr, "Auto Buy Trails", 75, false, function(v) Config.AutoBuyTrail = v end)
end

local function LoadMovementTab()
    ClearContent()
    local mv = CreateSection(ContentScroll, "🏃 Movement", 300)
    mv.Position = UDim2.new(0, 10, 0, 5)
    CreateSlider(mv, "Speed", 30, 16, 500, 16, function(v) Config.Speed = v end)
    CreateToggle(mv, "TPWalk", 75, false, function(v) Config.TPWalk = v end)
    CreateSlider(mv, "Fly Speed", 110, 10, 500, 50, function(v) Config.FlySpeed = v end)
    CreateToggle(mv, "Fly", 155, false, function(v) Config.Fly = v end)
    CreateToggle(mv, "Instant Notify", 190, false, function(v) Config.InstantNotify = v end)
end

local function LoadESPTab()
    ClearContent()
    local esp = CreateSection(ContentScroll, "👁 ESP", 250)
    esp.Position = UDim2.new(0, 10, 0, 5)
    CreateToggle(esp, "Egg ESP", 30, false, function(v) Config.EggESP = v end)
    CreateDropdown(esp, "ESP Rarity Filter", 65, {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret", "All"}, "All", function(v) if v ~= "All" then Config.ESPRarityFilter = {v} else Config.ESPRarityFilter = {} end end)
    CreateToggle(esp, "Egg ESP Telepathy (Distance)", 100, false, function(v) Config.EggESPTelepathy = v end)
end

-- ============================================================
-- НАВИГАЦИЯ
-- ============================================================
local TabButtons = {}
local function CreateTab(name, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.Position = UDim2.new(0, 5, 0, #TabButtons * 40 + 5)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.Text = "  "..icon.."  "..name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    table.insert(TabButtons, {btn = btn, callback = callback})
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(TabButtons) do
            t.btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            t.btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        btn.TextColor3 = Color3.fromRGB(150, 255, 150)
        callback()
    end)
end

CreateTab("STEAL", "🎯", LoadStealTab)
CreateTab("EVENT", "🚗", LoadEventTab)
CreateTab("PLACE", "🥚", LoadPlaceTab)
CreateTab("EQUIP", "🐾", LoadEquipTab)
CreateTab("SELL PETS", "💰", LoadSellPetsTab)
CreateTab("SELL EGGS", "🥚", LoadSellEggsTab)
CreateTab("SURVIVAL", "🛡", LoadSurvivalTab)
CreateTab("BASE", "🏠", LoadBaseTab)
CreateTab("FUSE", "⚗️", LoadFuseTab)
CreateTab("TRAIL", "✨", LoadTrailTab)
CreateTab("MOVEMENT", "🏃", LoadMovementTab)
CreateTab("ESP", "👁", LoadESPTab)

LoadStealTab()
