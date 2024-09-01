class_name NoTargetAction extends TargetAction

const NO_TARGET = preload("res://spells/targeting/target_types/no_target/no_target.tscn")

func start_target_selection(caster: Unit) -> void:
	var no_target: NoTarget = NO_TARGET.instantiate()
	target_selected.emit(_caster, no_target)
