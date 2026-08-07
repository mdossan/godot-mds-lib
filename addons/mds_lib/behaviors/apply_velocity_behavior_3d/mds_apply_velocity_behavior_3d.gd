class_name MdsApplyVelocityBehavior3D extends Node3D

@export var character_body_3d: CharacterBody3D

func _physics_process(_delta: float) -> void:
	character_body_3d.move_and_slide()
