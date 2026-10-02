local ReplicatedStorage = game:GetService("ReplicatedStorage")

local JestGlobals = require(ReplicatedStorage.DevPackages.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

local Care = require(ReplicatedStorage.Shared.domain.Care)
local Health = require(ReplicatedStorage.Shared.domain.Health)
local Lifecycle = require(ReplicatedStorage.Shared.domain.Lifecycle)
local Pedigree = require(ReplicatedStorage.Shared.domain.Pedigree)
local Pet = require(ReplicatedStorage.Shared.domain.Pet)

local function founderPedigree()
	return Pedigree.new({
		lineageId = "lineage-soulbound-001",
		generation = 0,
		founderPetId = "pet-founder-soulbound-001",
	})
end

local function descendantPedigree()
	return Pedigree.new({
		lineageId = "lineage-soulbound-001",
		generation = 1,
		founderPetId = "pet-founder-soulbound-001",
		parentPetIds = { "pet-founder-soulbound-001" },
	})
end

describe("Soulbound invariant", function()
	it("defaults regular pets to transferable", function()
		local pet = Pet.new("pet-regular-001", founderPedigree())

		expect(Pet.isSoulbound(pet)).toBe(false)
		expect(Pet.isTransferable(pet)).toBe(true)
		expect(pcall(function()
			Pet.assertTransferable(pet)
		end)).toBe(true)
	end)

	it("blocks transfer for an explicitly soulbound founder", function()
		local pet =
			Pet.new("pet-founder-soulbound-001", founderPedigree(), nil, nil, nil, nil, true)

		expect(Pet.isSoulbound(pet)).toBe(true)
		expect(Pet.isTransferable(pet)).toBe(false)
		expect(pcall(function()
			Pet.assertTransferable(pet)
		end)).toBe(false)
	end)

	it("rejects invalid persisted soulbound values", function()
		local invalidOk = pcall(function()
			Pet.new(
				"pet-invalid-soulbound-001",
				founderPedigree(),
				nil,
				nil,
				nil,
				nil,
				"yes" :: any
			)
		end)

		expect(invalidOk).toBe(false)
	end)

	it("preserves soulbound across domain state transitions", function()
		local pet =
			Pet.new("pet-founder-soulbound-001", founderPedigree(), nil, nil, nil, nil, true)
		local adult = Pet.withLifecycle(pet, Lifecycle.advance(pet.lifecycle, "adult"))
		local cared = Pet.withCareState(
			adult,
			Care.new({
				affection = 0.9,
			})
		)
		local healthy = Pet.withHealthState(cared, Health.new())

		expect(Pet.isSoulbound(adult)).toBe(true)
		expect(Pet.isSoulbound(cared)).toBe(true)
		expect(Pet.isSoulbound(healthy)).toBe(true)
		expect(Pet.isTransferable(healthy)).toBe(false)
	end)

	it("does not inherit soulbound automatically into descendants", function()
		local descendant = Pet.new("pet-descendant-001", descendantPedigree())

		expect(descendant.pedigree.generation).toBe(1)
		expect(Pet.isSoulbound(descendant)).toBe(false)
		expect(Pet.isTransferable(descendant)).toBe(true)
	end)
end)
