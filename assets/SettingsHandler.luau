-- RAILMAN V1.3 © 2026 AuxstarTech
-- OPEN SOURCE, NO ACCREDITATION NEEDED

local Settings = {}

local ServerScriptService = game:GetService("ServerScriptService")
local Railman = ServerScriptService["Railman V2"]
local Configuration = Railman.Configuration

Settings.Defaults = {}
Settings.AllowedTeams = {}

function Settings.Initialize()
	for _, v : Instance in Configuration:GetChildren() do
		if v:IsA("ValueBase") then
			if string.find(v.Name, "^Default_") then
				local ValueName = string.sub(v.Name, 9)
				Settings.Defaults[ValueName] = v.Value
			else
				Settings.Defaults[v.Name] = v.Value
			end
		end
	end
	for _, v in string.split(Configuration.TeamsAllowed.Value, ";") do
		table.insert(Settings.AllowedTeams, v)
	end
end

return Settings
