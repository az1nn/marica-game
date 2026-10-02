export type CareInput = {
	hunger: number?,
	hygiene: number?,
	affection: number?,
	energy: number?,
}

export type CareState = {
	hunger: number,
	hygiene: number,
	affection: number,
	energy: number,
}

local Care = {}

local function assertUnitValue(value: any, label: string): number
	if type(value) ~= "number" or value ~= value or value == math.huge or value == -math.huge then
		error(("%s must be a finite number"):format(label), 3)
	end

	if value < 0 or value > 1 then
		error(("%s must be between 0 and 1"):format(label), 3)
	end

	return value
end

local function resolve(value: number?, defaultValue: number, label: string): number
	if value == nil then
		return defaultValue
	end

	return assertUnitValue(value, label)
end

function Care.new(values: CareInput?): CareState
	local source = values or {}

	return table.freeze({
		hunger = resolve(source.hunger, 0, "Care.hunger"),
		hygiene = resolve(source.hygiene, 1, "Care.hygiene"),
		affection = resolve(source.affection, 1, "Care.affection"),
		energy = resolve(source.energy, 1, "Care.energy"),
	}) :: CareState
end

function Care.quality(state: CareState): number
	local validated = Care.new(state)
	local fed = 1 - validated.hunger

	return math.min(fed, validated.hygiene, validated.affection, validated.energy)
end

function Care.toExpressionFactors(state: CareState, potential: { [string]: number }): { [string]: number }
	local quality = Care.quality(state)
	local factors = {}

	for traitName in pairs(potential) do
		factors[traitName] = quality
	end

	return table.freeze(factors)
end

return table.freeze(Care)
