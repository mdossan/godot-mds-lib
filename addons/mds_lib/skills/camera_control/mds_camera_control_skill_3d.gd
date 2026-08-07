class_name MdsCameraControlSkill3D extends Node3D

@export var node_vertical: Node3D
@export var node_horizontal: Node3D
@export var sensitivity: float = 0.5
@export var disabled: bool = false

var current_rot = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	
	if disabled:
		return
	
	if event is InputEventMouseMotion:
		current_rot.x = (current_rot.x - event.relative.x)
		current_rot.y = clamp(current_rot.y - event.relative.y, -90, 35)

func _process(delta: float) -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	
	node_vertical.rotation.x = deg_to_rad(current_rot.y) * sensitivity
	node_horizontal.rotation.y = deg_to_rad(current_rot.x) * sensitivity
