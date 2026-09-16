-- ============================================================
-- SYLPHIN HUB - BLADE CLIENT UI (4 TABS CHUẨN)
-- ============================================================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Khởi tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SylphinHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Bảng chính (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 620, 0, 380)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 19, 24)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

-- Giúp UI tự động thu phóng/co giãn tỷ lệ chuẩn mọi thiết bị
local AspectRatio = Instance.new("UIAspectRatioConstraint", MainFrame)
AspectRatio.AspectRatio = 620 / 380

-- Nút ẩn/hiện Menu (Toggle Button)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 85, 0, 30)
ToggleBtn.Position = UDim2.new(0, 15, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
ToggleBtn.Text = "SYLPHIN"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 11
ToggleBtn.Active = true
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

local tStroke = Instance.new("UIStroke", ToggleBtn)
tStroke.Color = Color3.fromRGB(123, 92, 255)
tStroke.Thickness = 1.5

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Sidebar (Thanh bên trái)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0.28, 0, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Sidebar.BorderSizePixel = 0

local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.Padding = UDim.new(0, 4)
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder

local SidebarPadding = Instance.new("UIPadding", Sidebar)
SidebarPadding.PaddingTop = UDim.new(0, 12)
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingRight = UDim.new(0, 8)

-- Profile Footer Card (Khúc dưới menu chuẩn Blade UI)
local ProfileCard = Instance.new("Frame", Sidebar)
ProfileCard.Size = UDim2.new(1, 0, 0, 50)
ProfileCard.Position = UDim2.new(0, 0, 1, -56)
ProfileCard.BackgroundColor3 = Color3.fromRGB(18, 19, 24)
ProfileCard.BorderSizePixel = 0
Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 10)

