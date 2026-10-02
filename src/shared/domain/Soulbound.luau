export type State = boolean

local Soulbound = {}

function Soulbound.new(value: boolean?): State
	if value == nil then
		return false
	end

	if type(value) ~= "boolean" then
		error("Soulbound state must be a boolean", 2)
	end

	return value
end

function Soulbound.isTransferable(state: State): boolean
	return not Soulbound.new(state)
end

function Soulbound.assertTransferable(state: State)
	if not Soulbound.isTransferable(state) then
		error("Soulbound pet cannot be transferred", 2)
	end
end

return table.freeze(Soulbound)
