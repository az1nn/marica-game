local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = require(ReplicatedStorage.Shared)

print(("[MaricaGame] server bootstrap: %s / %s"):format(Shared.name, Shared.runtime))
