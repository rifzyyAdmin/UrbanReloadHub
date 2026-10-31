
-- Urban Reload Hub | UI v2
-- UI and toggle framework for Roblox Studio

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("UrbanReloadHub")
if old then
    old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "UrbanReloadHub"
gui.ResetOnSpawn = false
gui.DisplayOrder = 100
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(280, 265)
frame.Position = UDim2.new(0.5, -140, 0.5, -132)
frame.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius =
    UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(55, 70, 95)
stroke.Parent = frame

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 46)
header.BackgroundColor3 = Color3.fromRGB(27, 31, 45)
header.BorderSizePixel = 0
header.Active = true
header.Parent = frame

Instance.new("UICorner", header).CornerRadius =
    UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -65, 1, 0)
title.Position = UDim2.fromOffset(14, 0)
title.BackgroundTransparency = 1
title.Text = "URBAN RELOAD HUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(34, 30)
minimize.Position = UDim2.new(1, -42, 0, 8)
minimize.BackgroundColor3 = Color3.fromRGB(48, 54, 72)
minimize.Text = "—"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.Parent = header

Instance.new("UICorner", minimize).CornerRadius =
    UDim.new(0, 7)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -100)
content.Position = UDim2.fromOffset(10, 55)
content.BackgroundTransparency = 1
content.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

local states = {
    ESP = false,
    Aimbot = false,
    ["Auto Farm"] = false
}

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 27)
status.Position = UDim2.new(0, 10, 1, -32)
status.BackgroundTransparency = 1
status.Text = "UI ready | Modules not connected"
status.TextColor3 = Color3.fromRGB(180, 185, 200)
status.Font = Enum.Font.Gotham
status.TextSize = 10
status.Parent = frame

local function makeToggle(name)
    local button = Instance.new("TextButton")
    button.Name = name:gsub("%s", "") .. "Toggle"
    button.Size = UDim2.new(1, 0, 0, 43)
    button.BackgroundColor3 = Color3.fromRGB(38, 42, 57)
    button.BorderSizePixel = 0
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 14
    button.LayoutOrder =
        name == "ESP" and 1
        or name == "Aimbot" and 2 or 3
    button.Parent = content

    Instance.new("UICorner", button).CornerRadius =
        UDim.new(0, 8)

    local function update()
        button.Text = name .. "  [" ..
            (states[name] and "ON" or "OFF") .. "]"

        button.BackgroundColor3 = states[name]
            and Color3.fromRGB(35, 110, 85)
            or Color3.fromRGB(38, 42, 57)
    end

    button.Activated:Connect(function()
        states[name] = not states[name]
        update()

        status.Text = name .. " display: " ..
            (states[name] and "ON" or "OFF") ..
            " | Module not connected"
    end)

    update()
end

makeToggle("ESP")
makeToggle("Aimbot")
makeToggle("Auto Farm")

local minimized = false

minimize.Activated:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    status.Visible = not minimized
    frame.Size = minimized
        and UDim2.fromOffset(280, 46)
        or UDim2.fromOffset(280, 265)

    minimize.Text = minimized and "+" or "—"
end)

-- Drag the menu using its header.
local dragging = false
local dragStart
local startPosition
local dragInput

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState ==
                Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)
