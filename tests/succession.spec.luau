local ReplicatedStorage = game:GetService("ReplicatedStorage")

local JestGlobals = require(ReplicatedStorage.DevPackages.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

local Genetics = require(ReplicatedStorage.Shared.domain.Genetics)
local Lifecycle = require(ReplicatedStorage.Shared.domain.Lifecycle)
local Pedigree = require(ReplicatedStorage.Shared.domain.Pedigree)
local Pet = require(ReplicatedStorage.Shared.domain.Pet)
local Succession = require(ReplicatedStorage.Shared.domain.Succession)

local function makeParent(): Pet.Pet
	local parent = Pet.new(
		"pet-founder-001",
		Pedigree.new({
			lineageId = "lineage-succession-001",
			generation = 0,
			founderPetId = "pet-founder-001",
		}),
		nil,
		Genetics.newPotential({
			resilience = 0.4,
			size = 0.5,
		}),
		nil,
		nil,
		true,
		0.8
	)

	local adult = Pet.withLifecycle(parent, Lifecycle.advance(parent.lifecycle, "adult"))
	local senior = Pet.withLifecycle(adult, Lifecycle.advance(adult.lifecycle, "senior"))

	return Pet.withLifecycle(senior, Lifecycle.endLife(senior.lifecycle, "natural"))
end

describe("Deterministic succession", function()
	it("derives stable successor-specific genetic seeds", function()
		expect(Succession.deriveGeneticSeed(40, 1)).toBe(40)
		expect(Succession.deriveGeneticSeed(40, 2)).toBe(41)
		expect(Succession.deriveGeneticSeed(40, 2)).toBe(41)

		local zeroOrdinalOk = pcall(function()
			Succession.deriveGeneticSeed(40, 0)
		end)
		local fractionalSeedOk = pcall(function()
			Succession.deriveGeneticSeed(0.5, 1)
		end)

		expect(zeroOrdinalOk).toBe(false)
		expect(fractionalSeedOk).toBe(false)
	end)

	it("creates the same successor state for the same explicit inputs", function()
		local parent = makeParent()
		local first = Succession.createSuccessor(parent, "pet-successor-001", 0, 1)
		local repeated = Succession.createSuccessor(parent, "pet-successor-001", 0, 1)

		expect(first.id).toBe("pet-successor-001")
		expect(repeated.id).toBe(first.id)
		expect(first.geneticPotential.resilience).toBe(0.45)
		expect(first.geneticPotential.size).toBe(0.5)
		expect(repeated.geneticPotential.resilience).toBe(first.geneticPotential.resilience)
		expect(repeated.geneticPotential.size).toBe(first.geneticPotential.size)
		expect(first.lifecycle.stage).toBe("juvenile")
		expect(first.lifecycle.status).toBe("active")
		expect(first.soulbound).toBe(false)
		expect(first.affection).toBe(0)
	end)

	it("uses successor ordinal to produce deterministic sibling genetic directions", function()
		local parent = makeParent()
		local first = Succession.createSuccessor(parent, "pet-successor-001", 0, 1)
		local second = Succession.createSuccessor(parent, "pet-successor-002", 0, 2)

		expect(first.geneticPotential.resilience).toBe(0.45)
		expect(first.geneticPotential.size).toBe(0.5)
		expect(second.geneticPotential.resilience).toBe(0.4)
		expect(second.geneticPotential.size).toBe(0.55)
	end)

	it("starts the next generation from the ended parent lineage", function()
		local parent = makeParent()
		local successor = Succession.createSuccessor(parent, "pet-successor-001", 0, 1)

		expect(successor.pedigree.lineageId).toBe(parent.pedigree.lineageId)
		expect(successor.pedigree.founderPetId).toBe(parent.pedigree.founderPetId)
		expect(successor.pedigree.generation).toBe(parent.pedigree.generation + 1)
		expect(#successor.pedigree.parentPetIds).toBe(1)
		expect(successor.pedigree.parentPetIds[1]).toBe(parent.id)
	end)

	it("rejects succession before the parent lifecycle has ended", function()
		local active = Pet.new(
			"pet-active-001",
			Pedigree.new({
				lineageId = "lineage-succession-002",
				generation = 0,
				founderPetId = "pet-active-001",
			}),
			nil,
			Genetics.newPotential({
				resilience = 0.4,
			})
		)

		local ok = pcall(function()
			Succession.createSuccessor(active, "pet-successor-invalid", 0, 1)
		end)

		expect(ok).toBe(false)
	end)
end)
