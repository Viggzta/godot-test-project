extends Node2D

var _finished_animations: int = 0
var _total_animations: int = 2

func _ready() -> void:
	$CPUParticles2D.emitting = true
	$CPUParticles2D2.emitting = true

func _on_cpu_particles_2d_finished() -> void:
	_count_done()


func _on_cpu_particles_2d_2_finished() -> void:
	_count_done()

func _count_done() -> void:
	_finished_animations += 1
	if _finished_animations == _total_animations:
		queue_free()
