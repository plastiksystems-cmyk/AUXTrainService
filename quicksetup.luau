-- run this inside the command bar to setup the train service
local ServerScriptService = game:GetService("ServerScriptService")

local Main = Instance.new("Script")
Main.Name = "Main"
Main.Source = [[
local CollectionService = game:GetService("CollectionService")

local TrainOperationService = require(script:FindFirstChild("TrainOperationService"))
local trains = workspace:GetDescendants()

local TAG = "Train"

for _, train : Instance in CollectionService:GetTagged(TAG) do
	if train:IsA("Model") then
		local seat = train:FindFirstChildOfClass("VehicleSeat")
		if not seat then 
			return 
		end
		local throttleConnection = seat:GetPropertyChangedSignal("Throttle"):Connect(TrainOperationService.StartOperations)
		local acConnection
		acConnection = seat.AncestryChanged:Connect(function()
			if seat:IsDescendantOf(workspace) == false then
				throttleConnection:Disconnect()
				acConnection:Disconnect()
			end
		end
	else
		warn(`[TrainService.Main] Non model given train tag: {train:GetFullName()}`)
	end
end
TrainOperationService.StartOperations()
]]
Main.Parent = ServerScriptService

local Module = Instance.new("ModuleScript")
Module.Name = "TrainOperationService"
Module.Source = [[
local TrainService = {}

local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")

local TAG = "Train"

function TrainService.StartOperations()
	for _, train in CollectionService:GetTagged(TAG) do
		if train:IsA("Model") then
			TrainService.Operations(train)
		else
			warn(`[TrainService] Non-model was given train tag! {train:GetFullName()}`)
		end
	end
end

function TrainService.Operations(Train : Model)
	if not Train then return end

	local seat = Train:FindFirstChildOfClass("VehicleSeat")
	if not seat then return end

	local wheels = {}
	for _, inst : Instance in ipairs(Train:GetDescendants()) do
		if inst:IsA("HingeConstraint") and (inst.Name == "WheelL" or inst.Name == "WheelR") then
			inst.ActuatorType = Enum.ActuatorType.Motor
			inst.MotorMaxTorque = math.huge
			table.insert(wheels, inst)
		end
	end

	local tweens = {}
	local maxSpeed = Train:GetAttribute("Speed")
	local reverseSpeed = Train:GetAttribute("ReverseSpeed")
	local targetVelocity = 0

	seat:GetPropertyChangedSignal("Throttle"):Connect(function()
		for _, wheel : HingeConstraint in ipairs(wheels) do
			if wheel.Name == "WheelL" then
				if seat.Throttle == 1 then
					targetVelocity = maxSpeed
				elseif seat.Throttle == -1 then
					targetVelocity = -reverseSpeed
				else
					targetVelocity = 0
				end
			elseif wheel.Name == "WheelR" then
				if seat.Throttle == 1 then
					targetVelocity = -maxSpeed
				elseif seat.Throttle == -1 then
					targetVelocity = reverseSpeed
				else
					targetVelocity = 0
				end	
			end
			if tweens[wheel] then
				tweens[wheel]:Cancel()
			end
			local tween1 = TweenService:Create(wheel, TweenInfo.new(10, Enum.EasingStyle.Quad), {AngularVelocity = targetVelocity})
			tween1:Play()
			tweens[wheel] = tween1
		end
	end)
end

return TrainService

-- PLACE INSIDE OF MAIN SCRIPT
]]
Module.Parent = Main
