local Pedigree = require(script.Parent.Pedigree)
local PetId = require(script.Parent.PetId)

export type Pet = {
	id: string,
	pedigree: Pedigree.Pedigree,
}

local Pet = {}

function Pet.new(id: string, pedigree: Pedigree.Pedigree): Pet
	local validatedId = PetId.fromString(id)

	return table.freeze({
		id = validatedId,
		pedigree = pedigree,
	}) :: Pet
end

function Pet.getId(pet: Pet): string
	return pet.id
end

return table.freeze(Pet)
