--local keo = Page:Slider("text",100,500,100,function(t) --Thanh kéo
do  local ui =  game:GetService("CoreGui"):FindFirstChild("Ui Native Hub")  if ui then ui:Destroy() end end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()



local function Tween(instance, properties,style,wa)
	if style == nil or "" then
		return Back
	end
	tween:Create(instance,TweenInfo.new(wa,Enum.EasingStyle[style]),{properties}):Play()
end

local ActualTypes = {
	RoundFrame = "ImageLabel",
	Shadow = "ImageLabel",
	Circle = "ImageLabel",
	CircleButton = "ImageButton",
	Frame = "Frame",
	Label = "TextLabel",
	Button = "TextButton",
	SmoothButton = "ImageButton",
	Box = "TextBox",
	ScrollingFrame = "ScrollingFrame",
	Menu = "ImageButton",
	NavBar = "ImageButton"
}

local Properties = {
	RoundFrame = {
		BackgroundTransparency = 1,
		Image = "http://www.roblox.com/asset/?id=5554237731",
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(3,3,297,297)
	},
	SmoothButton = {
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Image = "http://www.roblox.com/asset/?id=5554237731",
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(3,3,297,297)
	},
	Shadow = {
		Name = "Shadow",
		BackgroundTransparency = 1,
		Image = "http://www.roblox.com/asset/?id=5554236805",
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(23,23,277,277),
		Size = UDim2.fromScale(1,1) + UDim2.fromOffset(30,30),
		Position = UDim2.fromOffset(-15,-15)
	},
	Circle = {
		BackgroundTransparency = 1,
		Image = "http://www.roblox.com/asset/?id=5554831670"
	},
	CircleButton = {
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Image = "http://www.roblox.com/asset/?id=5554831670"
	},
	Frame = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1,1)
	},
	Label = {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(5,0),
		Size = UDim2.fromScale(1,1) - UDim2.fromOffset(5,0),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	},
	Button = {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(5,0),
		Size = UDim2.fromScale(1,1) - UDim2.fromOffset(5,0),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	},
	Box = {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(5,0),
		Size = UDim2.fromScale(1,1) - UDim2.fromOffset(5,0),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	},
	ScrollingFrame = {
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.fromScale(0,0),
		Size = UDim2.fromScale(1,1)
	},
	Menu = {
		Name = "More",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Image = "http://www.roblox.com/asset/?id=5555108481",
		Size = UDim2.fromOffset(20,20),
		Position = UDim2.fromScale(1,0.5) - UDim2.fromOffset(25,10)
	},
	NavBar = {
		Name = "SheetToggle",
		Image = "http://www.roblox.com/asset/?id=5576439039",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(20,20),
		Position = UDim2.fromOffset(5,5),
		AutoButtonColor = false
	}
}

local Types = {
	"RoundFrame",
	"Shadow",
	"Circle",
	"CircleButton",
	"Frame",
	"Label",
	"Button",
	"SmoothButton",
	"Box",
	"ScrollingFrame",
	"Menu",
	"NavBar"
}

function FindType(String)
	for _, Type in next, Types do
		if Type:sub(1, #String):lower() == String:lower() then
			return Type
		end
	end
	return false
end

local Objects = {}

function Objects.new(Type)
	local TargetType = FindType(Type)
	if TargetType then
		local NewImage = Instance.new(ActualTypes[TargetType])
		if Properties[TargetType] then
			for Property, Value in next, Properties[TargetType] do
				NewImage[Property] = Value
			end
		end
		return NewImage
	else
		return Instance.new(Type)
	end
end

local function GetXY(GuiObject)
	local Max, May = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
	local Px, Py = math.clamp(Mouse.X - GuiObject.AbsolutePosition.X, 0, Max), math.clamp(Mouse.Y - GuiObject.AbsolutePosition.Y, 0, May)
	return Px/Max, Py/May
end

local function CircleAnim(GuiObject, EndColour, StartColour)
	local PX, PY = GetXY(GuiObject)
	local Circle = Objects.new("Circle")
	Circle.Size = UDim2.fromScale(0,0)
	Circle.Position = UDim2.fromScale(PX,PY)
	Circle.ImageColor3 = StartColour or GuiObject.ImageColor3
	Circle.ZIndex = 200
	Circle.Parent = GuiObject
	local Size = GuiObject.AbsoluteSize.X
	TweenService:Create(Circle, TweenInfo.new(0.4), {Position = UDim2.fromScale(PX,PY) - UDim2.fromOffset(Size/2,Size/2), ImageTransparency = 1, ImageColor3 = EndColour, Size = UDim2.fromOffset(Size,Size)}):Play()
	spawn(function()
		wait(0.4)
		Circle:Destroy()
	end)
end


local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil	
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos =
            UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
        local Tween = TweenService:Create(object, TweenInfo.new(0.2), {Position = pos})
        Tween:Play()
    end

    topbarobject.InputBegan:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = input.Position
                StartPosition = object.Position

                input.Changed:Connect(
                    function()
                        if input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                        end
                    end
                )
            end
        end
    )

    topbarobject.InputChanged:Connect(
        function(input)
            if
                input.UserInputType == Enum.UserInputType.MouseMovement or
                input.UserInputType == Enum.UserInputType.Touch
            then
                DragInput = input
            end
        end
    )

    UserInputService.InputChanged:Connect(
        function(input)
            if input == DragInput and Dragging then
                Update(input)
            end
        end
    )
end


local Lib = {}

