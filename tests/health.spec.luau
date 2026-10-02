local ReplicatedStorage = game:GetService("ReplicatedStorage")

local JestGlobals = require(ReplicatedStorage.DevPackages.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

local Care = require(ReplicatedStorage.Shared.domain.Care)
local Genetics = require(ReplicatedStorage.Shared.domain.Genetics)
local Health = require(ReplicatedStorage.Shared.domain.Health)
local Pedigree = require(ReplicatedStorage.Shared.domain.Pedigree)
local Pet = require(ReplicatedStorage.Shared.domain.Pet)

local function founderPedigree()
	return Pedigree.new({
		lineageId = "lineage-health-001",
		generation = 0,
		founderPetId = "pet-health-001",
	})
end

local function severeNeglect()
	return Care.new({
		hunger = 1,
		hygiene = 0,
		affection = 0,
		energy = 0,
	})
end

describe("Health state", function()
	it("defaults to healthy immutable state", function()
		local health = Health.new()
		local mutationOk = pcall(function()
			local mutable = health :: any
			mutable.status = "critical"
		end)

		expect(health.status).toBe("healthy")
		expect(health.neglectHours).toBe(0)
		expect(health.untreatedHours).toBe(0)
		expect(Health.isTerminalRisk(health)).toBe(false)
		expect(mutationOk).toBe(false)
	end)

	it("rejects invalid persisted health durations", function()
		local negativeOk = pcall(function()
			Health.new({
				neglectHours = -1,
			})
		end)
		local infiniteOk = pcall(function()
			Health.new({
				untreatedHours = math.huge,
			})
		end)

		expect(negativeOk).toBe(false)
		expect(infiniteOk).toBe(false)
	end)

	it("keeps normal short absence below the neglect boundary", function()
		local health = Health.advance(Health.new(), severeNeglect(), 12)

		expect(health.status).toBe("healthy")
		expect(health.neglectHours).toBe(12)
		expect(health.untreatedHours).toBe(0)
	end)

	it("progresses deterministically through neglect, sickness and critical state", function()
		local health = Health.new()
		health = Health.advance(health, severeNeglect(), 24)
		expect(health.status).toBe("neglected")

		health = Health.advance(health, severeNeglect(), 24)
		expect(health.status).toBe("sick")
		expect(health.untreatedHours).toBe(0)

		health = Health.advance(health, severeNeglect(), 24)
		expect(health.status).toBe("critical")
		expect(health.untreatedHours).toBe(24)
		expect(Health.isTerminalRisk(health)).toBe(false)

		health = Health.advance(health, Care.new(), 24)
		expect(health.status).toBe("critical")
		expect(health.untreatedHours).toBe(48)
		expect(Health.isTerminalRisk(health)).toBe(true)
	end)

	it("allows good care to recover neglect before sickness but not cure disease", function()
		local neglected = Health.advance(Health.new(), severeNeglect(), 24)
		local recovered = Health.advance(neglected, Care.new(), 24)

		expect(recovered.status).toBe("healthy")
		expect(recovered.neglectHours).toBe(0)

		local sick = Health.advance(Health.new(), severeNeglect(), 48)
		local stillSick = Health.advance(sick, Care.new(), 12)

		expect(stillSick.status).toBe("sick")
		expect(stillSick.neglectHours).toBe(48)
		expect(stillSick.untreatedHours).toBe(12)
	end)

	it("returns explicit treatment cost and deterministic recovery", function()
		local sick = Health.advance(Health.new(), severeNeglect(), 48)
		local basic = Health.treat(sick, "basic")
		local advanced = Health.treat(sick, "advanced")

		expect(basic.cost).toBe(10)
		expect(basic.state.status).toBe("neglected")
		expect(basic.state.neglectHours).toBe(24)
		expect(advanced.cost).toBe(30)
		expect(advanced.state.status).toBe("healthy")
		expect(advanced.state.neglectHours).toBe(0)
	end)

	it("persists health on Pet and ends life only after untreated terminal risk", function()
		local care = severeNeglect()
		local pet = Pet.new(
			"pet-health-001",
			founderPedigree(),
			nil,
			Genetics.newPotential({
				resilience = 0.8,
			}),
			care
		)
		local advanced = Pet.advanceHealth(pet, 96)

		expect(pet.healthState.status).toBe("healthy")
		expect(pet.lifecycle.status).toBe("active")
		expect(advanced.id).toBe(pet.id)
		expect(advanced.pedigree).toBe(pet.pedigree)
		expect(advanced.geneticPotential).toBe(pet.geneticPotential)
		expect(advanced.careState).toBe(pet.careState)
		expect(advanced.healthState.status).toBe("critical")
		expect(Health.isTerminalRisk(advanced.healthState)).toBe(true)
		expect(advanced.lifecycle.status).toBe("ended")
		expect(advanced.lifecycle.endReason).toBe("health")
	end)

	it("applies treatment without rewriting care, genetics or identity", function()
		local pet = Pet.new(
			"pet-health-001",
			founderPedigree(),
			nil,
			Genetics.newPotential({
				resilience = 0.8,
			}),
			severeNeglect()
		)
		local sick = Pet.advanceHealth(pet, 48)
		local treated, cost = Pet.applyTreatment(sick, "advanced")

		expect(sick.healthState.status).toBe("sick")
		expect(treated.healthState.status).toBe("healthy")
		expect(cost).toBe(30)
		expect(treated.id).toBe(sick.id)
		expect(treated.pedigree).toBe(sick.pedigree)
		expect(treated.geneticPotential).toBe(sick.geneticPotential)
		expect(treated.careState).toBe(sick.careState)
		expect(treated.lifecycle).toBe(sick.lifecycle)
	end)
end)
