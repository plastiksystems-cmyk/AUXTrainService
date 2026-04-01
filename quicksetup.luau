-- run this inside the command bar to setup the train service
-- Credits: highzpeedtrain

local ServerScriptService = game:GetService("ServerScriptService")

local Main = Instance.new("Script")
Main.Name = "Loader"
Main.Source = [[
-- © 2026 mcborsh.org
-- OPEN SOURCE, NO ACCREDITATION NEEDED

local CollectionService = game:GetService("CollectionService")

local ServicesFolder = script.Parent:FindFirstChild("Services") :: Folder
if not ServicesFolder then
    error("Services folder not found!")
end

local TrainServiceModule = ServicesFolder:FindFirstChild("TrainOperationService") :: ModuleScript
if not TrainServiceModule then
    error("TrainOperationService module not found!")
end

local TrainOperationService = require(TrainServiceModule)

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
			if not seat:IsDescendantOf(workspace) then
				throttleConnection:Disconnect()
				acConnection:Disconnect()
			end
		end)
	else
		warn(`[TrainService.Main] Non model given train tag: {train:GetFullName()}`)
	end
end
TrainOperationService.StartOperations()
]]
Main.Parent = ServerScriptService

local Services = Instance.new("Folder")
Services.Parent = ServerScriptService

local Module = Instance.new("ModuleScript")
Module.Parent = Services
Module.Name = "TrainOperationService"
Module.Source = [[
-- © 2026 mcborsh.org
-- OPEN SOURCE, NO ACCREDITATION NEEDED

local TrainService = {}

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
			inst.MotorMaxAcceleration = math.huge
			table.insert(wheels, inst)
		end
	end

	local maxSpeed = Train:GetAttribute("Speed")
	local reverseSpeed = Train:GetAttribute("ReverseSpeed") or -30
	local targetVelocity = 0

	task.spawn(function()
		while seat.Parent do
			if seat.Throttle == 1 then
				targetVelocity += 1
			elseif seat.Throttle == -1 then
				targetVelocity -= 1
			end

			for _, wheel in ipairs(wheels) do
				if wheel.Name == "WheelL" then
					wheel.AngularVelocity = targetVelocity
				else
					wheel.AngularVelocity = -targetVelocity
				end
			end

			task.wait(0.05)
		end
	end)
end

return TrainService

-- PLACE INSIDE OF "Services" FOLDER
]]
