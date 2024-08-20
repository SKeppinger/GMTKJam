extends Node3D


@export var white: ColorRect

var fading = false

func _process(delta):
	if fading:
		white.color.a += delta * 0.25
		if white.color.a > 1:
			white.color.a = 1
			get_tree().change_scene_to_file("res://zaher/main_menu.tscn")

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		fading = true
