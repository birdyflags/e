local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Library = {}
Library.__index = Library

local Themes = {
    Primary = Color3.fromRGB(231, 101, 99),
    Secondary = Color3.fromRGB(202, 202, 207),
    Background = Color3.fromRGB(16, 16, 19),
    Surface = Color3.fromRGB(19, 19, 23),
    Border = Color3.fromRGB(21, 21, 25),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(83, 83, 89)
}

local function CreateTween(instance, properties, duration, style, direction)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out

    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame)
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            CreateTween(frame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.1)
        end
    end)
end

function Library:CreateNotification(title, text, duration)
    duration = duration or 3

    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 80)
    notif.Position = UDim2.new(1, 320, 0, 20)
    notif.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
    notif.BackgroundTransparency = 0.1
    notif.BorderSizePixel = 0
    notif.ZIndex = 1000
    notif.Parent = self.ScreenGui

    local blur = Instance.new("BlurEffect")
    blur.Size = 24
    blur.Parent = game:GetService("Lighting")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif

    local stroke = Instance.new("UIStroke")
    stroke.Color = Themes.Primary
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = notif

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Themes.Primary
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notif

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 0, 35)
    textLabel.Position = UDim2.new(0, 10, 0, 35)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Themes.Text
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    textLabel.Parent = notif

    CreateTween(notif, {Position = UDim2.new(1, -320, 0, 20)}, 0.5, Enum.EasingStyle.Back)

    task.delay(duration, function()
        CreateTween(notif, {Position = UDim2.new(1, 320, 0, 20)}, 0.3)
        task.wait(0.3)
        notif:Destroy()
    end)
end

