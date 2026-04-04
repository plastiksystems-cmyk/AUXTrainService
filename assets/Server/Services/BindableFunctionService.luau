local BindableFunctionService = {}

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

function BindableFunctionService.GetTrainOccupant(Train : Model) : Player?
	if not Train then return false end
	
	local Seat = Train:FindFirstChildOfClass("VehicleSeat")
	
	if not Seat then return false end
	
	return Players:GetPlayerFromCharacter(Seat.Occupant.Parent)
end

function BindableFunctionService.GetTrain(Player : Player) : Model?
	for _, Train : Instance in CollectionService:GetTagged("Train") do
		if Train:IsA("Model") then
		
			local Seat = Train:FindFirstChildOfClass("VehicleSeat")
			if not Seat then continue end
		
			local Occupant = Seat.Occupant
			if not Occupant then continue end
			local Character = Occupant.Parent
			local SeatedPlayer = Players:GetPlayerFromCharacter(Character)
		
			if SeatedPlayer ~= Player then continue end
		
			return Train
		else
			error(`[BindableFunctionService.GetTrain] Non model given train tag: {Train:GetFullName()}`)
		end
	end
end

function BindableFunctionService.GetTrainByHeadcode(Headcode : string) : Model?
	for _, Train : Instance in CollectionService:GetTagged("Train") do
		if Train:IsA("Model") then
			local TrainHeadcode = Train:GetAttribute("RAILMAN_HEADCODE")
			if not TrainHeadcode then continue end
			
			if TrainHeadcode ~= Headcode then continue end

			return Train
		else
			error(`[BindableFunctionService.GetTrain] Non model given train tag: {Train:GetFullName()}`)
		end
	end
end

return BindableFunctionService
