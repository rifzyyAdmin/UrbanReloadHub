-- Urban Reload Hub | LocalScript
-- UI demo for Roblox Studio; no external dependencies.
local Players = game:GetService('Players')
local player = Players.LocalPlayer
local gui = Instance.new('ScreenGui')
gui.Name = 'UrbanReloadHub'
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild('PlayerGui')
local frame = Instance.new('Frame')
frame.Size = UDim2.fromOffset(260, 230)
frame.Position = UDim2.new(0.5, -130, 0.5, -115)
frame.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
frame.Parent = gui
Instance.new('UICorner', frame).CornerRadius = UDim.new(0, 12)
local title = Instance.new('TextLabel')
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = 'URBAN RELOAD HUB'
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame
local features = {'ESP', 'Aimbot', 'Auto Farm'}
local states = {}
for i, feature in ipairs(features) do
    states[feature] = false
    local button = Instance.new('TextButton')
    button.Size = UDim2.new(1, -24, 0, 42)
    button.Position = UDim2.fromOffset(12, 45 + (i - 1) * 49)
    button.BackgroundColor3 = Color3.fromRGB(38, 42, 57)
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = frame
    Instance.new('UICorner', button).CornerRadius = UDim.new(0, 8)
    local function update()
        button.Text = feature .. ': ' .. (states[feature] and 'ON' or 'OFF')
        button.BackgroundColor3 = states[feature] and Color3.fromRGB(35, 125, 95) or Color3.fromRGB(38, 42, 57)
    end
    button.MouseButton1Click:Connect(function()
        states[feature] = not states[feature]
        update()
    end)
    update()
end
local note = Instance.new('TextLabel')
note.Size = UDim2.new(1, -16, 0, 22)
note.Position = UDim2.fromOffset(8, 198)
note.BackgroundTransparency = 1
note.Text = 'UI demo • Toggles only'
note.TextColor3 = Color3.fromRGB(165, 170, 185)
note.Font = Enum.Font.Gotham
note.TextSize = 11
note.Parent = frame