function Lib:Window(text,img)
    local UiNativeHub = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local UICornerMain = Instance.new("UICorner")
    local Top = Instance.new("Frame")
    local UICornerTop = Instance.new("UICorner")
    local logo = Instance.new("ImageLabel")
    local Tab = Instance.new("Frame")
    local ScrollingTab = Instance.new("ScrollingFrame")
    local TabList = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")
    local NameReal = Instance.new("TextLabel")
    local ImageTab = Instance.new("ImageLabel")
    local MainPage = Instance.new("Frame")
    local UICornerPage = Instance.new("UICorner")
    local PageFolder = Instance.new("Folder")
    local UIPageLayout = Instance.new("UIPageLayout")
    local Tabtoggle = false
    local abc = false

    UiNativeHub.Name = "Ui Native Hub"
    UiNativeHub.Parent = game.CoreGui
    UiNativeHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    Main.Name = "Main"
    Main.Parent = UiNativeHub
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Position = UDim2.new(0.240740746, 0, 0.286585361, 0)
    Main.Size = UDim2.new(0, 0, 0, 0)

    pcall(Main:TweenSize(UDim2.new(0, 700, 0, 380),"Out","Back",0.4,true))

    UICornerMain.CornerRadius = UDim.new(0, 4)
    UICornerMain.Name = "UICornerMain"
    UICornerMain.Parent = Main
    
    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Top.BorderSizePixel = 0
    Top.Size = UDim2.new(0, 700, 0, 38)
    
    UICornerTop.CornerRadius = UDim.new(0, 4)
    UICornerTop.Name = "UICornerTop"
    UICornerTop.Parent = Top
    
    logo.Name = "logo"
    logo.Parent = Top
    logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    logo.BackgroundTransparency = 1.000
    logo.Position = UDim2.new(0.0157142859, 0, 0, 0)
    logo.Size = UDim2.new(0, 43, 0, 38)
    logo.Image = img
    
    NameReal.Name = "NameReal"
    NameReal.Parent = Top
    NameReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NameReal.BackgroundTransparency = 1.000
    NameReal.Position = UDim2.new(0.0900000036, 0, 0, 0)
    NameReal.Size = UDim2.new(0, 170, 0, 38)
    NameReal.Font = Enum.Font.GothamBold
    NameReal.Text = text
    NameReal.TextColor3 = Color3.fromRGB(255,255,255)
    NameReal.TextSize = 16.000
    NameReal.TextXAlignment = Enum.TextXAlignment.Left
    
    ImageTab.Name = "ImageTab"
    ImageTab.Parent = Top
    ImageTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageTab.BackgroundTransparency = 1.000
    ImageTab.Position = UDim2.new(0.940000057, 0, 0.105263151, 0)
    ImageTab.Size = UDim2.new(0, 30, 0, 30)
    ImageTab.Image = "http://www.roblox.com/asset/?id=11271966220"
    
    local TabButtonnnn = Instance.new("TextButton")
    TabButtonnnn.Parent = ImageTab
    TabButtonnnn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabButtonnnn.BackgroundTransparency = 1.000
    TabButtonnnn.Size = UDim2.new(0, 30, 0, 30)
    TabButtonnnn.Font = Enum.Font.SourceSans
    TabButtonnnn.Text = ""
    TabButtonnnn.TextColor3 = Color3.fromRGB(0, 0, 0)
    TabButtonnnn.TextSize = 14.000
    
    Tab.Name = "Tab"
    Tab.Parent = Main
    Tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Tab.BorderSizePixel = 0
    Tab.ClipsDescendants = true
    Tab.Position = UDim2.new(0, 0, 0.100000001, 0)
    Tab.Size = UDim2.new(0, 0, 0, 342)
    Tab.ZIndex = 2

    ScrollingTab.Name = "ScrollingTab"
    ScrollingTab.Parent = Tab
    ScrollingTab.Active = true
    ScrollingTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScrollingTab.BackgroundTransparency = 1.000
    ScrollingTab.BorderSizePixel = 0
    ScrollingTab.Size = UDim2.new(0, 247, 0, 342)
    ScrollingTab.ScrollBarThickness = 4
    ScrollingTab.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingTab.ClipsDescendants = true

    TabList.Name = "TabList"
    TabList.Parent = ScrollingTab
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 3)



    UIPadding.Parent = ScrollingTab
    UIPadding.PaddingTop = UDim.new(0, 5)
    
    MainPage.Name = "MainPage"
    MainPage.Parent = Main
    MainPage.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainPage.BorderSizePixel = 0
    MainPage.Position = UDim2.new(0.0157142859, 0, 0.126315787, 0)
    MainPage.Size = UDim2.new(0, 677, 0, 318)
    MainPage.ClipsDescendants = true
    
    UICornerPage.CornerRadius = UDim.new(0, 4)
    UICornerPage.Name = "UICornerPage"
    UICornerPage.Parent = MainPage
    
    PageFolder.Name = "PageFolder"
    PageFolder.Parent = MainPage
    
    UIPageLayout.Parent = PageFolder
    UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIPageLayout.EasingDirection = Enum.EasingDirection.InOut
    UIPageLayout.EasingStyle = Enum.EasingStyle.Quad
    UIPageLayout.GamepadInputEnabled = false
    UIPageLayout.ScrollWheelInputEnabled = false
    UIPageLayout.TouchInputEnabled = false
    UIPageLayout.TweenTime = 0.300



    local Black = Instance.new("Frame")
    Black.Name = "Black"
    Black.Parent = Main
    Black.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Black.BackgroundTransparency = .3
    Black.BorderSizePixel = 0
    Black.Position = UDim2.new(0, 0, 0.086585361, 0)
    Black.Size = UDim2.new(0, 0, 0, 342)
    
    
    UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.RightControl then
			if uihide == false then
				uihide = true
                pcall(Main:TweenSize(UDim2.new(0, 0, 0, 0),"In","Quad",0.4,true))
			else
				uihide = false
				pcall(Main:TweenSize(UDim2.new(0, 700, 0, 380),"Out","Back",0.4,true))
			end
		end
	end)
    
    TabButtonnnn.MouseButton1Click:Connect(function()
        if Tabtoggle == false then
            Tabtoggle = true
            TweenService:Create(
                Tab,
                TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 247, 0, 342)}
            ):Play()
            TweenService:Create(
                Black,
                TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 700, 0, 342)}
            ):Play()
            TweenService:Create(
                ImageTab,
                TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                {ImageColor3 = Color3.fromRGB(32,143,252)}
            ):Play()
        else
            Tabtoggle = false
            TweenService:Create(
                Tab,
                TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 0, 0, 342)}
            ):Play()
            TweenService:Create(
                Black,
                TweenInfo.new(0,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 0, 0, 342)}
            ):Play()
            TweenService:Create(
                ImageTab,
                TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                {ImageColor3 = Color3.fromRGB(255, 255, 255)}
            ):Play()
        end
    end)

    local Ui = {}

    function Ui:Tab(text)
        local TabFrame = Instance.new("Frame")
        local Tabb = Instance.new("Frame")
        local UICornerTabb = Instance.new("UICorner")
        local UIGradientTabb = Instance.new("UIGradient")
        local TextTab = Instance.new("TextLabel")
        local TextButton = Instance.new("TextButton")
        local MainFramePage = Instance.new("Frame")
        local UICornerMainFramePage = Instance.new("UICorner")

        TabFrame.Name = "TabFrame"
        TabFrame.Parent = ScrollingTab
        TabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabFrame.BackgroundTransparency = 1.000
        TabFrame.Size = UDim2.new(0, 247, 0, 40)
        
        Tabb.Name = "Tabb"
        Tabb.Parent = TabFrame
        Tabb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Tabb.ClipsDescendants = true
        Tabb.Position = UDim2.new(0.0445344113, 0, 0.125, 0)
        Tabb.Size = UDim2.new(0, 222, 0, 30)
        
        UICornerTabb.CornerRadius = UDim.new(0, 4)
        UICornerTabb.Name = "UICornerTabb"
        UICornerTabb.Parent = Tabb
        
        UIGradientTabb.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(32,143,252)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(160, 212, 255))}
        UIGradientTabb.Name = "UIGradientTabb"
        UIGradientTabb.Parent = Tabb
        
        TextTab.Name = "TextTab"
        TextTab.Parent = Tabb
        TextTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextTab.BackgroundTransparency = 1.000
        TextTab.Size = UDim2.new(0, 222, 0, 30)
        TextTab.Font = Enum.Font.GothamBold
        TextTab.Text = text
        TextTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextTab.TextSize = 15.000
        
        TextButton.Parent = TabFrame
        TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextButton.BackgroundTransparency = 1.000
        TextButton.Size = UDim2.new(0, 247, 0, 40)
        TextButton.Font = Enum.Font.SourceSans
        TextButton.Text = ""
        TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        TextButton.TextSize = 14.000
        
        MainFramePage.Name = "MainFramePage"
        MainFramePage.Parent = PageFolder
        MainFramePage.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        MainFramePage.BorderSizePixel = 0
        MainFramePage.Position = UDim2.new(0.0925237387, 0, 0.132605091, 0)
        MainFramePage.Size = UDim2.new(0, 677, 0, 318)
        MainFramePage.ClipsDescendants = true
        
        UICornerMainFramePage.CornerRadius = UDim.new(0, 4)
        UICornerMainFramePage.Name = "UICornerMainFramePage"
        UICornerMainFramePage.Parent = MainFramePage

        local ScrollMainPage = Instance.new("ScrollingFrame")
        local UIListLayoutPage = Instance.new("UIListLayout")
        
        ScrollMainPage.Name = "ScrollMainPage"
        ScrollMainPage.Parent = MainFramePage
        ScrollMainPage.Active = true
        ScrollMainPage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ScrollMainPage.BackgroundTransparency = 1.000
        ScrollMainPage.BorderSizePixel = 0
        ScrollMainPage.Size = UDim2.new(0, 677, 0, 318)
        ScrollMainPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        ScrollMainPage.ScrollBarThickness = 0
        
        UIListLayoutPage.Name = "UIListLayoutPage"
        UIListLayoutPage.Parent = ScrollMainPage
        UIListLayoutPage.FillDirection = Enum.FillDirection.Horizontal
        UIListLayoutPage.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayoutPage.Padding = UDim.new(0, 7)

        local UIPaddingPage = Instance.new("UIPadding")
        
        UIPaddingPage.Name = "UIPaddingPage"
        UIPaddingPage.Parent = ScrollMainPage
        UIPaddingPage.PaddingLeft = UDim.new(0, 7)
        UIPaddingPage.PaddingTop = UDim.new(0, 12)

        MakeDraggable(Top,Main)


        TextButton.MouseButton1Click:Connect(function()
            CircleAnim(Tabb, Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))
            TextTab.TextSize = 0
            TweenService:Create(
                TextTab,
                TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                {TextSize = 15}
            ):Play()
            for i,v in next, PageFolder:GetChildren() do 
                if v.Name == "MainFramePage" then
                    currenttab = v.Name
                end
                UIPageLayout:JumpTo(MainFramePage)
                
            end
		end)

		if abc == false then
            UIPageLayout:JumpToIndex(1)
			abc = true
		end

        local Tab = {}

        function Tab:Page()

            local MainFramePage_2 = Instance.new("Frame")
            local UICornerMainFramePage_2 = Instance.new("UICorner")
            local ScrollingMainFramePage = Instance.new("ScrollingFrame")
            local UIListLayoutMainFramePage = Instance.new("UIListLayout")



            MainFramePage_2.Name = "MainFramePage"
            MainFramePage_2.Parent = ScrollMainPage
            MainFramePage_2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            MainFramePage_2.BorderSizePixel = 0
            MainFramePage_2.ClipsDescendants = true
            MainFramePage_2.Position = UDim2.new(-0.010447761, 0, -0.00326797389, 0)
            MainFramePage_2.Size = UDim2.new(0, 328, 0, 296)

            UICornerMainFramePage_2.CornerRadius = UDim.new(0, 4)
            UICornerMainFramePage_2.Name = "UICornerMainFramePage"
            UICornerMainFramePage_2.Parent = MainFramePage_2

            ScrollingMainFramePage.Name = "ScrollingMainFramePage"
            ScrollingMainFramePage.Parent = MainFramePage_2
            ScrollingMainFramePage.Active = true
            ScrollingMainFramePage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ScrollingMainFramePage.BackgroundTransparency = 1.000
            ScrollingMainFramePage.BorderSizePixel = 0
            ScrollingMainFramePage.Size = UDim2.new(0, 328, 0, 296)
            ScrollingMainFramePage.CanvasSize = UDim2.new(0, 0, 0, 0)
            ScrollingMainFramePage.ScrollBarThickness = 0

            UIListLayoutMainFramePage.Name = "UIListLayoutMainFramePage"
            UIListLayoutMainFramePage.Parent = ScrollingMainFramePage
            UIListLayoutMainFramePage.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayoutMainFramePage.Padding = UDim.new(0, 8)


            local UIPaddingMainFramePage = Instance.new("UIPadding")

            UIPaddingMainFramePage.Name = "UIPaddingMainFramePage"
            UIPaddingMainFramePage.Parent = ScrollingMainFramePage
            UIPaddingMainFramePage.PaddingTop = UDim.new(0, 9)
            
            
            game:GetService("RunService").Stepped:Connect(function()
                pcall(function()
                    ScrollingMainFramePage.CanvasSize = UDim2.new(0,0,0,UIListLayoutMainFramePage.AbsoluteContentSize.Y + 26)
                    ScrollingTab.CanvasSize = UDim2.new(0,0,0,TabList.AbsoluteContentSize.Y + 10)
                end)
            end)

            local main = {}
            function main:Toggle2(text,default,callback)
                local ToggleFrame2 = Instance.new("Frame")
                local TextToggle2 = Instance.new("TextLabel")
                local Toggle_2 = Instance.new("Frame")
                local UICornerToggle2 = Instance.new("UICorner")
                local Tgle2 = Instance.new("ImageLabel")
                local ButtonTgle2 = Instance.new("TextButton")
                local toggle2 = false
                local lock2 = false

                ToggleFrame2.Name = "ToggleFrame2"
                ToggleFrame2.Parent = ScrollingMainFramePage
                ToggleFrame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleFrame2.BackgroundTransparency = 1.000
                ToggleFrame2.ClipsDescendants = true
                ToggleFrame2.Size = UDim2.new(0, 328, 0, 32)

                TextToggle2.Name = "TextToggle2"
                TextToggle2.Parent = ToggleFrame2
                TextToggle2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextToggle2.BackgroundTransparency = 1.000
                TextToggle2.Position = UDim2.new(0.23780489, 0, 0, 0)
                TextToggle2.Size = UDim2.new(0, 192, 0, 32)
                TextToggle2.Font = Enum.Font.GothamBold
                TextToggle2.Text = "Auto Farm Level"
                TextToggle2.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextToggle2.TextSize = 14.000
                TextToggle2.TextXAlignment = Enum.TextXAlignment.Left

                Toggle_2.Name = "Toggle"
                Toggle_2.Parent = ToggleFrame2
                Toggle_2.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
                Toggle_2.BorderSizePixel = 0
                Toggle_2.Position = UDim2.new(0.103658535, 0, 0.0625, 0)
                Toggle_2.Size = UDim2.new(0, 28, 0, 28)

                UICornerToggle2.CornerRadius = UDim.new(0, 4)
                UICornerToggle2.Name = "UICornerToggle2"
                UICornerToggle2.Parent = Toggle_2

                Tgle2.Name = "Tgle2"
                Tgle2.Parent = Toggle_2
                Tgle2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Tgle2.BackgroundTransparency = 1.000
                Tgle2.Position = UDim2.new(0.0357142873, 0, 0.0357142873, 0)
                Tgle2.Size = UDim2.new(0, 26, 0, 26)
                Tgle2.Image = "rbxassetid://6031068421"
                Tgle2.ImageColor3 = Color3.fromRGB(32,143,252)

                ButtonTgle2.Name = "ButtonTgle2"
                ButtonTgle2.Parent = ToggleFrame2
                ButtonTgle2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ButtonTgle2.BackgroundTransparency = 1.000
                ButtonTgle2.Size = UDim2.new(0, 328, 0, 32)
                ButtonTgle2.Font = Enum.Font.SourceSans
                ButtonTgle2.Text = ""
                ButtonTgle2.TextColor3 = Color3.fromRGB(0, 0, 0)
                ButtonTgle2.TextSize = 14.000

                
                if default == false then
                    toggle_lol = false
                    TweenService:Create(
                        Tgle2,
                        TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                        {ImageTransparency = 1}
                    ):Play()
                    callback(toggle_lol)
                end
                if default == true then
                    toggle_lol = true
                    TweenService:Create(
                        Tgle2,
                        TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                        {ImageTransparency = 0}
                    ):Play()
                    callback(toggle_lol)
                end
                ButtonTgle2.MouseButton1Click:Connect(function()
                    if Tabtoggle == false then
                        if toggle_lol == false and lock2 == false then
                            toggle_lol = true
                            TweenService:Create(
                                Tgle2,
                                TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                                {ImageTransparency = 0}
                            ):Play()
                            callback(toggle_lol)
                        elseif toggle_lol == true and lock2 == false then
                            toggle_lol = false
                            TweenService:Create(
                                Tgle2,
                                TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                                {ImageTransparency = 1}
                            ):Play()
                            callback(toggle_lol)
                        end
                    end
                end
                )
            end

            function main:Button(text,callback)
                local FrameButton = Instance.new("Frame")
                local Btn = Instance.new("Frame")
                local UICornerBtn = Instance.new("UICorner")
                local UIGradientBtn = Instance.new("UIGradient")
                
                local TextLabelBtn = Instance.new("TextLabel")
                local ButtonBtn = Instance.new("TextButton")

                FrameButton.Name = "FrameButton"
                FrameButton.Parent = ScrollingMainFramePage
                FrameButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                FrameButton.BackgroundTransparency = 1.000
                FrameButton.Size = UDim2.new(0, 328, 0, 32)
                
                Btn.Name = "Btn"
                Btn.Parent = FrameButton
                Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Btn.BorderSizePixel = 0
                Btn.Position = UDim2.new(0.0487804897, 0, 0.03125, 0)
                Btn.Size = UDim2.new(0, 296, 0, 30)
                Btn.ClipsDescendants = true

                UICornerBtn.CornerRadius = UDim.new(0, 4)
                UICornerBtn.Name = "UICornerBtn"
                UICornerBtn.Parent = Btn
                



                UIGradientBtn.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(32,143,252)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(101, 185, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(32,143,252))}
                UIGradientBtn.Name = "UIGradientBtn"
                UIGradientBtn.Parent = Btn
                
                TextLabelBtn.Name = "TextLabelBtn"
                TextLabelBtn.Parent = Btn
                TextLabelBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextLabelBtn.BackgroundTransparency = 1.000
                TextLabelBtn.Size = UDim2.new(0, 296, 0, 30)
                TextLabelBtn.Font = Enum.Font.GothamBold
                TextLabelBtn.Text = text
                TextLabelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabelBtn.TextSize = 14.000
                
                ButtonBtn.Name = "ButtonBtn"
                ButtonBtn.Parent = FrameButton
                ButtonBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ButtonBtn.BackgroundTransparency = 1.000
                ButtonBtn.Size = UDim2.new(0, 328, 0, 31)
                ButtonBtn.Font = Enum.Font.SourceSans
                ButtonBtn.Text = ""
                ButtonBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                ButtonBtn.TextSize = 14.000
                
                ButtonBtn.MouseButton1Click:Connect(function()
                    if Tabtoggle == false then
                        CircleAnim(Btn, Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))
                        TextLabelBtn.TextSize = 0
                        TweenService:Create(
                            TextLabelBtn,
                            TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                            {TextSize = 14}
                        ):Play()
                        callback()
                    end
                end)
            end
            function main:Line()
                local LineFrame = Instance.new("Frame")
				local Line = Instance.new("Frame")
				local LineUIGradient = Instance.new("UIGradient")

				LineFrame.Name = "LineFrame"
				LineFrame.Parent = ScrollingMainFramePage
				LineFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				LineFrame.BackgroundTransparency = 1.000
				LineFrame.Size = UDim2.new(0, 328, 0, 21)

				Line.Name = "LineMain"
				Line.Parent = LineFrame
				Line.AnchorPoint = Vector2.new(0.5, 0.5)
				Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Line.BorderSizePixel = 0
				Line.Position = UDim2.new(0.5, 0, 0.428571433, 0)
				Line.Size = UDim2.new(0, 296, 0, 2)

				LineUIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(15, 15, 15)), ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0,90,165)), ColorSequenceKeypoint.new(0.51, Color3.fromRGB(32,143,252)), ColorSequenceKeypoint.new(0.85, Color3.fromRGB(0,90,165)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(15, 15, 15))}
				LineUIGradient.Name = "LineUIGradient"
				LineUIGradient.Parent = Line
            end
            function main:Label(text)
                local LabelFrame = Instance.new("Frame")
                local textlabel = Instance.new("TextLabel")
                local labelfunc = {}


                LabelFrame.Name = "LabelFrame"
                LabelFrame.Parent = ScrollingMainFramePage
                LabelFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                LabelFrame.BackgroundTransparency = 1.000
                LabelFrame.ClipsDescendants = true
                LabelFrame.Size = UDim2.new(0, 328, 0, 32)

                textlabel.Name = "TextToggle"
                textlabel.Parent = LabelFrame
                textlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textlabel.BackgroundTransparency = 1.000
                textlabel.Position = UDim2.new(0.090, 0, 0, 0)
                textlabel.Size = UDim2.new(0, 192, 0, 32)
                textlabel.Font = Enum.Font.GothamBold
                textlabel.Text = text
                textlabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textlabel.TextSize = 14.000
                textlabel.TextXAlignment = Enum.TextXAlignment.Left

                function labelfunc:Refresh(newtext)
                    textlabel.Text = newtext
                end

                return labelfunc
            end
            function main:Toggle(text,default,callback)
                local ToggleFrame = Instance.new("Frame")
                local TextToggle = Instance.new("TextLabel")
                local Toggle = Instance.new("Frame")
                local UICornerToggle = Instance.new("UICorner")
                local Tgle = Instance.new("Frame")
                local UICornerTgle = Instance.new("UICorner")
                local ButtonToggle = Instance.new("TextButton")
                default = default or false
                local toggle = default
                local RetrunStatsToggle = {}
                local lock = false

                ToggleFrame.Name = "ToggleFrame"
                ToggleFrame.Parent = ScrollingMainFramePage
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleFrame.BackgroundTransparency = 1.000
                ToggleFrame.ClipsDescendants = true
                ToggleFrame.Size = UDim2.new(0, 328, 0, 32)

                TextToggle.Name = "TextToggle"
                TextToggle.Parent = ToggleFrame
                TextToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextToggle.BackgroundTransparency = 1.000
                TextToggle.Position = UDim2.new(0.104, 0, 0, 0)
                TextToggle.Size = UDim2.new(0, 192, 0, 32)
                TextToggle.Font = Enum.Font.GothamBold
                TextToggle.Text = text
                TextToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextToggle.TextSize = 14.000
                TextToggle.TextXAlignment = Enum.TextXAlignment.Left

                Toggle.Name = "Toggle"
                Toggle.Parent = ToggleFrame
                Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Toggle.BorderSizePixel = 0
                Toggle.Position = UDim2.new(0.713414609, 0, 0.09375, 0)
                Toggle.Size = UDim2.new(0, 56, 0, 25)

                UICornerToggle.CornerRadius = UDim.new(0, 9999)
                UICornerToggle.Name = "UICornerToggle"
                UICornerToggle.Parent = Toggle

                Tgle.Name = "Tgle"
                Tgle.Parent = Toggle
                Tgle.BackgroundColor3 = Color3.fromRGB(32,143,252)
                Tgle.Position = UDim2.new(0, 1, 0, 2)
                Tgle.Size = UDim2.new(0, 22, 0, 22)

                UICornerTgle.CornerRadius = UDim.new(0, 9999)
                UICornerTgle.Name = "UICornerTgle"
                UICornerTgle.Parent = Tgle

                ButtonToggle.Name = "ButtonToggle"
                ButtonToggle.Parent = ToggleFrame
                ButtonToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ButtonToggle.BackgroundTransparency = 1.000
                ButtonToggle.Size = UDim2.new(0, 328, 0, 32)
                ButtonToggle.Font = Enum.Font.SourceSans
                ButtonToggle.Text = ""
                ButtonToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
                ButtonToggle.TextSize = 14.000


                if default == false then
                    toggle = false
                    TweenService:Create(
                        Tgle,
                        TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                        {Position = UDim2.new(0, 1.5, 0, 2)}
                    ):Play()
                    wait()
                    TweenService:Create(
                        Tgle,
                        TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                        {Size = UDim2.new(0, 32, 0, 22)}
                    ):Play()
                    wait()
                    TweenService:Create(
                        Tgle,
                        TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                        {Size = UDim2.new(0, 22, 0, 22)}
                    ):Play()
                    wait()
                    TweenService:Create(
                        Tgle,
                        TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                        {Position = UDim2.new(0, 1, 0, 2)}
                    ):Play()
                    callback(toggle)
                end
                if default == true then
                    toggle = true
                    TweenService:Create(
                        Tgle,
                        TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                        {Size = UDim2.new(0, 32, 0, 22)}
                    ):Play()
                    wait()
                    TweenService:Create(
                        Tgle,
                        TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                        {Position = UDim2.new(0, 30, 0, 2)}
                    ):Play()
                    wait()
                    TweenService:Create(
                        Tgle,
                        TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                        {Size = UDim2.new(0, 22, 0, 22)}
                    ):Play()
                    wait()
                    TweenService:Create(
                        Tgle,
                        TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                        {Position = UDim2.new(0, 33, 0, 2)}
                    ):Play()
                    callback(toggle)
                end

                ButtonToggle.MouseButton1Click:Connect(function()
                    if Tabtoggle == false then
                        if toggle == false and lock == false then
                            toggle = true
                            TweenService:Create(
                                Tgle,
                                TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                                {Size = UDim2.new(0, 32, 0, 22)}
                            ):Play()
                            wait()
                            TweenService:Create(
                                Tgle,
                                TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                                {Position = UDim2.new(0, 30, 0, 2)}
                            ):Play()
                            wait()
                            TweenService:Create(
                                Tgle,
                                TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                                {Size = UDim2.new(0, 22, 0, 22)}
                            ):Play()
                            wait()
                            TweenService:Create(
                                Tgle,
                                TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                                {Position = UDim2.new(0, 33, 0, 2)}
                            ):Play()
                            callback(toggle)
                        elseif toggle == true and lock == false then
                            toggle = false
                            TweenService:Create(
                                Tgle,
                                TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                                {Position = UDim2.new(0, 1.5, 0, 2)}
                            ):Play()
                            wait()
                            TweenService:Create(
                                Tgle,
                                TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                                {Size = UDim2.new(0, 32, 0, 22)}
                            ):Play()
                            wait()
                            TweenService:Create(
                                Tgle,
                                TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                                {Size = UDim2.new(0, 22, 0, 22)}
                            ):Play()
                            wait()
                            TweenService:Create(
                                Tgle,
                                TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                                {Position = UDim2.new(0, 1, 0, 2)}
                            ):Play()
                            callback(toggle)
                        end
                    end
                end
                )

                local lockerframe = Instance.new("Frame")

                lockerframe.Name = "lockerframe"
                lockerframe.Parent = ToggleFrame
                lockerframe.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                lockerframe.BackgroundTransparency = 1
                lockerframe.BorderSizePixel = 0
                lockerframe.Size = UDim2.new(0, 300, 0, 32)
                lockerframe.Position = UDim2.new(0.5, 0, 0.5, 0)
                lockerframe.AnchorPoint = Vector2.new(0.5, 0.5)
    
                local LockerImageLabel = Instance.new("ImageLabel")
    
                LockerImageLabel.Parent = lockerframe
                LockerImageLabel.BackgroundTransparency = 1.000
                LockerImageLabel.BorderSizePixel = 0
                LockerImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                LockerImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                LockerImageLabel.Size = UDim2.new(0, 0, 0, 0)
                LockerImageLabel.Image = "http://www.roblox.com/asset/?id=3926305904"
                LockerImageLabel.ImageRectOffset = Vector2.new(404, 364)
                LockerImageLabel.ImageRectSize = Vector2.new(36, 36)
                LockerImageLabel.ImageColor3 = Color3.fromRGB(255,25,25)

                function RetrunStatsToggle:Lock()
                    TweenService:Create(
                        lockerframe,
                        TweenInfo.new(.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out,0.1),
                        {BackgroundTransparency = 0.7}
                    ):Play()
                    TweenService:Create(
                        LockerImageLabel,
                        TweenInfo.new(.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out,0.1),
                        {Size = UDim2.new(0, 30, 0, 30)}
                    ):Play()
                    lock = true
                end

                function RetrunStatsToggle:ChangeStateTrue()
                    if toggle == false and lock == false then
                        toggle = true
                        TweenService:Create(
                            Tgle,
                            TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                            {Size = UDim2.new(0, 32, 0, 22)}
                        ):Play()
                        wait()
                        TweenService:Create(
                            Tgle,
                            TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                            {Position = UDim2.new(0, 30, 0, 2)}
                        ):Play()
                        wait()
                        TweenService:Create(
                            Tgle,
                            TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                            {Size = UDim2.new(0, 22, 0, 22)}
                        ):Play()
                        wait()
                        TweenService:Create(
                            Tgle,
                            TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                            {Position = UDim2.new(0, 33, 0, 2)}
                        ):Play()
                        callback(toggle)
                    end
                end

                function RetrunStatsToggle:ChangeStateFalse()
                    if toggle == true and lock == false then
                        toggle = false
                        TweenService:Create(
                            Tgle,
                            TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                            {Position = UDim2.new(0, 1.5, 0, 2)}
                        ):Play()
                        wait()
                        TweenService:Create(
                            Tgle,
                            TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                            {Size = UDim2.new(0, 32, 0, 22)}
                        ):Play()
                        wait()
                        TweenService:Create(
                            Tgle,
                            TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                            {Size = UDim2.new(0, 22, 0, 22)}
                        ):Play()
                        wait()
                        TweenService:Create(
                            Tgle,
                            TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                            {Position = UDim2.new(0, 1, 0, 2)}
                        ):Play()
                        callback(toggle)
                    end
                end
                function RetrunStatsToggle:Unlock()
                    TweenService:Create(
                        lockerframe,
                        TweenInfo.new(.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out,0.1),
                        {BackgroundTransparency = 1}
                    ):Play()
                    TweenService:Create(
                        LockerImageLabel,
                        TweenInfo.new(.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out,0.1),
                        {Size = UDim2.new(0, 0, 0, 0)}
                    ):Play()
                    lock = false
                end
                return RetrunStatsToggle
            end
            function main:Slider(text,min,max,set,callback)
                local sliderfunc = {}
                local SliderFrame = Instance.new("Frame")
                local ClickHere = Instance.new("TextButton")
                local Bar = Instance.new("Frame")
                local UICornerBar = Instance.new("UICorner")
                local BarValue = Instance.new("Frame")
                local UICornerBarValue = Instance.new("UICorner")
                local TextSlider = Instance.new("TextLabel")

                
                SliderFrame.Name = "SliderFrame"
                SliderFrame.Parent = ScrollingMainFramePage
                SliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderFrame.BackgroundTransparency = 1.000
                SliderFrame.Position = UDim2.new(0, 0, 0.292682916, 0)
                SliderFrame.Size = UDim2.new(0, 328, 0, 56)

                ClickHere.Name = "ClickHere"
                ClickHere.Parent = SliderFrame
                ClickHere.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ClickHere.BackgroundTransparency = 1.000
                ClickHere.ClipsDescendants = true
                ClickHere.Position = UDim2.new(0.0853658542, 0, 0.642857134, 0)
                ClickHere.Size = UDim2.new(0, 271, 0, 5)
                ClickHere.Font = Enum.Font.SourceSans
                ClickHere.Text = ""
                ClickHere.TextColor3 = Color3.fromRGB(0, 0, 0)
                ClickHere.TextSize = 14.000

                Bar.Name = "Bar"
                Bar.Parent = ClickHere
                Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Bar.ClipsDescendants = true
                Bar.Size = UDim2.new(0, 271, 0, 5)

                UICornerBar.CornerRadius = UDim.new(0, 99)
                UICornerBar.Name = "UICornerBar"
                UICornerBar.Parent = Bar

                BarValue.Name = "BarValue"
                BarValue.Parent = ClickHere
                BarValue.BackgroundColor3 = Color3.fromRGB(32,143,252)
                BarValue.Size = UDim2.new((set or 0) / max, 0, 0, 5)

                UICornerBarValue.CornerRadius = UDim.new(0, 99)
                UICornerBarValue.Name = "UICornerBarValue"
                UICornerBarValue.Parent = BarValue

                TextSlider.Name = "TextSlider"
                TextSlider.Parent = SliderFrame
                TextSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextSlider.BackgroundTransparency = 1.000
                TextSlider.Position = UDim2.new(0.0792682916, 0, 0.196428567, 0)
                TextSlider.Size = UDim2.new(0, 200, 0, 21)
                TextSlider.Font = Enum.Font.GothamBold
                TextSlider.Text = text.." : "..tostring(set and math.floor( (set / max) * (max - min) + min) or 0)
                TextSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextSlider.TextSize = 14.000
                TextSlider.TextXAlignment = Enum.TextXAlignment.Left


                
                local mouse = game.Players.LocalPlayer:GetMouse()
                local uis = game:GetService("UserInputService")


                if Value == nil then
                    Value = set
                    pcall(function()
                        callback(Value)
                    end)
                end

                
                ClickHere.MouseButton1Down:Connect(function()
                    if Tabtoggle == false then
                        Value = math.floor((((tonumber(max) - tonumber(min)) / 271) * BarValue.AbsoluteSize.X) + tonumber(min)) or 0
                        TweenService:Create(
                            BarValue,
                            TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                            {Size = UDim2.new(0, math.clamp(mouse.X - BarValue.AbsolutePosition.X, 0, 271), 0, 5)}
                        ):Play()
                        moveconnection = mouse.Move:Connect(function()
                            TextSlider.Text = text.." : "..Value
                            Value = math.floor((((tonumber(max) - tonumber(min)) / 271) * BarValue.AbsoluteSize.X) + tonumber(min))
                            TweenService:Create(
                                BarValue,
                                TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                                {Size = UDim2.new(0, math.clamp(mouse.X - BarValue.AbsolutePosition.X, 0, 271), 0, 5)}
                            ):Play()
                        end)
                        releaseconnection = uis.InputEnded:Connect(function(Mouse)
                            if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
                                Value = math.floor((((tonumber(max) - tonumber(min)) / 271) * BarValue.AbsoluteSize.X) + tonumber(min))
                                pcall(function()
                                    callback(Value)
                                    TextSlider.Text = text.." : "..Value
                                end)
                                TweenService:Create(
                                    BarValue,
                                    TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                                    {Size = UDim2.new(0, math.clamp(mouse.X - BarValue.AbsolutePosition.X, 0, 271), 0, 5)}
                                ):Play()
                                moveconnection:Disconnect()
                                releaseconnection:Disconnect()
                            end
                        end)
                    end
                end)

                function sliderfunc:Update(value)
                    TextSlider.Text = text.." : "..value
                    BarValue:TweenSize(UDim2.new((value or 0) / max, 0, 0, 5), "Out", "Sine", 0.2, true)
                    pcall(function()
                        callback(value)
                    end)
                end
                return sliderfunc
            end  
            function main:Dropdown(text,option,set,callback)
                local DropFrame = Instance.new("Frame")
                local Text = Instance.new("TextLabel")
                local DropImage = Instance.new("ImageLabel")
                local DownFrame = Instance.new("Frame")
                local ScrollingDown = Instance.new("ScrollingFrame")
                local ItemList = Instance.new("UIListLayout")
                local Frame = Instance.new("Frame")
                local CornerFrae = Instance.new("UICorner")
                local ButtonDrop = Instance.new("TextButton")
                local DropToggle = false
                local RetrunDrop = {}

                DropFrame.Name = "DropFrame"
                DropFrame.Parent = ScrollingMainFramePage
                DropFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropFrame.BackgroundTransparency = 1.000
                DropFrame.Position = UDim2.new(0, 0, 0.522648096, 0)
                DropFrame.Size = UDim2.new(0, 328, 0, 35)
                
                Frame.Parent = DropFrame
                Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Frame.BorderSizePixel = 0
                Frame.Position = UDim2.new(0.0457317084, 0, 0.0285714287, 0)
                Frame.Size = UDim2.new(0, 296, 0, 32)
                Frame.ClipsDescendants = true

                DropImage.Name = "DropImage"
                DropImage.Parent = Frame
                DropImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropImage.BackgroundTransparency = 1.000
                DropImage.Position = UDim2.new(0.871374369, 0, -0.012, 0)
                DropImage.Rotation = 180.000
                DropImage.Size = UDim2.new(0, 32, 0, 32)
                DropImage.Image = "rbxassetid://6031094670"
                
                Text.Name = "Text"
                Text.Parent = Frame
                Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Text.BackgroundTransparency = 1.000
                Text.Position = UDim2.new(0.0354317725, 0, -0.012, 0)
                Text.Size = UDim2.new(0, 221, 0, 32)
                Text.Font = Enum.Font.GothamBold
                Text.Text = text.." : "..set
                Text.TextColor3 = Color3.fromRGB(255, 255, 255)
                Text.TextSize = 14.000
                Text.TextXAlignment = Enum.TextXAlignment.Left
                
                CornerFrae.CornerRadius = UDim.new(0, 4)
                CornerFrae.Name = "CornerFrae"
                CornerFrae.Parent = Frame

                ButtonDrop.Name = "ButtonToggle"
                ButtonDrop.Parent = DropFrame
                ButtonDrop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ButtonDrop.BackgroundTransparency = 1.000
                ButtonDrop.Size = UDim2.new(0, 328, 0, 40)
                ButtonDrop.Font = Enum.Font.SourceSans
                ButtonDrop.Text = ""
                ButtonDrop.TextColor3 = Color3.fromRGB(0, 0, 0)
                ButtonDrop.TextSize = 14.000


                DownFrame.Name = "DownFrame"
                DownFrame.Parent = ScrollingMainFramePage
                DownFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DownFrame.BackgroundTransparency = 1.000
                DownFrame.BorderColor3 = Color3.fromRGB(27, 42, 53)
                DownFrame.ClipsDescendants = true
                DownFrame.Position = UDim2.new(0, 0, 0.1, 0)
                DownFrame.Size = UDim2.new(0, 328, 0, 0)

                ScrollingDown.Name = "ScrollingDown"
                ScrollingDown.Parent = DownFrame
                ScrollingDown.Active = true
                ScrollingDown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ScrollingDown.BackgroundTransparency = 1.000
                ScrollingDown.BorderSizePixel = 0
                ScrollingDown.Size = UDim2.new(0, 328, 0, 98)
                ScrollingDown.CanvasSize = UDim2.new(0, 0, 0, 0)
                ScrollingDown.ScrollBarThickness = 0
                ScrollingDown.BottomImage = ""
                ScrollingDown.TopImage = ""

                ItemList.Name = "ItemList"
                ItemList.Parent = ScrollingDown
                ItemList.SortOrder = Enum.SortOrder.LayoutOrder
                ItemList.Padding = UDim.new(0, 3)

                local SelectionScrollingUIPadding = Instance.new("UIPadding")
                SelectionScrollingUIPadding.Name = "SelectionScrollingUIPadding"
                SelectionScrollingUIPadding.Parent = ScrollingDown

                if set ~= nil then
                    callback(set)
                end

                for i,v in pairs(option) do
                    local ItemFrame = Instance.new("Frame")
                    local ItemButton = Instance.new("TextButton")
                    local UICorner = Instance.new("UICorner")


                    ItemFrame.Name = "ItemFrame"
                    ItemFrame.Parent = ScrollingDown
                    ItemFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    ItemFrame.BackgroundTransparency = 1.000
                    ItemFrame.Size = UDim2.new(0, 328, 0, 24)
    
                    ItemButton.Name = "ItemButton"
                    ItemButton.Parent = ItemFrame
                    ItemButton.BackgroundColor3 = Color3.fromRGB(32,143,252)
                    ItemButton.BorderSizePixel = 0
                    ItemButton.Position = UDim2.new(0.0701219514, 0, 0, 0)
                    ItemButton.Size = UDim2.new(0, 282, 0, 24)
                    ItemButton.AutoButtonColor = false
                    ItemButton.Font = Enum.Font.GothamBold
                    ItemButton.Text = tostring(v)
                    ItemButton.ClipsDescendants = true
                    ItemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ItemButton.TextSize = 14.000
    
                    UICorner.CornerRadius = UDim.new(0, 4)
                    UICorner.Parent = ItemButton

                    ItemButton.MouseButton1Down:Connect(function()
                        if Tabtoggle == false then
                            ItemButton.TextSize = 0
                            TweenService:Create(
                                ItemButton,
                                TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out,0.1),
                                {TextSize = 12}
                            ):Play()
                            Text.Text = tostring(text.." : "..v)
                            CircleAnim(ItemButton,Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255))
                            
                            callback(v)
                            DropToggle = false
                            TweenService:Create(
                                DownFrame,
                                TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                                {Size = UDim2.new(0, 328, 0, 0)}
                            ):Play()
                            TweenService:Create(
                                DropImage,
                                TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                                {Rotation = 180}
                            ):Play()
                        end         
                    end)
                end 

                ScrollingDown.CanvasSize = UDim2.new(0,0,0,ItemList.AbsoluteContentSize.Y + 10)
                ButtonDrop.MouseButton1Click:Connect(function()
                    if Tabtoggle == false then
                        if DropToggle == false then
                            DropToggle = true
                            TweenService:Create(
                                DownFrame,
                                TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                                {Size = UDim2.new(0, 328, 0, 98)}
                            ):Play()
                            TweenService:Create(
                                DropImage,
                                TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                                {Rotation = 270}
                            ):Play()
                            CircleAnim(Frame,Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255))
                        elseif DropToggle == true then
                            DropToggle = false
                            TweenService:Create(
                                DownFrame,
                                TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                                {Size = UDim2.new(0, 328, 0, 0)}
                            ):Play()
                            TweenService:Create(
                                DropImage,
                                TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                                {Rotation = 180}
                            ):Play()
                            CircleAnim(Frame,Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255))
                        end
                    end
                end
                )

                function RetrunDrop:Add(newtext)
                    local ItemFrame = Instance.new("Frame")
                    local ItemButton = Instance.new("TextButton")
                    local UICorner = Instance.new("UICorner")


                    ItemFrame.Name = "ItemFrame"
                    ItemFrame.Parent = ScrollingDown
                    ItemFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    ItemFrame.BackgroundTransparency = 1.000
                    ItemFrame.Size = UDim2.new(0, 328, 0, 24)
    
                    ItemButton.Name = "ItemButton"
                    ItemButton.Parent = ItemFrame
                    ItemButton.BackgroundColor3 = Color3.fromRGB(32,143,252)
                    ItemButton.BorderSizePixel = 0
                    ItemButton.Position = UDim2.new(0.0701219514, 0, 0, 0)
                    ItemButton.Size = UDim2.new(0, 282, 0, 24)
                    ItemButton.AutoButtonColor = false
                    ItemButton.Font = Enum.Font.GothamBold
                    ItemButton.Text = tostring(newtext)
                    ItemButton.ClipsDescendants = true
                    ItemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ItemButton.TextSize = 14.000
    
                    UICorner.CornerRadius = UDim.new(0, 4)
                    UICorner.Parent = ItemButton

                    ItemButton.MouseButton1Down:Connect(function()
                        if Tabtoggle == false then
                            ItemButton.TextSize = 0
                            TweenService:Create(
                                ItemButton,
                                TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out,0.1),
                                {TextSize = 12}
                            ):Play()
                            Text.Text = tostring(text.." : "..newtext)
                            CircleAnim(ItemButton,Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255))
                            
                            callback(newtext)
                            DropToggle = false
                            TweenService:Create(
                                DownFrame,
                                TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                                {Size = UDim2.new(0, 328, 0, 0)}
                            ):Play()
                            TweenService:Create(
                                DropImage,
                                TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                                {Rotation = 180}
                            ):Play()
                        end
                    end)

                    ScrollingDown.CanvasSize = UDim2.new(0,0,0,ItemList.AbsoluteContentSize.Y + 10)
                end

                function RetrunDrop:Clear()
                    Text.Text = tostring(text).." : "
                    DropToggle = false
                    TweenService:Create(
                        DownFrame,
                        TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                        {Size = UDim2.new(0, 328, 0, 0)}
                    ):Play()
                    TweenService:Create(
                        DropImage,
                        TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                        {Rotation = 180}
                    ):Play()
                    for i, v in next, ScrollingDown:GetChildren() do
                        if v:IsA("Frame") then
                            v:Destroy()
                        end
                    end
                    ScrollingDown.CanvasSize = UDim2.new(0,0,0,ItemList.AbsoluteContentSize.Y + 10)
                end
                return RetrunDrop
            end
            return main
        end
        return Tab
    end
    return Ui
