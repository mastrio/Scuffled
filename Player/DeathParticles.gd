extends Node2D

func _ready():
	yield(get_tree().create_timer(2), "timeout")
	$Particles.emitting = false
	yield(get_tree().create_timer(1.5), "timeout")
	queue_free()
