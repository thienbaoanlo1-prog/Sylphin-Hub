local UserInputService = game:GetService("UserInputService")
local teleportService = game:GetService("TeleportService")
local httpService = game:GetService("HttpService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

local gui = Instance.new("ScreenGui", gethui and gethui() or game:GetService("CoreGui"))
gui.Name = "SylPhinHub"

-- NÚT BẬT / TẮT MENU
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 90, 0, 32)
toggleBtn.Position = UDim2.new(0, 15, 0.4, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
toggleBtn.Text = "SylPhin"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 13
toggleBtn.Active = true
toggleBtn.Draggable = true

local tCorner = Instance.new("UICorner", toggleBtn)
tCorner.CornerRadius = UDim.new(0, 8)

local tStroke = Instance.new("UIStroke", toggleBtn)
tStroke.Color = Color3.fromRGB(255, 0, 0)
tStroke.Thickness = 1.5
tStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- BẢNG MENU CHÍNH
local main = Instance.new("Frame", gui)
main.Name = "MainFrame"
main.Size = UDim2.new(0, 500, 0, 390)
main.Position = UDim2.new(0.5, -250, 0.5, -195)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true

local mCorner = Instance.new("UICorner", main)
mCorner.CornerRadius = UDim.new(0, 12)

local mStroke = Instance.new("UIStroke", main)
mStroke.Color = Color3.fromRGB(255, 0, 0)
mStroke.Thickness = 2
mStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local sizeConstraint = Instance.new("UISizeConstraint", main)
sizeConstraint.MinSize = Vector2.new(380, 280)
sizeConstraint.MaxSize = Vector2.new(800, 600)

-- THANH TIÊU ĐỀ (HEADER)
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundTransparency = 1

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(0, 100, 0, 22)
title.Position = UDim2.new(0, 15, 0, 6)
title.BackgroundTransparency = 1
title.Text = "SylPhin"
title.TextColor3 = Color3.fromRGB(255, 40, 40)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local subtitle = Instance.new("TextLabel", header)
subtitle.Size = UDim2.new(0, 140, 0, 16)
subtitle.Position = UDim2.new(0, 15, 0, 26)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Chon hub cua ban"
subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextSize = 12

-- AVATAR ROBLOX CỦA NGƯỜI DÙNG
local avatarImg = Instance.new("ImageLabel", header)
avatarImg.Name = "UserAvatar"
avatarImg.Size = UDim2.new(0, 34, 0, 34)
avatarImg.Position = UDim2.new(0, 165, 0, 6)
avatarImg.BackgroundTransparency = 1
avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. localPlayer.UserId .. "&w=150&h=150"

local avatarCorner = Instance.new("UICorner", avatarImg)
avatarCorner.CornerRadius = UDim.new(1, 0)

local avatarStroke = Instance.new("UIStroke", avatarImg)
avatarStroke.Color = Color3.fromRGB(255, 40, 40)
avatarStroke.Thickness = 1.5

-- NÚT ĐÓNG MENU
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- THANH MỤC TAB (TAB NAVIGATION)
local tabContainer = Instance.new("Frame", main)
tabContainer.Size = UDim2.new(1, -20, 0, 30)
tabContainer.Position = UDim2.new(0, 10, 0, 45)
tabContainer.BackgroundTransparency = 1

local scriptsTabBtn = Instance.new("TextButton", tabContainer)
scriptsTabBtn.Size = UDim2.new(0.49, 0, 1, 0)
scriptsTabBtn.Position = UDim2.new(0, 0, 0, 0)
scriptsTabBtn.BackgroundColor3 = Color3.fromRGB(35, 15, 15)
scriptsTabBtn.Text = "SCRIPTS"
scriptsTabBtn.TextColor3 = Color3.fromRGB(255, 40, 40)
scriptsTabBtn.Font = Enum.Font.GothamBold
scriptsTabBtn.TextSize = 12

local sTabCorner = Instance.new("UICorner", scriptsTabBtn)
sTabCorner.CornerRadius = UDim.new(0, 6)

local sTabStroke = Instance.new("UIStroke", scriptsTabBtn)
sTabStroke.Color = Color3.fromRGB(255, 40, 40)
sTabStroke.Thickness = 1.5

local serverHopTabBtn = Instance.new("TextButton", tabContainer)
serverHopTabBtn.Size = UDim2.new(0.49, 0, 1, 0)
serverHopTabBtn.Position = UDim2.new(0.51, 0, 0, 0)
serverHopTabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
serverHopTabBtn.Text = "SERVER HOP"
serverHopTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
serverHopTabBtn.Font = Enum.Font.GothamBold
serverHopTabBtn.TextSize = 12

local shTabCorner = Instance.new("UICorner", serverHopTabBtn)
shTabCorner.CornerRadius = UDim.new(0, 6)

local shTabStroke = Instance.new("UIStroke", serverHopTabBtn)
shTabStroke.Color = Color3.fromRGB(40, 40, 40)
shTabStroke.Thickness = 1

-- KHUNG NỘI DUNG TỪNG TAB
local scriptsFrame = Instance.new("ScrollingFrame", main)
scriptsFrame.Size = UDim2.new(1, -20, 1, -110)
scriptsFrame.Position = UDim2.new(0, 10, 0, 80)
scriptsFrame.BackgroundTransparency = 1
scriptsFrame.BorderSizePixel = 0
scriptsFrame.ScrollBarThickness = 3
scriptsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scriptsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scriptsFrame.Visible = true

local scriptsLayout = Instance.new("UIListLayout", scriptsFrame)
scriptsLayout.Padding = UDim.new(0, 8)

local serverHopFrame = Instance.new("ScrollingFrame", main)
serverHopFrame.Size = UDim2.new(1, -20, 1, -110)
serverHopFrame.Position = UDim2.new(0, 10, 0, 80)
serverHopFrame.BackgroundTransparency = 1
serverHopFrame.BorderSizePixel = 0
serverHopFrame.ScrollBarThickness = 3
serverHopFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
serverHopFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
serverHopFrame.Visible = false

local shLayout = Instance.new("UIListLayout", serverHopFrame)
shLayout.Padding = UDim.new(0, 10)

-- DISCORD FOOTER PHÍA DƯỚI CÙNG MENU
local discordBtn = Instance.new("TextButton", main)
discordBtn.Size = UDim2.new(1, -20, 0, 22)
discordBtn.Position = UDim2.new(0, 10, 1, -24)
discordBtn.BackgroundTransparency = 1
discordBtn.Text = "Discord: https://discord.gg/aYvWCqTTd"
discordBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
discordBtn.Font = Enum.Font.GothamMedium
discordBtn.TextSize = 11

discordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://discord.gg/aYvWCqTTd")
        discordBtn.Text = "Da copy link Discord vao Clipboard!"
        task.wait(2)
        discordBtn.Text = "Discord: https://discord.gg/aYvWCqTTd"
    end
end)