local AvatarImg = Instance.new("ImageLabel", ProfileCard)
AvatarImg.Size = UDim2.new(0, 34, 0, 34)
AvatarImg.Position = UDim2.new(0, 8, 0.5, -17)
AvatarImg.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
pcall(function()
    AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

local NameLabel = Instance.new("TextLabel", ProfileCard)
NameLabel.Size = UDim2.new(1, -50, 0, 16)
NameLabel.Position = UDim2.new(0, 48, 0, 8)
NameLabel.BackgroundTransparency = 1
NameLabel.Font = Enum.Font.GothamBold
NameLabel.Text = LocalPlayer.Name
NameLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
NameLabel.TextSize = 11
NameLabel.TextXAlignment = Enum.TextXAlignment.Left

local ExpiryLabel = Instance.new("TextLabel", ProfileCard)
ExpiryLabel.Size = UDim2.new(1, -50, 0, 14)
ExpiryLabel.Position = UDim2.new(0, 48, 0, 26)
ExpiryLabel.BackgroundTransparency = 1
ExpiryLabel.Font = Enum.Font.Gotham
ExpiryLabel.Text = "Till: 1 Jan 2026"
ExpiryLabel.TextColor3 = Color3.fromRGB(130, 135, 150)
ExpiryLabel.TextSize = 10
ExpiryLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Container Khung Nội Dung
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(0.72, 0, 1, 0)
ContentArea.Position = UDim2.new(0.28, 0, 0, 0)
ContentArea.BackgroundTransparency = 1

local ContentPadding = Instance.new("UIPadding", ContentArea)
ContentPadding.PaddingTop = UDim.new(0, 12)
ContentPadding.PaddingLeft = UDim.new(0, 12)
ContentPadding.PaddingRight = UDim.new(0, 12)
ContentPadding.PaddingBottom = UDim.new(0, 12)

-- Hệ thống Tabs
local Tabs = {}

local function CreateTab(name, iconId)
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(1, 0, 0, 34)
    TabBtn.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = ""
    TabBtn.AutoButtonColor = false
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    -- Vạch tím chỉ báo Active khi click
    local ActiveIndicator = Instance.new("Frame", TabBtn)
    ActiveIndicator.Size = UDim2.new(0, 3, 0, 18)
    ActiveIndicator.Position = UDim2.new(0, 0, 0.5, -9)
    ActiveIndicator.BackgroundColor3 = Color3.fromRGB(123, 92, 255)
    ActiveIndicator.BorderSizePixel = 0
    ActiveIndicator.Visible = false
    Instance.new("UICorner", ActiveIndicator).CornerRadius = UDim.new(1, 0)

    -- Biểu tượng Icon
    local Icon = Instance.new("ImageLabel", TabBtn)
    Icon.Size = UDim2.new(0, 16, 0, 16)
    Icon.Position = UDim2.new(0, 10, 0.5, -8)
    Icon.BackgroundTransparency = 1
    Icon.Image = iconId or "rbxassetid://6031094678"
    Icon.ImageColor3 = Color3.fromRGB(140, 145, 160)

    local Title = Instance.new("TextLabel", TabBtn)
    Title.Size = UDim2.new(1, -34, 1, 0)
    Title.Position = UDim2.new(0, 32, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamMedium
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(140, 145, 160)
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local PageList = Instance.new("UIListLayout", Page)
    PageList.Padding = UDim.new(0, 8)

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Btn.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
            t.Indicator.Visible = false
            t.Title.TextColor3 = Color3.fromRGB(140, 145, 160)
            t.Icon.ImageColor3 = Color3.fromRGB(140, 145, 160)
            t.Page.Visible = false
        end

        TabBtn.BackgroundColor3 = Color3.fromRGB(32, 34, 44)
        ActiveIndicator.Visible = true
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Page.Visible = true
    end)

    local tabData = {Btn = TabBtn, Indicator = ActiveIndicator, Title = Title, Icon = Icon, Page = Page}
    table.insert(Tabs, tabData)
    return Page
end

-- Tạo 4 Tab theo yêu cầu
local HomePage = CreateTab("Home", "rbxassetid://6031075929")
local ServerHopPage = CreateTab("Server Hop", "rbxassetid://6034818372")
local ScriptsPage = CreateTab("Scripts", "rbxassetid://6031094678")
local ConfigPage = CreateTab("Config", "rbxassetid://6031097225")

-- Mặc định mở Tab Home
Tabs[1].Btn.BackgroundColor3 = Color3.fromRGB(32, 34, 44)
Tabs[1].Indicator.Visible = true
Tabs[1].Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Tabs[1].Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
Tabs[1].Page.Visible = true

-- Component: Slider Trượt (1 - 7)
local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -6, 0, 48)
    Frame.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", Frame).Color = Color3.fromRGB(35, 38, 48)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -20, 0, 18)
    Label.Position = UDim2.new(0, 10, 0, 6)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text .. ": " .. tostring(default)
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Track = Instance.new("Frame", Frame)
    Track.Size = UDim2.new(1, -20, 0, 6)
    Track.Position = UDim2.new(0, 10, 0, 30)
    Track.BackgroundColor3 = Color3.fromRGB(40, 42, 52)
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(123, 92, 255)
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame", Fill)
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = UDim2.new(1, -6, 0.5, -6)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + ((max - min) * pos))
        Fill.Size = UDim2.new((val - min)/(max - min), 0, 1, 0)
        Label.Text = text .. ": " .. tostring(val)
        callback(val)
    end

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            Update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            Update(input)
        end
    end)
end

