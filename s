-- Modern UI Library for Roblox
-- Place this in a LocalScript in StarterGui

local UILibrary = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Color Scheme
local Colors = {
	Background = Color3.fromRGB(30, 30, 35),
	Secondary = Color3.fromRGB(35, 35, 40),
	Accent = Color3.fromRGB(255, 140, 140),
	Text = Color3.fromRGB(200, 200, 200),
	TextDim = Color3.fromRGB(120, 120, 125),
	Border = Color3.fromRGB(50, 50, 55),
	Toggle = Color3.fromRGB(60, 60, 65),
	ToggleActive = Color3.fromRGB(255, 140, 140)
}

-- Utility Functions
local function CreateTween(obj, properties, duration)
	local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quart), properties)
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

	-- Main Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 750, 0, 500)
	MainFrame.Position = UDim2.new(0.5, -375, 0.5, -250)
	MainFrame.BackgroundColor3 = Colors.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui

	-- Add rounded corners
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 8)
	UICorner.Parent = MainFrame

	-- Top Bar
	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.Size = UDim2.new(1, 0, 0, 35)
	TopBar.BackgroundColor3 = Colors.Secondary
	TopBar.BorderSizePixel = 0
	TopBar.Parent = MainFrame

	local TopBarCorner = Instance.new("UICorner")
	TopBarCorner.CornerRadius = UDim.new(0, 8)
	TopBarCorner.Parent = TopBar

	local TopBarFix = Instance.new("Frame")
	TopBarFix.Size = UDim2.new(1, 0, 0, 10)
	TopBarFix.Position = UDim2.new(0, 0, 1, -10)
	TopBarFix.BackgroundColor3 = Colors.Secondary
	TopBarFix.BorderSizePixel = 0
	TopBarFix.Parent = TopBar

	-- Search Box
	local SearchFrame = Instance.new("Frame")
	SearchFrame.Size = UDim2.new(0, 300, 0, 25)
	SearchFrame.Position = UDim2.new(0.5, -150, 0.5, -12)
	SearchFrame.BackgroundColor3 = Colors.Background
	SearchFrame.BorderSizePixel = 0
	SearchFrame.Parent = TopBar

	local SearchCorner = Instance.new("UICorner")
	SearchCorner.CornerRadius = UDim.new(0, 4)
	SearchCorner.Parent = SearchFrame

	local SearchBox = Instance.new("TextBox")
	SearchBox.Size = UDim2.new(1, -10, 1, 0)
	SearchBox.Position = UDim2.new(0, 5, 0, 0)
	SearchBox.BackgroundTransparency = 1
	SearchBox.TextColor3 = Colors.Text
	SearchBox.PlaceholderText = "Search function"
	SearchBox.PlaceholderColor3 = Colors.TextDim
	SearchBox.Text = ""
	SearchBox.Font = Enum.Font.Gotham
	SearchBox.TextSize = 13
	SearchBox.TextXAlignment = Enum.TextXAlignment.Left
	SearchBox.Parent = SearchFrame

	-- Search Icon
	local SearchIcon = Instance.new("ImageLabel")
	SearchIcon.Size = UDim2.new(0, 16, 0, 16)
	SearchIcon.Position = UDim2.new(1, -20, 0.5, -8)
	SearchIcon.BackgroundTransparency = 1
	SearchIcon.Image = "rbxasset://textures/ui/common/search.png"
	SearchIcon.ImageColor3 = Colors.TextDim
	SearchIcon.Parent = SearchFrame

	-- Sidebar
	local Sidebar = Instance.new("ScrollingFrame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 180, 1, -35)
	Sidebar.Position = UDim2.new(0, 0, 0, 35)
	Sidebar.BackgroundColor3 = Colors.Secondary
	Sidebar.BorderSizePixel = 0
	Sidebar.ScrollBarThickness = 2
	Sidebar.ScrollBarImageColor3 = Colors.Accent
	Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
	Sidebar.Parent = MainFrame

	local SidebarLayout = Instance.new("UIListLayout")
	SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SidebarLayout.Padding = UDim.new(0, 0)
	SidebarLayout.Parent = Sidebar

	-- Content Area
	local Content = Instance.new("Frame")
	Content.Name = "Content"
	Content.Size = UDim2.new(1, -180, 1, -35)
	Content.Position = UDim2.new(0, 180, 0, 35)
	Content.BackgroundColor3 = Colors.Background
	Content.BorderSizePixel = 0
	Content.Parent = MainFrame

	-- Tab Container
	local TabContainer = Instance.new("Frame")
	TabContainer.Size = UDim2.new(1, -20, 1, -20)
	TabContainer.Position = UDim2.new(0, 10, 0, 10)
	TabContainer.BackgroundTransparency = 1
	TabContainer.Parent = Content

	MakeDraggable(MainFrame, TopBar)

	local Window = {}
	Window.Tabs = {}
	Window.CurrentTab = nil

	function Window:CreateTab(tabName, icon)
		local Tab = {}

		-- Tab Button
		local TabButton = Instance.new("TextButton")
		TabButton.Name = tabName
		TabButton.Size = UDim2.new(1, 0, 0, 45)
		TabButton.BackgroundTransparency = 1
		TabButton.Text = ""
		TabButton.Parent = Sidebar

		local TabLabel = Instance.new("TextLabel")
		TabLabel.Size = UDim2.new(1, -50, 1, 0)
		TabLabel.Position = UDim2.new(0, 50, 0, 0)
		TabLabel.BackgroundTransparency = 1
		TabLabel.Text = tabName:upper()
		TabLabel.TextColor3 = Colors.TextDim
		TabLabel.Font = Enum.Font.GothamBold
		TabLabel.TextSize = 11
		TabLabel.TextXAlignment = Enum.TextXAlignment.Left
		TabLabel.Parent = TabButton

		local TabIcon = Instance.new("Frame")
		TabIcon.Size = UDim2.new(0, 20, 0, 20)
		TabIcon.Position = UDim2.new(0, 20, 0.5, -10)
		TabIcon.BackgroundColor3 = Colors.TextDim
		TabIcon.BorderSizePixel = 0
		TabIcon.Parent = TabButton

		local IconCorner = Instance.new("UICorner")
		IconCorner.CornerRadius = UDim.new(0, 4)
		IconCorner.Parent = TabIcon

		-- Tab Content
		local TabContent = Instance.new("ScrollingFrame")
		TabContent.Size = UDim2.new(1, 0, 1, 0)
		TabContent.BackgroundTransparency = 1
		TabContent.BorderSizePixel = 0
		TabContent.ScrollBarThickness = 3
		TabContent.ScrollBarImageColor3 = Colors.Accent
		TabContent.Visible = false
		TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabContent.Parent = TabContainer

		local ContentLayout = Instance.new("UIListLayout")
		ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ContentLayout.Padding = UDim.new(0, 10)
		ContentLayout.Parent = TabContent

		ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
		end)

		TabButton.MouseButton1Click:Connect(function()
			if Window.CurrentTab then
				Window.CurrentTab.Content.Visible = false
				Window.CurrentTab.Label.TextColor3 = Colors.TextDim
			end

			TabContent.Visible = true
			TabLabel.TextColor3 = Colors.Text
			Window.CurrentTab = {Content = TabContent, Label = TabLabel}
		end)

		if not Window.CurrentTab then
			TabButton.MouseButton1Click:Fire()
		end

		Tab.Content = TabContent

		function Tab:CreateSection(sectionName)
			local Section = {}

			local SectionFrame = Instance.new("Frame")
			SectionFrame.Size = UDim2.new(1, 0, 0, 30)
			SectionFrame.BackgroundTransparency = 1
			SectionFrame.Parent = TabContent

			local SectionLabel = Instance.new("TextLabel")
			SectionLabel.Size = UDim2.new(1, 0, 1, 0)
			SectionLabel.BackgroundTransparency = 1
			SectionLabel.Text = sectionName
			SectionLabel.TextColor3 = Colors.Text
			SectionLabel.Font = Enum.Font.GothamBold
			SectionLabel.TextSize = 14
			SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
			SectionLabel.Parent = SectionFrame

			return Section
		end

		function Tab:CreateToggle(config)
			config = config or {}
			local name = config.Name or "Toggle"
			local default = config.Default or false
			local callback = config.Callback or function() end

			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
			ToggleFrame.BackgroundColor3 = Colors.Secondary
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.Parent = TabContent

			local ToggleCorner = Instance.new("UICorner")
			ToggleCorner.CornerRadius = UDim.new(0, 4)
			ToggleCorner.Parent = ToggleFrame

			local ToggleLabel = Instance.new("TextLabel")
			ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
			ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
			ToggleLabel.BackgroundTransparency = 1
			ToggleLabel.Text = name
			ToggleLabel.TextColor3 = Colors.Text
			ToggleLabel.Font = Enum.Font.Gotham
			ToggleLabel.TextSize = 13
			ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
			ToggleLabel.Parent = ToggleFrame

			local ToggleButton = Instance.new("Frame")
			ToggleButton.Size = UDim2.new(0, 40, 0, 20)
			ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
			ToggleButton.BackgroundColor3 = Colors.Toggle
			ToggleButton.BorderSizePixel = 0
			ToggleButton.Parent = ToggleFrame

			local ToggleButtonCorner = Instance.new("UICorner")
			ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
			ToggleButtonCorner.Parent = ToggleButton

			local ToggleCircle = Instance.new("Frame")
			ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
			ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
			ToggleCircle.BackgroundColor3 = Colors.Text
			ToggleCircle.BorderSizePixel = 0
			ToggleCircle.Parent = ToggleButton

			local CircleCorner = Instance.new("UICorner")
			CircleCorner.CornerRadius = UDim.new(1, 0)
			CircleCorner.Parent = ToggleCircle

			local toggled = default
			local Toggle = {}

			local function UpdateToggle()
				if toggled then
					CreateTween(ToggleButton, {BackgroundColor3 = Colors.ToggleActive}, 0.2)
					CreateTween(ToggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
				else
					CreateTween(ToggleButton, {BackgroundColor3 = Colors.Toggle}, 0.2)
					CreateTween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
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

			local SliderFrame = Instance.new("Frame")
			SliderFrame.Size = UDim2.new(1, 0, 0, 50)
			SliderFrame.BackgroundColor3 = Colors.Secondary
			SliderFrame.BorderSizePixel = 0
			SliderFrame.Parent = TabContent

			local SliderCorner = Instance.new("UICorner")
			SliderCorner.CornerRadius = UDim.new(0, 4)
			SliderCorner.Parent = SliderFrame

			local SliderLabel = Instance.new("TextLabel")
			SliderLabel.Size = UDim2.new(0.5, 0, 0, 25)
			SliderLabel.Position = UDim2.new(0, 10, 0, 5)
			SliderLabel.BackgroundTransparency = 1
			SliderLabel.Text = name
			SliderLabel.TextColor3 = Colors.Text
			SliderLabel.Font = Enum.Font.Gotham
			SliderLabel.TextSize = 13
			SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
			SliderLabel.Parent = SliderFrame

			local SliderValue = Instance.new("TextLabel")
			SliderValue.Size = UDim2.new(0, 60, 0, 25)
			SliderValue.Position = UDim2.new(1, -70, 0, 5)
			SliderValue.BackgroundTransparency = 1
			SliderValue.Text = tostring(default) .. suffix
			SliderValue.TextColor3 = Colors.Text
			SliderValue.Font = Enum.Font.Gotham
			SliderValue.TextSize = 13
			SliderValue.TextXAlignment = Enum.TextXAlignment.Right
			SliderValue.Parent = SliderFrame

			local SliderBG = Instance.new("Frame")
			SliderBG.Size = UDim2.new(1, -20, 0, 4)
			SliderBG.Position = UDim2.new(0, 10, 0, 35)
			SliderBG.BackgroundColor3 = Colors.Background
			SliderBG.BorderSizePixel = 0
			SliderBG.Parent = SliderFrame

			local SliderBGCorner = Instance.new("UICorner")
			SliderBGCorner.CornerRadius = UDim.new(1, 0)
			SliderBGCorner.Parent = SliderBG

			local SliderFill = Instance.new("Frame")
			SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			SliderFill.BackgroundColor3 = Colors.Accent
			SliderFill.BorderSizePixel = 0
			SliderFill.Parent = SliderBG

			local SliderFillCorner = Instance.new("UICorner")
			SliderFillCorner.CornerRadius = UDim.new(1, 0)
			SliderFillCorner.Parent = SliderFill

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

			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
			DropdownFrame.BackgroundColor3 = Colors.Secondary
			DropdownFrame.BorderSizePixel = 0
			DropdownFrame.Parent = TabContent

			local DropdownCorner = Instance.new("UICorner")
			DropdownCorner.CornerRadius = UDim.new(0, 4)
			DropdownCorner.Parent = DropdownFrame

			local DropdownLabel = Instance.new("TextLabel")
			DropdownLabel.Size = UDim2.new(0.4, 0, 1, 0)
			DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
			DropdownLabel.BackgroundTransparency = 1
			DropdownLabel.Text = name
			DropdownLabel.TextColor3 = Colors.Text
			DropdownLabel.Font = Enum.Font.Gotham
			DropdownLabel.TextSize = 13
			DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
			DropdownLabel.Parent = DropdownFrame

			local DropdownButton = Instance.new("TextButton")
			DropdownButton.Size = UDim2.new(0.5, 0, 0, 25)
			DropdownButton.Position = UDim2.new(0.45, 0, 0.5, -12)
			DropdownButton.BackgroundColor3 = Colors.Background
			DropdownButton.Text = default or "Select"
			DropdownButton.TextColor3 = Colors.Text
			DropdownButton.Font = Enum.Font.Gotham
			DropdownButton.TextSize = 12
			DropdownButton.BorderSizePixel = 0
			DropdownButton.Parent = DropdownFrame

			local DropdownButtonCorner = Instance.new("UICorner")
			DropdownButtonCorner.CornerRadius = UDim.new(0, 4)
			DropdownButtonCorner.Parent = DropdownButton

			local DropdownArrow = Instance.new("TextLabel")
			DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
			DropdownArrow.Position = UDim2.new(1, -25, 0, 0)
			DropdownArrow.BackgroundTransparency = 1
			DropdownArrow.Text = "▼"
			DropdownArrow.TextColor3 = Colors.TextDim
			DropdownArrow.Font = Enum.Font.Gotham
			DropdownArrow.TextSize = 10
			DropdownArrow.Parent = DropdownButton

			local DropdownList = Instance.new("Frame")
			DropdownList.Size = UDim2.new(0, DropdownButton.AbsoluteSize.X, 0, 0)
			DropdownList.Position = UDim2.new(0, DropdownButton.AbsolutePosition.X - DropdownFrame.AbsolutePosition.X, 0, 35)
			DropdownList.BackgroundColor3 = Colors.Secondary
			DropdownList.BorderSizePixel = 0
			DropdownList.ClipsDescendants = true
			DropdownList.Visible = false
			DropdownList.ZIndex = 10
			DropdownList.Parent = DropdownFrame

			local DropdownListCorner = Instance.new("UICorner")
			DropdownListCorner.CornerRadius = UDim.new(0, 4)
			DropdownListCorner.Parent = DropdownList

			local DropdownListLayout = Instance.new("UIListLayout")
			DropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			DropdownListLayout.Parent = DropdownList

			local expanded = false
			local Dropdown = {}

			for _, option in ipairs(options) do
				local OptionButton = Instance.new("TextButton")
				OptionButton.Size = UDim2.new(1, 0, 0, 25)
				OptionButton.BackgroundColor3 = Colors.Secondary
				OptionButton.Text = option
				OptionButton.TextColor3 = Colors.Text
				OptionButton.Font = Enum.Font.Gotham
				OptionButton.TextSize = 12
				OptionButton.BorderSizePixel = 0
				OptionButton.Parent = DropdownList

				OptionButton.MouseEnter:Connect(function()
					CreateTween(OptionButton, {BackgroundColor3 = Colors.Background}, 0.2)
				end)

				OptionButton.MouseLeave:Connect(function()
					CreateTween(OptionButton, {BackgroundColor3 = Colors.Secondary}, 0.2)
				end)

				OptionButton.MouseButton1Click:Connect(function()
					DropdownButton.Text = option
					expanded = false
					CreateTween(DropdownList, {Size = UDim2.new(0, DropdownButton.AbsoluteSize.X, 0, 0)}, 0.2)
					CreateTween(DropdownArrow, {Rotation = 0}, 0.2)
					wait(0.2)
					DropdownList.Visible = false
					callback(option)
				end)
			end

			DropdownButton.MouseButton1Click:Connect(function()
				expanded = not expanded
				if expanded then
					DropdownList.Visible = true
					CreateTween(DropdownList, {Size = UDim2.new(0, DropdownButton.AbsoluteSize.X, 0, #options * 25)}, 0.2)
					CreateTween(DropdownArrow, {Rotation = 180}, 0.2)
				else
					CreateTween(DropdownList, {Size = UDim2.new(0, DropdownButton.AbsoluteSize.X, 0, 0)}, 0.2)
					CreateTween(DropdownArrow, {Rotation = 0}, 0.2)
					wait(0.2)
					DropdownList.Visible = false
				end
			end)

			function Dropdown:Set(option)
				DropdownButton.Text = option
				callback(option)
			end

			return Dropdown
		end

		function Tab:CreateButton(config)
			config = config or {}
			local name = config.Name or "Button"
			local buttonText = config.ButtonText or "Click"
			local callback = config.Callback or function() end

			local ButtonFrame = Instance.new("Frame")
			ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
			ButtonFrame.BackgroundColor3 = Colors.Secondary
			ButtonFrame.BorderSizePixel = 0
			ButtonFrame.Parent = TabContent

			local ButtonCorner = Instance.new("UICorner")
			ButtonCorner.CornerRadius = UDim.new(0, 4)
			ButtonCorner.Parent = ButtonFrame

			local ButtonLabel = Instance.new("TextLabel")
			ButtonLabel.Size = UDim2.new(0.6, 0, 1, 0)
			ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
			ButtonLabel.BackgroundTransparency = 1
			ButtonLabel.Text = name
			ButtonLabel.TextColor3 = Colors.Text
			ButtonLabel.Font = Enum.Font.Gotham
			ButtonLabel.TextSize = 13
			ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
			ButtonLabel.Parent = ButtonFrame

			local Button = Instance.new("TextButton")
			Button.Size = UDim2.new(0, 80, 0, 25)
			Button.Position = UDim2.new(1, -90, 0.5, -12)
			Button.BackgroundColor3 = Colors.Accent
			Button.Text = buttonText
			Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			Button.Font = Enum.Font.GothamBold
			Button.TextSize = 12
			Button.BorderSizePixel = 0
			Button.Parent = ButtonFrame

			local ButtonButtonCorner = Instance.new("UICorner")
			ButtonButtonCorner.CornerRadius = UDim.new(0, 4)
			ButtonButtonCorner.Parent = Button

			Button.MouseButton1Click:Connect(function()
				CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(200, 100, 100)}, 0.1)
				wait(0.1)
				CreateTween(Button, {BackgroundColor3 = Colors.Accent}, 0.1)
				callback()
			end)

			return Button
		end

		function Tab:CreateColorPicker(config)
			config = config or {}
			local name = config.Name or "Color Picker"
			local default = config.Default or Color3.fromRGB(255, 255, 255)
			local callback = config.Callback or function() end

			local ColorFrame = Instance.new("Frame")
			ColorFrame.Size = UDim2.new(1, 0, 0, 35)
			ColorFrame.BackgroundColor3 = Colors.Secondary
			ColorFrame.BorderSizePixel = 0
			ColorFrame.Parent = TabContent

			local ColorCorner = Instance.new("UICorner")
			ColorCorner.CornerRadius = UDim.new(0, 4)
			ColorCorner.Parent = ColorFrame

			local ColorLabel = Instance.new("TextLabel")
			ColorLabel.Size = UDim2.new(0.6, 0, 1, 0)
			ColorLabel.Position = UDim2.new(0, 10, 0, 0)
			ColorLabel.BackgroundTransparency = 1
			ColorLabel.Text = name
			ColorLabel.TextColor3 = Colors.Text
			ColorLabel.Font = Enum.Font.Gotham
			ColorLabel.TextSize = 13
			ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
			ColorLabel.Parent = ColorFrame

			local ColorDisplay = Instance.new("Frame")
			ColorDisplay.Size = UDim2.new(0, 50, 0, 20)
			ColorDisplay.Position = UDim2.new(1, -60, 0.5, -10)
			ColorDisplay.BackgroundColor3 = default
			ColorDisplay.BorderSizePixel = 0
			ColorDisplay.Parent = ColorFrame

			local ColorDisplayCorner = Instance.new("UICorner")
			ColorDisplayCorner.CornerRadius = UDim.new(0, 4)
			ColorDisplayCorner.Parent = ColorDisplay

			local ColorButton = Instance.new("TextButton")
			ColorButton.Size = UDim2.new(1, 0, 1, 0)
			ColorButton.BackgroundTransparency = 1
			ColorButton.Text = ""
			ColorButton.Parent = ColorDisplay

			-- Color Picker Window
			local ColorPicker = Instance.new("Frame")
			ColorPicker.Size = UDim2.new(0, 200, 0, 250)
			ColorPicker.Position = UDim2.new(0, ColorFrame.AbsolutePosition.X + ColorFrame.AbsoluteSize.X - 200, 0, 40)
			ColorPicker.BackgroundColor3 = Colors.Secondary
			ColorPicker.BorderSizePixel = 0
			ColorPicker.Visible = false
			ColorPicker.ZIndex = 20
			ColorPicker.Parent = ColorFrame

			local PickerCorner = Instance.new("UICorner")
			PickerCorner.CornerRadius = UDim.new(0, 6)
			PickerCorner.Parent = ColorPicker

			-- Hue/Saturation Picker
			local HSVPicker = Instance.new("ImageLabel")
			HSVPicker.Size = UDim2.new(0, 180, 0, 180)
			HSVPicker.Position = UDim2.new(0, 10, 0, 10)
			HSVPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HSVPicker.BorderSizePixel = 0
			HSVPicker.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
			HSVPicker.Parent = ColorPicker

			-- Value Slider
			local ValueSlider = Instance.new("Frame")
			ValueSlider.Size = UDim2.new(0, 180, 0, 10)
			ValueSlider.Position = UDim2.new(0, 10, 0, 200)
			ValueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ValueSlider.BorderSizePixel = 0
			ValueSlider.Parent = ColorPicker

			local ValueGradient = Instance.new("UIGradient")
			ValueGradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
			}
			ValueGradient.Rotation = 0
			ValueGradient.Parent = ValueSlider

			-- Hex Input
			local HexInput = Instance.new("TextBox")
			HexInput.Size = UDim2.new(0, 180, 0, 25)
			HexInput.Position = UDim2.new(0, 10, 0, 215)
			HexInput.BackgroundColor3 = Colors.Background
			HexInput.Text = "#FFFFFF"
			HexInput.TextColor3 = Colors.Text
			HexInput.Font = Enum.Font.Gotham
			HexInput.TextSize = 12
			HexInput.BorderSizePixel = 0
			HexInput.Parent = ColorPicker

			local HexCorner = Instance.new("UICorner")
			HexCorner.CornerRadius = UDim.new(0, 4)
			HexCorner.Parent = HexInput

			local expanded = false

			ColorButton.MouseButton1Click:Connect(function()
				expanded = not expanded
				ColorPicker.Visible = expanded
			end)

			local function UpdateColor(color)
				ColorDisplay.BackgroundColor3 = color
				local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
				HexInput.Text = string.format("#%02X%02X%02X", r, g, b)
				callback(color)
			end

			UpdateColor(default)

			return {
				SetColor = function(self, color)
					UpdateColor(color)
				end
			}
		end

		function Tab:CreateKeybind(config)
			config = config or {}
			local name = config.Name or "Keybind"
			local default = config.Default or Enum.KeyCode.E
			local callback = config.Callback or function() end

			local KeybindFrame = Instance.new("Frame")
			KeybindFrame.Size = UDim2.new(1, 0, 0, 35)
			KeybindFrame.BackgroundColor3 = Colors.Secondary
			KeybindFrame.BorderSizePixel = 0
			KeybindFrame.Parent = TabContent

			local KeybindCorner = Instance.new("UICorner")
			KeybindCorner.CornerRadius = UDim.new(0, 4)
			KeybindCorner.Parent = KeybindFrame

			local KeybindLabel = Instance.new("TextLabel")
			KeybindLabel.Size = UDim2.new(0.6, 0, 1, 0)
			KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
			KeybindLabel.BackgroundTransparency = 1
			KeybindLabel.Text = name
			KeybindLabel.TextColor3 = Colors.Text
			KeybindLabel.Font = Enum.Font.Gotham
			KeybindLabel.TextSize = 13
			KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
			KeybindLabel.Parent = KeybindFrame

			local KeybindButton = Instance.new("TextButton")
			KeybindButton.Size = UDim2.new(0, 80, 0, 25)
			KeybindButton.Position = UDim2.new(1, -90, 0.5, -12)
			KeybindButton.BackgroundColor3 = Colors.Background
			KeybindButton.Text = default.Name
			KeybindButton.TextColor3 = Colors.Text
			KeybindButton.Font = Enum.Font.Gotham
			KeybindButton.TextSize = 12
			KeybindButton.BorderSizePixel = 0
			KeybindButton.Parent = KeybindFrame

			local KeybindButtonCorner = Instance.new("UICorner")
			KeybindButtonCorner.CornerRadius = UDim.new(0, 4)
			KeybindButtonCorner.Parent = KeybindButton

			local binding = false
			local currentKey = default

			KeybindButton.MouseButton1Click:Connect(function()
				binding = true
				KeybindButton.Text = "..."
				KeybindButton.TextColor3 = Colors.Accent
			end)

			UserInputService.InputBegan:Connect(function(input, processed)
				if binding and not processed then
					if input.KeyCode ~= Enum.KeyCode.Unknown then
						binding = false
						currentKey = input.KeyCode
						KeybindButton.Text = currentKey.Name
						KeybindButton.TextColor3 = Colors.Text
					end
				elseif input.KeyCode == currentKey and not processed then
					callback()
				end
			end)

			return {
				SetKey = function(self, key)
					currentKey = key
					KeybindButton.Text = key.Name
				end
			}
		end

		function Tab:CreateTextbox(config)
			config = config or {}
			local name = config.Name or "Textbox"
			local placeholder = config.Placeholder or "Enter text..."
			local default = config.Default or ""
			local callback = config.Callback or function() end

			local TextboxFrame = Instance.new("Frame")
			TextboxFrame.Size = UDim2.new(1, 0, 0, 35)
			TextboxFrame.BackgroundColor3 = Colors.Secondary
			TextboxFrame.BorderSizePixel = 0
			TextboxFrame.Parent = TabContent

			local TextboxCorner = Instance.new("UICorner")
			TextboxCorner.CornerRadius = UDim.new(0, 4)
			TextboxCorner.Parent = TextboxFrame

			local TextboxLabel = Instance.new("TextLabel")
			TextboxLabel.Size = UDim2.new(0.35, 0, 1, 0)
			TextboxLabel.Position = UDim2.new(0, 10, 0, 0)
			TextboxLabel.BackgroundTransparency = 1
			TextboxLabel.Text = name
			TextboxLabel.TextColor3 = Colors.Text
			TextboxLabel.Font = Enum.Font.Gotham
			TextboxLabel.TextSize = 13
			TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextboxLabel.Parent = TextboxFrame

			local Textbox = Instance.new("TextBox")
			Textbox.Size = UDim2.new(0.55, 0, 0, 25)
			Textbox.Position = UDim2.new(0.4, 0, 0.5, -12)
			Textbox.BackgroundColor3 = Colors.Background
			Textbox.Text = default
			Textbox.PlaceholderText = placeholder
			Textbox.PlaceholderColor3 = Colors.TextDim
			Textbox.TextColor3 = Colors.Text
			Textbox.Font = Enum.Font.Gotham
			Textbox.TextSize = 12
			Textbox.BorderSizePixel = 0
			Textbox.ClearTextOnFocus = false
			Textbox.Parent = TextboxFrame

			local TextboxBoxCorner = Instance.new("UICorner")
			TextboxBoxCorner.CornerRadius = UDim.new(0, 4)
			TextboxBoxCorner.Parent = Textbox

			Textbox.FocusLost:Connect(function()
				callback(Textbox.Text)
			end)

			return {
				SetText = function(self, text)
					Textbox.Text = text
				end
			}
		end

		table.insert(Window.Tabs, Tab)
		return Tab
	end

	-- Update sidebar size
	SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y)
	end)

	return Window
end

return UILibrary
