class_name MdsGravityBehavior3D extends Node3D

@export var character_body_3d: CharacterBody3D
@export var gravity_force: float = 9.8
@export var disabled: bool = false

func _physics_process(delta: float) -> void:
	if disabled:
		return

	if character_body_3d.is_on_floor():
		return

	var down_direction: Vector3 = -character_body_3d.global_basis.y
	character_body_3d.velocity += down_direction * gravity_force

func activate() -> void:
	disabled = false

func disable() -> void:
	disabled = true
