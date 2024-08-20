extends Node3D

signal picked_up

@export var animation: AnimationPlayer

func _on_pick_up_area_body_entered(body):
	picked_up.emit()
	hide()
