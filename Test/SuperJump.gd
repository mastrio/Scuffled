extends KinematicBody2D

# Signal
signal died
signal respawn

# Variables
export var speed = 300
export var gravity = 32
export var jumpforce = 800
export var affected_by_gravity = true
var respawn_location
var screen_size
var motion = Vector2.ZERO
var movement_direction = "right"
var on_floor = true
var launch_amount = 0
var woosh = false

# Ready
func _ready():
	respawn_location = position
	screen_size = get_viewport_rect().size
	$Sprite.animation = "Idle"
	$Sprite.play()
	$RunningParticles.emitting = false
	$SuperJumpParticles.emitting = false

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
	
	# Jumping
	if is_on_floor():
		on_floor = true
		# Jumping
		if Input.is_action_pressed("ui_up"):
			motion.y = -jumpforce
	else:
		on_floor = false
	
	# Super Jump
	if Input.is_key_pressed(KEY_W):
		$SuperJumpParticles.emitting = true
		woosh = true
		launch_amount += 15
		if (launch_amount >= 1500):
			launch_amount = 1500
		$LaunchHeight.text = str(launch_amount / 150)
	else:
		$SuperJumpParticles.emitting = false
		var launch_loop = launch_amount / 10
		while (launch_loop >= 10):
			motion.y = -launch_amount
			launch_loop -= 10
		launch_amount = 0
		$LaunchHeight.text = ""

	# Sprinting
	if Input.is_key_pressed(KEY_SHIFT):
		speed = 600
		$RunningParticles.emitting = true
	else:
		speed = 300
		$RunningParticles.emitting = false
	
	# Gravity
	if (affected_by_gravity == true):
		motion.y += gravity + delta
	motion = move_and_slide(motion, Vector2.UP)
	
	# Die
	if (position.y >= 1500):
		print("You Died!")
		launch_amount = 0
		motion.y = 0
		emit_signal("died")
		affected_by_gravity = false
		$Sprite.hide()
		position = respawn_location
		yield(get_tree().create_timer(5), "timeout")
		$Sprite.show()
		emit_signal("respawn")
		affected_by_gravity = true
	
