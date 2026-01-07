local TrainOperationService = require(script:FindFirstChild("TrainOperationService"))
local trains = workspace:GetDescendants()

for _, train : Instance in ipairs(trains) do
	if train:IsA("Model") and train:HasTag("Train") then
		local seat = train:FindFirstChildOfClass("VehicleSeat")
		if not seat then 
			return 
		end
		seat:GetPropertyChangedSignal("Throttle"):Connect(TrainOperationService.StartOperations)
	end
end
TrainOperationService.StartOperations()
