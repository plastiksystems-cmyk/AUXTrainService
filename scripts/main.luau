local CollectionService = game:GetService("CollectionService")

local TrainOperationService = require(script:FindFirstChild("TrainOperationService"))

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
