class_name FireBoltSpellEffect extends SpellEffect

const FIRE_BOLT_PROJECTILE = preload("res://spells/fire_bolt/projectile/fire_bolt_projectile.tscn")

func start_effect(source: Unit, target: Target):
	var fire_bolt_projectile: ProjectileBase = FIRE_BOLT_PROJECTILE.instantiate()
	fire_bolt_projectile.global_position = source.global_position
	
	if target is UnitTarget:
		if fire_bolt_projectile.move_behavior is LinearProjectileMoveBehavior:
			fire_bolt_projectile.move_behavior.set_move_towards(target.unit.global_position, 1024)
	
	source.add_child(fire_bolt_projectile)
