class_name Unit extends Node2D

signal move_step_completed()
signal spell_added(spell: Spell)
signal spell_removed(spell: Spell)

const FIRE_BOLT_SPELL = preload("res://spells/fire_bolt/fire_bolt_spell.tscn")
const Direction = preload("res://scripts/enums.gd").Direction

var speed: float = 32.0
var can_move: bool = true
var start_position: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var move_step: float = 0.0
var move_step_factor: float = 5 # 1/move_step_factor=time_needed_for_movement_in_seconds
var is_moving: bool = false

var spells: Array[Spell]

var _tile_map_position: Vector2i = SquareTileMap.TILE_NOT_FOUND
var tile_map_position: Vector2i:
	get:
		return _tile_map_position
	set(value):
		tile_map.set_occupied(_tile_map_position, false)
		tile_map.set_occupied(value, true)
		_tile_map_position = value

@export var team: int = 0
var _move_queue: Array[Vector2i] = []

@export var tile_map: SquareTileMap

func _init():
	start_position = position
	target_position = position

func _ready() -> void:
	tile_map_position = tile_map.get_node_from_global(global_position)
	var fire_bolt_spell: FireBoltSpell = FIRE_BOLT_SPELL.instantiate()
	add_spell(fire_bolt_spell)
	
func add_spell(spell: Spell) -> void:
	spells.append(spell)
	spell_added.emit(spell)

func _move(direction: Direction) -> void:
	if !can_move:
		# Do nothing
		return

	var performed_move: bool = false

	if direction == Direction.UP && tile_map.can_move(tile_map_position + Vector2i(0, -1)):
		tile_map_position += Vector2i(0, -1)
		target_position = position + Vector2(0, -Globals.tile_size.y)
		performed_move = true
	if direction == Direction.DOWN && tile_map.can_move(tile_map_position + Vector2i(0, 1)):
		tile_map_position += Vector2i(0, 1)
		target_position = position + Vector2(0, Globals.tile_size.y)
		performed_move = true
	if direction == Direction.LEFT && tile_map.can_move(tile_map_position + Vector2i(-1, 0)):
		tile_map_position += Vector2i(-1, 0)
		target_position = position + Vector2(-Globals.tile_size.y, 0)
		performed_move = true
	if direction == Direction.RIGHT && tile_map.can_move(tile_map_position + Vector2i(1, 0)):
		tile_map_position += Vector2i(1, 0)
		target_position = position + Vector2(Globals.tile_size.y, 0)
		performed_move = true

	if !performed_move:
		return

	can_move = false
	start_position = position
	is_moving = true

func _move_process(delta: float) -> void:
	if !is_moving:
		return

	move_step = clampf(move_step + (delta * move_step_factor), 0.0, 1.0)
	var move_step_interpolated: float = _custom_interpolated_move(move_step)

	position = start_position + ((target_position - start_position) * move_step_interpolated)
	if move_step == 1.0:
		can_move = true
		is_moving = false
		move_step = 0
		move_step_completed.emit()

func _custom_interpolated_move(step: float) -> float:
	return Interpolation.mix(
		Interpolation.smooth_start(step),
		Interpolation.smooth_stop4(step),
		step)

func _process(_delta: float) -> void:
	pass

func move_from_queue(path: Array[Vector2i]) -> void:
	_move_queue = path
	_on_move_step_completed()

func _physics_process(delta: float) -> void:
	_move_process(delta)

func _on_move_step_completed() -> void:
	if len(_move_queue) != 0:
		_move_queue.remove_at(0)
	if len(_move_queue) != 0:
		var next_move: Vector2i = _move_queue[0]
		var direction: Direction = _to_direction(next_move - tile_map_position)
		_move(direction)

func _to_direction(vec: Vector2i) -> Direction:
	if vec.x < 0:
		return Direction.LEFT
	if vec.x > 0:
		return Direction.RIGHT
	if vec.y < 0:
		return Direction.UP
	return Direction.DOWN # Default to down
