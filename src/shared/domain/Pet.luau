local Genetics = require(script.Parent.Genetics)
local Lifecycle = require(script.Parent.Lifecycle)
local Pedigree = require(script.Parent.Pedigree)
local PetId = require(script.Parent.PetId)

export type Pet = {
	id: string,
	pedigree: Pedigree.Pedigree,
	lifecycle: Lifecycle.Lifecycle,
	geneticPotential: Genetics.GeneticPotential,
	expressedTraits: Genetics.ExpressedTraits,
}

local Pet = {}

function Pet.new(
	id: string,
	pedigree: Pedigree.Pedigree,
	lifecycle: Lifecycle.Lifecycle?,
	geneticPotential: Genetics.GeneticPotential?
): Pet
	local validatedId = PetId.fromString(id)
	local resolvedLifecycle = lifecycle or Lifecycle.new()
	local resolvedPotential = Genetics.newPotential(geneticPotential or {})
	local expressedTraits = Genetics.express(resolvedPotential)

	return table.freeze({
		id = validatedId,
		pedigree = pedigree,
		lifecycle = resolvedLifecycle,
		geneticPotential = resolvedPotential,
		expressedTraits = expressedTraits,
	}) :: Pet
end

function Pet.getId(pet: Pet): string
	return pet.id
end

function Pet.withLifecycle(pet: Pet, lifecycle: Lifecycle.Lifecycle): Pet
	return table.freeze({
		id = pet.id,
		pedigree = pet.pedigree,
		lifecycle = lifecycle,
		geneticPotential = pet.geneticPotential,
		expressedTraits = pet.expressedTraits,
	}) :: Pet
end

function Pet.withExpressionFactors(pet: Pet, factors: Genetics.ExpressionFactors): Pet
	return table.freeze({
		id = pet.id,
		pedigree = pet.pedigree,
		lifecycle = pet.lifecycle,
		geneticPotential = pet.geneticPotential,
		expressedTraits = Genetics.express(pet.geneticPotential, factors),
	}) :: Pet
end

function Pet.isActive(pet: Pet): boolean
	return not Lifecycle.isTerminal(pet.lifecycle)
end

return table.freeze(Pet)
