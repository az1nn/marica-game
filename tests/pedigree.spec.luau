local ReplicatedStorage = game:GetService("ReplicatedStorage")

local JestGlobals = require(ReplicatedStorage.DevPackages.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

local Pedigree = require(ReplicatedStorage.Shared.domain.Pedigree)
local Pet = require(ReplicatedStorage.Shared.domain.Pet)

describe("Pedigree", function()
	it("represents a founder with generation zero and stable lineage metadata", function()
		local pedigree = Pedigree.new({
			lineageId = "lineage-001",
			generation = 0,
			founderPetId = "pet-founder-001",
		})
		local pet = Pet.new("pet-founder-001", pedigree)

		expect(pet.pedigree.lineageId).toBe("lineage-001")
		expect(pet.pedigree.generation).toBe(0)
		expect(pet.pedigree.founderPetId).toBe("pet-founder-001")
		expect(#pet.pedigree.parentPetIds).toBe(0)
	end)

	it("preserves direct parent references for descendants", function()
		local pedigree = Pedigree.new({
			lineageId = "lineage-001",
			generation = 1,
			founderPetId = "pet-founder-001",
			parentPetIds = { "pet-founder-001" },
		})

		expect(pedigree.lineageId).toBe("lineage-001")
		expect(pedigree.generation).toBe(1)
		expect(pedigree.founderPetId).toBe("pet-founder-001")
		expect(pedigree.parentPetIds[1]).toBe("pet-founder-001")
	end)

	it("freezes pedigree metadata and parent references", function()
		local pedigree = Pedigree.new({
			lineageId = "lineage-001",
			generation = 1,
			founderPetId = "pet-founder-001",
			parentPetIds = { "pet-founder-001" },
		})

		local pedigreeMutationOk = pcall(function()
			local mutable = pedigree :: any
			mutable.generation = 99
		end)
		local parentsMutationOk = pcall(function()
			local mutableParents = pedigree.parentPetIds :: any
			mutableParents[1] = "pet-other"
		end)

		expect(pedigreeMutationOk).toBe(false)
		expect(parentsMutationOk).toBe(false)
		expect(pedigree.generation).toBe(1)
		expect(pedigree.parentPetIds[1]).toBe("pet-founder-001")
	end)

	it("rejects impossible generation and direct-parent shapes", function()
		local founderWithParentOk = pcall(function()
			Pedigree.new({
				lineageId = "lineage-001",
				generation = 0,
				founderPetId = "pet-founder-001",
				parentPetIds = { "pet-parent" },
			})
		end)
		local descendantWithoutParentOk = pcall(function()
			Pedigree.new({
				lineageId = "lineage-001",
				generation = 1,
				founderPetId = "pet-founder-001",
			})
		end)
		local duplicateParentsOk = pcall(function()
			Pedigree.new({
				lineageId = "lineage-001",
				generation = 1,
				founderPetId = "pet-founder-001",
				parentPetIds = { "pet-parent", "pet-parent" },
			})
		end)

		expect(founderWithParentOk).toBe(false)
		expect(descendantWithoutParentOk).toBe(false)
		expect(duplicateParentsOk).toBe(false)
	end)
end)
