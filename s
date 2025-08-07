-- Modern UI Library for Roblox with Exact Visual Match
-- Place this in a LocalScript in StarterGui

local UILibrary = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Color Scheme (Exact match from images)
local Colors = {
    Background = Color3.fromRGB(28, 28, 33),  -- Main dark background
    Secondary = Color3.fromRGB(35, 35, 42),   -- Lighter sections
    Tertiary = Color3.fromRGB(40, 40, 47),    -- Even lighter
    Accent = Color3.fromRGB(255, 140, 140),   -- Pink accent
    Text = Color3.fromRGB(200, 200, 205),     -- Main text
    TextDim = Color3.fromRGB(130, 130, 135),  -- Dimmed text
    Border = Color3.fromRGB(45, 45, 52),      -- UI strokes
    Toggle = Color3.fromRGB(55, 55, 62),      -- Toggle off
    ToggleActive = Color3.fromRGB(255, 140, 140), -- Toggle on (pink)
    SliderBG = Color3.fromRGB(25, 25, 30)     -- Darker for sliders
}

-- Utility Functions
local function CreateTween(obj, properties, duration)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function UILibrary:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Settings"
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Frame (exact size from image)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 800, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    -- Main Frame Stroke
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Colors.Border
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame
    
    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame
    
    -- Left Sidebar Container
    local SidebarContainer = Instance.new("Frame")
    SidebarContainer.Name = "SidebarContainer"
    SidebarContainer.Size = UDim2.new(0, 150, 1, 0)
    SidebarContainer.BackgroundColor3 = Colors.Secondary
    SidebarContainer.BorderSizePixel = 0
    SidebarContainer.Parent = MainFrame
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = SidebarContainer
    
    -- Fix corner on right side
    local SidebarFix = Instance.new("Frame")
    SidebarFix.Size = UDim2.new(0, 10, 1, 0)
    SidebarFix.Position = UDim2.new(1, -10, 0, 0)
    SidebarFix.BackgroundColor3 = Colors.Secondary
    SidebarFix.BorderSizePixel = 0
    SidebarFix.Parent = SidebarContainer
    
    -- Arrow/Triangle Icon
    local ArrowIcon = Instance.new("ImageLabel")
    ArrowIcon.Size = UDim2.new(0, 20, 0, 20)
    ArrowIcon.Position = UDim2.new(0, 15, 0, 15)
    ArrowIcon.BackgroundTransparency = 1
    ArrowIcon.Image = "rbxasset://textures/ui/Controls/RotateRight.png"
    ArrowIcon.ImageColor3 = Colors.Accent
    ArrowIcon.Rotation = -90
    ArrowIcon.Parent = SidebarContainer
    
    -- Tab Categories
    local TabSection = Instance.new("Frame")
    TabSection.Size = UDim2.new(1, 0, 1, -60)
    TabSection.Position = UDim2.new(0, 0, 0, 60)
    TabSection.BackgroundTransparency = 1
    TabSection.Parent = SidebarContainer
    
    -- GENERAL Label
    local GeneralLabel = Instance.new("TextLabel")
    GeneralLabel.Size = UDim2.new(1, -20, 0, 20)
    GeneralLabel.Position = UDim2.new(0, 10, 0, 0)
    GeneralLabel.BackgroundTransparency = 1
    GeneralLabel.Text = "GENERAL"
    GeneralLabel.TextColor3 = Colors.TextDim
    GeneralLabel.Font = Enum.Font.GothamBold
    GeneralLabel.TextSize = 10
    GeneralLabel.TextXAlignment = Enum.TextXAlignment.Left
    GeneralLabel.Parent = TabSection
    
    -- Tab List
    local TabList = Instance.new("Frame")
    TabList.Size = UDim2.new(1, 0, 0, 200)
    TabList.Position = UDim2.new(0, 0, 0, 25)
    TabList.BackgroundTransparency = 1
    TabList.Parent = TabSection
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabList
    
    -- Main Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -150, 1, 0)
    ContentArea.Position = UDim2.new(0, 150, 0, 0)
    ContentArea.BackgroundColor3 = Colors.Background
    ContentArea.BorderSizePixel = 0
    ContentArea.Parent = MainFrame
    
    -- Content Header with Search
    local ContentHeader = Instance.new("Frame")
    ContentHeader.Size = UDim2.new(1, 0, 0, 50)
    ContentHeader.BackgroundTransparency = 1
    ContentHeader.Parent = ContentArea
    
    -- TEST Label (top left of content)
    local TestLabel = Instance.new("TextLabel")
    TestLabel.Size = UDim2.new(0, 100, 0, 20)
    TestLabel.Position = UDim2.new(0, 20, 0, 15)
    TestLabel.BackgroundTransparency = 1
    TestLabel.Text = "TEST"
    TestLabel.TextColor3 = Colors.TextDim
    TestLabel.Font = Enum.Font.GothamBold
    TestLabel.TextSize = 11
    TestLabel.TextXAlignment = Enum.TextXAlignment.Left
    TestLabel.Parent = ContentHeader
    
    -- Search Box Container
    local SearchContainer = Instance.new("Frame")
    SearchContainer.Size = UDim2.new(0, 250, 0, 30)
    SearchContainer.Position = UDim2.new(0.5, -125, 0, 15)
    SearchContainer.BackgroundColor3 = Colors.Secondary
    SearchContainer.BorderSizePixel = 0
    SearchContainer.Parent = ContentHeader
    
    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Color = Colors.Border
    SearchStroke.Thickness = 1
    SearchStroke.Parent = SearchContainer
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = SearchContainer
    
    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, -35, 1, 0)
    SearchBox.Position = UDim2.new(0, 10, 0, 0)
    SearchBox.BackgroundTransparency = 1
    SearchBox.TextColor3 = Colors.Text
    SearchBox.PlaceholderText = "Search function"
    SearchBox.PlaceholderColor3 = Colors.TextDim
    SearchBox.Text = ""
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextSize = 12
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.Parent = SearchContainer
    
    local SearchIcon = Instance.new("TextLabel")
    SearchIcon.Size = UDim2.new(0, 20, 0, 20)
    SearchIcon.Position = UDim2.new(1, -25, 0.5, -10)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Text = "🔍"
    SearchIcon.TextColor3 = Colors.TextDim
    SearchIcon.TextSize = 14
    SearchIcon.Parent = SearchContainer
    
    -- SETTINGS Label (top right)
    local SettingsLabel = Instance.new("TextLabel")
    SettingsLabel.Size = UDim2.new(0, 100, 0, 20)
    SettingsLabel.Position = UDim2.new(1, -120, 0, 15)
    SettingsLabel.BackgroundTransparency = 1
    SettingsLabel.Text = "SETTINGS"
    SettingsLabel.TextColor3 = Colors.TextDim
    SettingsLabel.Font = Enum.Font.GothamBold
    SettingsLabel.TextSize = 11
    SettingsLabel.TextXAlignment = Enum.TextXAlignment.Right
    SettingsLabel.Parent = ContentHeader
    
    -- Tab Content Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -40, 1, -70)
    TabContainer.Position = UDim2.new(0, 20, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = ContentArea
    
    MakeDraggable(MainFrame, MainFrame)
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    function Window:CreateTab(tabName, icon)
        local Tab = {}
        
        -- Tab Button in Sidebar
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(1, -20, 0, 35)
        TabButton.Position = UDim2.new(0, 10, 0, 0)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = ""
        TabButton.Parent = TabList
        
        -- Tab Icon (small colored square like in image)
        local TabIconFrame = Instance.new("Frame")
        TabIconFrame.Size = UDim2.new(0, 24, 0, 24)
        TabIconFrame.Position = UDim2.new(0, 8, 0.5, -12)
        TabIconFrame.BackgroundColor3 = Colors.Tertiary
        TabIconFrame.BorderSizePixel = 0
        TabIconFrame.Parent = TabButton
        
        local TabIconStroke = Instance.new("UIStroke")
        TabIconStroke.Color = Colors.Border
        TabIconStroke.Thickness = 1
        TabIconStroke.Parent = TabIconFrame
        
        local TabIconCorner = Instance.new("UICorner")
        TabIconCorner.CornerRadius = UDim.new(0, 6)
        TabIconCorner.Parent = TabIconFrame
        
        -- Tab Name
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -45, 1, 0)
        TabLabel.Position = UDim2.new(0, 40, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabName
        TabLabel.TextColor3 = Colors.TextDim
        TabLabel.Font = Enum.Font.Gotham
        TabLabel.TextSize = 12
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        -- Tab Content ScrollingFrame
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Colors.Accent
        TabContent.ScrollBarImageTransparency = 0.5
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Parent = TabContainer
        
        -- Two column layout
        local LeftColumn = Instance.new("Frame")
        LeftColumn.Size = UDim2.new(0.48, 0, 1, 0)
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.Parent = TabContent
        
        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Padding = UDim.new(0, 10)
        LeftLayout.Parent = LeftColumn
        
        local RightColumn = Instance.new("Frame")
        RightColumn.Size = UDim2.new(0.48, 0, 1, 0)
        RightColumn.Position = UDim2.new(0.52, 0, 0, 0)
        RightColumn.BackgroundTransparency = 1
        RightColumn.Parent = TabContent
        
        local RightLayout = Instance.new("UIListLayout")
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Padding = UDim.new(0, 10)
        RightLayout.Parent = RightColumn
        
        -- Update canvas size
        local function UpdateCanvas()
            local leftSize = LeftLayout.AbsoluteContentSize.Y
            local rightSize = RightLayout.AbsoluteContentSize.Y
            TabContent.CanvasSize = UDim2.new(0, 0, 0, math.max(leftSize, rightSize) + 20)
        end
        
        LeftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
        RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
        
        -- Tab selection
        TabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Content.Visible = false
                Window.CurrentTab.Label.TextColor3 = Colors.TextDim
                Window.CurrentTab.Icon.BackgroundColor3 = Colors.Tertiary
            end
            
            TabContent.Visible = true
            TabLabel.TextColor3 = Colors.Text
            TabIconFrame.BackgroundColor3 = Colors.Accent
            Window.CurrentTab = {Content = TabContent, Label = TabLabel, Icon = TabIconFrame}
        end)
        
        if not Window.CurrentTab then
            -- Use Activate instead of Fire for TextButtons
            TabButton.MouseButton1Click:Connect(function() end)
            TabContent.Visible = true
            TabLabel.TextColor3 = Colors.Text
            TabIconFrame.BackgroundColor3 = Colors.Accent
            Window.CurrentTab = {Content = TabContent, Label = TabLabel, Icon = TabIconFrame}
        end
        
        Tab.LeftColumn = LeftColumn
        Tab.RightColumn = RightColumn
        Tab.Content = TabContent
        
        local columnToggle = true
        
        function Tab:CreateSection(sectionName)
            local Section = {}
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Size = UDim2.new(1, 0, 0, 25)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Parent = columnToggle and LeftColumn or RightColumn
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = sectionName:upper()
            SectionLabel.TextColor3 = Colors.TextDim
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextSize = 11
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = SectionFrame
            
            columnToggle = not columnToggle
            
            return Section
        end
        
        function Tab:CreateToggle(config)
            config = config or {}
            local name = config.Name or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end
            local column = config.Column or (columnToggle and LeftColumn or RightColumn)
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Parent = column
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = name
            ToggleLabel.TextColor3 = Colors.Text
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextSize = 12
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            -- Toggle Button with exact style
            local ToggleButton = Instance.new("Frame")
            ToggleButton.Size = UDim2.new(0, 36, 0, 18)
            ToggleButton.Position = UDim2.new(1, -36, 0.5, -9)
            ToggleButton.BackgroundColor3 = Colors.Toggle
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = ToggleFrame
            
            local ToggleStroke = Instance.new("UIStroke")
            ToggleStroke.Color = Colors.Border
            ToggleStroke.Thickness = 1
            ToggleStroke.Parent = ToggleButton
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(1, 0)
            ToggleCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
            ToggleCircle.Position = UDim2.new(0, 2, 0.5, -7)
            ToggleCircle.BackgroundColor3 = Colors.Text
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            columnToggle = not columnToggle
            
            local toggled = default
            local Toggle = {}
            
            local function UpdateToggle()
                if toggled then
                    CreateTween(ToggleButton, {BackgroundColor3 = Colors.ToggleActive}, 0.2)
                    CreateTween(ToggleCircle, {Position = UDim2.new(1, -16, 0.5, -7)}, 0.2)
                else
                    CreateTween(ToggleButton, {BackgroundColor3 = Colors.Toggle}, 0.2)
                    CreateTween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -7)}, 0.2)
                end
                callback(toggled)
            end
            
            if default then
                UpdateToggle()
            end
            
            local ToggleDetect = Instance.new("TextButton")
            ToggleDetect.Size = UDim2.new(1, 0, 1, 0)
            ToggleDetect.BackgroundTransparency = 1
            ToggleDetect.Text = ""
            ToggleDetect.Parent = ToggleFrame
            
            ToggleDetect.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateToggle()
            end)
            
            function Toggle:Set(value)
                toggled = value
                UpdateToggle()
            end
            
            return Toggle
        end
        
        function Tab:CreateSlider(config)
            config = config or {}
            local name = config.Name or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local increment = config.Increment or 1
            local suffix = config.Suffix or ""
            local callback = config.Callback or function() end
            local column = config.Column or (columnToggle and LeftColumn or RightColumn)
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 45)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Parent = column
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(0.6, 0, 0, 20)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = name
            SliderLabel.TextColor3 = Colors.Text
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextSize = 12
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 50, 0, 20)
            SliderValue.Position = UDim2.new(1, -50, 0, 0)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(default) .. suffix
            SliderValue.TextColor3 = Colors.Text
            SliderValue.Font = Enum.Font.Gotham
            SliderValue.TextSize = 12
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            -- Slider Background
            local SliderBG = Instance.new("Frame")
            SliderBG.Size = UDim2.new(1, 0, 0, 6)
            SliderBG.Position = UDim2.new(0, 0, 0, 25)
            SliderBG.BackgroundColor3 = Colors.SliderBG
            SliderBG.BorderSizePixel = 0
            SliderBG.Parent = SliderFrame
            
            local SliderBGStroke = Instance.new("UIStroke")
            SliderBGStroke.Color = Colors.Border
            SliderBGStroke.Thickness = 1
            SliderBGStroke.Parent = SliderBG
            
            local SliderBGCorner = Instance.new("UICorner")
            SliderBGCorner.CornerRadius = UDim.new(1, 0)
            SliderBGCorner.Parent = SliderBG
            
            -- Slider Fill
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Colors.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBG
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            columnToggle = not columnToggle
            
            local Slider = {}
            local dragging = false
            
            local function UpdateSlider(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1), 0, 1, 0)
                SliderFill.Size = pos
                
                local value = math.floor(((pos.X.Scale * (max - min)) + min) / increment) * increment
                value = math.clamp(value, min, max)
                
                SliderValue.Text = tostring(value) .. suffix
                callback(value)
            end
            
            SliderBG.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    UpdateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
            
            function Slider:Set(value)
                value = math.clamp(value, min, max)
                SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                SliderValue.Text = tostring(value) .. suffix
                callback(value)
            end
            
            return Slider
        end
        
        function Tab:CreateDropdown(config)
            config = config or {}
            local name = config.Name or "Dropdown"
            local options = config.Options or {}
            local default = config.Default or options[1]
            local callback = config.Callback or function() end
            local column = config.Column or (columnToggle and LeftColumn or RightColumn)
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, 0, 0, 30)
            DropdownFrame.BackgroundTransparency = 1
            DropdownFrame.Parent = column
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(0.35, 0, 1, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = name
            DropdownLabel.TextColor3 = Colors.Text
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextSize = 12
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(0.6, 0, 1, 0)
            DropdownButton.Position = UDim2.new(0.4, 0, 0, 0)
            DropdownButton.BackgroundColor3 = Colors.Secondary
            DropdownButton.Text = default or "Select"
            DropdownButton.TextColor3 = Colors.Text
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.TextSize = 11
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Parent = DropdownFrame
            
            local DropdownStroke = Instance.new("UIStroke")
            DropdownStroke.Color = Colors.Border
            DropdownStroke.Thickness = 1
            DropdownStroke.Parent = DropdownButton
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 4)
            DropdownCorner.Parent = DropdownButton
            
            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
            DropdownArrow.Position = UDim2.new(1, -20, 0, 0)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Text = "▼"
            DropdownArrow.TextColor3 = Colors.TextDim
            DropdownArrow.Font = Enum.Font.Gotham
            DropdownArrow.TextSize = 9
            DropdownArrow.Parent = DropdownButton
            
            columnToggle = not columnToggle
            
            return {
                Set = function(self, option)
                    DropdownButton.Text = option
                    callback(option)
                end
            }
        end
        
        function Tab:CreateButton(config)
            config = config or {}
            local name = config.Name or "Button"
            local buttonText = config.ButtonText or "Click"
            local callback = config.Callback or function() end
            local column = config.Column or (columnToggle and LeftColumn or RightColumn)
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Size = UDim2.new(1, 0, 0, 30)
            ButtonFrame.BackgroundTransparency = 1
            ButtonFrame.Parent = column
            
            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Size = UDim2.new(0.6, 0, 1, 0)
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Text = name
            ButtonLabel.TextColor3 = Colors.Text
            ButtonLabel.Font = Enum.Font.Gotham
            ButtonLabel.TextSize = 12
            ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
            ButtonLabel.Parent = ButtonFrame
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(0, 70, 0, 24)
            Button.Position = UDim2.new(1, -70, 0.5, -12)
            Button.BackgroundColor3 = Colors.Accent
            Button.Text = buttonText
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Font = Enum.Font.GothamBold
            Button.TextSize = 11
            Button.BorderSizePixel = 0
            Button.Parent = ButtonFrame
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 4)
            ButtonCorner.Parent = Button
            
            columnToggle = not columnToggle
            
            Button.MouseButton1Click:Connect(callback)
            
            return Button
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    return Window
end

return UILibrary
