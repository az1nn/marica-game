local Workspace = game:GetService("Workspace")

local RobloxClock = {}

function RobloxClock.now(): number
	return Workspace:GetServerTimeNow()
end

return table.freeze(RobloxClock)
