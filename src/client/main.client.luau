local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = require(ReplicatedStorage.Shared)

print(("[MaricaGame] client bootstrap: %s / %s"):format(Shared.name, Shared.runtime))
