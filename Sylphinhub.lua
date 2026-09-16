-- ============================================================
-- SYLPHIN HUB - FIXED UI & SLIDE ANIMATION
-- ============================================================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ScreenGui Root
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SylphinHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Top Container (Chứa toàn bộ Menu)
local MainContainer = Instance.new("Frame", ScreenGui)
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, 600, 0, 380)
MainContainer.Position = UDim2.new(0.5, -300, 0.5, -190)
MainContainer.BackgroundTransparency = 1
MainContainer.Active = true
MainContainer.Draggable = true

-- Sidebar (Khung bên trái - Bật mặc định)
local Sidebar = Instance.new("Frame", MainContainer)
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 21, 28)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 5

local SidebarCorner = Instance.new("UICorner", Sidebar)
SidebarCorner.CornerRadius = UDim.new(0, 14)

-- Header Logo + Text "SYLPHIN" ở góc trên (Hình 3)
local HeaderFrame = Instance.new("Frame", Sidebar)
HeaderFrame.Size = UDim2.new(1, 0, 0, 45)
HeaderFrame.BackgroundTransparency = 1

local LogoIcon = Instance.new("ImageLabel", HeaderFrame)
LogoIcon.Size = UDim2.new(0, 22, 0, 22)
LogoIcon.Position = UDim2.new(0, 14, 0.5, -11)
LogoIcon.BackgroundTransparency = 1
LogoIcon.Image = "rbxassetid://6031075929"
LogoIcon.ImageColor3 = Color3.fromRGB(138, 92, 246)

local LogoTitle = Instance.new("TextLabel", HeaderFrame)
LogoTitle.Size = UDim2.new(1, -45, 1, 0)
LogoTitle.Position = UDim2.new(0, 42, 0, 0)
LogoTitle.BackgroundTransparency = 1
LogoTitle.Font = Enum.Font.GothamBold
LogoTitle.Text = "SYLPHIN"
LogoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoTitle.TextSize = 15
LogoTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Danh sách Tab
local TabContainer = Instance.new("Frame", Sidebar)
TabContainer.Size = UDim2.new(1, -16, 1, -115)
TabContainer.Position = UDim2.new(0, 8, 0, 50)
TabContainer.BackgroundTransparency = 1

local TabList = Instance.new("UIListLayout", TabContainer)
TabList.Padding = UDim.new(0, 4)

-- Profile Footer ở góc dưới Sidebar (Tự động cập nhật ngày thực tế)
local ProfileCard = Instance.new("Frame", Sidebar)
ProfileCard.Size = UDim2.new(1, -16, 0, 50)
ProfileCard.Position = UDim2.new(0, 8, 1, -58)
ProfileCard.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
ProfileCard.BorderSizePixel = 0
ProfileCard.ZIndex = 6
Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 10)

