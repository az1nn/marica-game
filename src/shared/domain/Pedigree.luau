local LineageId = require(script.Parent.LineageId)
local PetId = require(script.Parent.PetId)

export type Pedigree = {
	lineageId: string,
	generation: number,
	founderPetId: string,
	parentPetIds: { string },
}

export type Args = {
	lineageId: string,
	generation: number,
	founderPetId: string,
	parentPetIds: { string }?,
}

local Pedigree = {}

local function copyAndValidateParents(parentPetIds: { string }?): { string }
	local parents = {}
	local seen = {}

	for _, rawParentId in ipairs(parentPetIds or {}) do
		local parentId = PetId.fromString(rawParentId)

		if seen[parentId] then
			error("Pedigree parent ids must be unique", 3)
		end

		seen[parentId] = true
		table.insert(parents, parentId)
	end

	if #parents > 2 then
		error("Pedigree supports at most two direct parents", 3)
	end

	return table.freeze(parents)
end

function Pedigree.new(args: Args): Pedigree
	local lineageId = LineageId.fromString(args.lineageId)
	local founderPetId = PetId.fromString(args.founderPetId)
	local generation = args.generation

	if type(generation) ~= "number" or generation < 0 or generation % 1 ~= 0 then
		error("Pedigree generation must be a non-negative integer", 2)
	end

	local parentPetIds = copyAndValidateParents(args.parentPetIds)

	if generation == 0 and #parentPetIds ~= 0 then
		error("Generation zero pedigree must not have parents", 2)
	end

	if generation > 0 and #parentPetIds == 0 then
		error("Descendant pedigree must have at least one direct parent", 2)
	end

	return table.freeze({
		lineageId = lineageId,
		generation = generation,
		founderPetId = founderPetId,
		parentPetIds = parentPetIds,
	}) :: Pedigree
end

return table.freeze(Pedigree)
