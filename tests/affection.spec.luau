local ReplicatedStorage = game:GetService("ReplicatedStorage")

local JestGlobals = require(ReplicatedStorage.DevPackages.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

local Affection = require(ReplicatedStorage.Shared.domain.Affection)
local Care = require(ReplicatedStorage.Shared.domain.Care)
local Health = require(ReplicatedStorage.Shared.domain.Health)
local Lifecycle = require(ReplicatedStorage.Shared.domain.Lifecycle)
local Pedigree = require(ReplicatedStorage.Shared.domain.Pedigree)
local Pet = require(ReplicatedStorage.Shared.domain.Pet)

local function founderPedigree()
	return Pedigree.new({
		lineageId = "lineage-affection-001",
		generation = 0,
		founderPetId = "pet-affection-001",
	})
end

describe("Persistent affection", function()
	it("defaults to zero and validates persisted affection", function()
		expect(Affection.new()).toBe(0)
		expect(Affection.new(0.65)).toBe(0.65)

		local negativeOk = pcall(function()
			Affection.new(-0.01)
		end)
		local aboveOneOk = pcall(function()
			Affection.new(1.01)
		end)
		local infiniteOk = pcall(function()
			Affection.new(math.huge)
		end)

		expect(negativeOk).toBe(false)
		expect(aboveOneOk).toBe(false)
		expect(infiniteOk).toBe(false)
	end)

	it("accumulates deterministic bond without exceeding the normalized cap", function()
		local affection = Affection.increase(Affection.new(0.4), 0.25)
		local capped = Affection.increase(affection, 1)

		expect(affection).toBe(0.65)
		expect(capped).toBe(1)
	end)

	it("keeps persistent affection separate from momentary care affection", function()
		local care = Care.new({
			affection = 0.2,
		})
		local pet = Pet.new(
			"pet-affection-001",
			founderPedigree(),
			nil,
			nil,
			care,
			nil,
			nil,
			0.7
		)

		expect(pet.careState.affection).toBe(0.2)
		expect(Pet.getAffection(pet)).toBe(0.7)

		local cared = Pet.withCareState(
			pet,
			Care.new({
				affection = 1,
			})
		)

		expect(cared.careState.affection).toBe(1)
		expect(Pet.getAffection(cared)).toBe(0.7)
	end)

	it("grows bond immutably without rewriting care, pedigree or identity", function()
		local pet = Pet.new("pet-affection-001", founderPedigree())
		local bonded = Pet.gainAffection(pet, 0.3)

		expect(Pet.getAffection(pet)).toBe(0)
		expect(Pet.getAffection(bonded)).toBe(0.3)
		expect(bonded.id).toBe(pet.id)
		expect(bonded.pedigree).toBe(pet.pedigree)
		expect(bonded.careState).toBe(pet.careState)
		expect(bonded.healthState).toBe(pet.healthState)
		expect(bonded.soulbound).toBe(pet.soulbound)
	end)

	it("preserves persistent affection across lifecycle and health transitions", function()
		local pet = Pet.new(
			"pet-affection-001",
			founderPedigree(),
			nil,
			nil,
			nil,
			nil,
			nil,
			0.8
		)
		local adult = Pet.withLifecycle(pet, Lifecycle.advance(pet.lifecycle, "adult"))
		local healthy = Pet.withHealthState(adult, Health.new())

		expect(Pet.getAffection(adult)).toBe(0.8)
		expect(Pet.getAffection(healthy)).toBe(0.8)
	end)
end)
