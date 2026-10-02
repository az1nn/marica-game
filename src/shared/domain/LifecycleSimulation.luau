local Lifecycle = require(script.Parent.Lifecycle)

export type Schedule = {
	juvenileSeconds: number,
	adultSeconds: number,
	seniorSeconds: number,
}

local LifecycleSimulation = {}

local function assertFiniteNonNegative(value: any, label: string): number
	if type(value) ~= "number" or value ~= value or value == math.huge or value == -math.huge then
		error(("%s must be a finite number"):format(label), 3)
	end

	if value < 0 then
		error(("%s must not be negative"):format(label), 3)
	end

	return value
end

local function assertDuration(value: any, label: string): number
	local duration = assertFiniteNonNegative(value, label)

	if duration <= 0 then
		error(("%s must be greater than zero"):format(label), 3)
	end

	return duration
end

function LifecycleSimulation.advance(current, bornAt: number, now: number, schedule: Schedule)
	if current.status == "ended" then
		return current
	end

	local safeBornAt = assertFiniteNonNegative(bornAt, "bornAt")
	local safeNow = assertFiniteNonNegative(now, "now")
	local juvenileSeconds = assertDuration(schedule.juvenileSeconds, "schedule.juvenileSeconds")
	local adultSeconds = assertDuration(schedule.adultSeconds, "schedule.adultSeconds")
	local seniorSeconds = assertDuration(schedule.seniorSeconds, "schedule.seniorSeconds")

	local age = math.max(0, safeNow - safeBornAt)
	local adultAt = juvenileSeconds
	local seniorAt = juvenileSeconds + adultSeconds
	local naturalEndAt = juvenileSeconds + adultSeconds + seniorSeconds

	local result = current

	if result.stage == "juvenile" and age >= adultAt then
		result = Lifecycle.advance(result, "adult")
	end

	if result.stage == "adult" and age >= seniorAt then
		result = Lifecycle.advance(result, "senior")
	end

	if result.stage == "senior" and age >= naturalEndAt then
		result = Lifecycle.endLife(result, "natural")
	end

	return result
end

return table.freeze(LifecycleSimulation)