-- Component: Button
local function CreateButton(parent, text, color, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -6, 0, 38)
    Btn.BackgroundColor3 = color or Color3.fromRGB(123, 92, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 11
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    Btn.MouseButton1Click:Connect(function() callback(Btn) end)
    return Btn
end

-- ============================================================
-- TAB 1: HOME (MẠNG XÃ HỘI)
-- ============================================================
local socials = {
    {"TikTok", "https://www.tiktok.com/@sylphin_12tc?_r=1&_t=ZS-99m7QXnxo96"},
    {"Discord", "https://discord.gg/aYvWCqTTd"},
    {"YouTube", "https://youtube.com/@sylphinroblox?si=j90dBpPtOkiHn3qA"}
}

for _, item in ipairs(socials) do
    local card = Instance.new("Frame", HomePage)
    card.Size = UDim2.new(1, -6, 0, 48)
    card.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", card).Color = Color3.fromRGB(35, 38, 48)

    local sTitle = Instance.new("TextLabel", card)
    sTitle.Size = UDim2.new(0, 180, 0, 18)
    sTitle.Position = UDim2.new(0, 10, 0, 6)
    sTitle.BackgroundTransparency = 1
    sTitle.Text = item[1]
    sTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sTitle.Font = Enum.Font.GothamBold
    sTitle.TextSize = 12
    sTitle.TextXAlignment = Enum.TextXAlignment.Left

    local sLink = Instance.new("TextLabel", card)
    sLink.Size = UDim2.new(1, -110, 0, 14)
    sLink.Position = UDim2.new(0, 10, 0, 26)
    sLink.BackgroundTransparency = 1
    sLink.Text = item[2]
    sLink.TextColor3 = Color3.fromRGB(120, 125, 140)
    sLink.Font = Enum.Font.Gotham
    sLink.TextSize = 9
    sLink.TextXAlignment = Enum.TextXAlignment.Left

    local copyBtn = Instance.new("TextButton", card)
    copyBtn.Size = UDim2.new(0, 70, 0, 26)
    copyBtn.Position = UDim2.new(1, -78, 0.5, -13)
    copyBtn.BackgroundColor3 = Color3.fromRGB(123, 92, 255)
    copyBtn.Text = "COPY"
    copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.TextSize = 10
    Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)

    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(item[2])
            copyBtn.Text = "COPIED!"
            task.wait(1.5)
            copyBtn.Text = "COPY"
        end
    end)
end

-- ============================================================
-- TAB 2: SERVER HOP
-- ============================================================
local maxPlayers = 1
local autoDetectThreshold = 3
local autoDetectActive = false
local autoHopActive = false
local isHopping = false

local function hopServer()
    if isHopping then return end
    isHopping = true
    local placeId = game.PlaceId
    local jobId = game.JobId

    task.spawn(function()
        local nextPageCursor = ""
        for i = 1, math.random(5, 12) do
            local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Desc&limit=100" .. (nextPageCursor ~= "" and "&cursor=" .. nextPageCursor or "")
            local ok, response = pcall(function() return game:HttpGet(url) end)
            if ok and response then
                local ok2, data = pcall(function() return HttpService:JSONDecode(response) end)
                if ok2 and data and data.nextPageCursor then
                    nextPageCursor = data.nextPageCursor
                else break end
            else break end
        end

        local finalUrl = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100" .. (nextPageCursor ~= "" and "&cursor=" .. nextPageCursor or "")
        local ok, response = pcall(function() return game:HttpGet(finalUrl) end)
        local targetServer

        if ok and response then
            local ok2, data = pcall(function() return HttpService:JSONDecode(response) end)
            if ok2 and data and data.data then
                local validServers = {}
                for _, server in ipairs(data.data) do
                    if server.id ~= jobId and server.playing <= maxPlayers and server.playing > 0 then
                        table.insert(validServers, server)
                    end
                end
                if #validServers > 0 then
                    table.sort(validServers, function(a, b) return a.playing < b.playing end)
                    targetServer = validServers[1]
                end
            end
        end

        if targetServer then
            TeleportService:TeleportToPlaceInstance(placeId, targetServer.id, LocalPlayer)
        else
            task.wait(0.5)
            isHopping = false
            hopServer()
        end
    end)
end

Players.PlayerAdded:Connect(function()
    if autoDetectActive and #Players:GetPlayers() >= autoDetectThreshold then
        hopServer()
    end
end)

