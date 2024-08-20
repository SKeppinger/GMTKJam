extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://zaher/z.tscn")
	
func _on_credits_pressed():
	get_tree().change_scene_to_file("res//zaher/credits.tscn")
	
func _on_exit_pressed():
	get_tree().quit()
