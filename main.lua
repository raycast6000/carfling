local car = game:GetService("Workspace").Vehicles.BinaryProcesssCar; game.StarterGui:SetCore("SendNotification", {Title = "Car fling",Text = "Say /e stop whenever you wanna stop."})
if not car then 
    game.StarterGui:SetCore("SendNotification", {Title = "Car fling",Text = "Please spawn a car."})    
    return
end
local engine; (function() if not car:FindFirstChild("Engine") then print("Truck detected.") engine = car.Truck.Engine else print("Car detected") engine = car.Engine end end)()
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

local MousePart = Instance.new("Part", workspace)

MousePart.Size = Vector3.new(1,1,1)
MousePart.Anchored = false
MousePart.Color = Color3.fromRGB(0,0,0)
MousePart.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
MousePart.CanQuery = false
MousePart.CanCollide = false

--> Disable collision for the mousepart
for _,v in pairs(car:GetDescendants()) do
	if v:isA("BasePart") then
		local NoCollision = Instance.new("NoCollisionConstraint", v)
		NoCollision.Enabled = true
		NoCollision.Part0 = v
		NoCollision.Part1 = MousePart
	end
end

local Attachment0 = Instance.new("Attachment", engine)
local Attachment1 = Instance.new("Attachment", MousePart)

local AlignPosition = Instance.new("AlignPosition", MousePart)

AlignPosition.MaxVelocity = math.huge/9e11
AlignPosition.Attachment0 = Attachment0
AlignPosition.Attachment1 = Attachment1
AlignPosition.Responsiveness = 255

--> Fling thingy
local Gyro = Instance.new("AngularVelocity", engine)

Gyro.AngularVelocity = Vector3.new(20, 0, 0)
Gyro.MaxTorque = math.huge
Gyro.ReactionTorqueEnabled = true
Gyro.Attachment0 = Attachment0
Gyro.Attachment1 = Attachment0

--> Update the mousepart position
loop = game.RunService.RenderStepped:Connect(function()
	MousePart.Position = Mouse.Hit.Position
end)

--> Commands
Player.Chatted:Connect(function(msg)
	if msg == "/e stop" then
		loop:Disconnect()
		MousePart:Destroy()
	end
end)
