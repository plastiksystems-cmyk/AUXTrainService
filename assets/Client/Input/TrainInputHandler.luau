-- © 2026 AuxstarTech
-- OPEN SOURCE, NO ACCREDITATION NEEDED

local TrainInputHandler = {}

local ContextActionService = game:GetService("ContextActionService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local InputBegan = Events.InputBegan

function TrainInputHandler.Init()
	ContextActionService:BindAction("Horn", TrainInputHandler.Horn, true, Enum.KeyCode.H)
end

function TrainInputHandler.Horn(ActionName : string, InputState : Enum.UserInputState, InputObject : InputObject)
	if InputState == Enum.UserInputState.Begin then
		InputBegan:FireServer(ActionName)
	end
end

return TrainInputHandler
