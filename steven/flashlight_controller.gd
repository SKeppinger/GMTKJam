extends SpotLight3D

const RAY_LENGTH = 50.0

var camera

func _ready():
	camera = get_parent().get_node("Camera3D")

# Switch and shine light
func _physics_process(delta):
	if Input.is_action_pressed("Grow"):
		spot_angle = 15
		light_energy = 5
		light_color = Color(0.61, 0, 0.15)
		
		var space_state = get_world_3d().direct_space_state
		var mousepos = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mousepos)
		var to = from + camera.project_ray_normal(mousepos) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_areas = true
		query.exclude = [get_parent().get_parent(), get_parent().get_parent().get_node("Hitbox")]
		var result = space_state.intersect_ray(query)
		if result and result.collider.is_in_group("interactable"):
			var interactable = result.collider
			interactable.grow.emit(delta)
		elif result and result.collider.get_parent().is_in_group("interactable"):
			var interactable = result.collider.get_parent()
			interactable.grow.emit(delta)
	elif Input.is_action_pressed("Shrink"):
		spot_angle = 15
		light_energy = 5
		light_color = Color(0.34, 0.71, 1)
		
		var space_state = get_world_3d().direct_space_state
		var mousepos = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mousepos)
		var to = from + camera.project_ray_normal(mousepos) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_areas = true
		query.exclude = [get_parent().get_parent(), get_parent().get_parent().get_node("Hitbox")]
		var result = space_state.intersect_ray(query)
		if result and result.collider.is_in_group("interactable"):
			var interactable = result.collider
			interactable.shrink.emit(delta)
		elif result and result.collider.get_parent().is_in_group("interactable"):
			var interactable = result.collider.get_parent()
			interactable.shrink.emit(delta)
	else:
		spot_angle = 40
		light_energy = 1
		light_color = Color(1, 1, 1)
