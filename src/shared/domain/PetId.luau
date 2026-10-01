export type PetId = string
export type Generator = () -> string

local PetId = {}

function PetId.fromString(value: unknown): PetId
	if type(value) ~= "string" then
		error("PetId must be a string", 2)
	end

	if value == "" or string.match(value, "%S") == nil then
		error("PetId must not be empty", 2)
	end

	return value
end

function PetId.new(generate: Generator): PetId
	if type(generate) ~= "function" then
		error("PetId generator must be a function", 2)
	end

	return PetId.fromString(generate())
end

return table.freeze(PetId)
