class_name UnitTargetAction extends TargetAction

const UNIT_TARGET = preload("res://spells/targeting/target_types/unit_target/unit_target.tscn")
const ok_color: Color = Color(0, 1, 0, 0.2)
const bad_color: Color = Color(1, 0, 0, 0.2)

@export var target_allied_units: bool = false
@export var target_enemy_units: bool = false
@export var target_self: bool = false
@export var range: int = 256

var _is_targeting: bool = false
@onready var target_indicator: Line2D = $TargetIndicator

func start_target_selection(caster: Unit) -> void:
	_caster = caster
	_is_targeting = true
	target_indicator.visible = true

func _process(_delta: float) -> void:
	if !_is_targeting:
		return
	target_indicator.points[0] = _caster.global_position
	var mouse_pos: Vector2 = get_global_mouse_position()
	target_indicator.points[1] = mouse_pos
	
	var tile: Vector2i = _caster.tile_map.get_node_from_global(mouse_pos)
	var target_unit: Unit = _get_unit_at_tile(tile)

	if _caster.global_position.distance_to(mouse_pos) > range:
		target_indicator.default_color = bad_color
	else:
		target_indicator.default_color = ok_color

	if target_unit == null:
		return
	if !target_self && target_unit == _caster:
		return
	if !target_allied_units && target_unit.team == _caster.team:
		return
	if !target_enemy_units && target_unit.team != _caster.team:
		return

	target_indicator.points[1] = target_unit.global_position
	
	if _caster.global_position.distance_to(target_unit.global_position) > range:
		target_indicator.default_color = bad_color
		return
	target_indicator.default_color = ok_color
	
	if !Input.is_action_pressed("left_click"):
		return
	
	var unit_target: UnitTarget = UNIT_TARGET.instantiate()
	unit_target.unit = target_unit
	_is_targeting = false
	target_indicator.visible = false
	target_selected.emit(_caster, unit_target)

func _get_unit_at_tile(tile: Vector2i) -> Unit:
	for unit: Unit in Globals.units:
		if unit.tile_map_position == tile:
			return unit
	return null
