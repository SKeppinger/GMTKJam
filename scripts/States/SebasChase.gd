extends State
class_name SebasChase

@export var enemy: CharacterBody3D
@export var move_speed := 5
@export var player: CharacterBody3D

func _ready():
	player = get_parent().get_parent().get_parent().get_node("Player")

func Physics_Update(delta: float):
	get_parent().get_parent().get_node("Crawling").set_visible(true)
	get_parent().get_parent().get_node("Crawling").get_node("AnimationPlayer").play("mixamo_com")
	#get_parent().get_parent().get_node("Running").get_node("AnimationPlayer").play("mixamo_com")
	var direction = player.global_position - enemy.global_position
	enemy.rotation.y = lerp_angle(enemy.rotation.y, atan2(direction.x, direction.z), 1) 
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
