export type LineageId = string
export type Generator = () -> string

local LineageId = {}

function LineageId.fromString(value: unknown): LineageId
	if type(value) ~= "string" then
		error("LineageId must be a string", 2)
	end

	if value == "" or string.match(value, "%S") == nil then
		error("LineageId must not be empty", 2)
	end

	return value
end

function LineageId.new(generate: Generator): LineageId
	if type(generate) ~= "function" then
		error("LineageId generator must be a function", 2)
	end

	return LineageId.fromString(generate())
end

return table.freeze(LineageId)
