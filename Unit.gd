extends Node2D

enum Direction {UP = 0, RIGHT = 1, DOWN = 2, LEFT = 3}

var speed: float = 32.0
var can_move: bool = true
var start_position: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var move_step: float = 0.0
var move_step_factor: float = 5 # 1/move_step_factor=time_needed_for_movement_in_seconds
var is_moving: bool = false

func _init():
	start_position = position
	target_position = position

func _move(direction: Direction) -> void:
	if !can_move:
		# Do nothing
		return
	can_move = false
	start_position = position

	if direction == Direction.UP:
		target_position = position + Vector2(0, -Globals.tile_size.y)
	if direction == Direction.DOWN:
		target_position = position + Vector2(0, Globals.tile_size.y)
	if direction == Direction.LEFT:
		target_position = position + Vector2(-Globals.tile_size.y, 0)
	if direction == Direction.RIGHT:
		target_position = position + Vector2(Globals.tile_size.y, 0)

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

func _custom_interpolated_move(step: float) -> float:
	return Interpolation.mix(
		Interpolation.smooth_start(step),
		Interpolation.smooth_stop4(step),
		step)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		_move(Direction.LEFT)
	if Input.is_action_pressed("move_right"):
		_move(Direction.RIGHT)
	if Input.is_action_pressed("move_up"):
		_move(Direction.UP)
	if Input.is_action_pressed("move_down"):
		_move(Direction.DOWN)

func _physics_process(delta: float) -> void:
	_move_process(delta)