end
if game.PlaceId == 2753915549 then
    World1 = true
elseif game.PlaceId == 4442272183 then
    World2 = true
elseif game.PlaceId == 7449423635 then
    World3 = true
end

 function CheckQuest()
                                    local MyLevel = game.Players.LocalPlayer.Data.Level.Value
                           if game.PlaceId == 2753915549 then -- sea1
                                        if MyLevel == 1 or MyLevel <= 9 then --Bandit
                                            Ms = "Bandit [Lv. 5]"
                                            NameQuest = "BanditQuest1"
                                            LevelQuest = 1
                                            NameMon = "Bandit Quest Giver"
                                            CFrameQuest = CFrame.new(1061.603271484375, 16.8598575592041, 1547.625)
                                            CFrameMob = CFrame.new(1039.3878173828125, 80.12092590332031, 1592.404296875)
                                            CFrameBring = CFrame.new(1192.048583984375, 16.7034969329834, 1611.431884765625)
                                            
                                            elseif MyLevel == 10 or MyLevel <= 14 then --monkey
                                            Ms = "Monkey [Lv. 14]"
                                            NameQuest = "JungleQuest"
                                            LevelQuest = 1
                                            NameMon = "Adventurer"
                                            CFrameQuest = CFrame.new(-1599.786865234375, 37.195369720458984, 156.74978637695312)
                                            CFrameMob = CFrame.new(-1776.05419921875, 74.84989166259766, 47.772865295410156)
                                            CFrameBring = CFrame.new(-1633.2825927734375, 15.852092742919922, 96.47166442871094)
                                            
                                            elseif MyLevel == 15 or MyLevel <= 29 then --Gozila
                                            Ms = "Gorilla [Lv. 20]"
                                            NameQuest = "JungleQuest"
                                            LevelQuest = 2
                                            NameMon = "Adventurer"
                                            CFrameQuest = CFrame.new(-1599.786865234375, 37.195369720458984, 156.74978637695312)
                                            CFrameMob = CFrame.new(-1321.07080078125, 82.16122436523438, -456.7127380371094)
                                            CFrameBring = CFrame.new(-1241.55078125, 6.27936315536499, -517.3883666992188)
                                            
                                            elseif MyLevel == 30 or MyLevel <= 39 then --pirate
                                            Ms = "Pirate [Lv. 35]"
                                            NameQuest = "BuggyQuest1"
                                            LevelQuest = 1
                                            NameMon = "Pirate Adventurer"
                                            CFrameQuest = CFrame.new(-1139.61767578125, 5.095293998718262, 3828.553365625)
                                            CFrameMob = CFrame.new(-1147.6865234375, 59.39506149291992, 3995.663818359375)
                                            CFrameBring = CFrame.new(-1179.3768310546875, 5.095293998718262, 3921.2919921875)
                                            
                                            elseif MyLevel == 40 or MyLevel <= 59 then --brute
                                            Ms = "Brute [Lv. 45]"
                                            NameQuest = "BuggyQuest1"
                                            LevelQuest = 2
                                            NameMon = "Pirate Adventurer"
                                            CFrameQuest = CFrame.new(-1139.61767578125, 5.095293998718262, 3828.553365625)
                                            CFrameMob = CFrame.new(-1134.163818359375, 93.64710235595703, 4317.65966796875)
                                            CFrameBring = CFrame.new(-1098.1475830078125, 14.809873580932617, 4337.5419921875)
                                            
                                            elseif MyLevel == 60 or MyLevel <= 74 then --Desert Bandit
                                            Ms = "Desert Bandit [Lv. 60]" --name mob
                                            NameQuest = "DesertQuest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Desert Adventurer"    --name npc
                                            CFrameQuest = CFrame.new(897.031128, 6.43846416, 4388.97168, -0.804044724, 3.68233266e-08, 0.594568789, 6.97835176e-08, 1, 3.24365246e-08, -0.594568789, 6.75715199e-08, -0.804044724)
                                            CFrameMob = CFrame.new(1053.786865234375, 52.50192642211914, 4489.82421875)
                                            CFrameBring = CFrame.new(922.7894897460938, 6.44875955581665, 4481.28125)
                                            
      elseif MyLevel == 75 or MyLevel <= 89 then --Desert Officre
                                            Ms = "Desert Officer [Lv. 70]" --name mob
                                            NameQuest = "DesertQuest" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Desert Adventurer"    --name npc
                                            CFrameQuest = CFrame.new(897.031128, 6.43846416, 4388.97168, -0.804044724, 3.68233266e-08, 0.594568789, 6.97835176e-08, 1, 3.24365246e-08, -0.594568789, 6.75715199e-08, -0.804044724)
                                            CFrameMob = CFrame.new(1561.3385009765625, 15.330206871032715, 4274.2587890625)      
                                            CFrameBring = CFrame.new(1613.4285888671875, 1.6109551191329956, 4360.02294921875)
    elseif MyLevel == 90 or MyLevel <= 99 then --Snow Bandit
                                            Ms = "Snow Bandit [Lv. 90]" --name mob
                                            NameQuest = "SnowQuest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Villager"    --name npc
                                            CFrameQuest = CFrame.new(1388.31689453125, 87.27276611328125, -1298.2066650390625)
                                            CFrameMob = CFrame.new(1419.9039306640625, 119.61993408203125, -1414.1715087890625)
                                            CFrameBring = CFrame.new(1386.5888671875, 87.27276611328125, -1379.3212890625)
                                            
      elseif MyLevel == 100 or MyLevel <= 119 then --Snowman
                                            Ms = "Snowman [Lv. 100]" --name mob
                                            NameQuest = "SnowQuest" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Villager"    --name npc
                                            CFrameQuest = CFrame.new(1388.31689453125, 87.27276611328125, -1298.2066650390625)
                                            CFrameMob = CFrame.new(1220.4559326171875, 138.01181030273438, -1489.2388916015625)        
                              CFrameBring = CFrame.new(1150.3426513671875, 106.23611450195312, -1516.80078125)
  elseif MyLevel == 120 or MyLevel <= 149 then --Chief Petty Officer
                                            Ms = "Chief Petty Officer [Lv. 120]" --name mob
                                            NameQuest = "MarineQuest2" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Marine"    --name npc
                                            CFrameQuest = CFrame.new(-5037.93017578125, 28.65203285217285, 4324.2392578125)
                                            CFrameMob = CFrame.new(-4760.70263671875, 74.91291046142578, 4461.4365234375)
                                            CFrameBring = CFrame.new(-4867.0634765625, 20.65203285217285, 4359.71337890625) or CFrame.new(-4675.14697265625, 20.652034759521484, 4477.3232421875)
                                            
                                            elseif MyLevel == 150 or MyLevel <= 174 then --Sky Bandit [Lv. 150]
                                            Ms = "Sky Bandit [Lv. 150]" --name mob
                                            NameQuest = "SkyQuest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Sky Adventurer"    --name npc
                                            CFrameQuest = CFrame.new(-4840.443359375, 717.6693725585938, -2620.983154296875)
                                            CFrameMob = CFrame.new(-4954.38720703125, 365.4177551269531, -2911.190673828125)
                                            CFrameBring = CFrame.new(-5003.708984375, 278.0669860839844, -2866.371826171875)
                                            
                                            elseif MyLevel == 175 or MyLevel <= 189 then --Dark Master [Lv. 175]
                                            Ms = "Dark Master [Lv. 175]" --name mob
                                            NameQuest = "SkyQuest" --name get quest
                                            LevelQuest = 2         -- lv quest
                                            NameMon = "Sky Adventurer"    --name npc
                                            CFrameQuest = CFrame.new(-4840.443359375, 717.6693725585938, -2620.983154296875)
                                            CFrameMob = CFrame.new(-5181.4873046875, 448.37725830078125, -2172.572998046875)    
     CFrameBring = CFrame.new(-5258.681640625, 388.6519470214844, -2278.768310546875)
                                       
               elseif MyLevel == 190 or MyLevel <= 209 then --m_b3
                                            Ms = "Prisoner [Lv. 190]" --name mob
                                            NameQuest = "PrisonerQuest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Jail Keeper"    --name npc
                                            CFrameQuest = CFrame.new(5307.03271484375, 1.6550424098968506, 473.080810546875)
                                            CFrameMob = CFrame.new(5246.40869140625, 72.6520004272461, 355.7655029296875)
                                            CFrameBring = CFrame.new(5166.82177734375, 1.798761248588562, 457.5108337402344)
   
  elseif MyLevel == 210 or MyLevel <= 249 then --m_b3
                                            Ms = "Dangerous Prisoner [Lv. 210]" --name mob
                                            NameQuest = "PrisonerQuest" --name get quest
                                            LevelQuest = 2         -- lv quest
                                            NameMon = "Jail Keeper"    --name npc
                                            CFrameQuest = CFrame.new(5307.03271484375, 1.6550424098968506, 473.080810546875)
                                            CFrameMob = CFrame.new(5664.5263671875, 72.6520004272461, 663.6072998046875)       
                                                         CFrameBring = CFrame.new(5609.08935546875, 1.6338006258010864, 659.2885131835938)     
                                       
   elseif MyLevel == 250 or MyLevel <= 299 then --Toga Warrior [Lv. 225]
                                            Ms = "Toga Warrior [Lv. 250]" --name mob
                                            NameQuest = "ColosseumQuest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Colosseum Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-1578.853759765625, 7.38933801651001, -2985.190185546875)
                                            CFrameMob = CFrame.new(-1780.4468994140625, 45.20888900756836, -2735.003173828125) 
                                      CFrameBring = CFrame.new(-1909.5372314453125, 7.289072513580322, -2760.071044921875)
               
  elseif MyLevel == 300 or MyLevel <= 324 then --Military Soldier [Lv. 300]
                                            Ms = "Military Soldier [Lv. 300]" --name mob
                                            NameQuest = "MagmaQuest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "The Mayor"    --name npc
                                            CFrameQuest = CFrame.new(-5315.4609375, 12.23685073852539, 8516.6962890625)
                                            CFrameMob = CFrame.new(-5615.11962890625, 59.20390701293945, 8445.76953125)
                                            CFrameBring = CFrame.new(-5377.1494140625, 8.990673065185547, 8493.80859375)
   
  elseif MyLevel == 325 or MyLevel <= 449 then --Military Spy [Lv. 325]
                                            Ms = "Military Spy [Lv. 325]" --name mob
                                            NameQuest = "MagmaQuest" --name get quest
                                            LevelQuest = 2       -- lv quest
                                            NameMon = "The Mayor"    --name npc
                                            CFrameQuest = CFrame.new(-5315.4609375, 12.23685073852539, 8516.6962890625)
                                            CFrameMob = CFrame.new(-5729.09130859375, 115.57196807861328, 8622.763671875)         
  CFrameBring = CFrame.new(-5849.50927734375, 77.23063659667969, 8823.505859375)
 elseif MyLevel == 450 or MyLevel <= 474 then --God's Guard [Lv. 450]
                                            Ms = "God's Guard [Lv. 450]" --name mob
                                            NameQuest = "SkyExp1Quest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Mole"    --name npc
                                            CFrameQuest = CFrame.new(-4722.51416015625, 845.2769775390625, -1951.57275390625)
                                            CFrameMob = CFrame.new(-4627.7509765625, 866.9027709960938, -1938.8880615234375)
                                            CFrameBring = CFrame.new(-4740.54541015625, 845.2769775390625, -1903.8253173828125)
   
  elseif MyLevel == 475 or MyLevel <= 524 then --Shanda [Lv. 475]
                                            Ms = "Shanda [Lv. 475]" --name mob
                                            NameQuest = "SkyExp1Quest" --name get quest
                                            LevelQuest = 2         -- lv quest
                                            NameMon = "Mole"    --name npc
                                            CFrameQuest = CFrame.new(-7860.5810546875, 5545.49169921875, -380.9195251464844)
                                            CFrameMob = CFrame.new(-7686.40673828125, 5600.93701171875, -441.3550109863281)   
              CFrameBring = CFrame.new(-7651.97216796875, 5545.49169921875, -519.1795043945312)
     elseif MyLevel == 525 or MyLevel <= 549 then --Royal Squad [Lv. 525]
                                            Ms = "Royal Squad [Lv. 525]" --name mob
                                            NameQuest = "SkyExp2Quest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Gan Fall Adventurer"    --name npc
                                            CFrameQuest = CFrame.new(-7905.001953125, 5635.96240234375, -1412.4091796875)
                                            CFrameMob = CFrame.new(-7634.65771484375, 5637.08056640625, -1411.266845703125)
                                            CFrameBring = CFrame.new(-7690.3349609375, 5606.876953125, -1456.149658203125)
   
  elseif MyLevel == 550 or MyLevel <= 624 then --Royal Soldier [Lv. 550]
                                            Ms = "Royal Soldier [Lv. 550]" --name mob
                                            NameQuest = "SkyExp2Quest" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Gan Fall Adventurer"    --name npc
                                            CFrameQuest = CFrame.new(-7905.001953125, 5635.96240234375, -1412.4091796875)
                                            CFrameMob = CFrame.new(-7837.5185546875, 5681.2587890625, -1790.808837890625)     
       CFrameBring = CFrame.new(-7838.7861328125, 5606.876953125, -1820.982666015625)
      elseif MyLevel == 625 or MyLevel <= 649 then --Galley Pirate [Lv. 625]
                                            Ms = "Galley Pirate [Lv. 625]" --name mob
                                            NameQuest = "FountainQuest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Freezeburg Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(5257.8203125, 38.501129150390625, 4049.2529296875)
                                            CFrameMob = CFrame.new(5559.6796875, 152.30133056640625, 4002.3876953125)
                                            CFrameBring = CFrame.new(5576.9287109375, 38.501129150390625, 3942.519287109375)
   
  elseif MyLevel == 650 or MyLevel >= 675 then --Galley Captain [Lv. 650]
                                            Ms = "Galley Captain [Lv. 650]" --name mob
                                            NameQuest = "FountainQuest" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Freezeburg Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(5257.8203125, 38.501129150390625, 4049.2529296875)
                                            CFrameMob = CFrame.new(5527.89501953125, 89.71221923828125, 4855.52490234375)    
                                                  CFrameBring = CFrame.new(5474.2099609375, 43.79754638671875, 4858.40478515625)            
