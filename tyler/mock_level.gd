extends Node3D

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = true
		$PauseMenu.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)