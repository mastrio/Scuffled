extends Node2D

func _on_Cave_body_entered(body):
	if (body.is_player == true):
		print("Entered Cave")
		$MapColour.hide()
		$CaveColour.show()

func _on_Cave_body_exited(body):
	if (body.is_player == true):
		print("Exited Cave")
		$CaveColour.hide()
		$MapColour.show()
