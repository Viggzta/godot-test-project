class_name FireBoltProjectile extends ProjectileBase

const FIRE_BOLT_PROJECTILE_COLLISION_EFFECT = preload("res://spells/fire_bolt/projectile/fire_bolt_projectile_collision_effect.tscn")

var collision_ignore_team: int

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Unit:
		return
	
	if body.team == collision_ignore_team:
		return
	
	print("Deal damage to ", body)
	var hit_effect: Node2D = FIRE_BOLT_PROJECTILE_COLLISION_EFFECT.instantiate()
	hit_effect.rotation = rotation
	hit_effect.global_position = global_position
	get_parent().add_child(hit_effect)
	queue_free()
