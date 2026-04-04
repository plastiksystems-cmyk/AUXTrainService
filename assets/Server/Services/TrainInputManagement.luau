-- © 2026 AuxstarTech
-- OPEN SOURCE, NO ACCREDITATION NEEDED

local TrainInputHandler = {}

local ServerScriptService = game:GetService("ServerScriptService")
local Railman = ServerScriptService["Railman V2"]
local Functions = Railman.Functions
local Services = Railman.Services
local GetTrainOccupant = Functions.GetTrainOccupant
local GetTrain = Functions.GetTrain

local Settings = require(Railman.SettingsHandler)
local Config = Railman.Configuration

Settings.Initialize()

local ExternalService = require(Services.BindableFunctionService)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Events
local InputBegan = Events.InputBegan

local function FindPos(Table : {any}, Value : any)
	for i, v in ipairs(Table) do
		if v ~= Value then continue end
		return i
	end
end

function TrainInputHandler.Execute(Train : Model, ActionName : string)
	if not ActionName then return end
	if ActionName == "Horn" then
		TrainInputHandler.Horn(Train, Train:GetAttribute("HornID"))
	end
end

local Cooldown = {}

function TrainInputHandler.Horn(Train : Model)
	if Cooldown[Train] then return end
	Cooldown[Train] = true
	
	if not Train then return end
	local HornSound
	
	if not Train:FindFirstChild("RAILMAN_HORN_SOUND") then
		HornSound = Config.Default_HornID:Clone()
		HornSound.Name = "RAILMAN_HORN_SOUND"
		HornSound.Parent = Train
	else
		HornSound = Train:FindFirstChild("RAILMAN_HORN_SOUND")
	end
	
	HornSound.Volume = 10
	
	if HornSound.IsPlaying then
		HornSound:Stop()
	end
	HornSound:Play()
	
	local Connection
	if not Connection then
		Connection = Train.Destroying:Connect(function()
			if Cooldown[Train] then
				local Position = FindPos(Cooldown, Train)
				table.remove(Cooldown, Position)
			end
		end)
	end
	
	task.wait(Settings.Defaults.HornCooldown)
	Cooldown[Train] = nil
end

InputBegan.OnServerEvent:Connect(function(Player : Player, ActionName : string)
	local Train = ExternalService.GetTrain(Player)
	if not Train then return end
	
	TrainInputHandler.Execute(Train, ActionName)
end)

return TrainInputHandler
