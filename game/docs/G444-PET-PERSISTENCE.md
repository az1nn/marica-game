# G444 — Persisted Animal Aggregate

G444 restores validated G440 v1 pets into typed MaricaPet objects, retaining pedigree, lifecycle including terminal archived parents, expressed traits as persisted (never recalculated from current care), health, affection and soulbound. The adapter serializes detached snapshots and revalidates full ancestry and succession-event cross-record constraints. Schema admission delegates to G443; save-on-disk delegates to G442. Invalid/future schema or inconsistent records fail closed; no founder is generated implicitly.

Independent runner: 12 cases (empty, founder, archived succession pair, detachment, bad revision, future version, missing pedigree, ID mismatch, founder bond invariant, health drift, historical expressed traits, actual SaveStore disk roundtrip) and QA GOOD→BAD→RESTORE. G445 marker replay, G446 restart, G447 offline elapsed and visual runtime are separate gates.
