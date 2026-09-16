local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- Config Server Hop
local HopConfig = {
    maxPlayers = 1,
    autoDetectThreshold = 3,
    autoDetectActive = false,
    autoHopActive = false
}

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomMenuUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 620, 0, 380)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

-- Constraint hỗ trợ co giãn/thu phóng đồng bộ mọi thứ
local AspectRatio = Instance.new("UIAspectRatioConstraint")
AspectRatio.AspectRatio = 620 / 380
AspectRatio.Parent = MainFrame

-- Sidebar Container
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0.3, 0, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 4)
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 12)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = Sidebar

-- Footer Profile Card (Hình 1)
local ProfileCard = Instance.new("Frame")
ProfileCard.Name = "ProfileCard"
ProfileCard.Size = UDim2.new(0.3, -12, 0, 55)
ProfileCard.Position = UDim2.new(0, 6, 1, -61)
ProfileCard.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
ProfileCard.BorderSizePixel = 0
ProfileCard.ZIndex = 5
ProfileCard.Parent = MainFrame

local ProfileCorner = Instance.new("UICorner")
ProfileCorner.CornerRadius = UDim.new(0, 10)
ProfileCorner.Parent = ProfileCard

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 36, 0, 36)
AvatarImg.Position = UDim2.new(0, 10, 0.5, -18)
AvatarImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
AvatarImg.ZIndex = 6
AvatarImg.Parent = ProfileCard

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImg

local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(1, -56, 0, 18)
NameLabel.Position = UDim2.new(0, 52, 0, 10)
NameLabel.BackgroundTransparency = 1
NameLabel.Font = Enum.Font.GothamBold
NameLabel.Text = LocalPlayer.DisplayName
NameLabel.TextColor3 = Color3.fromRGB(230, 230, 240)
NameLabel.TextSize = 13
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.ZIndex = 6
NameLabel.Parent = ProfileCard

local ExpiryLabel = Instance.new("TextLabel")
ExpiryLabel.Size = UDim2.new(1, -56, 0, 16)
ExpiryLabel.Position = UDim2.new(0, 52, 0, 28)
ExpiryLabel.BackgroundTransparency = 1
ExpiryLabel.Font = Enum.Font.Gotham
ExpiryLabel.Text = "Till: 1 Jan 2026"
ExpiryLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
ExpiryLabel.TextSize = 11
ExpiryLabel.TextXAlignment = Enum.TextXAlignment.Left
ExpiryLabel.ZIndex = 6
ExpiryLabel.Parent = ProfileCard

-- Container Nội Dung
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(0.7, 0, 1, 0)
ContentArea.Position = UDim2.new(0.3, 0, 0, 0)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingTop = UDim.new(0, 15)
ContentPadding.PaddingLeft = UDim.new(0, 15)
ContentPadding.PaddingRight = UDim.new(0, 15)
ContentPadding.PaddingBottom = UDim.new(0, 15)
ContentPadding.Parent = ContentArea

-- Quản lý Tab
local Tabs = {}
local CurrentTab = nil

local function CreateTab(name, iconId)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 36)
    TabBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    TabBtn.BorderSizePixel = 0
    TabBtn.AutoButtonColor = false
    TabBtn.Text = ""
    TabBtn.Parent = Sidebar

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = TabBtn

    -- Vạch tím chỉ báo Active (Hình 3)
    local ActiveIndicator = Instance.new("Frame")
    ActiveIndicator.Size = UDim2.new(0, 3, 0, 18)
    ActiveIndicator.Position = UDim2.new(0, 0, 0.5, -9)
    ActiveIndicator.BackgroundColor3 = Color3.fromRGB(138, 92, 246)
    ActiveIndicator.BorderSizePixel = 0
    ActiveIndicator.Visible = false
    ActiveIndicator.Parent = TabBtn

    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = ActiveIndicator

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 18, 0, 18)
    Icon.Position = UDim2.new(0, 12, 0.5, -9)
    Icon.BackgroundTransparency = 1
    Icon.Image = iconId or "rbxassetid://6031094678"
    Icon.ImageColor3 = Color3.fromRGB(160, 160, 180)
    Icon.Parent = TabBtn

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 38, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamMedium
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(160, 160, 180)
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TabBtn

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.Parent = ContentArea

    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 10)
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Parent = Page

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Btn.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
            t.Indicator.Visible = false
            t.Title.TextColor3 = Color3.fromRGB(160, 160, 180)
            t.Icon.ImageColor3 = Color3.fromRGB(160, 160, 180)
            t.Page.Visible = false
        end

        TabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        ActiveIndicator.Visible = true
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Page.Visible = true
    end)

    local tabData = {Btn = TabBtn, Indicator = ActiveIndicator, Title = Title, Icon = Icon, Page = Page}
    table.insert(Tabs, tabData)
    return Page, TabBtn
end

