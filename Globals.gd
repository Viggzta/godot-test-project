extends Node2D

static var tile_size: Vector2 = Vector2(64, 64)

static var units: Array[Unit] = []

static var team_colors: Dictionary = {
	0: Color.DARK_GREEN,
	1: Color.DARK_RED,
}