-- CHUYỂN TAB LOGIC
scriptsTabBtn.MouseButton1Click:Connect(function()
    scriptsFrame.Visible = true
    serverHopFrame.Visible = false
    scriptsTabBtn.BackgroundColor3 = Color3.fromRGB(35, 15, 15)
    scriptsTabBtn.TextColor3 = Color3.fromRGB(255, 40, 40)
    sTabStroke.Color = Color3.fromRGB(255, 40, 40)

    serverHopTabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    serverHopTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    shTabStroke.Color = Color3.fromRGB(40, 40, 40)
end)

serverHopTabBtn.MouseButton1Click:Connect(function()
    scriptsFrame.Visible = false
    serverHopFrame.Visible = true
    serverHopTabBtn.BackgroundColor3 = Color3.fromRGB(35, 15, 15)
    serverHopTabBtn.TextColor3 = Color3.fromRGB(255, 40, 40)
    shTabStroke.Color = Color3.fromRGB(255, 40, 40)

    scriptsTabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    scriptsTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    sTabStroke.Color = Color3.fromRGB(40, 40, 40)
end)

-- GÓC KÉO PHÓNG TO THU NHỎ
local resizeHandle = Instance.new("TextButton", main)
resizeHandle.Size = UDim2.new(0, 16, 0, 16)
resizeHandle.Position = UDim2.new(1, -16, 1, -16)
resizeHandle.BackgroundTransparency = 1
resizeHandle.Text = "//"
resizeHandle.TextColor3 = Color3.fromRGB(255, 0, 0)
resizeHandle.Font = Enum.Font.GothamBold
resizeHandle.TextSize = 10
resizeHandle.ZIndex = 10

