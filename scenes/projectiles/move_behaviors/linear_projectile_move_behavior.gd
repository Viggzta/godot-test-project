class_name LinearProjectileMoveBehavior extends ProjectileMoveBehavior

var speed: float = 1
var direction: Vector2 = Vector2(0, 1)

func _process(delta: float) -> void:
	var parent: ProjectileBase = get_parent()
	parent.position += direction * speed * delta
	parent.rotation = atan2(direction.y, direction.x)

func set_move_towards(target: Vector2, speed: float) -> void:
	direction = (target - global_position).normalized()
	self.speed = speed
	var parent: ProjectileBase = get_parent()
	parent.rotation = atan2(direction.y, direction.x)
