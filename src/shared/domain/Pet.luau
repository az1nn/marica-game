local Care = require(script.Parent.Care)
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
	careState: Care.CareState,
}

local Pet = {}

function Pet.new(
	id: string,
	pedigree: Pedigree.Pedigree,
	lifecycle: Lifecycle.Lifecycle?,
	geneticPotential: Genetics.GeneticPotential?,
	careState: Care.CareState?
): Pet
	local validatedId = PetId.fromString(id)
	local resolvedLifecycle = lifecycle or Lifecycle.new()
	local resolvedPotential = Genetics.newPotential(geneticPotential or {})
	local resolvedCare = Care.new(careState)
	local expressedTraits = Genetics.express(resolvedPotential, Care.toExpressionFactors(resolvedCare, resolvedPotential))

	return table.freeze({
		id = validatedId,
		pedigree = pedigree,
		lifecycle = resolvedLifecycle,
		geneticPotential = resolvedPotential,
		expressedTraits = expressedTraits,
		careState = resolvedCare,
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
		careState = pet.careState,
	}) :: Pet
end

function Pet.withExpressionFactors(pet: Pet, factors: Genetics.ExpressionFactors): Pet
	return table.freeze({
		id = pet.id,
		pedigree = pet.pedigree,
		lifecycle = pet.lifecycle,
		geneticPotential = pet.geneticPotential,
		expressedTraits = Genetics.express(pet.geneticPotential, factors),
		careState = pet.careState,
	}) :: Pet
end

function Pet.withCareState(pet: Pet, careState: Care.CareState): Pet
	local resolvedCare = Care.new(careState)

	return table.freeze({
		id = pet.id,
		pedigree = pet.pedigree,
		lifecycle = pet.lifecycle,
		geneticPotential = pet.geneticPotential,
		expressedTraits = Genetics.express(
			pet.geneticPotential,
			Care.toExpressionFactors(resolvedCare, pet.geneticPotential)
		),
		careState = resolvedCare,
	}) :: Pet
end

function Pet.isActive(pet: Pet): boolean
	return not Lifecycle.isTerminal(pet.lifecycle)
end

return table.freeze(Pet)
