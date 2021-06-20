extends Label

# Variables
var frames = 0
var second_counter = 0

# Runs every tick
func _physics_process(_delta):
	if second_counter >= 60:
		second_counter = 0
		self.text = "FPS: " + str(frames)
		frames = 0
	second_counter += 1

# Runs every frame
func _process(_delta):
	frames += 1