function Library:New(config)
    local window = setmetatable({}, Library)

    window.ScreenGui = Instance.new("ScreenGui")
    window.ScreenGui.Name = "AyraHub"
    window.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    window.ScreenGui.ResetOnSpawn = false
    window.ScreenGui.Parent = game.CoreGui

    window.BlurEffect = Instance.new("BlurEffect")
    window.BlurEffect.Size = 0
    window.BlurEffect.Parent = game.Lighting

    window.Visible = false
    window.Tabs = {}
    window.CurrentTab = nil

    window.MainFrame = Instance.new("Frame")
    window.MainFrame.Name = "MainFrame"
    window.MainFrame.ClipsDescendants = true
    window.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    window.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    window.MainFrame.Size = UDim2.new(0, 674, 0, 560)
    window.MainFrame.BackgroundColor3 = Themes.Background
    window.MainFrame.BackgroundTransparency = 0.05
    window.MainFrame.BorderSizePixel = 0
    window.MainFrame.Visible = false
    window.MainFrame.Parent = window.ScreenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 4)
    mainCorner.Parent = window.MainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(21, 21, 25)
    mainStroke.Parent = window.MainFrame

    MakeDraggable(window.MainFrame)

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.AnchorPoint = Vector2.new(0.5, 0)
    Header.Position = UDim2.new(0.5, 0, 0, 0)
    Header.Size = UDim2.new(0, 674, 0, 32)
    Header.BackgroundColor3 = Themes.Background
    Header.BorderSizePixel = 0
    Header.Parent = window.MainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 4)
    headerCorner.Parent = Header

    local headerLine = Instance.new("Frame")
    headerLine.Name = "Liner"
    headerLine.AnchorPoint = Vector2.new(0.5, 1)
    headerLine.Position = UDim2.new(0.5, 0, 1, 0)
    headerLine.Size = UDim2.new(1, 1, 0, 1)
    headerLine.BackgroundColor3 = Color3.fromRGB(24, 24, 27)
    headerLine.BorderSizePixel = 0
    headerLine.Parent = Header

    local gameName = Instance.new("TextLabel")
    gameName.Name = "Game_Name"
    gameName.AnchorPoint = Vector2.new(0, 0.5)
    gameName.Position = UDim2.new(0, 12, 0.5, 0)
    gameName.Size = UDim2.new(0, 1, 0, 1)
    gameName.AutomaticSize = Enum.AutomaticSize.XY
    gameName.BackgroundTransparency = 1
    gameName.Text = config.GameName or "GAME"
    gameName.TextColor3 = Themes.Text
    gameName.TextSize = 14
    gameName.Font = Enum.Font.GothamSemibold
    gameName.Parent = Header

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(238, 146, 145)),
        ColorSequenceKeypoint.new(1, Themes.Primary)
    }
    gradient.Parent = gameName

    local buildDate = Instance.new("TextLabel")
    buildDate.Name = "Build_Date"
    buildDate.AnchorPoint = Vector2.new(1, 0.5)
    buildDate.Position = UDim2.new(1, -12, 0.5, 0)
    buildDate.Size = UDim2.new(0, 1, 0, 1)
    buildDate.AutomaticSize = Enum.AutomaticSize.XY
    buildDate.BackgroundTransparency = 1
    buildDate.Text = "Build: " .. os.date("%A %m/%d/%Y")
    buildDate.TextColor3 = Themes.Text
    buildDate.TextSize = 14
    buildDate.Font = Enum.Font.Gotham
    buildDate.Parent = Header

    window.BottomBar = Instance.new("Frame")
    window.BottomBar.Name = "Bottom_Bar"
    window.BottomBar.AnchorPoint = Vector2.new(0.5, 1)
    window.BottomBar.Position = UDim2.new(0.5, 0, 1, 0)
    window.BottomBar.Size = UDim2.new(0, 674, 0, 39)
    window.BottomBar.BackgroundColor3 = Themes.Background
    window.BottomBar.BorderSizePixel = 0
    window.BottomBar.Parent = window.MainFrame

    local bottomCorner = Instance.new("UICorner")
    bottomCorner.CornerRadius = UDim.new(0, 4)
    bottomCorner.Parent = window.BottomBar

    local bottomLine = Instance.new("Frame")
    bottomLine.Name = "Liner"
    bottomLine.AnchorPoint = Vector2.new(0.5, 0)
    bottomLine.Position = UDim2.new(0.5, 0, 0, 0)
    bottomLine.Size = UDim2.new(1, 1, 0, 1)
    bottomLine.BackgroundColor3 = Color3.fromRGB(24, 24, 27)
    bottomLine.BorderSizePixel = 0
    bottomLine.Parent = window.BottomBar

    local libName = Instance.new("TextLabel")
    libName.Name = "Libary_Name"
    libName.RichText = true
    libName.AnchorPoint = Vector2.new(1, 0.5)
    libName.Position = UDim2.new(1, -12, 0.5, 0)
    libName.Size = UDim2.new(0, 1, 0, 1)
    libName.AutomaticSize = Enum.AutomaticSize.XY
    libName.BackgroundTransparency = 1
    libName.Text = 'AYRA<font color="#e76563">HUB</font>'
    libName.TextColor3 = Themes.Text
    libName.TextSize = 15
    libName.Font = Enum.Font.GothamSemibold
    libName.Parent = window.BottomBar

    window.TabHolder = Instance.new("Frame")
    window.TabHolder.Name = "Holder"
    window.TabHolder.BackgroundTransparency = 1
    window.TabHolder.Size = UDim2.new(0, 596, 0, 39)
    window.TabHolder.BorderSizePixel = 0
    window.TabHolder.Parent = window.BottomBar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 31)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Parent = window.TabHolder

    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 11)
    tabPadding.PaddingLeft = UDim.new(0, 15)
    tabPadding.Parent = window.TabHolder

    window.PageContainer = Instance.new("Frame")
    window.PageContainer.Name = "Page"
    window.PageContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    window.PageContainer.Position = UDim2.new(0.5, 0, 0.494, 0)
    window.PageContainer.Size = UDim2.new(0, 674, 0, 488)
    window.PageContainer.BackgroundTransparency = 1
    window.PageContainer.BorderSizePixel = 0
    window.PageContainer.Parent = window.MainFrame

    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "ToggleButton"
    toggleButton.Position = UDim2.new(0.837, 0, 0.024, 0)
    toggleButton.Size = UDim2.new(0, 157, 0, 65)
    toggleButton.BackgroundColor3 = Themes.Background
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = window.ScreenGui

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.Parent = toggleButton

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, 0, 1, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = "TOGGLE"
    toggleLabel.TextColor3 = Themes.Primary
    toggleLabel.TextSize = 20
    toggleLabel.Font = Enum.Font.GothamBold
    toggleLabel.Parent = toggleButton

    local toggleButton_clickable = Instance.new("TextButton")
    toggleButton_clickable.Size = UDim2.new(1, 0, 1, 0)
    toggleButton_clickable.BackgroundTransparency = 1
    toggleButton_clickable.Text = ""
    toggleButton_clickable.Parent = toggleButton

    toggleButton_clickable.MouseEnter:Connect(function()
        CreateTween(toggleButton, {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}, 0.2)
    end)

    toggleButton_clickable.MouseLeave:Connect(function()
        CreateTween(toggleButton, {BackgroundColor3 = Themes.Background}, 0.2)
    end)

    toggleButton_clickable.MouseButton1Click:Connect(function()
        window.Visible = not window.Visible

        if window.Visible then
            CreateTween(window.BlurEffect, {Size = 24}, 0.3)
            window.MainFrame.Visible = true
            window.MainFrame.Size = UDim2.new(0, 674, 0, 0)
            CreateTween(window.MainFrame, {Size = UDim2.new(0, 674, 0, 560)}, 0.4, Enum.EasingStyle.Back)
        else
            CreateTween(window.BlurEffect, {Size = 0}, 0.3)
            CreateTween(window.MainFrame, {Size = UDim2.new(0, 674, 0, 0)}, 0.3)
            task.wait(0.3)
            window.MainFrame.Visible = false
        end
    end)

    local watermark = Instance.new("Frame")
    watermark.Name = "Watermark"
    watermark.Position = UDim2.new(0, 12, 0, 15)
    watermark.Size = UDim2.new(0, 142, 0, 34)
    watermark.AutomaticSize = Enum.AutomaticSize.XY
    watermark.BackgroundColor3 = Themes.Background
    watermark.BorderSizePixel = 0
    watermark.Parent = window.ScreenGui

    local wmCorner = Instance.new("UICorner")
    wmCorner.CornerRadius = UDim.new(0, 4)
    wmCorner.Parent = watermark

    local wmStroke = Instance.new("UIStroke")
    wmStroke.Color = Color3.fromRGB(25, 25, 28)
    wmStroke.Parent = watermark

    local wmContainer = Instance.new("Frame")
    wmContainer.Name = "Container"
    wmContainer.Size = UDim2.new(1, 1, 1, 1)
    wmContainer.AutomaticSize = Enum.AutomaticSize.XY
    wmContainer.BackgroundTransparency = 1
    wmContainer.Parent = watermark

    local wmLayout = Instance.new("UIListLayout")
    wmLayout.Padding = UDim.new(0, 4)
    wmLayout.FillDirection = Enum.FillDirection.Horizontal
    wmLayout.Parent = wmContainer

    local wmPadding = Instance.new("UIPadding")
    wmPadding.PaddingTop = UDim.new(0, 8)
    wmPadding.PaddingRight = UDim.new(0, 8)
    wmPadding.PaddingLeft = UDim.new(0, 8)
    wmPadding.Parent = wmContainer

    local wmLibName = Instance.new("TextLabel")
    wmLibName.RichText = true
    wmLibName.Size = UDim2.new(0, 1, 0, 1)
    wmLibName.AutomaticSize = Enum.AutomaticSize.XY
    wmLibName.BackgroundTransparency = 1
    wmLibName.Text = 'AYRA<font color="#e76563">HUB</font>'
    wmLibName.TextColor3 = Themes.Text
    wmLibName.TextSize = 16
    wmLibName.Font = Enum.Font.GothamSemibold
    wmLibName.Parent = wmContainer

    local wmLine = Instance.new("Frame")
    wmLine.Name = "Line"
    wmLine.Size = UDim2.new(0, 16, 0, 16)
    wmLine.BackgroundTransparency = 1
    wmLine.Parent = wmContainer

    local wmLinePadding = Instance.new("UIPadding")
    wmLinePadding.PaddingTop = UDim.new(0, 2)
    wmLinePadding.Parent = wmLine

    local wmInline = Instance.new("Frame")
    wmInline.AnchorPoint = Vector2.new(0.5, 0.5)
    wmInline.Position = UDim2.new(0.5, 0, 0.5, 0)
    wmInline.Size = UDim2.new(0.01, 0, 0.7, 0)
    wmInline.BackgroundColor3 = Color3.fromRGB(159, 159, 161)
    wmInline.BorderSizePixel = 0
    wmInline.Parent = wmLine

    local wmFps = Instance.new("TextLabel")
    wmFps.Name = "Fps"
    wmFps.Size = UDim2.new(0, 1, 0, 1)
    wmFps.AutomaticSize = Enum.AutomaticSize.XY
    wmFps.BackgroundTransparency = 1
    wmFps.Text = "Fps: 60"
    wmFps.TextColor3 = Themes.Text
    wmFps.TextSize = 14
    wmFps.Font = Enum.Font.Gotham
    wmFps.Parent = wmContainer

    local fpsGradient = Instance.new("UIGradient")
    fpsGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.087, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Themes.Primary)
    }
    fpsGradient.Parent = wmFps

    local lastTime = tick()
    local fps = 60
    RunService.Heartbeat:Connect(function()
        local currentTime = tick()
        local delta = currentTime - lastTime
        lastTime = currentTime
        fps = math.floor(1 / delta)
        wmFps.Text = "Fps: " .. fps
    end)

    window:CreateNotification("AyraHub", "UI Library Loaded!", 2)

    return window