end end    
    if game.PlaceId == 4442272183 then -- sea2                                                                                 
 if MyLevel == 700 or MyLevel <= 724 then --Raider [Lv. 700]
                                            Ms = "Raider [Lv. 700]" --name mob
                                            NameQuest = "Area1Quest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Area 1 Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-427.6253662109375, 73.31376647949219, 1836.4666748046875)
                                            CFrameBring = CFrame.new(-721.4496459960938, 39.483028411865234, 2367.37353515625) 
                                            CFrameMob = CFrame.new(-477.41650390625, 99.85147857666016, 2325.179443359375)
                                            
                                            elseif MyLevel == 725 or MyLevel <= 774 then --Mercenary [Lv. 725]"
                                            Ms = "Mercenary [Lv. 725]" --name mob
                                            NameQuest = "Area1Quest" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Area 1 Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-427.6253662109375, 73.31376647949219, 1836.4666748046875)
                                            CFrameMob = CFrame.new(-856.7423095703125, 135.76040649414062, 1488.4263916015625)
                                            CFrameBring = CFrame.new(-933.7117919921875, 73.30294036865234, 1704.3751220703125) or CFrame.new(-1089.43212890625, 73.30294036865234, 1176.912353515625) 
                                            
                                            elseif MyLevel == 775 or MyLevel <= 874 then --Swan Pirate [Lv. 775]
                                            Ms = "Swan Pirate [Lv. 775]" --name mob
                                            NameQuest = "Area2Quest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Area 2 Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(635.6129150390625, 73.41377258300781, 918.0537109375)
                                            CFrameMob = CFrame.new(930.8262329101562, 151.6645965576172, 1192.30859375)
                                            CFrameBring = CFrame.new(929.234130859375, 73.30294036865234, 1210.5303955078125)
                                                                                                            
  elseif MyLevel == 875 or MyLevel <= 899 then --Marine Lieutenant [Lv. 875]
                                            Ms = "Marine Lieutenant [Lv. 875]" --name mob
                                            NameQuest = "MarineQuest3" --name get quest
                                            LevelQuest = 1      -- lv quest
                                            NameMon = "Marine Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-2441.47705078125, 73.35932922363281, -3217.752685546875)
                                            CFrameMob = CFrame.new(-2921.725341796875, 152.91773986816406, -3089.07470703125)
                                            CFrameBring = CFrame.new(-2843.622314453125, 73.30936431884766, -2990.433349609375)                                           
      elseif MyLevel == 900 or MyLevel <= 949 then --Marine Captain [Lv. 900]
                                            Ms = "Marine Captain [Lv. 900]" --name mob
                                            NameQuest = "MarineQuest3" --name get quest
                                            LevelQuest = 2         -- lv quest
                                            NameMon = "Marine Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-2441.47705078125, 73.35932922363281, -3217.752685546875)
                                            CFrameMob = CFrame.new(-2007.395751953125, 120.147216796875, -3203.88916015625)
                                            CFrameBring = CFrame.new(-1955.32568359375, 73.30936431884766, -3273.25341796875)   
                                            
                                            elseif MyLevel == 950 or MyLevel <= 974 then --Zombie [Lv. 950]
                                            Ms = "Zombie [Lv. 950]" --name mob
                                            NameQuest = "ZombieQuest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Graveyard Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-5495.4521484375, 48.823360443115234, -794.7634887695312)
                                            CFrameMob = CFrame.new(-5727.2783203125, 126.3752212524414, -728.1871337890625)
                                            CFrameBring = CFrame.new(-5677.216796875, 48.82343673706055, -696.4016723632812)
                                            
  elseif MyLevel == 975 or MyLevel <= 999 then --Vampire [Lv. 975]
                                            Ms = "Vampire [Lv. 975]" --name mob
                                            NameQuest = "ZombieQuest" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Graveyard Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-5495.4521484375, 48.823360443115234, -794.7634887695312)
                                            CFrameMob = CFrame.new(-5922.28125, 42.31851577758789, -1084.8621826171875)
                                            CFrameBring = CFrame.new(-6050.15869140625, 6.745943546295166, -1314.393328125)                
                             elseif MyLevel == 1000 or MyLevel <= 1049 then --Snow Trooper [Lv. 1000]
                                            Ms = "Snow Trooper [Lv. 1000]" --name mob
                                            NameQuest = "SnowMountainQuest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Snow Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(607.1868286132812, 401.7651672363281, -5372.98046875)
                                            CFrameMob = CFrame.new(538.6248168945312, 428.3368835449219, -5546.4677734375)
                                            CFrameBring = CFrame.new(604.3399047851562, 401.7651672363281, -5566.1025390625)
                                            
  elseif MyLevel == 1050 or MyLevel <= 1099 then --Winter Warrior [Lv. 1050]
                                            Ms = "Winter Warrior [Lv. 1050]" --name mob
                                            NameQuest = "SnowMountainQuest" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Snow Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(607.018310546875, 401.7651672363281, -5371.32080078125)
                                            CFrameMob = CFrame.new(1397.455078125, 465.8684387207031, -5203.23388671875)
                                            CFrameBring = CFrame.new(1316.513916015625, 429.7651062011719, -5313.61572265625)   
                                          elseif MyLevel == 1100 or MyLevel <= 1124 then --Lab Subordinate [Lv. 1100]
                                            Ms = "Lab Subordinate [Lv. 1100]" --name mob
                                            NameQuest = "IceSideQuest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Ice Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-6062.630859375, 16.295000076293945, -4903.611328125)
                                            CFrameMob = CFrame.new(-5836.0224609375, 48.78202819824219, -4508.833984375)
                                            CFrameBring = CFrame.new(-5737.90966796875, 16.295000076293945, -4500.74365234375)
                                            
  elseif MyLevel == 1125 or MyLevel <= 1174 then --Horned Warrior [Lv. 1125]
                                            Ms = "Horned Warrior [Lv. 1125]" --name mob
                                            NameQuest = "IceSideQuest" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Ice Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-6062.630859375, 16.295000076293945, -4903.611328125)
                                            CFrameMob = CFrame.new(-6400.66796875, 25.011735916137695, -5818.05712890625)
                                            CFrameBring = CFrame.new(-6466.91748046875, 16.29500389099121, -5705.90283203125)           
                elseif MyLevel == 1175 or MyLevel <= 1199 then --Magma Ninja [Lv. 1175]
                                            Ms = "Magma Ninja [Lv. 1175]" --name mob
                                            NameQuest = "FireSideQuest" --name& get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Fire Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-5428.10595703125, 16.295000076293945, -5297.57177734375)
                                            CFrameMob = CFrame.new(-5750.71630859375, 62.33693313598633, -5983.71435546875)
                                            CFrameBring = CFrame.new(-5720.39404296875, 16.295000076293945, -5812.42138671875) or CFrame.new(-5185.24169921875, 16.295122146606445, -6091.33935546875)                       
                                            
  elseif MyLevel == 1200 or MyLevel <= 1349 then --Lava Pirate [Lv. 1200]
                                            Ms = "Lava Pirate [Lv. 1200]" --name mob
                                            NameQuest = "FireSideQuest" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Fire Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-5428.10595703125, 16.295000076293945, -5297.57177734375)
                                            CFrameMob = CFrame.new(-5283.6630859375, 47.871910095214844, -4677.29345703125)
                                            CFrameBring = CFrame.new(-5289.73193359375, 16.295000076293945, -4558.72412109375)    
                     elseif MyLevel == 1350 or MyLevel <= 1374 then --Arctic Warrior [Lv. 1350]
                                            Ms = "Arctic Warrior [Lv. 1350]" --name mob
                                            NameQuest = "FrostQuest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Frost Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(5667.05908203125, 28.51487159729004, -6484.171875)
                                            CFrameMob = CFrame.new(5993.02587890625, 58.28438186645508, -6174.68896484375)
                                            CFrameBring = CFrame.new(6118.96240234375, 28.71002769470215, -6218.337890625)
                                            
  elseif MyLevel == 1375 or MyLevel <= 1424 then --Snow Lurker [Lv. 1375]
                                            Ms = "Snow Lurker [Lv. 1375]" --name mob
                                            NameQuest = "FrostQuest" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Frost Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(5667.05908203125, 28.51487159729004, -6484.171875)
                                            CFrameMob = CFrame.new(5557.3349609375, 57.892425537109375, -6598.27685546875)
                                            CFrameBring = CFrame.new(5601.07373046875, 28.939659118652344, -6723.14306640625)     
                           elseif MyLevel == 1425 or MyLevel <= 1449 then --Sea Soldier [Lv. 1425]
                                            Ms = "Sea Soldier [Lv. 1425]" --name mob
                                            NameQuest = "ForgottenQuest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Forgotten Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-3053.992431640625, 237.1895294189453, -10146.0830078125)
                                            CFrameMob = CFrame.new(-3519.587646484375, 74.93817138671875, -9724.068359375)
                                            CFrameBring = CFrame.new(-3368.539794921875, 27.295886993408203, -9782.5263671875)
                                            
  elseif MyLevel == 1450 or MyLevel >= 1474 then --Water Fighter [Lv. 1450]
                                            Ms = "Water Fighter [Lv. 1450]" --name mob
                                            NameQuest = "ForgottenQuest" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Forgotten Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-3053.992431640625, 237.1895294189453, -10146.0830078125)
                                            CFrameMob = CFrame.new(-3435.46923828125, 290.52178955078125, -10501.794921875)
                                            CFrameBring = CFrame.new(-3419.48974609375, 239.18936157226562, -10508.7607421875)                                                                                                
                                            end end
                                            
                   if game.PlaceId == 7449423635 then -- sea3    
