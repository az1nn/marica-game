local PetId = require(script.Parent.PetId)

export type Pet = {
	id: string,
}

local Pet = {}

function Pet.new(id: string): Pet
	local validatedId = PetId.fromString(id)

	return table.freeze({
		id = validatedId,
	}) :: Pet
end

function Pet.getId(pet: Pet): string
	return pet.id
end

return table.freeze(Pet)
