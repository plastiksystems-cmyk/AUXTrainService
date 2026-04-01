-- © 2026 AuxstarTech
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