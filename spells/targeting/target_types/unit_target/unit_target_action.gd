class_name UnitTargetAction extends TargetAction

const UNIT_TARGET = preload("res://spells/targeting/target_types/unit_target/unit_target.tscn")

@export var target_allied_units: bool = false
@export var target_enemy_units: bool = false
@export var target_self: bool = false

var _is_targeting: bool = false

func start_target_selection(caster: Unit) -> void:
	_caster = caster
	_is_targeting = true

func _process(_delta: float) -> void:
	if !_is_targeting:
		return
	var tile: Vector2i = _caster.tile_map.get_node_from_global(get_global_mouse_position())
	var target_unit: Unit = _get_unit_at_tile(tile)
	
	if !Input.is_action_pressed("left_click"):
		return
	
	if target_unit == null:
		return
	if !target_self && target_unit == _caster:
		return
	if !target_allied_units && target_unit.team == _caster.team:
		return
	if !target_enemy_units && target_unit.team != _caster.team:
		return

	var unit_target: UnitTarget = UNIT_TARGET.instantiate()
	unit_target.unit = target_unit
	_is_targeting = false
	target_selected.emit(_caster, unit_target)

func _get_unit_at_tile(tile: Vector2i) -> Unit:
	for unit: Unit in Globals.units:
		if unit.tile_map_position == tile:
			return unit
	return null