if MyLevel == 1500 or MyLevel <= 1524 then --Pirate Millionaire [Lv. 1500]
                                            Ms = "Pirate Millionaire [Lv. 1500]" --name mob
                                            NameQuest = "PiratePortQuest" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Pirate Port Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-289.6327819824219, 44.136451721191406, 5579.84228515625)
                                            CFrameMob = CFrame.new(-506.41162109375, 81.82060241699219, 5568.873046875)
                                            CFrameBring = CFrame.new(-565.9216918945312, 44.15378952026367, 5530.4326171875) 
                                            
  elseif MyLevel == 1525 or MyLevel <= 1574 then --Pistol Billionaire [Lv. 1525] 
                                            Ms = "Pistol Billionaire [Lv. 1525]" --name mob
                                            NameQuest = "PiratePortQuest" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Pirate Port Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-289.6327819824219, 44.136451721191406, 5579.84228515625)
                                            CFrameMob = CFrame.new(46.07829666137695, 134.91697692871094, 6076.12109375)
                                            CFrameBring = CFrame.new(-5.446301460266113, 74.13822937011719, 6129.6318359375)       
                                            
                                            elseif MyLevel == 1575 or MyLevel <= 1599 then --m_b3
                                            Ms = "Dragon Crew Warrior [Lv. 1575]" --name mob
                                            NameQuest = "AmazonQuest1" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Amazon Area 1 Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(5834.0126953125, 51.69459533691406, -1103.0084228515625)
                                            CFrameMob = CFrame.new(6297.81591796875, 109.59271240234375, -1086.8896484375)
                                            CFrameBring = CFrame.new(6491.39453125, 51.83952331542969, -979.994384765625)
                                            
  elseif MyLevel == 1600 or MyLevel <= 1624 then --m_b3
                                            Ms = "m_b31" --name mob
                                            NameQuest = "AmazonQuest1" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Amazon Area 1 Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(5834.0126953125, 51.69459533691406, -1103.0084228515625)
                                            CFrameMob = CFrame.new(6710.20361328125, 427.42218017578125, 115.1513900756836)
                                            CFrameBring = CFrame.new(6630.39697265625, 378.73773193359375, 262.2434387207031)                                             
                elseif MyLevel == 1625 or MyLevel <= 1649 then --m_b3
                                            Ms = "Female Islander [Lv. 1625]" --name mob
                                            NameQuest = "AmazonQuest2" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Amazon Area 2 Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(5447.1455078125, 601.9468994140625, 750.1180419921875)
                                            CFrameMob = CFrame.new(4646.63916015625, 792.59423828125, 776.8380126953125)
                                            CFrameBring = CFrame.new(4746.7080078125, 730.677001953125, 692.0280151367188)
                                            
  elseif MyLevel == 1650 or MyLevel <= 1699 then --Giant Islander [Lv. 1650]
                                            Ms = "Giant Islander [Lv. 1650]" --name mob
                                            NameQuest = "AmazonQuest2" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Amazon Area 2 Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(5447.1455078125, 601.9468994140625, 750.1180419921875)
                                            CFrameMob = CFrame.new(4920.9521484375, 670.2709350585938, -8.560141563415527)
                                            CFrameBring = CFrame.new(4763.189453125, 590.780029296875, -36.859249114990234)          
             elseif MyLevel == 1700 or MyLevel <= 1724 then --Marine Commodore [Lv. 1700]
                                            Ms = "Marine Commodore [Lv. 1700]" --name mob
                                            NameQuest = "MarineTreeIsland" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Marine Tree Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(2179.129150390625, 29.04867935180664, -6738.630859375)
                                            CFrameMob = CFrame.new(2440.161376953125, 126.5625991821289, -7372.95263671875)
                                            CFrameBring = CFrame.new(2339.177001953125, 73.4631576538086, -7515.31396484375)
                                            
  elseif MyLevel == 1725 or MyLevel <= 1774 then --Marine Rear Admiral [Lv. 1725]
                                            Ms = "Marine Rear Admiral [Lv. 1725]" --name mob
                                            NameQuest = "MarineTreeIsland" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Marine Tree Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(2179.129150390625, 29.04867935180664, -6738.630859375)
                                            CFrameMob = CFrame.new(3785.75634765625, 191.74342346191406, -7079.556640625)
                                            CFrameBring = CFrame.new(3670.998046875, 160.86729431152344, -7010.044921875)                
             elseif MyLevel == 1775 or MyLevel <= 1799 then --Fishman Raider [Lv. 1775]
                                            Ms = "Fishman Raider [Lv. 1775]" --name mob
                                            NameQuest = "DeepForestIsland3" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Turtle Adventure Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-10584.568359375, 332.1058654785156, -8758.7568359375)
                                            CFrameMob = CFrame.new(-10532.115234375, 374.5972900390625, -8267.361328125)
                                            CFrameBring = CFrame.new(-10686.943359375, 332.1058654785156, -8476.6474609375) or CFrame.new(-10408.716796875, 332.1058654785156, -8357.494140625)
                                            
  elseif MyLevel == 1800 or MyLevel <= 1824 then --Fishman Captain [Lv. 1800]
                                            Ms = "Fishman Captain [Lv. 1800]" --name mob
                                            NameQuest = "DeepForestIsland3" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Turtle Adventure Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-10584.568359375, 332.1058654785156, -8758.7568359375)
                                            CFrameMob = CFrame.new(-10308.4921875, 376.1828308105469, -8790.044921875)
                                            CFrameBring = CFrame.new(-10957.3740234375, 332.1058654785156, -8808.9951171875)   or CFrame.new(-11094.2783203125, 332.0664367675781, -9118.0009765625)              
                                             elseif MyLevel == 1825 or MyLevel <= 1849 then --Forest Pirate [Lv. 1825]
                                            Ms = "Forest Pirate [Lv. 1825]" --name mob
                                            NameQuest = "DeepForestIsland" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Deep Forest Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-13233.65625, 332.72137451171875, -7627.02490234375)
                                            CFrameMob = CFrame.new(-13497.9482421875, 391.09967041015625, -7907.6767578125)
                                            CFrameBring = CFrame.new(-13482.9677734375, 332.72137451171875, -7868.55712890625)
                                            
  elseif MyLevel == 1850 or MyLevel <= 1899 then --Mythological Pirate [Lv. 1850]
                                            Ms = "Mythological Pirate [Lv. 1850]" --name mob
                                            NameQuest = "DeepForestIsland" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Deep Forest Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-13233.65625, 332.72137451171875, -7627.02490234375)
                                            CFrameMob = CFrame.new(-13506.3642578125, 581.2453002929688, -6984.3818359375)
                                            CFrameBring = CFrame.new(-13658.9287109375, 470.13092041015625, -6991.89794921875)    or CFrame.new(  -13249.5517578125, 520.3683471679688, -6797.69970703125)                                   