local AvatarImg = Instance.new("ImageLabel", ProfileCard)
AvatarImg.Size = UDim2.new(0, 32, 0, 32)
AvatarImg.Position = UDim2.new(0, 8, 0.5, -16)
AvatarImg.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
pcall(function()
    AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

local NameLabel = Instance.new("TextLabel", ProfileCard)
NameLabel.Size = UDim2.new(1, -48, 0, 16)
NameLabel.Position = UDim2.new(0, 46, 0, 8)
NameLabel.BackgroundTransparency = 1
NameLabel.Font = Enum.Font.GothamBold
NameLabel.Text = LocalPlayer.Name
NameLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
NameLabel.TextSize = 11
NameLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Cập nhật ngày tháng năm hiện tại tự động
local ExpiryLabel = Instance.new("TextLabel", ProfileCard)
ExpiryLabel.Size = UDim2.new(1, -48, 0, 14)
ExpiryLabel.Position = UDim2.new(0, 46, 0, 25)
ExpiryLabel.BackgroundTransparency = 1
ExpiryLabel.Font = Enum.Font.Gotham
ExpiryLabel.Text = "Till: " .. os.date("%d %b %Y")
ExpiryLabel.TextColor3 = Color3.fromRGB(130, 135, 150)
ExpiryLabel.TextSize = 10
ExpiryLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Content Area (Khung bên phải có hiệu ứng trượt Slide)
local ContentArea = Instance.new("Frame", MainContainer)
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(0, 0, 1, 0) -- Mặc định ẩn sau sidebar
ContentArea.Position = UDim2.new(0, 180, 0, 0)
ContentArea.BackgroundColor3 = Color3.fromRGB(16, 17, 23)
ContentArea.BorderSizePixel = 0
ContentArea.ClipsDescendants = true
ContentArea.Visible = false
ContentArea.ZIndex = 3

local ContentCorner = Instance.new("UICorner", ContentArea)
ContentCorner.CornerRadius = UDim.new(0, 14)

local ContentPadding = Instance.new("UIPadding", ContentArea)
ContentPadding.PaddingTop = UDim.new(0, 14)
ContentPadding.PaddingLeft = UDim.new(0, 14)
ContentPadding.PaddingRight = UDim.new(0, 14)
ContentPadding.PaddingBottom = UDim.new(0, 14)

-- Animation Logic Trượt Khung Nội Dung (Slide Out / Slide In)
local isExpanded = false
local function ToggleContent(expand)
    if expand == nil then expand = not isExpanded end
    isExpanded = expand

    local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    if isExpanded then
        ContentArea.Visible = true
        TweenService:Create(ContentArea, tweenInfo, {
            Size = UDim2.new(0, 410, 1, 0),
            Position = UDim2.new(0, 188, 0, 0)
        }):Play()
    else
        local tween = TweenService:Create(ContentArea, tweenInfo, {
            Size = UDim2.new(0, 0, 1, 0),
            Position = UDim2.new(0, 180, 0, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            if not isExpanded then ContentArea.Visible = false end
        end)
    end
end

-- Nút Toggle Bật/Tắt Toàn Bộ Menu
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 80, 0, 30)
ToggleBtn.Position = UDim2.new(0, 15, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 21, 28)
ToggleBtn.Text = "SYLPHIN"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 11
ToggleBtn.Active = true
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

local tStroke = Instance.new("UIStroke", ToggleBtn)
tStroke.Color = Color3.fromRGB(138, 92, 246)
tStroke.Thickness = 1.5

local uiOpen = true
ToggleBtn.MouseButton1Click:Connect(function()
    uiOpen = not uiOpen
    if uiOpen then
        MainContainer.Visible = true
    else
        ToggleContent(false)
        task.wait(0.2)
        MainContainer.Visible = false
    end
end)

-- Quản lý Tabs
local Tabs = {}
local function CreateTab(name, iconId, isScrollable)
    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(1, 0, 0, 34)
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 21, 28)
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = ""
    TabBtn.AutoButtonColor = false
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local ActiveIndicator = Instance.new("Frame", TabBtn)
    ActiveIndicator.Size = UDim2.new(0, 3, 0, 18)
    ActiveIndicator.Position = UDim2.new(0, 0, 0.5, -9)
    ActiveIndicator.BackgroundColor3 = Color3.fromRGB(138, 92, 246)
    ActiveIndicator.BorderSizePixel = 0
    ActiveIndicator.Visible = false
    Instance.new("UICorner", ActiveIndicator).CornerRadius = UDim.new(1, 0)

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

    -- Fix lỗi cuộn trang: Khóa cuộn cho Home & Server Hop
    if isScrollable then
        Page.ScrollBarThickness = 2
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    else
        Page.ScrollBarThickness = 0
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.None
    end

    local PageList = Instance.new("UIListLayout", Page)
    PageList.Padding = UDim.new(0, 8)

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Btn.BackgroundColor3 = Color3.fromRGB(20, 21, 28)
            t.Indicator.Visible = false
            t.Title.TextColor3 = Color3.fromRGB(140, 145, 160)
            t.Icon.ImageColor3 = Color3.fromRGB(140, 145, 160)
            t.Page.Visible = false
        end

        TabBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
        ActiveIndicator.Visible = true
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Page.Visible = true

        -- Kích hoạt hiệu ứng Slide Out khi chọn Tab
        ToggleContent(true)
    end)

    local tabData = {Btn = TabBtn, Indicator = ActiveIndicator, Title = Title, Icon = Icon, Page = Page}
    table.insert(Tabs, tabData)
    return Page
end

-- Tạo 4 Tab (Home và Server Hop không thể kéo cuộn)
local HomePage = CreateTab("Home", "rbxassetid://6031075929", false)
local ServerHopPage = CreateTab("Server Hop", "rbxassetid://6034818372", false)
local ScriptsPage = CreateTab("Scripts", "rbxassetid://6031094678", true)
local ConfigPage = CreateTab("Config", "rbxassetid://6031097225", false)

-- Component: Slider Trượt (1 - 7)
local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -6, 0, 48)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 23, 30)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

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
    Track.BackgroundColor3 = Color3.fromRGB(38, 40, 52)
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(138, 92, 246)
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
            dragging = true; Update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then Update(input) end
    end)
