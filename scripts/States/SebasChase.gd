extends State
class_name SebasChase

@export var enemy: CharacterBody3D
@export var move_speed := 5.0
@export var player: CharacterBody3D

func Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	enemy.velocity = direction.normalized() * move_speed
	
	
