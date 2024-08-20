extends Node3D

@export var enemy : CharacterBody3D

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		var spawnpoints = get_tree().get_nodes_in_group("sebas_spawn")
		var nearest = spawnpoints[0]
		for point in spawnpoints:
			if point.global_position.distance_to(self.global_position) < nearest.global_position.distance_to(self.global_position):
				nearest = point
		enemy.global_position = nearest.global_position
		enemy.get_node("StateMachine").set_state(enemy.get_node("StateMachine").get_node("SebasIdle"))
		queue_free()
