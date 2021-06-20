extends Camera2D

# Variables
onready var player = get_parent().get_node("Player")
var follow_player = true

# On Ready
func _ready():
	$UIstuff/DeathTextBackground/DeathText.hide()
	$UIstuff/DeathTextBackground.hide()

# Process Loop
#func _process(_delta):
#	if (follow_player == true):
#		position = Vector2(player.position.x - 1, player.position.y - 1)

# When the players dies
func _on_Player_died():
	#follow_player = false
	$UIstuff/DeathTextBackground.show()
	$UIstuff/DeathTextBackground/DeathText.show()
	haha_u_ded()

# When the player respawns
func _on_Player_respawn():
	#follow_player = true
	$UIstuff/DeathTextBackground.hide()
	$UIstuff/DeathTextBackground/DeathText.hide()

# haha u ded
func haha_u_ded():
	$UIstuff/DeathTextBackground/DeathText.text = "Haha u ded!\nRespawning in 5"
	yield(get_tree().create_timer(1), "timeout")
	$UIstuff/DeathTextBackground/DeathText.text = "Haha u ded!\nRespawning in 4"
	yield(get_tree().create_timer(1), "timeout")
	$UIstuff/DeathTextBackground/DeathText.text = "Haha u ded!\nRespawning in 3"
	yield(get_tree().create_timer(1), "timeout")
	$UIstuff/DeathTextBackground/DeathText.text = "Haha u ded!\nRespawning in 2"
	yield(get_tree().create_timer(1), "timeout")
	$UIstuff/DeathTextBackground/DeathText.text = "Haha u ded!\nRespawning in 1"
	yield(get_tree().create_timer(1), "timeout")
