extends StaticBody3D

signal grow
signal shrink
signal block

var grown = false
var shrunk = false
var growing = false
var shrinking = false
var targeting = false
var dying = false
var dead = false

var grow_timer = 0.0
var shrink_timer = 0.0
var shift_timer = 0.0
var dying_timer = 0.0

@export var target_time: float
@export var shift_time: float
@export var target_grow_x: float
@export var target_grow_y: float
@export var target_grow_z: float
@export var target_shrink_x: float
@export var target_shrink_y: float
@export var target_shrink_z: float

@export var block_on_grow: bool
@export var block_on_shrink: bool

func shift_size(delta):
	if growing:
		shift_timer += delta
		if shift_timer >= shift_time:
			if not grown and not shrunk:
				scale = Vector3(target_grow_x, target_grow_y, target_grow_z)
				grown = true
				growing = false
				shift_timer = 0
			elif shrunk:
				scale = Vector3(1, 1, 1)
				shrunk = false
				growing = false
				shift_timer = 0
		else:
			var progress = shift_timer / shift_time
			if not grown and not shrunk:
				scale = Vector3(1 + (target_grow_x - 1) * progress, 1 + (target_grow_y - 1) * progress, 1 + (target_grow_z - 1) * progress)
			elif shrunk:
				scale = Vector3(target_shrink_x + (1 - target_shrink_x) * progress, target_shrink_y + (1 - target_shrink_y) * progress, target_shrink_z + (1 - target_shrink_z) * progress)
	elif shrinking:
		shift_timer += delta
		if shift_timer >= shift_time:
			if not grown and not shrunk:
				scale = Vector3(target_shrink_x, target_shrink_y, target_shrink_z)
				shrunk = true
				shrinking = false
				shift_timer = 0
			elif grown:
				scale = Vector3(1, 1, 1)
				grown = false
				shrinking = false
				shift_timer = 0
		else:
			var progress = shift_timer / shift_time
			if not grown and not shrunk:
				scale = Vector3(1 - (1 - target_shrink_x) * progress, 1 - (1 - target_shrink_y) * progress, 1 - (1 - target_shrink_z) * progress)
			elif grown:
				scale = Vector3(target_grow_x - (target_grow_x - 1) * progress, target_grow_y - (target_grow_y - 1) * progress, target_grow_z - (target_grow_z - 1) * progress)
	elif dying:
		shift_timer += delta
		if shift_timer >= shift_time:
			if not dead:
				scale = Vector3(0,0,0)
				dead = true
				dying = false
				shift_timer = 0
		else:
			var progress = shift_timer / shift_time
			if not dead and block_on_grow:
				scale = Vector3(target_grow_x - (target_grow_x * progress), target_grow_y - (target_grow_y * progress), target_grow_z - (target_grow_z * progress))
			if not dead and block_on_shrink:
				scale = Vector3(target_shrink_x - (target_shrink_x * progress), target_shrink_y - (target_shrink_y * progress), target_shrink_z - (target_shrink_z * progress))
			

func _process(delta):
	shift_size(delta)
	
	if not targeting:
		grow_timer -= delta
		shrink_timer -= delta
		if grow_timer < 0:
			grow_timer = 0
		if shrink_timer < 0:
			shrink_timer = 0
	targeting = false

func _on_grow(delta):
	if not grown:
		targeting = true
		if not shrinking and not growing and grow_timer < target_time:
			grow_timer += delta
		if not shrinking and not growing and grow_timer >= target_time:
			grow_timer = 0
			growing = true

func _on_shrink(delta):
	if not shrunk:
		targeting = true
		if not shrinking and not growing and shrink_timer < target_time:
			shrink_timer += delta
		if not shrinking and not growing and shrink_timer >= target_time:
			shrink_timer = 0
			shrinking = true

func block_and_die():
	block.emit()
	queue_free()

func _on_hitbox_body_entered(body):
	if block_on_grow and grown:
		dying = true
		await get_tree().create_timer(shift_time).timeout
		block_and_die()
	if block_on_shrink and shrunk:
		dying = true
		await get_tree().create_timer(shift_time).timeout
		block_and_die()
