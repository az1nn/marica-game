local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Jest = require(ReplicatedStorage.DevPackages.Jest)
local runCLI = Jest.runCLI
local tests = ServerScriptService.Tests

local status, result = runCLI(tests, {
	ci = true,
	verbose = true,
}, { tests }):awaitStatus()

if status == "Rejected" then
	error(result)
end

if not result.results.success then
	error("Jest tests failed")
end

print("Jest behavioral tests passed")
return {
	success = true,
}
