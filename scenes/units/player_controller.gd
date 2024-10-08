extends Node2D
const CLICK_ANIMATION = preload("res://scenes/utility/click_animation.tscn")
const Direction = preload("res://scripts/enums.gd").Direction

@export var unit: Unit
@export var tile_map: SquareTileMap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		unit._move(Direction.LEFT)
	if Input.is_action_pressed("move_right"):
		unit._move(Direction.RIGHT)
	if Input.is_action_pressed("move_up"):
		unit._move(Direction.UP)
	if Input.is_action_pressed("move_down"):
		unit._move(Direction.DOWN)
	if Input.is_action_just_pressed("right_click"):
		print(get_global_mouse_position())
		var tile: Vector2i = tile_map.get_node_from_global(get_global_mouse_position())
		var tile_click_position: Vector2 = tile_map.get_global_center_from_node(tile)
		var click_animation: Node2D = CLICK_ANIMATION.instantiate()
		click_animation.global_position = tile_click_position
		add_child(click_animation)
		print(tile)
		if tile != SquareTileMap.TILE_NOT_FOUND:
			unit.move_from_queue(tile_map.get_tile_path(unit.tile_map_position, tile))
