local Lifecycle = require(script.Parent.Lifecycle)
local Pedigree = require(script.Parent.Pedigree)
local PetId = require(script.Parent.PetId)

export type Pet = {
	id: string,
	pedigree: Pedigree.Pedigree,
	lifecycle: Lifecycle.Lifecycle,
}

local Pet = {}

function Pet.new(id: string, pedigree: Pedigree.Pedigree, lifecycle: Lifecycle.Lifecycle?): Pet
	local validatedId = PetId.fromString(id)
	local resolvedLifecycle = lifecycle or Lifecycle.new()

	return table.freeze({
		id = validatedId,
		pedigree = pedigree,
		lifecycle = resolvedLifecycle,
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
	}) :: Pet
end

function Pet.isActive(pet: Pet): boolean
	return not Lifecycle.isTerminal(pet.lifecycle)
end

return table.freeze(Pet)
