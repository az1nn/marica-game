local Care = require(script.Parent.Care)

export type Status = "healthy" | "neglected" | "sick" | "critical"
export type Treatment = "basic" | "advanced" | "emergency"

export type HealthInput = {
	neglectHours: number?,
	untreatedHours: number?,
}

export type HealthState = {
	status: Status,
	neglectHours: number,
	untreatedHours: number,
}

export type TreatmentResult = {
	state: HealthState,
	cost: number,
}

local Health = {}

local NEGLECTED_AT_HOURS = 24
local SICK_AT_HOURS = 48
local CRITICAL_AT_HOURS = 72
local TERMINAL_UNTREATED_HOURS = 48
local NEGLECT_QUALITY_THRESHOLD = 0.5
local RECOVERY_QUALITY_THRESHOLD = 0.75

local TREATMENT_REDUCTION = table.freeze({
	basic = 24,
	advanced = 48,
	emergency = 96,
})

local TREATMENT_COST = table.freeze({
	basic = 10,
	advanced = 30,
	emergency = 75,
})

local function assertFiniteNonNegative(value: any, label: string): number
	if type(value) ~= "number" or value ~= value or value == math.huge or value == -math.huge then
		error(("%s must be a finite number"):format(label), 3)
	end

	if value < 0 then
		error(("%s must not be negative"):format(label), 3)
	end

	return value
end

local function resolve(value: number?, defaultValue: number, label: string): number
	if value == nil then
		return defaultValue
	end

	return assertFiniteNonNegative(value, label)
end

local function deriveStatus(neglectHours: number): Status
	if neglectHours >= CRITICAL_AT_HOURS then
		return "critical"
	end

	if neglectHours >= SICK_AT_HOURS then
		return "sick"
	end

	if neglectHours >= NEGLECTED_AT_HOURS then
		return "neglected"
	end

	return "healthy"
end

local function freezeState(neglectHours: number, untreatedHours: number): HealthState
	local status = deriveStatus(neglectHours)
	local resolvedUntreated = untreatedHours

	if status == "healthy" or status == "neglected" then
		resolvedUntreated = 0
	end

	return table.freeze({
		status = status,
		neglectHours = neglectHours,
		untreatedHours = resolvedUntreated,
	}) :: HealthState
end

function Health.new(values: HealthInput?): HealthState
	local source = values or {}
	local neglectHours = resolve(source.neglectHours, 0, "Health.neglectHours")
	local untreatedHours = resolve(source.untreatedHours, 0, "Health.untreatedHours")

	return freezeState(neglectHours, untreatedHours)
end

function Health.advance(state: HealthState, careState: Care.CareState, elapsedHours: number): HealthState
	local current = Health.new(state)
	local elapsed = assertFiniteNonNegative(elapsedHours, "elapsedHours")
	local careQuality = Care.quality(careState)
	local nextNeglect = current.neglectHours

	if careQuality < NEGLECT_QUALITY_THRESHOLD then
		nextNeglect += elapsed
	elseif
		(current.status == "healthy" or current.status == "neglected")
		and careQuality >= RECOVERY_QUALITY_THRESHOLD
	then
		nextNeglect = math.max(0, nextNeglect - elapsed)
	end

	local nextStatus = deriveStatus(nextNeglect)
	local nextUntreated = current.untreatedHours

	if nextStatus == "sick" or nextStatus == "critical" then
		if current.status == "sick" or current.status == "critical" then
			nextUntreated += elapsed
		elseif careQuality < NEGLECT_QUALITY_THRESHOLD then
			nextUntreated += math.max(0, nextNeglect - SICK_AT_HOURS)
		end
	else
		nextUntreated = 0
	end

	return freezeState(nextNeglect, nextUntreated)
end

function Health.treat(state: HealthState, treatment: Treatment): TreatmentResult
	local current = Health.new(state)
	local reduction = TREATMENT_REDUCTION[treatment]
	local cost = TREATMENT_COST[treatment]

	if reduction == nil or cost == nil then
		error("Health treatment is invalid", 2)
	end

	if current.status == "healthy" then
		error("Healthy pet does not require treatment", 2)
	end

	local treatedState = freezeState(math.max(0, current.neglectHours - reduction), 0)

	return table.freeze({
		state = treatedState,
		cost = cost,
	}) :: TreatmentResult
end

function Health.isTerminalRisk(state: HealthState): boolean
	local current = Health.new(state)

	return current.status == "critical" and current.untreatedHours >= TERMINAL_UNTREATED_HOURS
end

return table.freeze(Health)
