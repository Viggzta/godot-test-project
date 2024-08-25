class_name SquareTileMap extends Node2D

@export var walkable_layer: TileMapLayer

const TILE_NOT_FOUND: Vector2i = Vector2i(-1, -1)
const INFINITY: float = 9999999.9

func can_move(target: Vector2i) -> bool:
	var found_tile: Vector2i = walkable_layer.get_cell_atlas_coords(target)
	return found_tile != TILE_NOT_FOUND

func get_node_from_global(global_pos: Vector2) -> Vector2i:
	return walkable_layer.local_to_map(to_local(global_pos))
	
func _reconstruct_path(came_from: Dictionary, current: Vector2i) -> Array[Vector2i]:
	var total_path: Array[Vector2i] = [ current ]
	while came_from.keys().has(current):
		current = came_from[current]
		total_path.append(current)
	total_path.reverse()
	return total_path

func get_tile_path(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	var open_set: Array[Vector2i] = [ from ]
	var came_from: Dictionary = {}
	var g_score: Dictionary = { from: 0 }
	var f_score: Dictionary = { from: _heuristic(from, to) }
	
	while len(open_set) > 0:
		var current: Vector2i = _get_lowest(open_set, f_score)
		if current == to:
			return _reconstruct_path(came_from, current)
		
		open_set.erase(current)
		for neighbor: Vector2i in _get_neighbours(current):
			var tentative_g_score: float = g_score[current] + 1 # 1 can be replaced with a weight instead
			
			if !g_score.has(neighbor):
				g_score[neighbor] = INFINITY
			
			if tentative_g_score < g_score[neighbor]:
				came_from[neighbor] = current
				g_score[neighbor] = tentative_g_score
				f_score[neighbor] = tentative_g_score + _heuristic(neighbor, to)
				if !open_set.has(neighbor):
					open_set.append(neighbor)
	
	return [] # No path found, sad.

func _heuristic(from: Vector2i, to: Vector2i) -> float:
	var v: Vector2i = to - from
	return abs(v.x) + abs(v.y)

func _get_lowest(sample_set: Array[Vector2i], value_set: Dictionary) -> Vector2i:
	var min_pos: Vector2i = sample_set[0]
	var min_value: float = INFINITY
	for x in sample_set:
		if value_set[x] < min_value:
			min_pos = x
			min_value = value_set[x]
	return min_pos

const _directions_nodes: Array[Vector2i] = [
	Vector2i(-1, 0),
	Vector2i(1, 0),
	Vector2i(0, 1),
	Vector2i(0, -1),
]
func _get_neighbours(node: Vector2i) -> Array[Vector2i]:
	var neighbours: Array[Vector2i] = []
	for n in _directions_nodes:
		var node_plus_n: Vector2i = node + n
		if can_move(node_plus_n):
			neighbours.append(node_plus_n)
	return neighbours