elseif MyLevel == 1900 or MyLevel <= 1924 then --Jungle Pirate [Lv. 1900]
                                            Ms = "Jungle Pirate [Lv. 1900]" --name mob
                                            NameQuest = "DeepForestIsland2" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Deep Forest Area 2 Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-12683.2880859375, 391.20391845703125, -9901.1484375)
                                            CFrameMob = CFrame.new(-12090.5185546875, 447.84625244140625, -10561.8701171875)
                                            CFrameBring = CFrame.new(-11803.9326171875, 332.0815124511719, -10570.623046875) or CFrame.new(-12265.771484375, 332.0815124511719, -10488.734375)
                                            
  elseif MyLevel == 1925 or MyLevel <= 1974 then --Jungle Pirate [Lv. 1900]
                                            Ms = "Jungle Pirate [Lv. 1900]" --name mob
                                            NameQuest = "DeepForestIsland2" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Deep Forest Area 2 Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-12683.2880859375, 391.20391845703125, -9901.1484375)
                                            CFrameMob = CFrame.new(-13335.2841796875, 446.6105041503906, -9916.2177734375)
                                            CFrameBring = CFrame.new(-13365.779296875, 391.8888854980469, -9815.4404296875)          
                                   elseif MyLevel == 1975 or MyLevel <= 1999 then --Reborn Skeleton [Lv. 1975]
                                            Ms = "Reborn Skeleton [Lv. 1975]" --name mob
                                            NameQuest = "HauntedQuest1" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Haunted Castle Quest Giver 1"    --name npc
                                            CFrameQuest = CFrame.new(-9480.8701171875, 142.4469451904297, 5567.6015625)
                                            CFrameMob = CFrame.new(-8761.7587890625, 176.92678833007812, 6178.2587890625)
                                            CFrameBring = CFrame.new(-8753.0634765625, 142.44805908203125, 6054.65185546875)
                                            
  elseif MyLevel == 2000 or MyLevel <= 2024 then --Living Zombie [Lv. 2000]
                                            Ms = "Living Zombie [Lv. 2000]" --name mob
                                            NameQuest = "HauntedQuest1" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Haunted Castle Quest Giver 1"    --name npc
                                            CFrameQuest = CFrame.new(-9480.8701171875, 142.4469451904297, 5567.6015625)
                                            CFrameMob = CFrame.new(-10080.99609375, 238.17595214844, 5915.44775390625)
                                            CFrameBring = CFrame.new(-10151.8662109375, 138.96990966796875, 5999.3056640625)                     
                        elseif MyLevel == 2025 or MyLevel <= 2049 then --Demonic Soul [Lv. 2025]
                                            Ms = "Demonic Soul [Lv. 2025]" --name mob
                                            NameQuest = "HauntedQuest2" --name get quest
                                            LevelQuest = 1         -- lv quest
                                            NameMon = "Haunted Castle Quest Giver 2"    --name npc
                                            CFrameQuest = CFrame.new(-9515.3583984375, 172.44805908203125, 6077.98193359375)
                                            CFrameMob = CFrame.new(-9567.6455078125, 205.01329040527344, 6041.50439453125)
                                            CFrameBring = CFrame.new(-9628.9521484375, 172.44805908203125, 6135.67529296875) or CFrame.new(-9355.6806640625, 172.44805908203125, 6128.958984375)
                                            
  elseif MyLevel == 2050 or MyLevel <= 2074 then --m_b3
                                            Ms = "Posessed Mummy [Lv. 2050]" --name mob
                                            NameQuest = "HauntedQuest2" --name get quest
                                            LevelQuest = 2        -- lv quest
                                            NameMon = "Haunted Castle Quest Giver 2"    --name npc
                                            CFrameQuest = CFrame.new(-9515.3583984375, 172.44805908203125, 6077.98193359375)
                                            CFrameMob = CFrame.new(-9683.0595703125, 30.237384796142578, 6359.37890625)
                                            CFrameBring = CFrame.new(-9592.609375, 6.502960681915283, 6304.86767578125)          
                      elseif MyLevel == 2075 or MyLevel <= 2099 then --m_b3
                                            Ms = "Peanut Scout [Lv. 2075]" --name mob
                                            NameQuest = "NutsIslandQuest" --name get quest
                                            LevelQuest = 1        -- lv quest
                                            NameMon = "Peanut Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-2103.4658203125, 38.44702911376953, -10192.3759765625)
                                            CFrameMob = CFrame.new(-1938.1060791015625, 92.89632415771484, -10194.41015625)
                                            CFrameBring = CFrame.new(-1981.99462890625, 38.44697189331055, -10212.177734375)          
                                            
     elseif MyLevel == 2100 or MyLevel <= 2124 then --m_b3
                                            Ms = "Peanut President [Lv. 2100]" --name mob
                                            NameQuest = "NutsIslandQuest" --name get quest
                                            LevelQuest = 2       -- lv quest
                                            NameMon = "Peanut Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-2103.4658203125, 38.44702911376953, -10192.3759765625)
                                            CFrameMob = CFrame.new(-1955.168701171875, 80.96415710449219, -10534.24609375)
                                            CFrameBring = CFrame.new(-1981.7294921875, 38.44706344604492, -10583.0283203125)             
        elseif MyLevel == 2125 or MyLevel <= 2149 then --m_b3
                                            Ms = "Ice Cream Chef [Lv. 2125]" --name mob
                                            NameQuest = "IceCreamIslandQuest" --name get quest
                                            LevelQuest = 1        -- lv quest
                                            NameMon = "Ice Cream Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-819.2644653320312, 66.16277313232422, -10965.35546875)
                                            CFrameMob = CFrame.new(-875.36962890625, 118.58836364746094, -11034.2578125)
                                            CFrameBring = CFrame.new(-966.68450195312, 66.16276550292969, -11046.341796875)
                                            
     elseif MyLevel == 2150 or MyLevel <= 2199 then --m_b3
                                            Ms = "Ice Cream Commander [Lv. 2150]" --name mob
                                            NameQuest = "IceCreamIslandQuest" --name get quest
                                            LevelQuest = 2       -- lv quest
                                            NameMon = "Ice Cream Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-819.2644653320312, 66.16277313232422, -10965.35546875)
                                            CFrameMob = CFrame.new(-697.4462280273438, 173.2466278076172, -11212.94140625)
                                            CFrameBring = CFrame.new(-638.2747192382812, 66.16278076171875, -11293.0546875)       
                     elseif MyLevel == 2200 or MyLevel <= 2224 then --m_b3
                                            Ms = "Cookie Crafter [Lv. 2200]"
                                            NameQuest = "CakeQuest1" --name get quest
                                            LevelQuest = 1        -- lv quest
                                            NameMon = "Cake Quest Giver"    --name npc
                                            CFrameQuest = CFrame.new(-2020.8443603515625, 38.141448974609375, -12029.701171875)
                                            CFrameMob = CFrame.new(-2289.203369140625, 92.37846374511719, -12041.884765625)
                                            CFrameBring = CFrame.new(-2367.436279296875, 38.14149856567383, -12120.3876953125)
                                            
     elseif MyLevel == 2225 or MyLevel <= 2249  then --m_b3
                                            Ms = "Cake Guard [Lv. 2225]"
                                            NameQuest = "CakeQuest2" --name get quest
                                            LevelQuest = 1      -- lv quest
                                            NameMon = "Cake Quest Giver 2"    --name npc
                                            CFrameQuest = CFrame.new(-1930.0250244140625, 38.14136505126953, -12839.5126953125)
                                            CFrameMob = CFrame.new(-1770.3917236328125, 81.48420715332031, -12207.4453125)
                                            CFrameBring = CFrame.new(-1550.4625244140625, 38.14139175415039, -12253.3388671875)     
        elseif MyLevel == 2250 or MyLevel <= 2299  then --m_b3
                                            Ms = "Cake Guard [Lv. 2250]"
                                            NameQuest = "CakeQuest2" --name get quest
                                            LevelQuest = 2       -- lv quest
                                            NameMon = "Cake Quest Giver 2"    --name npc
                                            CFrameQuest = CFrame.new(-1930.0250244140625, 38.14136505126953, -12839.5126953125)
                                            CFrameMob = CFrame.new(-2313.727294921875, 106.16911315917969, -12928.9609375)
                                            CFrameBring = CFrame.new(-2277.978271484375, 53.741302490234375, -12882.1669921875)
                                            
     elseif MyLevel == 2300 or MyLevel <= 2324 then --m_b3
                                            Ms = "Cocoa Warrior [Lv. 2300]"
                                            NameQuest = "ChocQuest1" --name get quest
                                            LevelQuest = 1        -- lv quest
                                            NameMon = "Chocolate Quest Giver 1"    --name npc
                                            CFrameQuest = CFrame.new(232.68365478515625, 25.07747459411621, -12198.4609375)
                                            CFrameMob = CFrame.new(141.66293334960938, 68.89732360839844, -12254.884765625)
                                            CFrameBring = CFrame.new(-59.606964328125, 25.077518463134766, -12293.5009765625)
                                            
     elseif MyLevel == 2325 or MyLevel <= 2349 then --m_b3
                                            Ms = "Chocolate Bar Battler [Lv. 2325]"
                                            NameQuest = "ChocQuest1" --name get quest
                                            LevelQuest = 2       -- lv quest
                                            NameMon = "Chocolate Quest Giver 1"    --name npc
                                            CFrameQuest = CFrame.new(232.68365478515625, 25.07747459411621, -12198.4609375)
                                            CFrameMob = CFrame.new(601.5966186523438, 74.49623107910156, -12581.8505859375)
                                            CFrameBring = CFrame.new(645.4754638671875, 25.077503204345703, -12556.8251953125)
                                            
         elseif MyLevel == 2350 or MyLevel <= 2374 then --m_b3
                                            Ms = "Sweet Thief [Lv. 2350]"
                                            NameQuest = "ChocQuest2" --name get quest
                                            LevelQuest = 1        -- lv quest
                                            NameMon = "Chocolate Quest Giver 2"  --name npc
                                            CFrameQuest = CFrame.new(149.07852172851562, 25.136638641357422, -12773.7724609375)
                                            CFrameMob = CFrame.new(-98.89625549316406, 141.48594665527344, -12260.88671875)
                                            CFrameBring = CFrame.new(-62.194541931152344, 25.07767105102539, -12263.3408203125)
                                            
     elseif MyLevel == 2375 or MyLevel <= 2399  then --m_b3
                                            Ms = "Candy Rebel [Lv. 2375]"
                                            NameQuest = "ChocQuest2" --name get quest
                                            LevelQuest = 2       -- lv quest
                                            NameMon = "Chocolate Quest Giver 2"   --name npc
                                            CFrameQuest = CFrame.new(149.07852172851562, 25.136638641357422, -12773.7724609375)
                                            CFrameMob = CFrame.new(722.8572387695312, 66.84835052490234, -12589.693359375)
                                            CFrameBring = CFrame.new(758.705865625, 25.077476501464844, -12648.5390625)               
            elseif MyLevel == 2400 or MyLevel <= 2424 then --m_b3
                                            Ms = "Candy Pirate [Lv. 2400]"
                                            NameQuest = "CandyQuest1" --name get quest
                                            LevelQuest = 1        -- lv quest
                                            NameMon = "Candy Cane Quest Giver"  --name npc
                                            CFrameQuest = CFrame.new(-1147.3931884765625, 14.45048999786377, -14445.3056640625)
                                            CFrameMob = CFrame.new(-1409.4703369140625, 70.9400405883789, -14846.0751953125)
                                            CFrameBring = CFrame.new(-1331.5687255859375, 15.250885009765625, -14735.1865234375)
                                            
     elseif MyLevel == 2425 or MyLevel >= 9999  then --m_b3
                                            Ms = "Snow Demon [Lv. 2425]"
                                            NameQuest = "CandyQuest1" --name get quest
                                            LevelQuest = 2       -- lv quest
                                            NameMon = "Candy Cane Quest Giver"   --name npc
                                            CFrameQuest = CFrame.new(-1147.3931884765625, 14.45048999786377, -14445.3056640625)
                                            CFrameMob = CFrame.new(-846.505126953125, 114.67166900634766, -14408.7978515625)
                                            CFrameBring = CFrame.new(-860.7842407226562, 15.250883102416992, -14339.814453125)        