local resizing = false
local startSize, startPos

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        startSize = main.Size
        startPos = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startPos
        main.Size = UDim2.new(0, math.max(380, startSize.X.Offset + delta.X), 0, math.max(280, startSize.Y.Offset + delta.Y))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)

-- ==========================================
-- TAB 1: DANH SÁCH SCRIPTS
-- ==========================================
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

for _, v in ipairs(hubs) do
    local row = Instance.new("Frame", scriptsFrame)
    row.Size = UDim2.new(1, -6, 0, 48)
    row.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    row.BorderSizePixel = 0

    local rowCorner = Instance.new("UICorner", row)
    rowCorner.CornerRadius = UDim.new(0, 8)

    local rowStroke = Instance.new("UIStroke", row)
    rowStroke.Color = Color3.fromRGB(35, 35, 35)
    rowStroke.Thickness = 1
    rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local name = Instance.new("TextLabel", row)
    name.Size = UDim2.new(1, -230, 1, 0) 
    name.Position = UDim2.new(0, 14, 0, 0)
    name.BackgroundTransparency = 1
    name.Text = string.upper(v[1])
    name.TextColor3 = Color3.fromRGB(230, 230, 230)
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.Font = Enum.Font.GothamMedium
    name.TextSize = 13

    local statusFrame = Instance.new("Frame", row)
    statusFrame.Size = UDim2.new(0, 95, 0, 28)
    statusFrame.AnchorPoint = Vector2.new(1, 0.5)
    statusFrame.Position = UDim2.new(1, -120, 0.5, 0) 
    statusFrame.BackgroundTransparency = 0

    local statusCorner = Instance.new("UICorner", statusFrame)
    statusCorner.CornerRadius = UDim.new(0, 8)

    local statusStroke = Instance.new("UIStroke", statusFrame)
    statusStroke.Thickness = 1.5
    statusStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local statusText = Instance.new("TextLabel", statusFrame)
    statusText.Size = UDim2.new(1, 0, 1, 0)
    statusText.BackgroundTransparency = 1
    statusText.Font = Enum.Font.GothamBold
    statusText.TextSize = 11

    if v[2] then
        statusFrame.BackgroundColor3 = Color3.fromRGB(15, 45, 15)
        statusText.Text = "KEYLESS"
        statusText.TextColor3 = Color3.fromRGB(50, 205, 50)
        statusStroke.Color = Color3.fromRGB(50, 205, 50)
    else
        statusFrame.BackgroundColor3 = Color3.fromRGB(45, 35, 15)
        statusText.Text = "KEY"
        statusText.TextColor3 = Color3.fromRGB(240, 190, 60)
        statusStroke.Color = Color3.fromRGB(240, 190, 60)
    end

    local exec = Instance.new("TextButton", row)
    exec.Size = UDim2.new(0, 95, 0, 28)
    exec.AnchorPoint = Vector2.new(1, 0.5)
    exec.Position = UDim2.new(1, -15, 0.5, 0) 
    exec.BackgroundColor3 = Color3.fromRGB(45, 15, 15)
    exec.BackgroundTransparency = 0
    exec.Text = "EXECUTE"
    exec.TextColor3 = Color3.fromRGB(255, 40, 40)
    exec.Font = Enum.Font.GothamBold
    exec.TextSize = 11

    local execCorner = Instance.new("UICorner", exec)
    execCorner.CornerRadius = UDim.new(0, 8)

    local execStroke = Instance.new("UIStroke", exec)
    execStroke.Color = Color3.fromRGB(255, 40, 40)
    execStroke.Thickness = 1.5
    execStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    exec.MouseButton1Click:Connect(function()
        pcall(function() loadstring(game:HttpGet(v[3]))() end)
    end)
