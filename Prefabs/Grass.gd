extends Node2D

# Variables
var animation_to_play = "Idle"

# On ready
func _ready():
	animation_to_play = "Idle"

# Physics Process thing
func _physics_process(_delta):
	$".".play()
	$".".animation = animation_to_play

# Left trigger
func _on_Left_body_entered(body):
	if (body.is_player):
		animation_to_play = "WaveRight"
		$Right.position.y -= 10000

# Right trigger
func _on_Right_body_entered(body):
	if (body.is_player):
		animation_to_play = "WaveLeft"
		$Left.position.y -= 10000

# Grass exited on left side
func _on_Left_body_exited(body):
	if (body.is_player):
		animation_to_play = "Idle"
		$Right.position.y += 10000

# Grass exited on right side
func _on_Right_body_exited(body):
	if (body.is_player):
		animation_to_play = "Idle"
		$Left.position.y += 10000
