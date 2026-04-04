local TrainSecurityService = {}

local Players = game:GetService("Players")

local Attempts = {}

local AuthorizedTeams = {
	"Example team 1",
	"Example team 2"
}

function TrainSecurityService.IsAuthorized(Player : Player) : boolean
	for _, team in AuthorizedTeams do
		if Player.Team and team == Player.Team.Name then
			return true
		end
	end
	return false
end

function TrainSecurityService.GetAttemptCount(PlayerName : string) : number
	local PlayerAttempts = 0
	for _, attempt in Attempts do
		if attempt == PlayerName then
			PlayerAttempts += 1
		end
	end
	return PlayerAttempts
end

function TrainSecurityService.Init(Seat : Seat, Player : Player)
	if not Seat or not Player then return end
	
	if not TrainSecurityService.IsAuthorized(Player) then
		local weld = Seat:FindFirstChild("SeatWeld")
		
		if weld and weld:IsA("Weld") then
			task.delay(0.5, function()
				weld:Destroy()
			end)
		end
		
		table.insert(Attempts, Player.Name)
		
		if TrainSecurityService.GetAttemptCount(Player.Name) > 2 then
			Player:Kick("Attempted to enter a seat multiple times which you dont have permission to enter")
		end
	
		if #Attempts > 10 then
			table.remove(Attempts, 1)
		end
	end
end

Players.PlayerRemoving:Connect(function(Player, Reason)
	for Index, Value in Attempts do
		if Value == Player.Name then table.remove(Attempts, Index) end
	end
end)

return TrainSecurityService
