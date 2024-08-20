extends State
class_name SebasChase

const RAY_LENGTH = 100.0

var sightline = false
var navigating = false
var destination

@export var enemy: CharacterBody3D
@export var move_speed := 5
@export var player: CharacterBody3D

func _ready():
	player = get_parent().get_parent().get_parent().get_node("Player")

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
	get_parent().get_parent().get_node("Running").set_visible(true)
	#get_parent().get_parent().get_node("Crawling").get_node("AnimationPlayer").play("mixamo_com")
	get_parent().get_parent().get_node("Running").get_node("AnimationPlayer").play("mixamo_com")
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
		else:
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
				enemy.position = nearest_to_me.position
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
	print("slowing down!")
	move_speed /= 5
	await get_tree().create_timer(1).timeout
	move_speed *= 5
	print("speeding up!")

func _on_cracked_wall_block():
	print("slowing down!")
	move_speed /= 5
	await get_tree().create_timer(1).timeout
	move_speed *= 5
	print("speeding up!")

#this one is for the "crate" object instead of "interactable", we can prob delete one of them and rename the other and be fine
func _on_crate_block():
	print("slowing down!")
	move_speed /= 5
	await get_tree().create_timer(1).timeout
	move_speed *= 5
	print("speeding up!")
