local ReplicatedStorage = game:GetService("ReplicatedStorage")

local JestGlobals = require(ReplicatedStorage.DevPackages.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

local Care = require(ReplicatedStorage.Shared.domain.Care)
local Genetics = require(ReplicatedStorage.Shared.domain.Genetics)
local Pedigree = require(ReplicatedStorage.Shared.domain.Pedigree)
local Pet = require(ReplicatedStorage.Shared.domain.Pet)

local function founderPedigree()
	return Pedigree.new({
		lineageId = "lineage-care-001",
		generation = 0,
		founderPetId = "pet-care-001",
	})
end

describe("Care state", function()
	it("defaults to fully cared and keeps care immutable", function()
		local care = Care.new()
		local mutationOk = pcall(function()
			local mutable = care :: any
			mutable.hygiene = 0
		end)

		expect(care.hunger).toBe(0)
		expect(care.hygiene).toBe(1)
		expect(care.affection).toBe(1)
		expect(care.energy).toBe(1)
		expect(Care.quality(care)).toBe(1)
		expect(mutationOk).toBe(false)
	end)

	it("validates every measurable need as a normalized score", function()
		local invalidHungerOk = pcall(function()
			Care.new({
				hunger = 1.01,
			})
		end)
		local invalidEnergyOk = pcall(function()
			Care.new({
				energy = -0.01,
			})
		end)

		expect(invalidHungerOk).toBe(false)
		expect(invalidEnergyOk).toBe(false)
	end)

	it("uses the weakest essential need as the care quality", function()
		local care = Care.new({
			hunger = 0.2,
			hygiene = 0.75,
			affection = 0.6,
			energy = 0.9,
		})

		expect(Care.quality(care)).toBe(0.6)
	end)

	it("translates care into deterministic trait-expression factors", function()
		local potential = Genetics.newPotential({
			size = 0.8,
			resilience = 0.5,
		})
		local care = Care.new({
			affection = 0.5,
		})
		local factors = Care.toExpressionFactors(care, potential)

		expect(factors.size).toBe(0.5)
		expect(factors.resilience).toBe(0.5)
	end)

	it("updates pet expression without mutating identity, pedigree or genetic potential", function()
		local pet = Pet.new(
			"pet-care-001",
			founderPedigree(),
			nil,
			Genetics.newPotential({
				size = 0.8,
				resilience = 0.6,
			})
		)
		local neglected = Care.new({
			hunger = 0.4,
			hygiene = 0.7,
			affection = 0.5,
			energy = 0.9,
		})
		local updated = Pet.withCareState(pet, neglected)

		expect(updated.id).toBe(pet.id)
		expect(updated.pedigree).toBe(pet.pedigree)
		expect(updated.lifecycle).toBe(pet.lifecycle)
		expect(updated.geneticPotential).toBe(pet.geneticPotential)
		expect(updated.geneticPotential.size).toBe(0.8)
		expect(updated.expressedTraits.size).toBe(0.4)
		expect(updated.expressedTraits.resilience).toBe(0.3)
		expect(updated.careState.affection).toBe(0.5)
		expect(pet.expressedTraits.size).toBe(0.8)
		expect(pet.careState.affection).toBe(1)
	end)
end)
