# G445 Durable Succession

The G440 event ledger stores one immutable marker per terminal parent. Existing marker returns the same persisted two children without save; absent marker generates exactly two and commits marker plus both children in one G442 atomic revision. Conflicts fail closed. G446 restart and clock rollback and G447 offline catch-up are separate tasks.
