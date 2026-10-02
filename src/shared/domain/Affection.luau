export type State = number

local Affection = {}

local function assertUnitValue(value: any, label: string): number
	if type(value) ~= "number" or value ~= value or value == math.huge or value == -math.huge then
		error(("%s must be a finite number"):format(label), 3)
	end

	if value < 0 or value > 1 then
		error(("%s must be between 0 and 1"):format(label), 3)
	end

	return value
end

local function assertGain(value: any): number
	if type(value) ~= "number" or value ~= value or value == math.huge or value == -math.huge then
		error("Affection gain must be a finite number", 3)
	end

	if value < 0 then
		error("Affection gain must not be negative", 3)
	end

	return value
end

function Affection.new(value: number?): State
	if value == nil then
		return 0
	end

	return assertUnitValue(value, "Affection")
end

function Affection.increase(state: State, gain: number): State
	local current = Affection.new(state)
	local resolvedGain = assertGain(gain)

	return math.min(1, current + resolvedGain)
end

return table.freeze(Affection)
