extends Camera2D

# Variables
onready var player = get_parent().get_node("Player")
var follow_player = true

# Process Loop
func _process(delta):
	if (follow_player == true):
		position = Vector2(player.position.x - 1, player.position.y - 1)

func _on_player_died():
	follow_player = false

func _on_player_respawn():
	follow_player = true
