local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "GunHub", HidePremium = false, SaveConfig = false, ConfigFolder = "OrionTest"})

OrionLib:MakeNotification({
	Name = "Thanks!",
	Content = "Thanks for executing GunHub! It's a pleasure To see you using this script, I hope you have a great day!",
	Image = "rbxassetid://4483345998",
	Time = 5
})

local PlayerTab = Window:MakeTab({
	Name = "Player",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = PlayerTab:AddSection({
	Name = "Movement"
})

PlayerTab:AddSlider({
	Name = "Walkspeed",
	Min = 16,
	Max = 500,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "WS",
	Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end    
})

PlayerTab:AddSlider({
	Name = "Jump Height",
	Min = 16,
	Max = 500,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "JP",
	Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
	end    
})

local Flying = false
local Speed = 50
local BodyGyro, BodyVelocity
local Input = {W = false, A = false, S = false, D = false}

local UserInputService = game:GetService("UserInputService")

local function updateVelocity()
    local direction = Vector3.new()

    if Input.W then
        direction = direction + workspace.CurrentCamera.CFrame.LookVector
    end
    if Input.S then
        direction = direction - workspace.CurrentCamera.CFrame.LookVector
    end
    if Input.A then
        direction = direction - workspace.CurrentCamera.CFrame.RightVector
    end
    if Input.D then
        direction = direction + workspace.CurrentCamera.CFrame.RightVector
    end

    if direction.Magnitude > 0 then
        direction = direction.Unit * Speed
    else
        direction = Vector3.new(0, 0, 0)
    end

    BodyVelocity.Velocity = direction
end

local function fly()
    if Flying then return end
    Flying = true
    
    local Player = game.Players.LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9e4
    BodyGyro.maxTorque = Vector3.new(9e4, 9e4, 9e4)
    BodyGyro.CFrame = HumanoidRootPart.CFrame
    BodyGyro.Parent = HumanoidRootPart
    
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.maxForce = Vector3.new(9e4, 9e4, 9e4)
    BodyVelocity.Parent = HumanoidRootPart

    game:GetService("RunService").RenderStepped:Connect(function()
        if not Flying then return end
        Character.Humanoid.PlatformStand = true
        BodyGyro.CFrame = workspace.CurrentCamera.CFrame
        updateVelocity()
    end)
end

local function unfly()
    if not Flying then return end
    Flying = false
    
    local Player = game.Players.LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    
    Humanoid.PlatformStand = false
    BodyGyro:Destroy()
    BodyVelocity:Destroy()
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
        Input.W = true
    elseif input.KeyCode == Enum.KeyCode.A then
        Input.A = true
    elseif input.KeyCode == Enum.KeyCode.S then
        Input.S = true
    elseif input.KeyCode == Enum.KeyCode.D then
        Input.D = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
        Input.W = false
    elseif input.KeyCode == Enum.KeyCode.A then
        Input.A = false
    elseif input.KeyCode == Enum.KeyCode.S then
        Input.S = false
    elseif input.KeyCode == Enum.KeyCode.D then
        Input.D = false
    end
end)

PlayerTab:AddToggle({
	Name = "Fly",
	Default = false,
	Callback = function(Value)
		if Value then
			fly()
		else
			unfly()
		end
	end    
})
