local ReplicatedStorage = game:GetService("ReplicatedStorage")

local JestGlobals = require(ReplicatedStorage.DevPackages.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

local Pedigree = require(ReplicatedStorage.Shared.domain.Pedigree)
local Pet = require(ReplicatedStorage.Shared.domain.Pet)
local PetId = require(ReplicatedStorage.Shared.domain.PetId)

local function founderPedigree()
	return Pedigree.new({
		lineageId = "lineage-founder-001",
		generation = 0,
		founderPetId = "pet-founder-001",
	})
end

describe("Pet identity", function()
	it("creates an opaque PetId from an injected generator exactly once", function()
		local calls = 0
		local id = PetId.new(function()
			calls += 1
			return "pet-founder-001"
		end)

		expect(id).toBe("pet-founder-001")
		expect(calls).toBe(1)
	end)

	it("rejects empty or non-string ids", function()
		local emptyOk = pcall(function()
			PetId.fromString("   ")
		end)
		local nonStringOk = pcall(function()
			PetId.fromString(123)
		end)

		expect(emptyOk).toBe(false)
		expect(nonStringOk).toBe(false)
	end)

	it("keeps the id stable for the lifetime of the Pet entity", function()
		local pet = Pet.new("pet-founder-001", founderPedigree())
		local mutationOk = pcall(function()
			local mutable = pet :: any
			mutable.id = "pet-reassigned"
		end)

		expect(Pet.getId(pet)).toBe("pet-founder-001")
		expect(mutationOk).toBe(false)
		expect(Pet.getId(pet)).toBe("pet-founder-001")
	end)
end)
