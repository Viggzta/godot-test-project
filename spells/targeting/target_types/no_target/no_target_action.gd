class_name NoTargetAction extends TargetAction

const NO_TARGET = preload("res://spells/targeting/target_types/no_target/no_target.tscn")

func start_target_selection() -> void:
	var no_target: NoTarget = NO_TARGET.instantiate()
	emit_signal("target_selected", no_target)
