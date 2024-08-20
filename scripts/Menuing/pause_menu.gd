extends Control

func _on_continue_pressed():
	hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_exit_to_desktop_pressed():
	get_tree().quit()
	