end end                                                                                                        
 end
   CheckQuest()
    local Win = Lib:Window("Update","rbxassetid://13150998787") --tên bảng
    local Main = Win:Tab("Fram")
    local Page = Main:Page()
    local Page2 = Main:Page()

   
    local label = Page:Label("your mom") -- tên giới thiệu
     local line = Page:Line() -- thanh ngăn cách
local Toggle = Page:Toggle("Auto Chest",default, function(t) -- tắt bật 1
    
   if t then
        _G.m_b8 = true
    else
        _G.m_b8 = false
    end
end)
function TPchest(P1)          
                    local Distance = (P1.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
               if Distance >= 0 then
                        Speed = 1200000
                    end
                    
                   local tween =  game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Distance/Speed), {CFrame = P1  }) tween:Play()                                    
              end
              
       game:GetService('RunService').RenderStepped:connect(function()       
    if   _G.m_b8 then
    
      if game:GetService("Workspace"):FindFirstChild("Chest2") then
     TPchest(game:GetService("Workspace"):FindFirstChild("Chest2").CFrame)
     end
     if game:GetService("Workspace"):FindFirstChild("Chest1") then
     TPchest(game:GetService("Workspace"):FindFirstChild("Chest1").CFrame)
     end
     if game:GetService("Workspace"):FindFirstChild("Chest3") then
TpChest(game:GetService("Workspace"):FindFirstChild("Chest3").CFrame)
end
end end)
spawn(function()
    while task.wait(3.5) do
        pcall(function()
            if _G.m_b8 then
            game.Players.LocalPlayer.Character.Humanoid.Health = 0
            wait(5)
            local function Stopchest()
    if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("God's Chalice") then
_G.m_b8= false
if not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("God's Chalice") then
    game.Players.LocalPlayer.Character.Head:Destroy()
     end
            end
            end
            end
end)
end
end)
local Toggle = Page:Toggle("auto fram",default, function(t)
if t then
    
end
    end)    
    
