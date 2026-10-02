local Care = require(script.Parent.Care)
local Genetics = require(script.Parent.Genetics)
local Health = require(script.Parent.Health)
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
	healthState: Health.HealthState,
}

local Pet = {}

function Pet.new(
	id: string,
	pedigree: Pedigree.Pedigree,
	lifecycle: Lifecycle.Lifecycle?,
	geneticPotential: Genetics.GeneticPotential?,
	careState: Care.CareState?,
	healthState: Health.HealthState?
): Pet
	local validatedId = PetId.fromString(id)
	local resolvedLifecycle = lifecycle or Lifecycle.new()
	local resolvedPotential = Genetics.newPotential(geneticPotential or {})
	local resolvedCare = Care.new(careState)
	local resolvedHealth = Health.new(healthState)
	local expressedTraits = Genetics.express(
		resolvedPotential,
		Care.toExpressionFactors(resolvedCare, resolvedPotential)
	)

	return table.freeze({
		id = validatedId,
		pedigree = pedigree,
		lifecycle = resolvedLifecycle,
		geneticPotential = resolvedPotential,
		expressedTraits = expressedTraits,
		careState = resolvedCare,
		healthState = resolvedHealth,
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
		healthState = pet.healthState,
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
		healthState = pet.healthState,
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
		healthState = pet.healthState,
	}) :: Pet
end

function Pet.withHealthState(pet: Pet, healthState: Health.HealthState): Pet
	local resolvedHealth = Health.new(healthState)

	return table.freeze({
		id = pet.id,
		pedigree = pet.pedigree,
		lifecycle = pet.lifecycle,
		geneticPotential = pet.geneticPotential,
		expressedTraits = pet.expressedTraits,
		careState = pet.careState,
		healthState = resolvedHealth,
	}) :: Pet
end

function Pet.advanceHealth(pet: Pet, elapsedHours: number): Pet
	if Lifecycle.isTerminal(pet.lifecycle) then
		return pet
	end

	local nextHealth = Health.advance(pet.healthState, pet.careState, elapsedHours)
	local nextLifecycle = pet.lifecycle

	if Health.isTerminalRisk(nextHealth) then
		nextLifecycle = Lifecycle.endLife(nextLifecycle, "health")
	end

	return table.freeze({
		id = pet.id,
		pedigree = pet.pedigree,
		lifecycle = nextLifecycle,
		geneticPotential = pet.geneticPotential,
		expressedTraits = pet.expressedTraits,
		careState = pet.careState,
		healthState = nextHealth,
	}) :: Pet
end

function Pet.applyTreatment(pet: Pet, treatment: Health.Treatment): (Pet, number)
	if Lifecycle.isTerminal(pet.lifecycle) then
		error("Ended pet cannot receive treatment", 2)
	end

	local result = Health.treat(pet.healthState, treatment)
	local treatedPet = Pet.withHealthState(pet, result.state)

	return treatedPet, result.cost
end

function Pet.isActive(pet: Pet): boolean
	return not Lifecycle.isTerminal(pet.lifecycle)
end

return table.freeze(Pet)
