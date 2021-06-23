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
var is_jumping = false
var is_walking = false
var emmiting_run_particles = false
var is_sprinting = false

# Ready
func _ready():
	respawn_location = position
	screen_size = get_viewport_rect().size
	$RunningParticles.emitting = false
	$DoubleJumpParticles.show()
	$DoubleJumpParticles.emitting = false
	$JumpLandParticles.hide()
	$JumpLandParticles.emitting = false
	$Sprite.play("Idle")

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
			is_jumping = true
			yield(get_tree().create_timer(0.01), "timeout")
			$Sprite.play("Jumping")
		elif (!has_double_jumped):
			print("Double Jump!")
			motion.y = -jumpforce
			has_double_jumped = true
			$Sprite.play("Jumping")
			is_jumping = true
			jump_rotation()
			$DoubleJumpParticles.emitting = true
			yield(get_tree().create_timer(0.5), "timeout")
			$DoubleJumpParticles.emitting = false
			is_jumping = false

# Physics Loop
func _physics_process(delta):
	# Left / Right movement
	if Input.is_action_pressed("ui_right"):
		get_node("Sprite").set_flip_h(false)
		$Sprite.play("Walking")
		is_walking = true
		motion.x = speed
		movement_direction = "right"
	elif Input.is_action_pressed("ui_left"):
		get_node("Sprite").set_flip_h(true)
		$Sprite.play("Walking")
		is_walking = true
		motion.x = -speed
		movement_direction = "left"
	else:
		motion.x = lerp(motion.x, 0, 0.25)
		if (is_jumping == false):
			is_walking = false
			$Sprite.play("Idle")

	# Sprinting
	if Input.is_key_pressed(KEY_SHIFT):
		speed = 550
		#$RunningParticles.emitting = true
		emmiting_run_particles = true
		is_sprinting = true
	else:
		speed = 400
		#$RunningParticles.emitting = false
		emmiting_run_particles = false
		is_sprinting = false

	# Jump Land Particles
	if is_on_floor():
		if (has_double_jumped):
			land_particles()
		if (!is_walking || is_jumping):
			$Sprite.play("Idle")
		if (emmiting_run_particles):
			$RunningParticles.emitting = true
	elif (emmiting_run_particles):
		$RunningParticles.emitting = false

	# Gravity
	if (affected_by_gravity):
		motion.y += gravity + delta
	motion = move_and_slide(motion, Vector2.UP)

	# Die if fall off stage lol u bad haha amogus
	if (position.y >= 1000):
		die()

func land_particles():
	$JumpLandParticles.restart()
	$JumpLandParticles.emitting = true
	yield(get_tree().create_timer(0.5), "timeout")
	$JumpLandParticles.emitting = false

# Jump Rotation
func jump_rotation():
	var loop = 30
	while (loop >= 1):
		if (movement_direction == "right"):
			$Sprite.rotate(0.2)
		if (movement_direction == "left"):
			$Sprite.rotate(-0.2)
		loop -= 1
		yield(get_tree().create_timer(0.0025), "timeout")
	$Sprite.rotation = 0

# Die
func die():
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
