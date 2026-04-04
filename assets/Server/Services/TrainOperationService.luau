local OperationService = {}

local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Railman = ServerScriptService["Railman V2"]
local Settings = require(Railman.SettingsHandler)

local ID = 0

local function GenerateID() : string
	ID += 1
	return `{Settings.Defaults["HeadcodePrefix"]}_{ID}`
end

function OperationService.Initialize(Train : Model) : {HingeConstraint}?
	if not Train then return end
	local IsTrain = nil
	
	for _, tag : any in Train:GetTags() do
		if tag ~= "Train" then continue end
		IsTrain = true
	end
	
	if not IsTrain then return end
	
	local Wheels = {}
	
	for _, Motor : HingeConstraint in ipairs(Wheels) do
		Motor.MotorMaxTorque = 0
	end
	
	for _, v : Instance in ipairs(Train:GetDescendants()) do
		if v:IsA("HingeConstraint") then
			table.insert(Wheels, v)
		end
	end
	
	Train:SetAttribute("RAILMAN_HEADCODE", GenerateID())
	
	return Wheels
end

local Active = {}
local Velocity = {}

function OperationService.Begin(Train : Model, Seat : VehicleSeat, Motors : {HingeConstraint})
	if not Train or not Motors then return end
	if not Seat then Seat = Train:FindFirstChildOfClass("VehicleSeat") end
	
	if Active[Train] then return end
	Active[Train] = true
	
	local Humanoid = Seat.Occupant
	if not Humanoid then return end
	local Character = Humanoid.Parent
	local Player = Players:GetPlayerFromCharacter(Character)
	
	Seat:SetNetworkOwner(Player)
	
	for _, Motor : HingeConstraint in ipairs(Motors) do
		Motor.ActuatorType = Enum.ActuatorType.Motor
		Motor.MotorMaxTorque = math.huge
		Motor.MotorMaxAcceleration = math.huge
	end
	
	Velocity[Train] = 0
	
	local MaxSpeed = Train:GetAttribute("MaxSpeed") or Settings.Defaults.MaxSpeed
	local ReverseSpeed = Train:GetAttribute("ReverseSpeed") or Settings.Defaults.ReverseSpeed	
	local Acceleration = Train:GetAttribute("Acceleration") or Settings.Defaults.Acceleration
	
	task.spawn(function()
		while Seat.Parent do
			if Seat.Throttle == 1 then
				Velocity[Train] += 1 * Acceleration
			elseif Seat.Throttle == -1 then
				Velocity[Train] -= 1 * Acceleration
			else
				if Settings.Defaults.GravityEnabled then
					Velocity[Train] *= 0.98
				end
			end
			
			Velocity[Train] = math.clamp(Velocity[Train], -ReverseSpeed, MaxSpeed)

			for _, Motor : HingeConstraint in ipairs(Motors) do
				if Motor.Name == "WheelL" then
					Motor.AngularVelocity = Velocity[Train]
				elseif Motor.Name == "WheelR" then
					Motor.AngularVelocity = -Velocity[Train]
				end
			end

			task.wait()
		end
		
		Active[Train] = nil
	end)
end

return OperationService