end

-- ==========================================
-- TAB 2: SERVER HOP LOGIC & UI (1 - 7 RANGE)
-- ==========================================
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
            local url = "https://games.roblox.com/v1/games/" .. placeId
                .. "/servers/Public?sortOrder=Desc&limit=100"
                .. (nextPageCursor ~= "" and "&cursor=" .. nextPageCursor or "")

            local ok, response = pcall(function() return game:HttpGet(url) end)
            if ok and response then
                local ok2, data = pcall(function() return httpService:JSONDecode(response) end)
                if ok2 and data and data.nextPageCursor then
                    nextPageCursor = data.nextPageCursor
                else
                    break
                end
            else
                break
            end
        end

        local finalUrl = "https://games.roblox.com/v1/games/" .. placeId
            .. "/servers/Public?sortOrder=Asc&limit=100"
            .. (nextPageCursor ~= "" and "&cursor=" .. nextPageCursor or "")

        local ok, response = pcall(function() return game:HttpGet(finalUrl) end)
        local targetServer

        if ok and response then
            local ok2, data = pcall(function() return httpService:JSONDecode(response) end)
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
            teleportService:TeleportToPlaceInstance(placeId, targetServer.id, localPlayer)
        else
            task.wait(0.5)
            isHopping = false
            hopServer()
        end
    end)
end

