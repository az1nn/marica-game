extends SceneTree

# G421: executable boundary and alias isolation; the fixture runner owns Luau parity.
const LINEAGE_ID = preload("res://src/domain/lineage_id.gd")
const PEDIGREE = preload("res://src/domain/pedigree.gd")


func _initialize() -> void:
    call_deferred("_run_tests")


func _run_tests() -> void:
    if not _test_lineage_generation():
        quit(1)
        return
    if not _test_founder_and_descendant():
        quit(1)
        return
    if not _test_immutable_snapshots():
        quit(1)
        return
    print("MARICA_G421_LINEAGE_PEDIGREE_PASS")
    quit(0)


func _test_lineage_generation() -> bool:
    var generated: Dictionary = LINEAGE_ID.generate(Callable(self, "_fixed_lineage_id"))
    if not generated.get("ok", false) or generated.get("id") != "lineage-fixed":
        push_error("G421 injected lineage ID generator failed")
        return false
    var invalid: Dictionary = LINEAGE_ID.generate(Callable())
    if invalid.get("ok", true) or invalid.get("error") != "LineageId generator must be a function":
        push_error("G421 accepted invalid lineage generator")
        return false
    return true


func _test_founder_and_descendant() -> bool:
    var founder: Dictionary = PEDIGREE.create(
        {"lineageId": "lin", "generation": 0, "founderPetId": "founder"}
    )
    if not founder.get("ok", false):
        push_error("G421 founder creation failed")
        return false
    var founder_record: MaricaPedigree = founder["pedigree"]
    if founder_record.get_generation() != 0 or not founder_record.get_parent_ids().is_empty():
        push_error("G421 founder invariant failed")
        return false
    var child: Dictionary = PEDIGREE.create(
        {
            "lineageId": "lin",
            "generation": 1,
            "founderPetId": "founder",
            "parentPetIds": ["parent-a", "parent-b"]
        }
    )
    if not child.get("ok", false):
        push_error("G421 child pedigree creation failed")
        return false
    var record: MaricaPedigree = child["pedigree"]
    if record.get_founder_pet_id() != "founder" or record.get_lineage_id() != "lin":
        push_error("G421 child lineage/founder drift")
        return false
    if record.get_parent_ids() != ["parent-a", "parent-b"]:
        push_error("G421 child parents not preserved in order")
        return false
    return true


func _test_immutable_snapshots() -> bool:
    var source_parents: Array = ["parent-a"]
    var created: Dictionary = PEDIGREE.create(
        {
            "lineageId": "lineage-A",
            "generation": 1,
            "founderPetId": "founder",
            "parentPetIds": source_parents
        }
    )
    if not created.get("ok", false):
        push_error("G421 immutable snapshot fixture did not create")
        return false
    var record: MaricaPedigree = created["pedigree"]
    source_parents[0] = "mutated-input"
    var snapshot: Dictionary = record.to_snapshot()
    var exported_parents: Array = snapshot["parentPetIds"]
    exported_parents[0] = "mutated-snapshot"
    snapshot["generation"] = 99
    var public_parents: Array[String] = record.get_parent_ids()
    public_parents[0] = "mutated-getter"
    if record.get_generation() != 1 or record.get_parent_ids() != ["parent-a"]:
        push_error("G421 pedigree state aliased caller-owned input or snapshot")
        return false
    if record.to_snapshot()["generation"] != 1:
        push_error("G421 pedigree generation snapshot leaked mutable state")
        return false
    return true


func _fixed_lineage_id() -> String:
    return "lineage-fixed"