local ServerInfoLabel = Instance.new("TextLabel", ServerHopPage)
ServerInfoLabel.Size = UDim2.new(1, -6, 0, 18)
ServerInfoLabel.BackgroundTransparency = 1
ServerInfoLabel.Font = Enum.Font.GothamMedium
ServerInfoLabel.Text = "Current Server: " .. #Players:GetPlayers() .. " player(s)"
ServerInfoLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
ServerInfoLabel.TextSize = 11
ServerInfoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Thanh trượt Slider 1 - 7
CreateSlider(ServerHopPage, "Max Players Threshold", 1, 7, maxPlayers, function(v) maxPlayers = v end)
CreateSlider(ServerHopPage, "Auto Detect Threshold", 1, 7, autoDetectThreshold, function(v) autoDetectThreshold = v end)

CreateButton(ServerHopPage, "HOP SERVER NOW", Color3.fromRGB(123, 92, 255), function() hopServer() end)

local autoDetectBtn
autoDetectBtn = CreateButton(ServerHopPage, "AUTO DETECT HOP: DISABLED", Color3.fromRGB(24, 25, 32), function()
    autoDetectActive = not autoDetectActive
    autoDetectBtn.Text = "AUTO DETECT HOP: " .. (autoDetectActive and "ENABLED" or "DISABLED")
    autoDetectBtn.TextColor3 = autoDetectActive and Color3.fromRGB(123, 92, 255) or Color3.fromRGB(255, 255, 255)
end)

local autoHopBtn
autoHopBtn = CreateButton(ServerHopPage, "AUTO HOP: DISABLED", Color3.fromRGB(24, 25, 32), function()
    autoHopActive = not autoHopActive
    autoHopBtn.Text = "AUTO HOP: " .. (autoHopActive and "ENABLED" or "DISABLED")
    autoHopBtn.TextColor3 = autoHopActive and Color3.fromRGB(123, 92, 255) or Color3.fromRGB(255, 255, 255)
    if autoHopActive then hopServer() end
end)

