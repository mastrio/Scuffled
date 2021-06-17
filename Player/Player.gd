extends KinematicBody2D

# Signal
signal on_player_died
signal on_player_respawn

# Variables
export var speed = 300
export var gravity = 32
export var jumpforce = 800
export var rotation_amount = 0.15
export var affected_by_gravity = true
var screen_size
var motion = Vector2.ZERO 

# Ready
func _ready():
	screen_size = get_viewport_rect().size
	$RunningParticles.emitting = false

# Physics Loop
func _physics_process(delta): 
	
	# Left / Right movement
	if Input.is_action_pressed("ui_right"):
		motion.x = speed
		rotate(rotation_amount)
	elif Input.is_action_pressed("ui_left"):
		motion.x = -speed
		rotate(-rotation_amount)
	else:
		motion.x = lerp(motion.x, 0, 0.25)
	
	# Jumping
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motion.y = -jumpforce
	
	# Sprinting
	if Input.is_key_pressed(KEY_SHIFT):
		speed = 600
		rotation_amount = 0.3
		$RunningParticles.emitting = true
	else:
		speed = 300
		$RunningParticles.emitting = false
	
	# Gravity
	if (affected_by_gravity == true):
		motion.y += gravity + delta
	
	motion = move_and_slide(motion, Vector2.UP)
	
	# Die
	if (position.y >= 600):
		print("You Died!")
		motion.y = 0
		$Sprite.hide()
		emit_signal("on_player_died")
		affected_by_gravity = false
		position = Vector2(508, -35)
		yield(get_tree().create_timer(1), "timeout")
		$Sprite.show()
		emit_signal("on_player_respawn")
		affected_by_gravity = true
