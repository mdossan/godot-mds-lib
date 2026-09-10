class_name MdsDash3D extends Node3D

const META: String = "mds_dash_3d"

signal dash_started
signal dash_ended

@export var character_body: CharacterBody3D
@export var dash_action: String = "dash"
@export var dash_force: float = 120
@export var dash_frame_number: int = 12
@export var is_dashing: bool = false
@export var disabled: bool = false

var current_dash_frame: int = 0

func _ready() -> void:
	character_body.set_meta(META, self)

func _input(event: InputEvent) -> void:
	if disabled:
		return

	if not is_multiplayer_authority():
		return

	if event.is_action_pressed(dash_action):
		dash_started.emit()
		current_dash_frame = 0
		is_dashing = true

func _physics_process(delta: float) -> void:
	if disabled:
		return

	if not is_multiplayer_authority():
		return

	if not is_dashing:
		return

	#character_body.velocity = 
	character_body.move_and_collide(-global_basis.z * dash_force * delta)
	dash_ended.emit()
	if current_dash_frame < dash_frame_number:
		current_dash_frame += 1
	else:
		is_dashing = false
	
