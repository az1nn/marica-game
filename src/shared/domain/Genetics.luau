export type GeneticPotential = { [string]: number }
export type ExpressionFactors = { [string]: number }
export type ExpressedTraits = { [string]: number }

local Genetics = {}

local function assertTraitName(value: any, label: string): string
	if type(value) ~= "string" or string.match(value, "^%s*$") ~= nil then
		error(("%s trait name must be a non-empty string"):format(label), 3)
	end

	return value
end

local function assertUnitValue(value: any, label: string): number
	if type(value) ~= "number" or value ~= value or value == math.huge or value == -math.huge then
		error(("%s must be a finite number"):format(label), 3)
	end

	if value < 0 or value > 1 then
		error(("%s must be between 0 and 1"):format(label), 3)
	end

	return value
end

local function copyTraitMap(values: any, label: string): { [string]: number }
	if type(values) ~= "table" then
		error(("%s must be a table"):format(label), 3)
	end

	local copy = {}

	for rawName, rawValue in pairs(values) do
		local traitName = assertTraitName(rawName, label)
		copy[traitName] = assertUnitValue(rawValue, ("%s.%s"):format(label, traitName))
	end

	return table.freeze(copy)
end

function Genetics.newPotential(values: GeneticPotential): GeneticPotential
	return copyTraitMap(values, "Genetic potential") :: GeneticPotential
end

function Genetics.express(
	potential: GeneticPotential,
	factors: ExpressionFactors?
): ExpressedTraits
	local validatedPotential = copyTraitMap(potential, "Genetic potential")
	local validatedFactors = copyTraitMap(factors or {}, "Expression factors")
	local expressed = {}

	for traitName in pairs(validatedFactors) do
		if validatedPotential[traitName] == nil then
			error(("Expression factor references unknown trait %q"):format(traitName), 2)
		end
	end

	for traitName, potentialValue in pairs(validatedPotential) do
		local factor = validatedFactors[traitName]

		if factor == nil then
			factor = 1
		end

		expressed[traitName] = potentialValue * factor
	end

	return table.freeze(expressed) :: ExpressedTraits
end

return table.freeze(Genetics)