end

local function CreateButton(parent, text, color, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -6, 0, 36)
    Btn.BackgroundColor3 = color or Color3.fromRGB(138, 92, 246)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 11
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    Btn.MouseButton1Click:Connect(function() callback(Btn) end)
    return Btn
end

-- ==================== TAB 1: HOME ====================
local socials = {
    {"TikTok", "https://www.tiktok.com/@sylphin_12tc?_r=1&_t=ZS-99m7QXnxo96"},
    {"Discord", "https://discord.gg/aYvWCqTTd"},
    {"YouTube", "https://youtube.com/@sylphinroblox?si=j90dBpPtOkiHn3qA"}
}

for _, item in ipairs(socials) do
    local card = Instance.new("Frame", HomePage)
    card.Size = UDim2.new(1, -6, 0, 46)
    card.BackgroundColor3 = Color3.fromRGB(22, 23, 30)
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local sTitle = Instance.new("TextLabel", card)
    sTitle.Size = UDim2.new(0, 180, 0, 18)
    sTitle.Position = UDim2.new(0, 10, 0, 5)
    sTitle.BackgroundTransparency = 1
    sTitle.Text = item[1]
    sTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sTitle.Font = Enum.Font.GothamBold
    sTitle.TextSize = 12
    sTitle.TextXAlignment = Enum.TextXAlignment.Left

    local sLink = Instance.new("TextLabel", card)
    sLink.Size = UDim2.new(1, -100, 0, 14)
    sLink.Position = UDim2.new(0, 10, 0, 24)
    sLink.BackgroundTransparency = 1
    sLink.Text = item[2]
    sLink.TextColor3 = Color3.fromRGB(120, 125, 140)
    sLink.Font = Enum.Font.Gotham
    sLink.TextSize = 9
    sLink.TextXAlignment = Enum.TextXAlignment.Left

    local copyBtn = Instance.new("TextButton", card)
    copyBtn.Size = UDim2.new(0, 65, 0, 24)
    copyBtn.Position = UDim2.new(1, -72, 0.5, -12)
    copyBtn.BackgroundColor3 = Color3.fromRGB(138, 92, 246)
    copyBtn.Text = "COPY"
    copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.TextSize = 10
    Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)

    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(item[2])
            copyBtn.Text = "COPIED!"
            task.wait(1.2)
            copyBtn.Text = "COPY"
        end
    end)
end

-- ==================== TAB 2: SERVER HOP ====================
local maxPlayers = 1
local autoDetectThreshold = 3

CreateSlider(ServerHopPage, "Max Players Threshold", 1, 7, maxPlayers, function(v) maxPlayers = v end)
CreateSlider(ServerHopPage, "Auto Detect Threshold", 1, 7, autoDetectThreshold, function(v) autoDetectThreshold = v end)

CreateButton(ServerHopPage, "HOP SERVER NOW", Color3.fromRGB(138, 92, 246), function() end)
CreateButton(ServerHopPage, "AUTO DETECT HOP: DISABLED", Color3.fromRGB(22, 23, 30), function() end)
CreateButton(ServerHopPage, "AUTO HOP: DISABLED", Color3.fromRGB(22, 23, 30), function() end)

local ServerInfoLabel = Instance.new("TextLabel", ServerHopPage)
ServerInfoLabel.Size = UDim2.new(1, -6, 0, 18)
ServerInfoLabel.BackgroundTransparency = 1
ServerInfoLabel.Font = Enum.Font.GothamMedium
ServerInfoLabel.Text = "Current Server: " .. #Players:GetPlayers() .. " player(s)"
ServerInfoLabel.TextColor3 = Color3.fromRGB(180, 185, 200)
ServerInfoLabel.TextSize = 11
ServerInfoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ==================== TAB 3: SCRIPTS ====================
local searchBarFrame = Instance.new("Frame", ScriptsPage)
searchBarFrame.Size = UDim2.new(1, -6, 0, 32)
searchBarFrame.BackgroundColor3 = Color3.fromRGB(22, 23, 30)
Instance.new("UICorner", searchBarFrame).CornerRadius = UDim.new(0, 6)

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

-- ==================== TAB 4: CONFIG ====================
local cfgInputFrame = Instance.new("Frame", ConfigPage)
cfgInputFrame.Size = UDim2.new(1, -6, 0, 36)
cfgInputFrame.BackgroundColor3 = Color3.fromRGB(22, 23, 30)
Instance.new("UICorner", cfgInputFrame).CornerRadius = UDim.new(0, 6)

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
