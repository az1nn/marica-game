export type Stage = "juvenile" | "adult" | "senior"
export type Status = "active" | "ended"
export type EndReason = "natural" | "health"

export type Lifecycle = {
	stage: Stage,
	status: Status,
	endReason: EndReason?,
}

local Lifecycle = {}

local STAGE_ORDER = table.freeze({
	juvenile = 1,
	adult = 2,
	senior = 3,
})

local function assertStage(stage: any)
	if type(stage) ~= "string" or STAGE_ORDER[stage] == nil then
		error("Lifecycle stage is invalid", 3)
	end
end

local function freezeState(stage: Stage, status: Status, endReason: EndReason?): Lifecycle
	return table.freeze({
		stage = stage,
		status = status,
		endReason = endReason,
	}) :: Lifecycle
end

function Lifecycle.new(): Lifecycle
	return freezeState("juvenile", "active", nil)
end

function Lifecycle.advance(current: Lifecycle, nextStage: Stage): Lifecycle
	assertStage(current.stage)
	assertStage(nextStage)

	if current.status ~= "active" then
		error("Ended lifecycle cannot advance", 2)
	end

	local currentIndex = STAGE_ORDER[current.stage]
	local nextIndex = STAGE_ORDER[nextStage]

	if nextIndex ~= currentIndex + 1 then
		error("Lifecycle stages must advance exactly one step", 2)
	end

	return freezeState(nextStage, "active", nil)
end

function Lifecycle.endLife(current: Lifecycle, reason: EndReason): Lifecycle
	assertStage(current.stage)

	if current.status ~= "active" then
		error("Ended lifecycle is terminal", 2)
	end

	if reason ~= "natural" and reason ~= "health" then
		error("Lifecycle end reason is invalid", 2)
	end

	if reason == "natural" and current.stage ~= "senior" then
		error("Natural end of life requires senior stage", 2)
	end

	return freezeState(current.stage, "ended", reason)
end

function Lifecycle.isTerminal(current: Lifecycle): boolean
	return current.status == "ended"
end

return table.freeze(Lifecycle)
