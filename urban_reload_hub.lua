
-- URBAN RELOAD HUB v2
-- UI hub for Roblox Lua environments
-- Feature switches are UI states, not game exploit implementations.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then return end

local playerGui = player:WaitForChild("PlayerGui")

-- Avoid duplicate panels
local old = playerGui:FindFirstChild("UrbanReloadHub")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "UrbanReloadHub"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.fromOffset(280, 290)
frame.Position = UDim2.new(0.5, -140, 0.5, -145)
frame.BackgroundColor3 = Color3.fromRGB(15, 17, 26)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = object
end

corner(frame, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(55, 75, 115)
stroke.Thickness = 1
stroke.Parent = frame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 46)
header.BackgroundColor3 = Color3.fromRGB(25, 30, 46)
header.BorderSizePixel = 0
header.Active = true
header.Parent = frame
corner(header, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.fromOffset(14, 0)
title.BackgroundTransparency = 1
title.Text = "URBAN RELOAD"
title.TextColor3 = Color3.fromRGB(235, 240, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local function makeButton(parent, text, size, position, color)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = position
    b.BackgroundColor3 = color or Color3.fromRGB(38, 43, 61)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(245, 247, 255)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 13
    b.AutoButtonColor = true
    b.BorderSizePixel = 0
    b.Parent = parent
    corner(b, 8)
    return b
end

local minimize = makeButton(
    header, "—", UDim2.fromOffset(30, 28),
    UDim2.new(1, -70, 0, 9), Color3.fromRGB(48, 56, 78)
)

local close = makeButton(
    header, "X", UDim2.fromOffset(28, 28),
    UDim2.new(1, -34, 0, 9), Color3.fromRGB(125, 47, 58)
)

-- Body
local body = Instance.new("Frame")
body.Name = "Body"
body.Size = UDim2.new(1, -20, 1, -62)
body.Position = UDim2.fromOffset(10, 52)
body.BackgroundTransparency = 1
body.Parent = frame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 24)
subtitle.BackgroundTransparency = 1
subtitle.Text = "FEATURE CONTROL"
subtitle.TextColor3 = Color3.fromRGB(145, 160, 190)
subtitle.Font = Enum.Font.GothamBold
subtitle.TextSize = 11
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = body

local features = {
    {name = "ESP", description = "NPC visibility"},
    {name = "Aimbot", description = "Target assistance"},
    {name = "Auto Farm", description = "Farm automation"},
    {name = "Auto Loot", description = "Loot interaction"}
}

local states = {}
local statusLabels = {}

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 24)
status.Position = UDim2.new(0, 0, 1, -24)
status.BackgroundTransparency = 1
status.Text = "READY • UI loaded"
status.TextColor3 = Color3.fromRGB(100, 210, 165)
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = body

local function refresh(feature)
    local data = states[feature.name]
    data.button.Text = feature.name .. "   " .. (data.enabled and "ON" or "OFF")
    data.button.BackgroundColor3 = data.enabled
        and Color3.fromRGB(28, 105, 79)
        or Color3.fromRGB(35, 40, 57)

    data.status.Text = data.enabled and "ENABLED" or "DISABLED"
    data.status.TextColor3 = data.enabled
        and Color3.fromRGB(100, 230, 170)
        or Color3.fromRGB(140, 148, 165)
end

for index, feature in ipairs(features) do
    states[feature.name] = {
        enabled = false
    }

    local y = 30 + (index - 1) * 43

    local button = makeButton(
        body,
        feature.name .. "   OFF",
        UDim2.new(0.68, -4, 0, 36),
        UDim2.fromOffset(0, y)
    )

    local stateLabel = Instance.new("TextLabel")
    stateLabel.Size = UDim2.new(0.32, 0, 0, 36)
    stateLabel.Position = UDim2.new(0.68, 4, 0, y)
    stateLabel.BackgroundTransparency = 1
    stateLabel.Text = "DISABLED"
    stateLabel.TextColor3 = Color3.fromRGB(140, 148, 165)
    stateLabel.Font = Enum.Font.Gotham
    stateLabel.TextSize = 9
    stateLabel.Parent = body

    states[feature.name].button = button
    states[feature.name].status = stateLabel

    button.Activated:Connect(function()
        states[feature.name].enabled =
            not states[feature.name].enabled

        refresh(feature)

        status.Text = feature.name
            .. (states[feature.name].enabled
                and " selected ON"
                or " selected OFF")
    end)

    refresh(feature)
end

-- Drag panel using mouse or touch
local dragging = false
local dragInput
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
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

local minimized = false

minimize.Activated:Connect(function()
    minimized = not minimized
    body.Visible = not minimized
    frame.Size = minimized
        and UDim2.fromOffset(280, 46)
        or UDim2.fromOffset(280, 290)
    minimize.Text = minimized and "+" or "—"
end)

close.Activated:Connect(function()
    gui:Destroy()
end)

print("[UrbanReloadHub] UI loaded")
