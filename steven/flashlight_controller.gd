extends SpotLight3D

enum LightMode {GROW, SHRINK}

const RAY_LENGTH = 100.0

var mode = LightMode.GROW

var camera

func _ready():
	camera = get_parent().get_node("Camera3D")

# Switch and shine light
func _physics_process(_delta):
	if Input.is_action_pressed("Shine"):
		spot_angle = 15
		light_energy = 5
		if mode == LightMode.GROW:
			light_color = Color(0.61, 0, 0.15)
		else:
			light_color = Color(0.34, 0.71, 1)
		
		var space_state = get_world_3d().direct_space_state
		var mousepos = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mousepos)
		var to = from + camera.project_ray_normal(mousepos) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_areas = true
		query.exclude = [get_parent().get_parent()]
		var result = space_state.intersect_ray(query)
		if result and result.collider.get_parent().is_in_group("interactable"):
			var interactable = result.collider.get_parent()
			if mode == LightMode.GROW:
				interactable.emit_signal("grow")
			else:
				interactable.emit_signal("shrink")
	else:
		spot_angle = 45
		light_energy = 1
		light_color = Color(1, 1, 1)
	
	if Input.is_action_just_pressed("Switch"):
		if mode == LightMode.GROW:
			mode = LightMode.SHRINK
		else:
			mode = LightMode.GROW
