extends Node3D

@export var music : AudioStreamPlayer

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		music.play()
		queue_free()
