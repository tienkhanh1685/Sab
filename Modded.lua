local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local savedPosition = nil
local currentTween = nil

-- 1. Create Main ScreenGui (IgnoreGuiInset ensures it handles the notch better)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileTeleportGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true 
screenGui.Parent = playerGui

-- 2. Open/Close Toggle Button (Crucial for Mobile)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Toggle"
toggleBtn.Size = UDim2.new(0, 100, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 50) -- Top left, below the Roblox icon
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleBtn.BackgroundTransparency = 0.3
toggleBtn.Text = "MENU"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn

-- 3. Main Container Frame (Centered for Mobile)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 240)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -120) -- Perfectly Centered
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Visible = false -- Hidden by default
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.Parent = mainFrame

-- Helper Function for Buttons
local function createBtn(name, text, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 170, 0, 45)
    btn.Position = UDim2.new(0.5, 0, 0, yPos)
    btn.AnchorPoint = Vector2.new(0.5, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = mainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local saveBtn = createBtn("Save", "SAVE POSITION", 50, Color3.fromRGB(0, 120, 215))
local tpBtn   = createBtn("TP", "TELEPORT", 110, Color3.fromRGB(40, 180, 100))
local stopBtn = createBtn("Stop", "STOP", 170, Color3.fromRGB(200, 50, 50))

--- LOGIC ---

-- Toggle Visibility
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Function to get HumanoidRootPart safely
local function getHRP()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

saveBtn.MouseButton1Click:Connect(function()
    local hrp = getHRP()
    if hrp then
        savedPosition = hrp.Position
        saveBtn.Text = "SAVED!"
        task.wait(1)
        saveBtn.Text = "SAVE POSITION"
    end
end)

tpBtn.MouseButton1Click:Connect(function()
    local hrp = getHRP()
    if hrp and savedPosition then
        if currentTween then currentTween:Cancel() end
        currentTween = TweenService:Create(hrp, TweenInfo.new(1), {CFrame = CFrame.new(savedPosition)})
        currentTween:Play()
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    if currentTween then currentTween:Cancel() end
end)
