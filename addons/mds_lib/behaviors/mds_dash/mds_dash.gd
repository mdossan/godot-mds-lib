class_name MdsDash extends Node3D

@export var character_body: CharacterBody3D
@export var dash_action: String = "dash"
@export var dash_force: float = 36.0
@export var is_dashing: bool = false

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	
	if event.is_action_pressed(dash_action):
		is_dashing = true

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return

	if not is_dashing:
		return

	character_body.velocity *= dash_force
	is_dashing = false
