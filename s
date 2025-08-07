-- Modern UI Library
-- A complete UI library with dark theme and cyan accents

local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- UI Configuration
local Config = {
    AccentColor = Color3.fromRGB(66, 255, 249),
    BackgroundColor = Color3.fromRGB(17, 16, 24),
    SecondaryBackground = Color3.fromRGB(28, 28, 33),
    TertiaryBackground = Color3.fromRGB(36, 36, 43),
    TextColor = Color3.fromRGB(255, 255, 255),
    DimTextColor = Color3.fromRGB(124, 121, 125),
    SubTextColor = Color3.fromRGB(111, 108, 112),
}

-- Utility Functions
local function Create(class, properties)
    local obj = Instance.new(class)
    for prop, val in pairs(properties) do
        obj[prop] = val
    end
    return obj
end

local function Tween(obj, info, properties)
    local tween = TweenService:Create(obj, info or TweenInfo.new(0.2), properties)
    tween:Play()
    return tween
end

local function AddDragging(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Main Library Functions
function Library:CreateWindow(options)
    options = options or {}
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    -- Create main GUI
    Window.GUI = Create("ScreenGui", {
        Name = options.Name or "UILibrary",
        Parent = game:GetService("CoreGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    
    -- Main Background
    Window.Background = Create("Frame", {
        Name = "Background",
        Parent = Window.GUI,
        BackgroundColor3 = Config.BackgroundColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0.022, 0, 0.064, 0),
        Size = UDim2.new(0, 470, 0, 581),
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 3),
        Parent = Window.Background,
    })
    
    -- Menu Glow
    Window.MenuGlow = Create("ImageLabel", {
        Name = "MenuGlow",
        Parent = Window.Background,
        BackgroundTransparency = 1,
        Position = UDim2.new(-0.047, 0, -0.037, 0),
        Size = UDim2.new(0, 513, 0, 623),
        ZIndex = 0,
        Image = "rbxassetid://18245826428",
        ImageColor3 = Config.AccentColor,
        ImageTransparency = 0.74,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(21, 21, 79, 79),
    })
    
    -- Topbar
    Window.Topbar = Create("Frame", {
        Name = "Topbar",
        Parent = Window.Background,
        BackgroundColor3 = Config.SecondaryBackground,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.01, 0),
        Size = UDim2.new(0, 470, 0, 30),
    })
    
    -- Title
    Window.Title = Create("TextLabel", {
        Parent = Window.Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.025, 0, -0.2, 0),
        Size = UDim2.new(0, 120, 0, 32),
        Font = Enum.Font.SourceSansBold,
        Text = options.Title or "UI Library",
        TextColor3 = Config.AccentColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Tabs Container
    Window.TabsHolder = Create("Frame", {
        Name = "TabsHolder",
        Parent = Window.Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.506, 0, -0.176, 0),
        Size = UDim2.new(0, 232, 0, 36),
    })
    
    Create("UIListLayout", {
        Parent = Window.TabsHolder,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
    })
    
    -- Bottom Bar
    Window.UnderBar = Create("Frame", {
        Name = "UnderBar",
        Parent = Window.Background,
        BackgroundColor3 = Config.SecondaryBackground,
        BorderSizePixel = 0,
        Position = UDim2.new(0.002, 0, 0.964, 0),
        Size = UDim2.new(0, 468, 0, 21),
    })
    
    Window.GameName = Create("TextLabel", {
        Name = "GameName",
        Parent = Window.UnderBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 150, 0, 21),
        Font = Enum.Font.SourceSansSemibold,
        Text = options.GameName or game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
        TextColor3 = Config.AccentColor,
        TextSize = 14,
    })
    
    Window.UserStatus = Create("TextLabel", {
        Name = "UserStatus",
        Parent = Window.UnderBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.786, 0, 0, 0),
        Size = UDim2.new(0, 94, 0, 21),
        Font = Enum.Font.SourceSansSemibold,
        Text = LocalPlayer.Name,
        TextColor3 = Config.AccentColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
    })
    
    -- Container for tabs content
    Window.TabContainer = Create("Frame", {
        Parent = Window.Background,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.06, 0),
        Size = UDim2.new(1, 0, 0.9, 0),
    })
    
    -- Make window draggable
    AddDragging(Window.Background, Window.Topbar)
    
    -- Toggle visibility with keybind
    if options.Keybind then
        UserInputService.InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == options.Keybind then
                Window.GUI.Enabled = not Window.GUI.Enabled
            end
        end)
    end
    
    -- Tab Functions
    function Window:CreateTab(name)
        local Tab = {}
        Tab.Name = name
        Tab.Sections = {}
        
        -- Tab Button
        Tab.Button = Create("TextLabel", {
            Name = "TabButton",
            Parent = Window.TabsHolder,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 50, 0, 32),
            Font = Enum.Font.SourceSansSemibold,
            Text = name,
            TextColor3 = Config.DimTextColor,
            TextSize = 14,
        })
        
        -- Selected Line
        Tab.SelectedLine = Create("Frame", {
            Name = "SelectedLine",
            Parent = Tab.Button,
            BackgroundColor3 = Config.AccentColor,
            BorderSizePixel = 0,
            Position = UDim2.new(-0.06, 0, 1, 0),
            Size = UDim2.new(0, 55, 0, 2),
            Visible = false,
        })
        
        -- Tab Content
        Tab.Content = Create("ScrollingFrame", {
            Parent = Window.TabContainer,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 4,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0),
        })
        
        Create("UIListLayout", {
            Parent = Tab.Content,
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
        })
        
        -- Tab Click Handler
        Tab.Button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Window:SelectTab(Tab)
            end
        end)
        
        -- Section Functions
        function Tab:CreateSection(title)
            local Section = {}
            Section.Elements = {}
            
            -- Section Frame
            Section.Frame = Create("Frame", {
                Parent = Tab.Content,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 225, 0, 420),
            })
            
            -- Section Title
            Section.TitleFrame = Create("Frame", {
                Name = "Title",
                Parent = Section.Frame,
                BackgroundColor3 = Config.SecondaryBackground,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.022, 0),
                Size = UDim2.new(0, 225, 0, 15),
            })
            
            Section.TitleText = Create("TextLabel", {
                Parent = Section.TitleFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.028, 0, -0.467, 0),
                Size = UDim2.new(0, 79, 0, 22),
                Font = Enum.Font.SourceSansSemibold,
                Text = title,
                TextColor3 = Config.AccentColor,
                TextSize = 15,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            
            -- Section Content Holder
            Section.ContentHolder = Create("Frame", {
                Name = "SectionHolder",
                Parent = Section.Frame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.015, 0, 0.088, 0),
                Size = UDim2.new(0, 216, 0, 380),
            })
            
            Create("UIListLayout", {
                Parent = Section.ContentHolder,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 7),
            })
            
            -- Update canvas size
            local function UpdateCanvasSize()
                Tab.Content.CanvasSize = UDim2.new(0, 0, 0, Tab.Content.UIListLayout.AbsoluteContentSize.Y)
            end
            
            -- Element Functions
            function Section:AddToggle(options)
                options = options or {}
                local Toggle = {}
                
                Toggle.Frame = Create("TextButton", {
                    Parent = Section.ContentHolder,
                    BackgroundColor3 = options.Default and Config.AccentColor or Color3.new(1, 1, 1),
                    BackgroundTransparency = options.Default and 0 or 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 18, 0, 18),
                    Text = "",
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 3),
                    Parent = Toggle.Frame,
                })
                
                Toggle.Title = Create("TextLabel", {
                    Parent = Toggle.Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1.461, 0, -0.056, 0),
                    Size = UDim2.new(0, 188, 0, 20),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = options.Name or "Toggle",
                    TextColor3 = options.Default and Config.TextColor or Config.DimTextColor,
                    TextSize = 15,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                Toggle.Checkmark = Create("ImageLabel", {
                    Parent = Toggle.Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.111, 0, 0.111, 0),
                    Size = UDim2.new(0, 13, 0, 13),
                    Image = "http://www.roblox.com/asset/?id=6031094667",
                    ImageColor3 = Color3.new(0, 0, 0),
                    Visible = options.Default or false,
                })
                
                Toggle.Value = options.Default or false
                
                Toggle.Frame.MouseButton1Click:Connect(function()
                    Toggle.Value = not Toggle.Value
                    
                    if Toggle.Value then
                        Tween(Toggle.Frame, nil, {BackgroundColor3 = Config.AccentColor, BackgroundTransparency = 0})
                        Tween(Toggle.Title, nil, {TextColor3 = Config.TextColor})
                        Toggle.Checkmark.Visible = true
                    else
                        Tween(Toggle.Frame, nil, {BackgroundTransparency = 1})
                        Tween(Toggle.Title, nil, {TextColor3 = Config.DimTextColor})
                        Toggle.Checkmark.Visible = false
                    end
                    
                    if options.Callback then
                        options.Callback(Toggle.Value)
                    end
                end)
                
                UpdateCanvasSize()
                return Toggle
            end
            
            function Section:AddSlider(options)
                options = options or {}
                local Slider = {}
                
                Slider.Frame = Create("TextLabel", {
                    Parent = Section.ContentHolder,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 215, 0, 32),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = options.Name or "Slider",
                    TextColor3 = Config.DimTextColor,
                    TextSize = 15,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                })
                
                Slider.SliderFrame = Create("Frame", {
                    Parent = Slider.Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.8, 0),
                    Size = UDim2.new(0, 214, 0, 2),
                })
                
                Slider.Filler = Create("Frame", {
                    Parent = Slider.SliderFrame,
                    BackgroundColor3 = Config.AccentColor,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, -4, 7),
                    Size = UDim2.new(0, 0, 0, 4),
                    ZIndex = 2,
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 2),
                    Parent = Slider.Filler,
                })
                
                Slider.Head = Create("TextButton", {
                    Parent = Slider.Filler,
                    BackgroundColor3 = Color3.fromRGB(54, 54, 54),
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -5, -0.75, 0),
                    Size = UDim2.new(0, 10, 0, 10),
                    Text = "",
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = Slider.Head,
                })
                
                Slider.ValueBox = Create("TextBox", {
                    Parent = Slider.Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.765, 0, 0, 0),
                    Size = UDim2.new(0, 50, 0, 19),
                    Font = Enum.Font.SourceSansSemibold,
                    PlaceholderColor3 = Config.SubTextColor,
                    PlaceholderText = tostring(options.Default or options.Min or 0),
                    Text = "",
                    TextColor3 = Config.SubTextColor,
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Right,
                })
                
                local min = options.Min or 0
                local max = options.Max or 100
                local default = options.Default or min
                local increment = options.Increment or 1
                
                Slider.Value = default
                
                local function UpdateSlider(value)
                    value = math.clamp(value, min, max)
                    value = math.floor(value / increment) * increment
                    Slider.Value = value
                    
                    local percent = (value - min) / (max - min)
                    Tween(Slider.Filler, TweenInfo.new(0.1), {Size = UDim2.new(percent, 0, 0, 4)})
                    Slider.ValueBox.PlaceholderText = tostring(value)
                    
                    if options.Callback then
                        options.Callback(value)
                    end
                end
                
                local dragging = false
                
                Slider.Head.MouseButton1Down:Connect(function()
                    dragging = true
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                RunService.RenderStepped:Connect(function()
                    if dragging then
                        local mousePos = UserInputService:GetMouseLocation().X
                        local framePos = Slider.SliderFrame.AbsolutePosition.X
                        local frameSize = Slider.SliderFrame.AbsoluteSize.X
                        local percent = math.clamp((mousePos - framePos) / frameSize, 0, 1)
                        local value = min + (max - min) * percent
                        UpdateSlider(value)
                    end
                end)
                
                Slider.ValueBox.FocusLost:Connect(function()
                    local value = tonumber(Slider.ValueBox.Text)
                    if value then
                        UpdateSlider(value)
                    end
                    Slider.ValueBox.Text = ""
                end)
                
                UpdateSlider(default)
                UpdateCanvasSize()
                return Slider
            end
            
            function Section:AddDropdown(options)
                options = options or {}
                local Dropdown = {}
                
                Dropdown.Frame = Create("TextButton", {
                    Parent = Section.ContentHolder,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 216, 0, 20),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = " " .. (options.Default or options.Options[1] or "Select"),
                    TextColor3 = Config.DimTextColor,
                    TextSize = 15,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                Dropdown.Arrow = Create("ImageLabel", {
                    Parent = Dropdown.Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.907, 0, 0, 0),
                    Size = UDim2.new(0, 20, 0, 20),
                    Image = "http://www.roblox.com/asset/?id=6034818372",
                    ImageColor3 = Config.SubTextColor,
                })
                
                Dropdown.Holder = Create("Frame", {
                    Parent = Dropdown.Frame,
                    BackgroundColor3 = Config.TertiaryBackground,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 1.35, 0),
                    Size = UDim2.new(0, 215, 0, 0),
                    ClipsDescendants = true,
                    ZIndex = 2,
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 2),
                    Parent = Dropdown.Holder,
                })
                
                Create("UIListLayout", {
                    Parent = Dropdown.Holder,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 1),
                })
                
                Dropdown.Options = {}
                Dropdown.Value = options.Default or options.Options[1]
                Dropdown.Open = false
                
                for _, option in ipairs(options.Options or {}) do
                    local OptionLabel = Create("TextLabel", {
                        Parent = Dropdown.Holder,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 215, 0, 16),
                        Font = Enum.Font.SourceSansSemibold,
                        Text = " " .. option,
                        TextColor3 = option == Dropdown.Value and Config.AccentColor or Config.SubTextColor,
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                    })
                    
                    OptionLabel.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Dropdown.Value = option
                            Dropdown.Frame.Text = " " .. option
                            
                            for _, opt in pairs(Dropdown.Options) do
                                opt.TextColor3 = Config.SubTextColor
                            end
                            OptionLabel.TextColor3 = Config.AccentColor
                            
                            if options.Callback then
                                options.Callback(option)
                            end
                            
                            Dropdown:Toggle()
                        end
                    end)
                    
                    table.insert(Dropdown.Options, OptionLabel)
                end
                
                function Dropdown:Toggle()
                    Dropdown.Open = not Dropdown.Open
                    local size = Dropdown.Open and UDim2.new(0, 215, 0, #Dropdown.Options * 17) or UDim2.new(0, 215, 0, 0)
                    Tween(Dropdown.Holder, TweenInfo.new(0.2), {Size = size})
                    Tween(Dropdown.Arrow, TweenInfo.new(0.2), {Rotation = Dropdown.Open and 180 or 0})
                end
                
                Dropdown.Frame.MouseButton1Click:Connect(function()
                    Dropdown:Toggle()
                end)
                
                UpdateCanvasSize()
                return Dropdown
            end
            
            function Section:AddButton(options)
                options = options or {}
                local Button = {}
                
                Button.Frame = Create("TextButton", {
                    Parent = Section.ContentHolder,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 100, 0, 30),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = options.Name or "Button",
                    TextColor3 = Config.TextColor,
                    TextSize = 15,
                })
                
                Button.Frame.MouseButton1Click:Connect(function()
                    if options.Callback then
                        options.Callback()
                    end
                end)
                
                Button.Frame.MouseEnter:Connect(function()
                    Tween(Button.Frame, TweenInfo.new(0.1), {TextColor3 = Config.AccentColor})
                end)
                
                Button.Frame.MouseLeave:Connect(function()
                    Tween(Button.Frame, TweenInfo.new(0.1), {TextColor3 = Config.TextColor})
                end)
                
                UpdateCanvasSize()
                return Button
            end
            
            function Section:AddTextbox(options)
                options = options or {}
                local Textbox = {}
                
                Textbox.Frame = Create("Frame", {
                    Parent = Section.ContentHolder,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 215, 0, 30),
                })
                
                Textbox.Title = Create("TextLabel", {
                    Parent = Textbox.Frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = options.Name or "Textbox",
                    TextColor3 = Config.DimTextColor,
                    TextSize = 15,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                Textbox.Input = Create("TextBox", {
                    Parent = Textbox.Frame,
                    BackgroundColor3 = Config.TertiaryBackground,
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = Enum.Font.SourceSans,
                    PlaceholderText = options.Placeholder or "Enter text...",
                    Text = options.Default or "",
                    TextColor3 = Config.TextColor,
                    TextSize = 14,
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 3),
                    Parent = Textbox.Input,
                })
                
                Textbox.Input.FocusLost:Connect(function()
                    if options.Callback then
                        options.Callback(Textbox.Input.Text)
                    end
                end)
                
                UpdateCanvasSize()
                return Textbox
            end
            
            function Section:AddKeybind(options)
                options = options or {}
                local Keybind = {}
                
                Keybind.Frame = Create("Frame", {
                    Parent = Section.ContentHolder,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 215, 0, 20),
                })
                
                Keybind.Title = Create("TextLabel", {
                    Parent = Keybind.Frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 150, 0, 20),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = options.Name or "Keybind",
                    TextColor3 = Config.DimTextColor,
                    TextSize = 15,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                Keybind.Button = Create("TextButton", {
                    Parent = Keybind.Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.814, 0, 0, 0),
                    Size = UDim2.new(0, 40, 0, 20),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = options.Default and options.Default.Name or "None",
                    TextColor3 = Config.TextColor,
                    TextSize = 15,
                })
                
                local binding = false
                Keybind.Key = options.Default
                
                Keybind.Button.MouseButton1Click:Connect(function()
                    binding = true
                    Keybind.Button.Text = "..."
                end)
                
                UserInputService.InputBegan:Connect(function(input, processed)
                    if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                        Keybind.Key = input.KeyCode
                        Keybind.Button.Text = input.KeyCode.Name
                        binding = false
                    elseif not processed and Keybind.Key and input.KeyCode == Keybind.Key then
                        if options.Callback then
                            options.Callback()
                        end
                    end
                end)
                
                UpdateCanvasSize()
                return Keybind
            end
            
            function Section:AddColorpicker(options)
                options = options or {}
                local Colorpicker = {}
                
                Colorpicker.Frame = Create("Frame", {
                    Parent = Section.ContentHolder,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 215, 0, 20),
                })
                
                Colorpicker.Title = Create("TextLabel", {
                    Parent = Colorpicker.Frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 150, 0, 20),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = options.Name or "Color",
                    TextColor3 = Config.DimTextColor,
                    TextSize = 15,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                Colorpicker.Button = Create("TextButton", {
                    Parent = Colorpicker.Frame,
                    BackgroundColor3 = options.Default or Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.851, 0, 0.148, 0),
                    Size = UDim2.new(0, 32, 0, 13),
                    Text = "",
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 3),
                    Parent = Colorpicker.Button,
                })
                
                Colorpicker.Value = options.Default or Color3.fromRGB(255, 255, 255)
                
                -- Create color picker window (simplified)
                Colorpicker.Button.MouseButton1Click:Connect(function()
                    -- This would open a color picker UI
                    -- For simplicity, we'll cycle through preset colors
                    local colors = {
                        Color3.fromRGB(255, 0, 0),
                        Color3.fromRGB(0, 255, 0),
                        Color3.fromRGB(0, 0, 255),
                        Color3.fromRGB(255, 255, 0),
                        Color3.fromRGB(255, 0, 255),
                        Color3.fromRGB(0, 255, 255),
                        Color3.fromRGB(255, 255, 255),
                    }
                    
                    local currentIndex = 1
                    for i, color in ipairs(colors) do
                        if color == Colorpicker.Value then
                            currentIndex = i
                            break
                        end
                    end
                    
                    currentIndex = currentIndex % #colors + 1
                    Colorpicker.Value = colors[currentIndex]
                    Colorpicker.Button.BackgroundColor3 = Colorpicker.Value
                    
                    if options.Callback then
                        options.Callback(Colorpicker.Value)
                    end
                end)
                
                UpdateCanvasSize()
                return Colorpicker
            end
            
            function Section:AddLabel(text)
                local Label = Create("TextLabel", {
                    Parent = Section.ContentHolder,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 215, 0, 20),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = text or "Label",
                    TextColor3 = Config.SubTextColor,
                    TextSize = 15,
                })
                
                UpdateCanvasSize()
                return Label
            end
            
            function Section:AddDivider()
                local Divider = Create("Frame", {
                    Parent = Section.ContentHolder,
                    BackgroundColor3 = Config.AccentColor,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 215, 0, 3),
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 3),
                    Parent = Divider,
                })
                
                UpdateCanvasSize()
                return Divider
            end
            
            return Section
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            Window:SelectTab(Tab)
        end
        
        return Tab
    end
    
    function Window:SelectTab(tab)
        -- Hide all tabs
        for _, t in pairs(Window.Tabs) do
            t.Content.Visible = false
            t.SelectedLine.Visible = false
            t.Button.TextColor3 = Config.DimTextColor
        end
        
        -- Show selected tab
        tab.Content.Visible = true
        tab.SelectedLine.Visible = true
        tab.Button.TextColor3 = Config.AccentColor
        Window.CurrentTab = tab
    end
    
    function Window:Toggle()
        Window.GUI.Enabled = not Window.GUI.Enabled
    end
    
    function Window:Destroy()
        Window.GUI:Destroy()
    end
    
    return Window
end

return Library
