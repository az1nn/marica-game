local ReplicatedStorage = game:GetService("ReplicatedStorage")

local JestGlobals = require(ReplicatedStorage.DevPackages.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

local Shared = require(ReplicatedStorage.Shared)

describe("toolchain bootstrap", function()
	it("loads the shared runtime metadata", function()
		expect(Shared.name).toBe("Marica Game")
		expect(Shared.runtime).toBe("Roblox")
	end)
end)
