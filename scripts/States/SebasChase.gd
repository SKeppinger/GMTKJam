extends State
class_name SebasChase

@export var enemy: CharacterBody3D
@export var move_speed := 5
@export var player: CharacterBody3D

func Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	enemy.velocity = direction.normalized() * move_speed

func _on_interactable_block():
	print("slowing down!")
	move_speed /= 2
	await get_tree().create_timer(2).timeout
	move_speed *= 2
	print("speeding up!")

func _on_cracked_wall_block():
	print("slowing down!")
	move_speed /= 2
	await get_tree().create_timer(2).timeout
	move_speed *= 2
	print("speeding up!")

#this one is for the "crate" object instead of "interactable", we can prob delete one of them and rename the other and be fine
func _on_interactable_2_block():
	print("slowing down!")
	move_speed /= 2
	await get_tree().create_timer(2).timeout
	move_speed *= 2
	print("speeding up!")
