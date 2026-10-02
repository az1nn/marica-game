local ReplicatedStorage = game:GetService("ReplicatedStorage")

local JestGlobals = require(ReplicatedStorage.DevPackages.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

local Lifecycle = require(ReplicatedStorage.Shared.domain.Lifecycle)
local LifecycleSimulation = require(ReplicatedStorage.Shared.domain.LifecycleSimulation)
local SimulationTime = require(ReplicatedStorage.Shared.domain.SimulationTime)

local function fakeClock(initialNow: number)
	local currentNow = initialNow
	local clock = {}

	function clock.now(): number
		return currentNow
	end

	function clock.set(nextNow: number)
		currentNow = nextNow
	end

	function clock.advance(delta: number)
		currentNow += delta
	end

	return clock
end

local schedule = table.freeze({
	juvenileSeconds = 10,
	adultSeconds = 20,
	seniorSeconds = 30,
})

describe("Simulation time", function()
	it("uses an injected clock and reports deterministic offline elapsed time", function()
		local clock = fakeClock(1_000)
		local first = SimulationTime.observe(clock, 900)

		expect(first.rawNow).toBe(1_000)
		expect(first.logicalNow).toBe(1_000)
		expect(first.elapsed).toBe(100)

		clock.advance(250)

		local second = SimulationTime.observe(clock, first.logicalNow)

		expect(second.rawNow).toBe(1_250)
		expect(second.logicalNow).toBe(1_250)
		expect(second.elapsed).toBe(250)
	end)

	it("clamps clock rollback so logical time and elapsed never move backwards", function()
		local clock = fakeClock(900)
		local observation = SimulationTime.observe(clock, 1_000)

		expect(observation.rawNow).toBe(900)
		expect(observation.logicalNow).toBe(1_000)
		expect(observation.elapsed).toBe(0)
	end)

	it("catches up across multiple lifecycle stages after an offline gap", function()
		local clock = fakeClock(1_035)
		local observation = SimulationTime.observe(clock, 1_000)
		local lifecycle = LifecycleSimulation.advance(Lifecycle.new(), 1_000, observation.logicalNow, schedule)

		expect(observation.elapsed).toBe(35)
		expect(lifecycle.stage).toBe("senior")
		expect(lifecycle.status).toBe("active")
	end)

	it("can cross natural end of life in one deterministic catch-up", function()
		local clock = fakeClock(1_065)
		local observation = SimulationTime.observe(clock, 1_000)
		local lifecycle = LifecycleSimulation.advance(Lifecycle.new(), 1_000, observation.logicalNow, schedule)

		expect(lifecycle.stage).toBe("senior")
		expect(lifecycle.status).toBe("ended")
		expect(lifecycle.endReason).toBe("natural")
	end)

	it("keeps an already-ended lifecycle terminal during later simulation", function()
		local ended = Lifecycle.endLife(Lifecycle.new(), "health")
		local later = LifecycleSimulation.advance(ended, 1_000, 9_999, schedule)

		expect(later).toBe(ended)
		expect(later.endReason).toBe("health")
	end)

	it("does not create negative age when now is before bornAt", function()
		local lifecycle = LifecycleSimulation.advance(Lifecycle.new(), 2_000, 1_500, schedule)

		expect(lifecycle.stage).toBe("juvenile")
		expect(lifecycle.status).toBe("active")
	end)
end)
