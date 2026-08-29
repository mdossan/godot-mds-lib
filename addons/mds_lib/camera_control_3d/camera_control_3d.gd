class_name MdsCameraControl3D extends Node3D

static var META: String = "mds_camera_control_3d"

@export var parent: Node3D
@export var node_horizontal: Node3D
@export var node_vertical: Node3D
@export var camera_3d: Node3D
@export var zoom_marker_3d: Marker3D
@export var sensitivity: float = 0.5
@export var disabled: bool = false

var current_rot = Vector2.ZERO
var camera_initial_position: Vector3

func _ready() -> void:
	parent.set_meta(META, self)
	camera_initial_position = camera_3d.position

func _input(event: InputEvent) -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	
	if disabled:
		return
	
	if event is InputEventMouseMotion:
		current_rot.x = (current_rot.x - event.relative.x)
		current_rot.y = clamp(current_rot.y - event.relative.y, -120, 120)
	
	if event.is_action_pressed("zoom"):
		var tween: Tween = create_tween()
		tween.tween_property(camera_3d, "position", zoom_marker_3d.position, .1)
	if event.is_action_released("zoom"):
		var tween: Tween = create_tween()
		tween.tween_property(camera_3d, "position", camera_initial_position, .1)

func _process(delta: float) -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	
	node_vertical.rotation.x = deg_to_rad(current_rot.y) * sensitivity
	node_horizontal.rotation.y = deg_to_rad(current_rot.x) * sensitivity