end

function Library:CreateTab(name, icon)
    local tab = {}
    tab.Name = name
    tab.Sections = {}

    local tabButton = Instance.new("Frame")
    tabButton.Name = "Tab"
    tabButton.BackgroundTransparency = 1
    tabButton.Size = UDim2.new(0, 53, 0, 14)
    tabButton.AutomaticSize = Enum.AutomaticSize.XY
    tabButton.BorderSizePixel = 0
    tabButton.Parent = self.TabHolder

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Parent = tabButton

    local tabIcon = Instance.new("ImageLabel")
    tabIcon.Name = "Tab_Icon"
    tabIcon.AnchorPoint = Vector2.new(0, 0.5)
    tabIcon.Position = UDim2.new(0, 5, 0.5, 0)
    tabIcon.Size = UDim2.new(0, 17, 0, 17)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Image = icon or "rbxassetid://80246246481431"
    tabIcon.ImageColor3 = Themes.Secondary
    tabIcon.ScaleType = Enum.ScaleType.Fit
    tabIcon.Parent = tabButton

    local tabName = Instance.new("TextLabel")
    tabName.Name = "Tab_Name"
    tabName.AnchorPoint = Vector2.new(1, 0.5)
    tabName.Position = UDim2.new(1, -5, 0.5, 0)
    tabName.Size = UDim2.new(0, 1, 0, 1)
    tabName.AutomaticSize = Enum.AutomaticSize.XY
    tabName.BackgroundTransparency = 1
    tabName.Text = name
    tabName.TextColor3 = Themes.Secondary
    tabName.TextSize = 15
    tabName.Font = Enum.Font.Gotham
    tabName.Parent = tabButton

    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = tabButton

    tab.Page = Instance.new("ScrollingFrame")
    tab.Page.Name = name .. "_Page"
    tab.Page.Active = true
    tab.Page.AnchorPoint = Vector2.new(0.5, 0.5)
    tab.Page.Position = UDim2.new(0.5, 0, 0.5, 0)
    tab.Page.Size = UDim2.new(0, 674, 0, 490)
    tab.Page.BackgroundTransparency = 1
    tab.Page.BorderSizePixel = 0
    tab.Page.ScrollBarThickness = 4
    tab.Page.ScrollBarImageColor3 = Themes.Primary
    tab.Page.Visible = false
    tab.Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tab.Page.Parent = self.PageContainer

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 12)
    pageLayout.Wraps = true
    pageLayout.FillDirection = Enum.FillDirection.Horizontal
    pageLayout.Parent = tab.Page

    local pagePadding = Instance.new("UIPadding")
    pagePadding.PaddingTop = UDim.new(0, 10)
    pagePadding.PaddingLeft = UDim.new(0, 16)
    pagePadding.Parent = tab.Page

    clickDetector.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Page.Visible = false
            local btn = t.Button
            CreateTween(btn:FindFirstChild("Tab_Icon"), {ImageColor3 = Themes.Secondary}, 0.2)
            CreateTween(btn:FindFirstChild("Tab_Name"), {TextColor3 = Themes.Secondary}, 0.2)
        end

        tab.Page.Visible = true
        CreateTween(tabIcon, {ImageColor3 = Themes.Primary}, 0.2)
        CreateTween(tabName, {TextColor3 = Themes.Primary}, 0.2)

        self.CurrentTab = tab
    end)

    clickDetector.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            CreateTween(tabIcon, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
            CreateTween(tabName, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        end
    end)

    clickDetector.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            CreateTween(tabIcon, {ImageColor3 = Themes.Secondary}, 0.2)
            CreateTween(tabName, {TextColor3 = Themes.Secondary}, 0.2)
        end
    end)

    tab.Button = tabButton
    table.insert(self.Tabs, tab)