-- ============================================================
-- TAB 3: SCRIPTS (CÓ THANH TÌM KIẾM SEARCH ELEMENT)
-- ============================================================
local searchBarFrame = Instance.new("Frame", ScriptsPage)
searchBarFrame.Size = UDim2.new(1, -6, 0, 32)
searchBarFrame.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Instance.new("UICorner", searchBarFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", searchBarFrame).Color = Color3.fromRGB(35, 38, 48)

local searchInput = Instance.new("TextBox", searchBarFrame)
searchInput.Size = UDim2.new(1, -20, 1, 0)
searchInput.Position = UDim2.new(0, 10, 0, 0)
searchInput.BackgroundTransparency = 1
searchInput.PlaceholderText = "Search element..."
searchInput.PlaceholderColor3 = Color3.fromRGB(100, 105, 120)
searchInput.Text = ""
searchInput.TextColor3 = Color3.fromRGB(255, 255, 255)
searchInput.Font = Enum.Font.GothamMedium
searchInput.TextSize = 11
searchInput.TextXAlignment = Enum.TextXAlignment.Left

local hubs = {
    {"BigFroot", false, "https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"},
    {"NRL", false, "https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua"},
    {"AJJAN", false, "https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua"},
    {"Zeroin", false, "https://raw.githubusercontent.com/napun87/stealanegg/refs/heads/main/Zeroin.lua"},
    {"Clover", false, "https://cloverhub.app/clover.lua"},
    {"Tsuo", true, "https://raw.githubusercontent.com/Tsuo7/TsuoHub/main/stealanegg"},
    {"Blyxo hub", true, "https://flowauth.net/v1/loaders/69d3463240384f3a73fbe32c178093a2.lua"},
    {"Voidshell", true, "https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/StealAnEgg.luau"},
    {"Night Hub", true, "https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/StealEggOnly.luau"},
    {"BK Hub", true, "https://api.luarmor.net/files/v4/loaders/9ee4edde227ac85f50872bf9e4226508.lua"},
    {"Axon", false, "https://api.luarmor.net/files/v3/loaders/97c3f6db55a2cf72141537a85458e5a7.lua"},
    {"Miranda Hub", true, "https://raw.githubusercontent.com/miirandahub/loader/refs/heads/main/stealaeggs"},
    {"Lennon Hub", true, "https://raw.githubusercontent.com/lennonxscripts/lennonhubv2/refs/heads/main/stealaneggv2"},
    {"Fyy", false, "https://FyyCommunity.com"},
    {"Airflow", false, "https://airflowscript.com/loader"},
    {"On hub", true, "https://raw.githubusercontent.com/davizin713/ONhub/refs/heads/main/script.lua"},
    {"Ub hub", true, "https://raw.githubusercontent.com/TeamUBHub/UBLoader/refs/heads/main/Loader.lua"},
    {"Sena", true, "https://raw.githubusercontent.com/senarblx/sena/refs/heads/main/loaderv2sena"},
    {"Chilli", true, "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"},
    {"Ronnei Hub", true, "https://raw.githubusercontent.com/elonmod/skibidi/refs/heads/main/Ronneihub-keyless.lua"},
    {"Foxname", true, "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/Fn-stealanegg.lua"},
    {"Menu Tieng Viet", true, "https://raw.githubusercontent.com/tranduykhanh08428-web/Raw.lua/refs/heads/main/Stealanegg.lua"},
    {"Limbohub", true, "https://limbohub.my.id/loader.lua"}
}

local scriptCards = {}
for _, v in ipairs(hubs) do
    local row = Instance.new("Frame", ScriptsPage)
    row.Size = UDim2.new(1, -6, 0, 42)
    row.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", row).Color = Color3.fromRGB(35, 38, 48)

    local name = Instance.new("TextLabel", row)
    name.Size = UDim2.new(1, -190, 1, 0)
    name.Position = UDim2.new(0, 10, 0, 0)
    name.BackgroundTransparency = 1
    name.Text = string.upper(v[1])
    name.TextColor3 = Color3.fromRGB(230, 230, 240)
    name.Font = Enum.Font.GothamMedium
    name.TextSize = 11
    name.TextXAlignment = Enum.TextXAlignment.Left

    local tag = Instance.new("TextLabel", row)
    tag.Size = UDim2.new(0, 60, 0, 20)
    tag.Position = UDim2.new(1, -150, 0.5, -10)
    tag.BackgroundColor3 = v[2] and Color3.fromRGB(20, 50, 30) or Color3.fromRGB(60, 45, 20)
    tag.Text = v[2] and "KEYLESS" or "KEY"
    tag.TextColor3 = v[2] and Color3.fromRGB(60, 220, 100) or Color3.fromRGB(250, 180, 50)
    tag.Font = Enum.Font.GothamBold
    tag.TextSize = 9
    Instance.new("UICorner", tag).CornerRadius = UDim.new(0, 5)

    local exec = Instance.new("TextButton", row)
    exec.Size = UDim2.new(0, 75, 0, 24)
    exec.Position = UDim2.new(1, -82, 0.5, -12)
    exec.BackgroundColor3 = Color3.fromRGB(123, 92, 255)
    exec.Text = "EXECUTE"
    exec.TextColor3 = Color3.fromRGB(255, 255, 255)
    exec.Font = Enum.Font.GothamBold
    exec.TextSize = 9
    Instance.new("UICorner", exec).CornerRadius = UDim.new(0, 6)

    exec.MouseButton1Click:Connect(function()
        pcall(function() loadstring(game:HttpGet(v[3]))() end)
    end)

    table.insert(scriptCards, {frame = row, title = string.lower(v[1])})
end

searchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(searchInput.Text)
    for _, card in ipairs(scriptCards) do
        card.frame.Visible = (query == "" or string.find(card.title, query) ~= nil)
    end
end)

