extends CharacterBody3D

const SPEED = 5.0

var MOUSE_SENSITIVITY = 0.05

var camera
var pivot

func _ready():
	camera = $Pivot/Camera3D
	pivot = $Pivot
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Camera rotation
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		pivot.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		var camera_rotation = pivot.rotation_degrees
		camera_rotation.x = clamp(camera_rotation.x, -70, 70)
		pivot.rotation_degrees = camera_rotation

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
