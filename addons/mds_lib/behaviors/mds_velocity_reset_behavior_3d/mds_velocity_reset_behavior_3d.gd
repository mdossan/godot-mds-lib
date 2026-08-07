class_name VelocityResetBehavior3D extends Node3D

@export var character_body_3d: CharacterBody3D

func _physics_process(delta: float) -> void:
	character_body_3d.velocity = Vector3.ZERO
