extends CharacterBody3D

func _physics_process(delta):
	print(global_position)
	move_and_slide()
