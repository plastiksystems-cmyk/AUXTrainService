-- RAILMAN V1.3 © 2026 AuxstarTech
-- OPEN SOURCE, NO ACCREDITATION NEEDED
-- BROUGHT TO YOU BY: Petrulici, highzpeedtrain

-- SERVICE DEFINITIONS! /////////////////////////////////////////////////

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Events
local InputBegan = Events.InputBegan

--///////////////////////////////////////////////////////////////////////

local Railman = script
local Functions = script.Functions

-- EVENTS! //////////////////////////////////////////////////////////////

local GetTrainOccupant = Functions.GetTrainOccupant
local GetTrain = Functions.GetTrain
local GetTrainByHeadcode = Functions.GetTrainByHeadcode

-- SERVICE REQUIRE AND DEFINITIONS! /////////////////////////////////////

local ServicesFolder = script:FindFirstChild("Services") :: Folder?
if not ServicesFolder then
	error("Services folder not found!")
end

local TrainServiceModule = ServicesFolder:FindFirstChild("OperationService") :: ModuleScript?
if not TrainServiceModule then
	error("TrainOperationService module not found!")
end

local TrainSecurityModule = ServicesFolder:FindFirstChild("TrainSecurityService") :: ModuleScript?
if not TrainSecurityModule then
	error("TrainSecurityService module not found!")
end

local TrainInputModule = ServicesFolder:FindFirstChild("TrainInputManagement") :: ModuleScript?
if not TrainInputModule then
	error("TrainInputManagement module not found!")
end

local BindableFunctionModule = ServicesFolder:FindFirstChild("BindableFunctionService") :: ModuleScript?
if not BindableFunctionModule then
	error("BindableFunctionService module not found!")
end

local SettingsModule = Railman:FindFirstChild("SettingsHandler") :: ModuleScript?
if not SettingsModule then
	error("SettingsHandler module not found!")
end

-- SERVICE REQUIRE AND DEFINITIONS!

local OperationService = require(TrainServiceModule)
local TrainSecurityService = require(TrainSecurityModule)
local TrainInputManagement = require(TrainInputModule)
local ExternalService = require(BindableFunctionModule)
local Settings = require(SettingsModule)

local Trains = CollectionService:GetTagged("Train")

-- RUNTIME!

for _, Train : Instance in Trains do
	if Train:IsA("Model") then
		
		local Seat = Train:FindFirstChildOfClass("VehicleSeat")
		if not Seat then continue end
		
		local Occupant
		local Character
		local Player
		
		local Wheels = OperationService.Initialize(Train)
		
		local SeatConnection = Seat.Changed:Connect(function(Property : string)
			if Property == "Throttle" then
				--DO NOTHING
			elseif Property == "Occupant" then
				OperationService.Begin(Train, Seat, Wheels)
				
				if not Settings.Defaults.TeamOnly then return end
				
				Occupant = Seat.Occupant
				
				if not Occupant then return end
				Character = Occupant.Parent
				
				Player = Players:GetPlayerFromCharacter(Character)
				
				TrainSecurityService.Init(Seat, Player)
			end
		end)
		
		Seat.Destroying:Connect(function()
			if SeatConnection then
				SeatConnection:Disconnect()
			end
		end)
		
		GetTrainOccupant.OnInvoke = function()
			ExternalService.GetTrainOccupant(Train)
		end
		
		GetTrain.OnInvoke = function(player : Player)
			ExternalService.GetTrain(player)
		end
		
		GetTrainByHeadcode.OnInvoke = function(Headcode : string)
			ExternalService.GetTrainByHeadcode(Headcode)
		end
		
		local InputConnection = InputBegan.OnServerEvent:Connect(function(player, ActionName)
			if player == Player then
				TrainInputManagement.Execute(Train, ActionName)
			end
		end)
		
		Players.PlayerRemoving:Connect(function(player, reason)
			if InputConnection and player == Player then
				InputConnection:Disconnect()
			end
		end)
	else
		warn(`[TrainService.Main] Non model given train tag: {Train:GetFullName()}`)
	end
end

Settings.Initialize()

print(`{script.Name} DEFAULTS:`)
for i, v in pairs(Settings.Defaults) do
	print(`[{i}]: {v}`)
end