-- HÀM TẠO SLIDER
local function createSlider(titleText, minVal, maxVal, defaultVal, callback)
    local sliderFrame = Instance.new("Frame", serverHopFrame)
    sliderFrame.Size = UDim2.new(1, -6, 0, 52)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)

    local sCorner = Instance.new("UICorner", sliderFrame) sCorner.CornerRadius = UDim.new(0, 8)
    local sStroke = Instance.new("UIStroke", sliderFrame)
    sStroke.Color = Color3.fromRGB(35, 35, 35)
    sStroke.Thickness = 1

    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 6)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = titleText .. ": " .. tostring(defaultVal)

    local track = Instance.new("Frame", sliderFrame)
    track.Size = UDim2.new(1, -24, 0, 6)
    track.Position = UDim2.new(0, 12, 0, 34)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    local tCorner = Instance.new("UICorner", track) tCorner.CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    local initRatio = (defaultVal - minVal) / (maxVal - minVal)
    fill.Size = UDim2.new(initRatio, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
    local fCorner = Instance.new("UICorner", fill) fCorner.CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(initRatio, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local kCorner = Instance.new("UICorner", knob) kCorner.CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function updateInput(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local val = math.floor(minVal + (maxVal - minVal) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, 0, 0.5, 0)
        label.Text = titleText .. ": " .. tostring(val)
        callback(val)
    end

    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateInput(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- SLIDER 1: MAX PLAYERS THRESHOLD (1 ĐẾN 7)
createSlider("Max Players Threshold", 1, 7, maxPlayers, function(v)
    maxPlayers = v
end)

-- SLIDER 2: AUTO DETECT THRESHOLD (1 ĐẾN 7)
createSlider("Auto Detect Threshold", 1, 7, autoDetectThreshold, function(v)
    autoDetectThreshold = v
end)

-- NÚT: HOP SERVER NOW
local hopNowBtn = Instance.new("TextButton", serverHopFrame)
hopNowBtn.Size = UDim2.new(1, -6, 0, 42)
hopNowBtn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
hopNowBtn.Text = "HOP SERVER NOW"
hopNowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hopNowBtn.Font = Enum.Font.GothamBold
hopNowBtn.TextSize = 13

local hCorner = Instance.new("UICorner", hopNowBtn) hCorner.CornerRadius = UDim.new(0, 8)
local hStroke = Instance.new("UIStroke", hopNowBtn)
hStroke.Color = Color3.fromRGB(255, 60, 60)
hStroke.Thickness = 1.5

hopNowBtn.MouseButton1Click:Connect(function()
    hopServer()
end)

-- NÚT: AUTO DETECT HOP
local autoDetectBtn = Instance.new("TextButton", serverHopFrame)
autoDetectBtn.Size = UDim2.new(1, -6, 0, 42)
autoDetectBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
autoDetectBtn.Text = "AUTO DETECT HOP: DISABLED"
autoDetectBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
autoDetectBtn.Font = Enum.Font.GothamBold
autoDetectBtn.TextSize = 12

local adCorner = Instance.new("UICorner", autoDetectBtn) adCorner.CornerRadius = UDim.new(0, 8)
local adStroke = Instance.new("UIStroke", autoDetectBtn)
adStroke.Color = Color3.fromRGB(35, 35, 35)
adStroke.Thickness = 1

autoDetectBtn.MouseButton1Click:Connect(function()
    autoDetectActive = not autoDetectActive
    if autoDetectActive then
        autoDetectBtn.Text = "AUTO DETECT HOP: ENABLED"
        autoDetectBtn.TextColor3 = Color3.fromRGB(255, 40, 40)
        autoDetectBtn.BackgroundColor3 = Color3.fromRGB(45, 15, 15)
        adStroke.Color = Color3.fromRGB(255, 40, 40)
    else
        autoDetectBtn.Text = "AUTO DETECT HOP: DISABLED"
        autoDetectBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        autoDetectBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        adStroke.Color = Color3.fromRGB(35, 35, 35)
    end
end)

-- NÚT: AUTO HOP
local autoHopBtn = Instance.new("TextButton", serverHopFrame)
autoHopBtn.Size = UDim2.new(1, -6, 0, 42)
autoHopBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
autoHopBtn.Text = "AUTO HOP: DISABLED"
autoHopBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
autoHopBtn.Font = Enum.Font.GothamBold
autoHopBtn.TextSize = 12

local ahCorner = Instance.new("UICorner", autoHopBtn) ahCorner.CornerRadius = UDim.new(0, 8)
local ahStroke = Instance.new("UIStroke", autoHopBtn)
ahStroke.Color = Color3.fromRGB(35, 35, 35)
ahStroke.Thickness = 1

autoHopBtn.MouseButton1Click:Connect(function()
    autoHopActive = not autoHopActive
    if autoHopActive then
        autoHopBtn.Text = "AUTO HOP: ENABLED"
        autoHopBtn.TextColor3 = Color3.fromRGB(255, 40, 40)
        autoHopBtn.BackgroundColor3 = Color3.fromRGB(45, 15, 15)
        ahStroke.Color = Color3.fromRGB(255, 40, 40)
        hopServer()
    else
        autoHopBtn.Text = "AUTO HOP: DISABLED"
        autoHopBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        autoHopBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        ahStroke.Color = Color3.fromRGB(35, 35, 35)
    end
end)

-- THÔNG TIN SERVER HIỆN TẠI
local serverInfo = Instance.new("TextLabel", serverHopFrame)
serverInfo.Size = UDim2.new(1, -6, 0, 24)
serverInfo.BackgroundTransparency = 1
serverInfo.Font = Enum.Font.GothamMedium
serverInfo.TextSize = 12
serverInfo.TextColor3 = Color3.fromRGB(180, 180, 180)
serverInfo.TextXAlignment = Enum.TextXAlignment.Left
serverInfo.Text = "Current Server: " .. tostring(#players:GetPlayers()) .. " player(s)"

local function updatePlayerCount()
    serverInfo.Text = "Current Server: " .. tostring(#players:GetPlayers()) .. " player(s)"
end

players.PlayerAdded:Connect(function()
    updatePlayerCount()
    if autoDetectActive and #players:GetPlayers() >= autoDetectThreshold then
        hopServer()
    end
end)

players.PlayerRemoving:Connect(function()
    task.wait(0.2)
    updatePlayerCount()
end)

if autoHopActive then
    hopServer()
end
