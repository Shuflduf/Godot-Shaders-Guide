@tool
extends Node2D

var tot_rot = 0.0

func _ready() -> void:
	%Mesh.rotation.y = 0
	tot_rot = 0.0

func _process(delta: float) -> void:
	var diff = delta * (TAU / 10.0)
	tot_rot += diff
	%Mesh.rotate_y(diff)
	if !Engine.is_editor_hint():
		print(tot_rot)
		if tot_rot > TAU:
			get_tree().quit()
