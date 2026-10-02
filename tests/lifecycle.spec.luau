local ReplicatedStorage = game:GetService("ReplicatedStorage")

local JestGlobals = require(ReplicatedStorage.DevPackages.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

local Lifecycle = require(ReplicatedStorage.Shared.domain.Lifecycle)
local Pedigree = require(ReplicatedStorage.Shared.domain.Pedigree)
local Pet = require(ReplicatedStorage.Shared.domain.Pet)

local function founderPedigree()
	return Pedigree.new({
		lineageId = "lineage-founder-001",
		generation = 0,
		founderPetId = "pet-founder-001",
	})
end

describe("Lifecycle", function()
	it("starts a new pet as active juvenile state", function()
		local pet = Pet.new("pet-founder-001", founderPedigree())

		expect(pet.lifecycle.stage).toBe("juvenile")
		expect(pet.lifecycle.status).toBe("active")
		expect(pet.lifecycle.endReason).toBeNil()
		expect(Pet.isActive(pet)).toBe(true)
	end)

	it("advances stages deterministically one step at a time", function()
		local juvenile = Lifecycle.new()
		local adult = Lifecycle.advance(juvenile, "adult")
		local senior = Lifecycle.advance(adult, "senior")

		expect(adult.stage).toBe("adult")
		expect(adult.status).toBe("active")
		expect(senior.stage).toBe("senior")
		expect(senior.status).toBe("active")
	end)

	it("rejects skipped and backwards stage transitions", function()
		local juvenile = Lifecycle.new()
		local skipOk = pcall(function()
			Lifecycle.advance(juvenile, "senior")
		end)
		local adult = Lifecycle.advance(juvenile, "adult")
		local backwardsOk = pcall(function()
			Lifecycle.advance(adult, "juvenile")
		end)

		expect(skipOk).toBe(false)
		expect(backwardsOk).toBe(false)
	end)

	it("supports health-driven early end of life and keeps terminal state irreversible", function()
		local ended = Lifecycle.endLife(Lifecycle.new(), "health")
		local advanceAfterEndOk = pcall(function()
			Lifecycle.advance(ended, "adult")
		end)
		local endAgainOk = pcall(function()
			Lifecycle.endLife(ended, "health")
		end)

		expect(ended.stage).toBe("juvenile")
		expect(ended.status).toBe("ended")
		expect(ended.endReason).toBe("health")
		expect(Lifecycle.isTerminal(ended)).toBe(true)
		expect(advanceAfterEndOk).toBe(false)
		expect(endAgainOk).toBe(false)
	end)

	it("allows natural end only after the senior stage", function()
		local juvenile = Lifecycle.new()
		local earlyNaturalEndOk = pcall(function()
			Lifecycle.endLife(juvenile, "natural")
		end)
		local senior = Lifecycle.advance(Lifecycle.advance(juvenile, "adult"), "senior")
		local ended = Lifecycle.endLife(senior, "natural")

		expect(earlyNaturalEndOk).toBe(false)
		expect(ended.status).toBe("ended")
		expect(ended.endReason).toBe("natural")
	end)

	it("updates a frozen Pet by replacement while preserving identity and pedigree", function()
		local pet = Pet.new("pet-founder-001", founderPedigree())
		local adult = Lifecycle.advance(pet.lifecycle, "adult")
		local advancedPet = Pet.withLifecycle(pet, adult)
		local mutationOk = pcall(function()
			local mutable = advancedPet.lifecycle :: any
			mutable.stage = "senior"
		end)

		expect(advancedPet.id).toBe(pet.id)
		expect(advancedPet.pedigree).toBe(pet.pedigree)
		expect(advancedPet.lifecycle.stage).toBe("adult")
		expect(mutationOk).toBe(false)
	end)
end)