-- Tạo các Tab theo Hình 2
local CombatPage = CreateTab("Combat", "rbxassetid://6031094678")
local MovementPage = CreateTab("Movement", "rbxassetid://6031097225")
local VisualsPage = CreateTab("Visuals", "rbxassetid://6031094678")
local RenderPage = CreateTab("Render", "rbxassetid://6031075929")
local MiscPage = CreateTab("Misc", "rbxassetid://6034818372")
local ServerHopPage = CreateTab("Server Hop", "rbxassetid://6034818372")

-- Mặc định chọn Tab Combat
Tabs[1].Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
Tabs[1].Indicator.Visible = true
Tabs[1].Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Tabs[1].Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
Tabs[1].Page.Visible = true

--- Component: Thanh Trượt Slider (Hình 5) từ 1-7
local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text .. ": " .. tostring(default)
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local SliderTrack = Instance.new("Frame")
    SliderTrack.Size = UDim2.new(1, -20, 0, 6)
    SliderTrack.Position = UDim2.new(0, 10, 0, 32)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Parent = Frame

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = SliderTrack

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(138, 92, 246)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderTrack

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new(1, -7, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = SliderFill

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + ((max - min) * pos))
        SliderFill.Size = UDim2.new((value - min)/(max - min), 0, 1, 0)
        Label.Text = text .. ": " .. tostring(value)
        callback(value)
    end

    SliderTrack.InputBegan:Connect(function(input)
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

--- Component: Button / Toggle
local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 42)
    Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    Btn.BorderSizePixel = 0
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(220, 220, 230)
    Btn.TextSize = 12
    Btn.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        callback(Btn)
    end)
    return Btn
end

-- Server Hop Logic
local function HopServer()
    local placeId = game.PlaceId
    local servers = {}
    local req = request or http_request or (syn and syn.request)
    
    if req then
        local res = req({Url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100", tostring(placeId))})
        local body = HttpService:JSONDecode(res.Body)
        if body and body.data then
            for _, s in ipairs(body.data) do
                if s.playing <= HopConfig.maxPlayers and s.id ~= game.JobId then
                    table.insert(servers, s.id)
                end
            end
        end
    end

    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(placeId, servers[math.random(1, #servers)], LocalPlayer)
    else
        TeleportService:Teleport(placeId, LocalPlayer)
    end
end

-- DỰNG TAB SERVER HOP (Hình 4)
local ServerInfoLabel = Instance.new("TextLabel")
ServerInfoLabel.Size = UDim2.new(1, 0, 0, 20)
ServerInfoLabel.BackgroundTransparency = 1
ServerInfoLabel.Font = Enum.Font.Gotham
ServerInfoLabel.Text = "Current Server: " .. #Players:GetPlayers() .. " player(s)"
ServerInfoLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
ServerInfoLabel.TextSize = 12
ServerInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
ServerInfoLabel.Parent = ServerHopPage

-- Thay nhập số bằng Thanh trượt 1-7 (Hình 5)
CreateSlider(ServerHopPage, "Max Players Threshold", 1, 7, HopConfig.maxPlayers, function(val)
    HopConfig.maxPlayers = val
end)

CreateSlider(ServerHopPage, "Auto Detect Threshold", 1, 7, HopConfig.autoDetectThreshold, function(val)
    HopConfig.autoDetectThreshold = val
end)

CreateButton(ServerHopPage, "HOP SERVER NOW", function()
    HopServer()
end)

local AutoDetectBtn = CreateButton(ServerHopPage, "AUTO DETECT HOP: DISABLED", function(btn)
    HopConfig.autoDetectActive = not HopConfig.autoDetectActive
    btn.Text = "AUTO DETECT HOP: " .. (HopConfig.autoDetectActive and "ENABLED" or "DISABLED")
    btn.TextColor3 = HopConfig.autoDetectActive and Color3.fromRGB(138, 92, 246) or Color3.fromRGB(220, 220, 230)
end)

local AutoHopBtn = CreateButton(ServerHopPage, "AUTO HOP: DISABLED", function(btn)
    HopConfig.autoHopActive = not HopConfig.autoHopActive
    btn.Text = "AUTO HOP: " .. (HopConfig.autoHopActive and "ENABLED" or "DISABLED")
    btn.TextColor3 = HopConfig.autoHopActive and Color3.fromRGB(138, 92, 246) or Color3.fromRGB(220, 220, 230)
end)

-- Vòng lặp kiểm tra Auto Hop
task.spawn(function()
    while task.wait(3) do
        local currentCount = #Players:GetPlayers()
        ServerInfoLabel.Text = "Current Server: " .. currentCount .. " player(s)"
        
        if HopConfig.autoDetectActive and currentCount >= HopConfig.autoDetectThreshold then
            HopServer()
        elseif HopConfig.autoHopActive then
            HopServer()
        end
    end
end)
