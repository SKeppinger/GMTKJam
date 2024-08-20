extends State
class_name SebasChase

const RAY_LENGTH = 100.0

var sightline = false
var navigating = false
var destination

@export var enemy: CharacterBody3D
@export var move_speed := 7
@export var player: CharacterBody3D
@export var animation: AnimationPlayer


func _ready():
	player = get_parent().get_parent().get_parent().get_node("Player")
	animation = player.get_child(1).get_child(0).get_child(0)
	enemy.get_node("Running").set_visible(true)
	enemy.get_node("Running").get_node("AnimationPlayer").play("mixamo_com")

func navigate_to_point(from: Node3D, to: Node3D):
	if from != to:
		navigating = true
		var current = from
		while current and current != to:
			current = current.next
		if current:
			var direction = from.next.global_position - enemy.global_position
			enemy.rotation.y = lerp_angle(enemy.rotation.y, atan2(direction.x, direction.z), 1) 
			enemy.velocity = direction.normalized() * move_speed
		else:
			current = from
			while current and current != to:
				current = current.prev
			if current:
				var direction = from.prev.global_position - enemy.global_position
				enemy.rotation.y = lerp_angle(enemy.rotation.y, atan2(direction.x, direction.z), 1) 
				enemy.velocity = direction.normalized() * move_speed
			else:
				navigating = false
		if enemy.global_position.distance_to(to.global_position) < 1.0:
			navigating = false
	else:
		navigating = false

func Physics_Update(delta: float):
	if not navigating:
		var space_state = enemy.get_world_3d().direct_space_state
		var from = enemy.global_position
		var to = player.global_position
		var query = PhysicsRayQueryParameters3D.create(from, to, enemy.collision_mask)
		var result = space_state.intersect_ray(query)
		if result and result.collider.is_in_group("player") and not navigating:
			sightline = true
			var direction = player.global_position - enemy.global_position
			enemy.rotation.y = lerp_angle(enemy.rotation.y, atan2(direction.x, direction.z), 1) 
			enemy.velocity = direction.normalized() * move_speed
		elif result and not result.collider.is_in_group("player"):
			var path_points = get_tree().get_nodes_in_group("sebas_path")
			var nearest_to_player = path_points[0]
			for point in path_points:
				if point.global_position.distance_to(player.global_position) < nearest_to_player.global_position.distance_to(player.global_position):
					nearest_to_player = point
			var nearest_to_me = path_points[0]
			for point in path_points:
				if point.global_position.distance_to(enemy.global_position) < nearest_to_me.global_position.distance_to(enemy.global_position):
					if point != nearest_to_player:
						nearest_to_me = point
			if sightline:
				sightline = false
				enemy.global_position = nearest_to_me.global_position
			destination = nearest_to_player
			navigate_to_point(nearest_to_me, destination)
	else:
		if destination:
			var path_points = get_tree().get_nodes_in_group("sebas_path")
			var nearest_to_me = path_points[0]
			for point in path_points:
				if point.global_position.distance_to(enemy.global_position) < nearest_to_me.global_position.distance_to(enemy.global_position):
					if point != destination:
						nearest_to_me = point
			navigate_to_point(nearest_to_me, destination)

func _on_interactable_block():
	enemy.get_node("Break").play()
	enemy.get_node("Running").set_visible(false)
	enemy.get_node("Crawling").set_visible(false)
	enemy.get_node("Attacking").set_visible(true)
	enemy.get_node("Attacking").get_node("AnimationPlayer").play("mixamo_com")
	print("slowing down!")
	move_speed /= 5
	await get_tree().create_timer(1).timeout
	enemy.get_node("Attacking").set_visible(false)
	enemy.get_node("Running").set_visible(true)
	move_speed *= 5
	print("speeding up!")

func _on_cracked_wall_block():
	enemy.get_node("Break").play()
	enemy.get_node("Running").set_visible(false)
	enemy.get_node("Crawling").set_visible(false)
	enemy.get_node("Attacking").set_visible(true)
	enemy.get_node("Attacking").get_node("AnimationPlayer").play("mixamo_com")
	print("slowing down!")
	move_speed /= 5
	await get_tree().create_timer(1).timeout
	enemy.get_node("Attacking").set_visible(false)
	enemy.get_node("Running").set_visible(true)
	move_speed *= 5
	print("speeding up!")

#this one is for the "crate" object instead of "interactable", we can prob delete one of them and rename the other and be fine
func _on_crate_block():
	enemy.get_node("Break").play()
	enemy.get_node("Running").set_visible(false)
	enemy.get_node("Crawling").set_visible(false)
	enemy.get_node("Attacking").set_visible(true)
	enemy.get_node("Attacking").get_node("AnimationPlayer").play("mixamo_com")
	print("slowing down!")
	move_speed /= 5
	await get_tree().create_timer(1).timeout
	enemy.get_node("Attacking").set_visible(false)
	enemy.get_node("Running").set_visible(true)
	move_speed *= 5
	print("speeding up!")

func _on_player_death():
	print("Im DEAD!!!!")
	enemy.get_node("Running").set_visible(false)
	enemy.get_node("Crawling").set_visible(false)
	enemy.get_node("Biting").set_visible(true)
	enemy.get_node("Bite").play()
	enemy.get_node("Biting").get_node("AnimationPlayer").play("mixamo_com")
	move_speed = -1
	await get_tree().create_timer(1).timeout
	animation.play("Dying")
	await get_tree().create_timer(3).timeout
	get_tree().reload_current_scene()