if #self.Tabs == 1 then
    -- use the same logic you run when the button is clicked
    self.CurrentTab = tab
    tab.Page.Visible = true
    CreateTween(tabIcon , {ImageColor3 = Themes.Primary}, 0.2)
    CreateTween(tabName,  {TextColor3 = Themes.Primary}, 0.2)
end

    function tab:CreateSection(name)
        local section = {}
        section.Name = name
        section.Elements = {}

        local sectionFrame = Instance.new("Frame")
        sectionFrame.Name = "Section"
        sectionFrame.ClipsDescendants = true
        sectionFrame.Size = UDim2.new(0, 312, 0, 70)
        sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
        sectionFrame.BackgroundColor3 = Themes.Surface
        sectionFrame.BackgroundTransparency = 0.45
        sectionFrame.BorderSizePixel = 0
        sectionFrame.Parent = tab.Page

        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 6)
        sectionCorner.Parent = sectionFrame

        local sectionStroke = Instance.new("UIStroke")
        sectionStroke.Color = Color3.fromRGB(32, 34, 45)
        sectionStroke.Parent = sectionFrame

        local header = Instance.new("Frame")
        header.Name = "Header"
        header.AnchorPoint = Vector2.new(0.5, 0)
        header.Position = UDim2.new(0.5, 0, 0, 0)
        header.Size = UDim2.new(0, 312, 0, 30)
        header.BackgroundColor3 = Color3.fromRGB(23, 24, 30)
        header.BorderSizePixel = 0
        header.Parent = sectionFrame

        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = UDim.new(0, 6)
        headerCorner.Parent = header

        local headerLine = Instance.new("Frame")
        headerLine.AnchorPoint = Vector2.new(0.5, 1)
        headerLine.Position = UDim2.new(0.5, 0, 1, 0)
        headerLine.Size = UDim2.new(1, 1, 0, 1)
        headerLine.BackgroundColor3 = Color3.fromRGB(21, 21, 25)
        headerLine.BorderSizePixel = 0
        headerLine.Parent = header

        local sectionName = Instance.new("TextLabel")
        sectionName.Name = "Section_Name"
        sectionName.AnchorPoint = Vector2.new(0, 0.5)
        sectionName.Position = UDim2.new(0, 9, 0.5, 0)
        sectionName.Size = UDim2.new(0, 1, 0, 1)
        sectionName.AutomaticSize = Enum.AutomaticSize.XY
        sectionName.BackgroundTransparency = 1
        sectionName.Text = name
        sectionName.TextColor3 = Themes.Text
        sectionName.TextSize = 14
        sectionName.Font = Enum.Font.Gotham
        sectionName.Parent = header

        local arrowIcon = Instance.new("ImageLabel")
        arrowIcon.Name = "Arrow_Icon"
        arrowIcon.AnchorPoint = Vector2.new(1, 0.5)
        arrowIcon.Position = UDim2.new(1, -12, 0.5, 0)
        arrowIcon.Size = UDim2.new(0, 16, 0, 16)
        arrowIcon.BackgroundTransparency = 1
        arrowIcon.Image = "rbxassetid://133540734301865"
        arrowIcon.ScaleType = Enum.ScaleType.Fit
        arrowIcon.Parent = header

        local holder = Instance.new("Frame")
        holder.Name = "Holder"
        holder.AnchorPoint = Vector2.new(0.5, 0)
        holder.Position = UDim2.new(0.5, 0, 1, 0)
        holder.Size = UDim2.new(0, 1, 0, 1)
        holder.AutomaticSize = Enum.AutomaticSize.XY
        holder.BackgroundTransparency = 1
        holder.Parent = header

        local holderLayout = Instance.new("UIListLayout")
        holderLayout.SortOrder = Enum.SortOrder.LayoutOrder
        holderLayout.Parent = holder

        local holderPadding = Instance.new("UIPadding")
        holderPadding.PaddingBottom = UDim.new(0, 10)
        holderPadding.PaddingTop = UDim.new(0, 5)
        holderPadding.Parent = holder

        section.Frame = sectionFrame
        section.Holder = holder

        table.insert(tab.Sections, section)

        function section:AddToggle(config)
            local toggle = {Value = config.Default or false}

            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = "Toggle_Component"
            toggleFrame.AnchorPoint = Vector2.new(0.5, 0)
            toggleFrame.Size = UDim2.new(0, 312, 0, 30)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Parent = holder

            local toggleBox = Instance.new("Frame")
            toggleBox.Name = "Toggle"
            toggleBox.AnchorPoint = Vector2.new(0, 0.5)
            toggleBox.Position = UDim2.new(0, 19, 0.5, 0)
            toggleBox.Size = UDim2.new(0, 16, 0, 16)
            toggleBox.BackgroundColor3 = toggle.Value and Themes.Primary or Color3.fromRGB(26, 26, 33)
            toggleBox.BorderSizePixel = 0
            toggleBox.Parent = toggleFrame

            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 3)
            toggleCorner.Parent = toggleBox

            if not toggle.Value then
                local toggleStroke = Instance.new("UIStroke")
                toggleStroke.Name = "Stroke"
                toggleStroke.Color = Color3.fromRGB(34, 34, 41)
                toggleStroke.Parent = toggleBox
            end

            local checkIcon = Instance.new("ImageLabel")
            checkIcon.Name = "Check_Icon"
            checkIcon.AnchorPoint = Vector2.new(0.5, 0.5)
            checkIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
            checkIcon.Size = UDim2.new(0, 8, 0, 7)
            checkIcon.BackgroundTransparency = 1
            checkIcon.Image = "rbxassetid://83899464799881"
            checkIcon.Visible = toggle.Value
            checkIcon.Parent = toggleBox

            local toggleName = Instance.new("TextLabel")
            toggleName.Name = "Toggle_Name"
            toggleName.AnchorPoint = Vector2.new(0, 0.5)
            toggleName.Position = UDim2.new(0, 43, 0.5, 0)
            toggleName.Size = UDim2.new(0, 1, 0, 1)
            toggleName.AutomaticSize = Enum.AutomaticSize.XY
            toggleName.BackgroundTransparency = 1
            toggleName.Text = config.Name
            toggleName.TextColor3 = toggle.Value and Themes.Text or Themes.TextDim
            toggleName.TextSize = 14
            toggleName.Font = Enum.Font.Gotham
            toggleName.Parent = toggleFrame

            local clickDetector = Instance.new("TextButton")
            clickDetector.Size = UDim2.new(1, 0, 1, 0)
            clickDetector.BackgroundTransparency = 1
            clickDetector.Text = ""
            clickDetector.Parent = toggleFrame

            clickDetector.MouseEnter:Connect(function()
                if not toggle.Value then
                    CreateTween(toggleBox, {BackgroundColor3 = Color3.fromRGB(35, 35, 42)}, 0.2)
                end
            end)

            clickDetector.MouseLeave:Connect(function()
                if not toggle.Value then
                    CreateTween(toggleBox, {BackgroundColor3 = Color3.fromRGB(26, 26, 33)}, 0.2)
                end
            end)

            clickDetector.MouseButton1Click:Connect(function()
                toggle.Value = not toggle.Value

                if toggle.Value then
                    CreateTween(toggleBox, {BackgroundColor3 = Themes.Primary}, 0.2)
                    CreateTween(toggleName, {TextColor3 = Themes.Text}, 0.2)
                    checkIcon.Visible = true
                    if toggleBox:FindFirstChild("Stroke") then
                        toggleBox.Stroke:Destroy()
                    end
                else
                    CreateTween(toggleBox, {BackgroundColor3 = Color3.fromRGB(26, 26, 33)}, 0.2)
                    CreateTween(toggleName, {TextColor3 = Themes.TextDim}, 0.2)
                    checkIcon.Visible = false
                    local toggleStroke = Instance.new("UIStroke")
                    toggleStroke.Name = "Stroke"
                    toggleStroke.Color = Color3.fromRGB(34, 34, 41)
                    toggleStroke.Parent = toggleBox
                end

                if config.Callback then
                    config.Callback(toggle.Value)
                end
            end)

            function toggle:SetValue(value)
                toggle.Value = value

                if value then
                    toggleBox.BackgroundColor3 = Themes.Primary
                    toggleName.TextColor3 = Themes.Text
                    checkIcon.Visible = true
                    if toggleBox:FindFirstChild("Stroke") then
                        toggleBox.Stroke:Destroy()
                    end
                else
                    toggleBox.BackgroundColor3 = Color3.fromRGB(26, 26, 33)
                    toggleName.TextColor3 = Themes.TextDim
                    checkIcon.Visible = false
                    if not toggleBox:FindFirstChild("Stroke") then
                        local toggleStroke = Instance.new("UIStroke")
                        toggleStroke.Name = "Stroke"
                        toggleStroke.Color = Color3.fromRGB(34, 34, 41)
                        toggleStroke.Parent = toggleBox
                    end
                end

                if config.Callback then
                    config.Callback(value)
                end
            end

            return toggle
        end

        function section:AddButton(config)
            local button = {}

            local buttonFrame = Instance.new("Frame")
            buttonFrame.Name = "Button_Component"
            buttonFrame.AnchorPoint = Vector2.new(0.5, 0)
            buttonFrame.Size = UDim2.new(0, 312, 0, 43)
            buttonFrame.BackgroundTransparency = 1
            buttonFrame.BorderSizePixel = 0
            buttonFrame.Parent = holder

            local buttonBox = Instance.new("Frame")
            buttonBox.Name = "Button"
            buttonBox.AnchorPoint = Vector2.new(0.5, 0.5)
            buttonBox.Position = UDim2.new(0.5, 0, 0.5, 0)
            buttonBox.Size = UDim2.new(0, 275, 0, 30)
            buttonBox.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
            buttonBox.BorderSizePixel = 0
            buttonBox.Parent = buttonFrame

            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 3)
            buttonCorner.Parent = buttonBox

            local buttonStroke = Instance.new("UIStroke")
            buttonStroke.Color = Color3.fromRGB(34, 34, 41)
            buttonStroke.Parent = buttonBox

            local buttonText = Instance.new("TextLabel")
            buttonText.Name = "Button_Text"
            buttonText.AnchorPoint = Vector2.new(0.5, 0.5)
            buttonText.Position = UDim2.new(0.5, 0, 0.5, 0)
            buttonText.Size = UDim2.new(0, 1, 0, 1)
            buttonText.AutomaticSize = Enum.AutomaticSize.XY
            buttonText.BackgroundTransparency = 1
            buttonText.Text = config.Name
            buttonText.TextColor3 = Themes.TextDim
            buttonText.TextSize = 15
            buttonText.Font = Enum.Font.Gotham
            buttonText.Parent = buttonBox

            local clickDetector = Instance.new("TextButton")
            clickDetector.Size = UDim2.new(1, 0, 1, 0)
            clickDetector.BackgroundTransparency = 1
            clickDetector.Text = ""
            clickDetector.Parent = buttonBox

            clickDetector.MouseEnter:Connect(function()
                CreateTween(buttonBox, {BackgroundColor3 = Color3.fromRGB(30, 30, 36)}, 0.2)
                CreateTween(buttonText, {TextColor3 = Themes.Text}, 0.2)
            end)

            clickDetector.MouseLeave:Connect(function()
                CreateTween(buttonBox, {BackgroundColor3 = Color3.fromRGB(24, 24, 30)}, 0.2)
                CreateTween(buttonText, {TextColor3 = Themes.TextDim}, 0.2)
            end)

            clickDetector.MouseButton1Click:Connect(function()
                CreateTween(buttonBox, {BackgroundColor3 = Themes.Primary}, 0.1)
                CreateTween(buttonText, {TextColor3 = Themes.Text}, 0.1)
                task.wait(0.1)
                CreateTween(buttonBox, {BackgroundColor3 = Color3.fromRGB(30, 30, 36)}, 0.2)

                if config.Callback then
                    config.Callback()
                end
            end)

            return button
        end

        function section:AddSlider(config)
            local slider = {
                Value = config.Default or config.Min,
                Min = config.Min or 0,
                Max = config.Max or 100,
                Increment = config.Increment or 1
            }

            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = "Slider_Component"
            sliderFrame.AnchorPoint = Vector2.new(0.5, 0)
            sliderFrame.Size = UDim2.new(0, 312, 0, 40)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Parent = holder

            local sliderText = Instance.new("TextLabel")
            sliderText.Name = "Slider_Text"
            sliderText.AnchorPoint = Vector2.new(0, 0.5)
            sliderText.Position = UDim2.new(0, 19, 0.5, -8)
            sliderText.Size = UDim2.new(0, 1, 0, 1)
            sliderText.AutomaticSize = Enum.AutomaticSize.XY
            sliderText.BackgroundTransparency = 1
            sliderText.Text = config.Name
            sliderText.TextColor3 = Themes.TextDim
            sliderText.TextSize = 14
            sliderText.Font = Enum.Font.Gotham
            sliderText.Parent = sliderFrame

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Name = "Value"
            valueLabel.AnchorPoint = Vector2.new(1, 0.5)
            valueLabel.Position = UDim2.new(1, -20, 0.5, -8)
            valueLabel.Size = UDim2.new(0, 1, 0, 1)
            valueLabel.AutomaticSize = Enum.AutomaticSize.XY
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(slider.Value)
            valueLabel.TextColor3 = Themes.TextDim
            valueLabel.TextSize = 14
            valueLabel.Font = Enum.Font.Gotham
            valueLabel.Parent = sliderFrame

            local progressBg = Instance.new("Frame")
            progressBg.Name = "Progress_BG"
            progressBg.AnchorPoint = Vector2.new(0, 0.5)
            progressBg.Position = UDim2.new(0, 19, 0.5, 13)
            progressBg.Size = UDim2.new(0, 272, 0, 7)
            progressBg.BackgroundColor3 = Color3.fromRGB(32, 32, 39)
            progressBg.BorderSizePixel = 0
            progressBg.Parent = sliderFrame

            local bgCorner = Instance.new("UICorner")
            bgCorner.Parent = progressBg

            local bgStroke = Instance.new("UIStroke")
            bgStroke.Color = Color3.fromRGB(40, 40, 46)
            bgStroke.Parent = progressBg

            local progress = Instance.new("Frame")
            progress.Name = "Progress"
            progress.AnchorPoint = Vector2.new(0.5, 0.5)
            progress.Position = UDim2.new(0.5, 0, 0.5, 0)
            progress.Size = UDim2.new(0, 0, 0, 7)
            progress.BackgroundColor3 = Themes.Primary
            progress.BorderSizePixel = 0
            progress.Parent = progressBg

            local progCorner = Instance.new("UICorner")
            progCorner.Parent = progress

            local pointer = Instance.new("Frame")
            pointer.Name = "Pointer"
            pointer.AnchorPoint = Vector2.new(1, 0.5)
            pointer.Position = UDim2.new(1, 0, 0.5, 0)
            pointer.Size = UDim2.new(0, 10, 0, 10)
            pointer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            pointer.BorderSizePixel = 0
            pointer.Parent = progress

            local pointerCorner = Instance.new("UICorner")
            pointerCorner.Parent = pointer

            local function updateSlider(value)
                value = math.clamp(value, slider.Min, slider.Max)
                value = math.floor(value / slider.Increment + 0.5) * slider.Increment
                slider.Value = value

                valueLabel.Text = tostring(value)

                local percent = (value - slider.Min) / (slider.Max - slider.Min)
                local targetSize = math.floor(272 * percent)

                CreateTween(progress, {
                    Size = UDim2.new(0, targetSize, 0, 7),
                    Position = UDim2.new(percent / 2, 0, 0.5, 0)
                }, 0.1)

                if config.Callback then
                    config.Callback(value)
                end
            end

            local dragging = false

            progressBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local mousePos = input.Position.X
                    local bgPos = progressBg.AbsolutePosition.X
                    local bgSize = progressBg.AbsoluteSize.X
                    local percent = math.clamp((mousePos - bgPos) / bgSize, 0, 1)
                    local value = slider.Min + (slider.Max - slider.Min) * percent
                    updateSlider(value)
                end
            end)

            progressBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = input.Position.X
                    local bgPos = progressBg.AbsolutePosition.X
                    local bgSize = progressBg.AbsoluteSize.X
                    local percent = math.clamp((mousePos - bgPos) / bgSize, 0, 1)
                    local value = slider.Min + (slider.Max - slider.Min) * percent
                    updateSlider(value)
                end
            end)

            updateSlider(slider.Value)

            function slider:SetValue(value)
                updateSlider(value)
            end

            return slider
        end

        function section:AddDropdown(config)
            local dropdown = {
                Value = config.Default or {},
                Options = config.Options or {},
                Multi = config.Multi or false
            }

            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Name = "Dropdown_Component"
            dropdownFrame.AnchorPoint = Vector2.new(0.5, 0)
            dropdownFrame.Size = UDim2.new(0, 312, 0, 55)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.BorderSizePixel = 0
            dropdownFrame.Parent = holder

            local dropdownName = Instance.new("TextLabel")
            dropdownName.Name = "Dropdown_Name"
            dropdownName.Position = UDim2.new(0, 20, 0, 12)
            dropdownName.Size = UDim2.new(0, 1, 0, 1)
            dropdownName.AutomaticSize = Enum.AutomaticSize.XY
            dropdownName.BackgroundTransparency = 1
            dropdownName.Text = config.Name
            dropdownName.TextColor3 = Color3.fromRGB(204, 204, 209)
            dropdownName.TextSize = 14
            dropdownName.Font = Enum.Font.Gotham
            dropdownName.Parent = dropdownFrame

            local holderBox = Instance.new("Frame")
            holderBox.Name = "Holder"
            holderBox.AnchorPoint = Vector2.new(0.5, 1)
            holderBox.Position = UDim2.new(0.5, 0, 1, 0)
            holderBox.Size = UDim2.new(0, 272, 0, 22)
            holderBox.BackgroundColor3 = Color3.fromRGB(26, 26, 33)
            holderBox.BorderSizePixel = 0
            holderBox.ClipsDescendants = true
            holderBox.Parent = dropdownFrame

            local holderCorner = Instance.new("UICorner")
            holderCorner.CornerRadius = UDim.new(0, 2)
            holderCorner.Parent = holderBox

            local holderStroke = Instance.new("UIStroke")
            holderStroke.Color = Color3.fromRGB(34, 34, 41)
            holderStroke.Parent = holderBox

            local optionsLabel = Instance.new("TextLabel")
            optionsLabel.Name = "Options"
            optionsLabel.AnchorPoint = Vector2.new(0, 0.5)
            optionsLabel.Position = UDim2.new(0, 8, 0.5, -1)
            optionsLabel.Size = UDim2.new(0, 1, 0, 1)
            optionsLabel.AutomaticSize = Enum.AutomaticSize.XY
            optionsLabel.BackgroundTransparency = 1
            optionsLabel.Text = dropdown.Multi and table.concat(dropdown.Value, ", ") or (dropdown.Value[1] or "Select...")
            optionsLabel.TextColor3 = Color3.fromRGB(204, 204, 209)
            optionsLabel.TextSize = 14
            optionsLabel.Font = Enum.Font.Gotham
            optionsLabel.Parent = holderBox

            local clickDetector = Instance.new("TextButton")
            clickDetector.Size = UDim2.new(1, 0, 1, 0)
            clickDetector.BackgroundTransparency = 1
            clickDetector.Text = ""
            clickDetector.Parent = holderBox

            clickDetector.MouseEnter:Connect(function()
                CreateTween(holderBox, {BackgroundColor3 = Color3.fromRGB(32, 32, 39)}, 0.2)
            end)

            clickDetector.MouseLeave:Connect(function()
                CreateTween(holderBox, {BackgroundColor3 = Color3.fromRGB(26, 26, 33)}, 0.2)
            end)

            local expanded = false

            clickDetector.MouseButton1Click:Connect(function()
                expanded = not expanded

                if expanded then
                    local listHeight = #dropdown.Options * 22
                    CreateTween(holderBox, {Size = UDim2.new(0, 272, 0, 22 + listHeight)}, 0.3)
                else
                    CreateTween(holderBox, {Size = UDim2.new(0, 272, 0, 22)}, 0.3)
                end
            end)

            function dropdown:Refresh(options)
                dropdown.Options = options or dropdown.Options

                for _, child in pairs(holderBox:GetChildren()) do
                    if child:IsA("TextButton") and child.Name ~= "TextButton" then
                        child:Destroy()
                    end
                end

                for i, option in pairs(dropdown.Options) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Name = option
                    optionButton.Position = UDim2.new(0, 0, 0, 22 * i)
                    optionButton.Size = UDim2.new(1, 0, 0, 22)
                    optionButton.BackgroundColor3 = Color3.fromRGB(23, 23, 30)
                    optionButton.BorderSizePixel = 0
                    optionButton.Text = option
                    optionButton.TextColor3 = Color3.fromRGB(204, 204, 209)
                    optionButton.TextSize = 13
                    optionButton.Font = Enum.Font.Gotham
                    optionButton.Parent = holderBox

                    optionButton.MouseEnter:Connect(function()
                        CreateTween(optionButton, {BackgroundColor3 = Themes.Primary}, 0.2)
                    end)

                    optionButton.MouseLeave:Connect(function()
                        CreateTween(optionButton, {BackgroundColor3 = Color3.fromRGB(23, 23, 30)}, 0.2)
                    end)

                    optionButton.MouseButton1Click:Connect(function()
                        if dropdown.Multi then
                            local index = table.find(dropdown.Value, option)
                            if index then
                                table.remove(dropdown.Value, index)
                            else
                                table.insert(dropdown.Value, option)
                            end
                            optionsLabel.Text = table.concat(dropdown.Value, ", ")
                        else
                            dropdown.Value = {option}
                            optionsLabel.Text = option
                            expanded = false
                            CreateTween(holderBox, {Size = UDim2.new(0, 272, 0, 22)}, 0.3)
                        end

                        if config.Callback then
                            config.Callback(dropdown.Value)
                        end
                    end)
                end
            end

            dropdown:Refresh()

            return dropdown
        end

        return section
    end

    return tab
end

return Library
