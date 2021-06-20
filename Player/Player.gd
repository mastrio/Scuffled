extends KinematicBody2D

# Signal
signal died
signal respawn

# Variables
export var speed = 400
export var gravity = 32
export var jumpforce = 800
export var affected_by_gravity = true
var is_player = true
var respawn_location
var screen_size
var motion = Vector2.ZERO
var movement_direction = "right"
var on_floor = true
var has_double_jumped = false

# Ready
func _ready():
	respawn_location = position
	screen_size = get_viewport_rect().size
	$Sprite.play("Idle")
	$RunningParticles.emitting = false
	$DoubleJumpParticles.show()
	$DoubleJumpParticles.emitting = false
	$JumpLandParticles.hide()
	$JumpLandParticles.emitting = false

# Input
func _input(_event):
	# Jumping / Double Jumping
	if is_on_floor():
		has_double_jumped = false
		on_floor = true
	else:
		on_floor = false
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			print("Jump!")
			motion.y = -jumpforce
			$Sprite.stop()
			$Sprite.play("Jumping")
		elif (!has_double_jumped):
			print("Double Jump!")
			motion.y = -jumpforce
			has_double_jumped = true
			$DoubleJumpParticles.emitting = true
			yield(get_tree().create_timer(0.5), "timeout")
			$DoubleJumpParticles.emitting = false

# Physics Loop
func _physics_process(delta):
	# Left / Right movement
	if Input.is_action_pressed("ui_right"):
		get_node("Sprite").set_flip_h(false)
		#$Sprite.animation = "Walking"
		motion.x = speed
		movement_direction = "right"
	elif Input.is_action_pressed("ui_left"):
		get_node("Sprite").set_flip_h(true)
		#$Sprite.animation = "Walking"
		motion.x = -speed
		movement_direction = "left"
	else:
		$Sprite.animation = "Idle"
		motion.x = lerp(motion.x, 0, 0.25)

	# Sprinting
	if Input.is_key_pressed(KEY_SHIFT):
		speed = 550
		$RunningParticles.emitting = true
	else:
		speed = 400
		$RunningParticles.emitting = false
	
	# Jump Land Particles
	if is_on_floor():
		if (has_double_jumped == true):
			land_particles()
	
	# Gravity
	if (affected_by_gravity == true):
		motion.y += gravity + delta
	motion = move_and_slide(motion, Vector2.UP)
	
	# Die
	if (position.y >= 1000):
		print("You Died!")
		motion.y = 0
		emit_signal("died")
		affected_by_gravity = false
		$Sprite.hide()
		$DoubleJumpParticles.hide()
		var death_particles = preload("res://Player/DeathParticles.tscn")
		var death_particles_instance = death_particles.instance()
		death_particles_instance.position = position
		death_particles_instance.position.y = 900
		get_parent().add_child(death_particles_instance)
		position = respawn_location
		yield(get_tree().create_timer(5), "timeout")
		$Sprite.show()
		$DoubleJumpParticles.show()
		emit_signal("respawn")
		affected_by_gravity = true

func land_particles():
	$JumpLandParticles.restart()
	$JumpLandParticles.emitting = true
	yield(get_tree().create_timer(0.5), "timeout")
	$JumpLandParticles.emitting = false
