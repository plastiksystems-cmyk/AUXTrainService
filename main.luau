local TrainOperationService = require(script:FindFirstChild("TrainOperationService"))
local workspace1 = game:GetService("Workspace")
local trains = workspace1.Trains:GetChildren()

for _, train : Model in ipairs(trains) do
	local seat = train:FindFirstChildOfClass("VehicleSeat")
	if not seat then 
		return 
	end
	seat:GetPropertyChangedSignal("Throttle"):Connect(TrainOperationService.StartOperations)
end
TrainOperationService.StartOperations()

-- PLACE IN SERVERSCRIPTSERVICE
-- AFTER, CREATE A FOLDER IN WORKSPACE NAMED "Trains" AND PUT THE CLASS 03 IN IT
