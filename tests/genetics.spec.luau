local ReplicatedStorage = game:GetService("ReplicatedStorage")

local JestGlobals = require(ReplicatedStorage.DevPackages.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

local Genetics = require(ReplicatedStorage.Shared.domain.Genetics)
local Lifecycle = require(ReplicatedStorage.Shared.domain.Lifecycle)
local Pedigree = require(ReplicatedStorage.Shared.domain.Pedigree)
local Pet = require(ReplicatedStorage.Shared.domain.Pet)

local function founderPedigree()
	return Pedigree.new({
		lineageId = "lineage-genetics-001",
		generation = 0,
		founderPetId = "pet-genetics-001",
	})
end

describe("Genetic potential and expressed traits", function()
	it("copies and freezes normalized genetic potential", function()
		local source = {
			size = 1,
			resilience = 0.5,
		}
		local potential = Genetics.newPotential(source)

		source.size = 0

		local mutationOk = pcall(function()
			local mutable = potential :: any
			mutable.size = 0
		end)

		expect(potential.size).toBe(1)
		expect(potential.resilience).toBe(0.5)
		expect(mutationOk).toBe(false)
	end)

	it("derives expression deterministically without changing potential", function()
		local potential = Genetics.newPotential({
			size = 1,
			resilience = 0.5,
		})
		local expressed = Genetics.express(potential, {
			size = 0.25,
		})

		expect(expressed.size).toBe(0.25)
		expect(expressed.resilience).toBe(0.5)
		expect(potential.size).toBe(1)
		expect(potential.resilience).toBe(0.5)
	end)

	it("rejects invalid scores and factors for deterministic bounded traits", function()
		local invalidPotentialOk = pcall(function()
			Genetics.newPotential({
				size = 1.01,
			})
		end)
		local invalidFactorOk = pcall(function()
			Genetics.express(
				Genetics.newPotential({
					size = 1,
				}),
				{
					size = -0.1,
				}
			)
		end)
		local unknownTraitOk = pcall(function()
			Genetics.express(
				Genetics.newPotential({
					size = 1,
				}),
				{
					speed = 0.5,
				}
			)
		end)

		expect(invalidPotentialOk).toBe(false)
		expect(invalidFactorOk).toBe(false)
		expect(unknownTraitOk).toBe(false)
	end)

	it("keeps genetic potential stable when a pet receives new expression factors", function()
		local potential = Genetics.newPotential({
			size = 1,
			resilience = 0.5,
		})
		local pet = Pet.new("pet-genetics-001", founderPedigree(), nil, potential)
		local updated = Pet.withExpressionFactors(pet, {
			size = 0.5,
			resilience = 0.25,
		})

		expect(updated.geneticPotential).toBe(pet.geneticPotential)
		expect(updated.geneticPotential.size).toBe(1)
		expect(updated.geneticPotential.resilience).toBe(0.5)
		expect(pet.expressedTraits.size).toBe(1)
		expect(updated.expressedTraits.size).toBe(0.5)
		expect(updated.expressedTraits.resilience).toBe(0.125)
		expect(updated.pedigree).toBe(pet.pedigree)
		expect(updated.lifecycle).toBe(pet.lifecycle)
	end)

	it("preserves genetics when lifecycle changes", function()
		local pet = Pet.new(
			"pet-genetics-001",
			founderPedigree(),
			nil,
			Genetics.newPotential({
				size = 0.5,
			})
		)
		local advanced = Pet.withLifecycle(pet, Lifecycle.advance(pet.lifecycle, "adult"))

		expect(advanced.geneticPotential).toBe(pet.geneticPotential)
		expect(advanced.expressedTraits).toBe(pet.expressedTraits)
	end)
end)