-- ============================================================
-- TAB 4: CONFIG SYSTEM
-- ============================================================
local Config = {
    Folder = "SylphinConfigs",
    CurrentName = "default",
    AutoSave = false,
    Data = {}
}
if makefolder and not isfolder(Config.Folder) then pcall(makefolder, Config.Folder) end

function Config:Save(name)
    if not writefile then return false end
    name = name or self.CurrentName
    local path = self.Folder .. "/" .. name .. ".json"
    return pcall(writefile, path, HttpService:JSONEncode(self.Data))
end

function Config:Load(name)
    if not (readfile and isfile) then return false end
    name = name or self.CurrentName
    local path = self.Folder .. "/" .. name .. ".json"
    if not isfile(path) then return false end
    local ok, content = pcall(readfile, path)
    if ok and content then
        local ok2, data = pcall(function() return HttpService:JSONDecode(content) end)
        if ok2 and type(data) == "table" then
            self.Data = data
            return true
        end
    end
    return false
end

function Config:Delete(name)
    if not (delfile and isfile) then return false end
    name = name or self.CurrentName
    local path = self.Folder .. "/" .. name .. ".json"
    if isfile(path) then return pcall(delfile, path) end
    return false
end

local cfgInputFrame = Instance.new("Frame", ConfigPage)
cfgInputFrame.Size = UDim2.new(1, -6, 0, 38)
cfgInputFrame.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Instance.new("UICorner", cfgInputFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", cfgInputFrame).Color = Color3.fromRGB(35, 38, 48)

local cfgNameBox = Instance.new("TextBox", cfgInputFrame)
cfgNameBox.Size = UDim2.new(1, -20, 1, 0)
cfgNameBox.Position = UDim2.new(0, 10, 0, 0)
cfgNameBox.BackgroundTransparency = 1
cfgNameBox.PlaceholderText = "Config Name..."
cfgNameBox.PlaceholderColor3 = Color3.fromRGB(100, 105, 120)
cfgNameBox.Text = "default"
cfgNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
cfgNameBox.Font = Enum.Font.GothamMedium
cfgNameBox.TextSize = 11
cfgNameBox.TextXAlignment = Enum.TextXAlignment.Left

local cfgBtnContainer = Instance.new("Frame", ConfigPage)
cfgBtnContainer.Size = UDim2.new(1, -6, 0, 32)
cfgBtnContainer.BackgroundTransparency = 1

local function createCfgBtn(title, pos, color, callback)
    local btn = Instance.new("TextButton", cfgBtnContainer)
    btn.Size = UDim2.new(0.31, 0, 1, 0)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = title
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

createCfgBtn("SAVE", UDim2.new(0, 0, 0, 0), Color3.fromRGB(123, 92, 255), function()
    local name = cfgNameBox.Text ~= "" and cfgNameBox.Text or "default"
    Config:Save(name)
end)

createCfgBtn("LOAD", UDim2.new(0.345, 0, 0, 0), Color3.fromRGB(40, 140, 70), function()
    local name = cfgNameBox.Text ~= "" and cfgNameBox.Text or "default"
    Config:Load(name)
end)

createCfgBtn("DELETE", UDim2.new(0.69, 0, 0, 0), Color3.fromRGB(180, 40, 50), function()
    local name = cfgNameBox.Text ~= "" and cfgNameBox.Text or "default"
    Config:Delete(name)
end)

local autoSaveBtn
autoSaveBtn = CreateButton(ConfigPage, "AUTO SAVE: DISABLED", Color3.fromRGB(24, 25, 32), function()
    Config.AutoSave = not Config.AutoSave
    autoSaveBtn.Text = "AUTO SAVE: " .. (Config.AutoSave and "ENABLED" or "DISABLED")
    autoSaveBtn.TextColor3 = Config.AutoSave and Color3.fromRGB(123, 92, 255) or Color3.fromRGB(255, 255, 255)
end)

game:BindToClose(function()
    if Config.AutoSave then Config:Save() end
end)
