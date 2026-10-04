local Genetics = require(script.Parent.Genetics)
local Lifecycle = require(script.Parent.Lifecycle)
local Pedigree = require(script.Parent.Pedigree)
local Pet = require(script.Parent.Pet)

local Succession = {}

local function assertNonNegativeInteger(value: any, label: string): number
	if type(value) ~= "number" or value ~= value or value == math.huge or value == -math.huge then
		error(("%s must be a finite number"):format(label), 3)
	end

	if value < 0 or math.floor(value) ~= value then
		error(("%s must be a non-negative integer"):format(label), 3)
	end

	return value
end

local function assertPositiveInteger(value: any, label: string): number
	local resolved = assertNonNegativeInteger(value, label)

	if resolved == 0 then
		error(("%s must be greater than zero"):format(label), 3)
	end

	return resolved
end

function Succession.deriveGeneticSeed(successionSeed: number, successorOrdinal: number): number
	local resolvedSeed = assertNonNegativeInteger(successionSeed, "Succession seed")
	local resolvedOrdinal = assertPositiveInteger(successorOrdinal, "Successor ordinal")

	return resolvedSeed + resolvedOrdinal - 1
end

function Succession.createSuccessor(
	parent: Pet.Pet,
	successorId: string,
	successionSeed: number,
	successorOrdinal: number
): Pet.Pet
	if not Lifecycle.isTerminal(parent.lifecycle) then
		error("Successor can only be generated from an ended pet", 2)
	end

	local geneticSeed = Succession.deriveGeneticSeed(successionSeed, successorOrdinal)
	local advancedPotential = Genetics.advancePotential(parent.geneticPotential, geneticSeed)
	local pedigree = Pedigree.new({
		lineageId = parent.pedigree.lineageId,
		generation = parent.pedigree.generation + 1,
		founderPetId = parent.pedigree.founderPetId,
		parentPetIds = { parent.id },
	})

	return Pet.new(successorId, pedigree, nil, advancedPotential, nil, nil, false, 0)
end

return table.freeze(Succession)
