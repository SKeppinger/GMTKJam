extends State
class_name SebasChase

@export var enemy: CharacterBody3D
@export var move_speed := 5
@export var player: CharacterBody3D

func Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	enemy.velocity = direction.normalized() * move_speed

func _on_interactable_block():
	move_speed /= 2
	await get_tree().create_timer(2).timeout
	move_speed *= 2
