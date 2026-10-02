export type Clock = {
	now: () -> number,
}

export type Observation = {
	rawNow: number,
	logicalNow: number,
	elapsed: number,
}

local SimulationTime = {}

local function assertFiniteTimestamp(value: any, label: string): number
	if type(value) ~= "number" or value ~= value or value == math.huge or value == -math.huge then
		error(("%s must be a finite number"):format(label), 3)
	end

	if value < 0 then
		error(("%s must not be negative"):format(label), 3)
	end

	return value
end

function SimulationTime.observe(clock: Clock, lastObservedAt: number): Observation
	if type(clock) ~= "table" or type(clock.now) ~= "function" then
		error("Clock must provide now()", 2)
	end

	local previous = assertFiniteTimestamp(lastObservedAt, "lastObservedAt")
	local rawNow = assertFiniteTimestamp(clock.now(), "Clock.now()")
	local logicalNow = math.max(rawNow, previous)

	return table.freeze({
		rawNow = rawNow,
		logicalNow = logicalNow,
		elapsed = logicalNow - previous,
	}) :: Observation
end

return table.freeze(SimulationTime)
