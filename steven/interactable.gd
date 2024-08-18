extends StaticBody3D

signal grow
signal shrink

var grown = false
var shrunk = false

var model

@export var target_grow_x: float
@export var target_grow_y: float
@export var target_grow_z: float
@export var target_shrink_x: float
@export var target_shrink_y: float
@export var target_shrink_z: float

func _ready():
	model = $CollisionShape3D

func _on_grow():
	if not grown and not shrunk:
		model.scale = Vector3(target_grow_x, target_grow_y, target_grow_z)
		grown = true
	elif shrunk:
		model.scale = Vector3(1, 1, 1)
		shrunk = false

func _on_shrink():
	if not grown and not shrunk:
		model.scale = Vector3(target_shrink_x, target_shrink_y, target_shrink_z)
		shrunk = true
	elif grown:
		model.scale = Vector3(1, 1, 1)
		grown = false
