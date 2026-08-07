class_name MdsJumpSkill3D extends Node3D

signal jump_started
signal jump_ended

@export var target_character_body_3d: CharacterBody3D

@export_group("Jump Config")
@export var jump_curve: Curve = preload("res://addons/mds_lib/skills/jump/default_jump_curve.tres")
@export var jump_force: float = 150
@export var jump_speed: float = 1.8
@export var jump_action: String = "jump"

var jumping: bool = false
var jump_in_progress: bool = false
var jump_time: float = 0.0
var jump_last_sample: float = 0.0
var jump_release_offset: float = 1.0
var jump_release_time: float = 1.0

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	
	if event.is_action_pressed(jump_action):
		jumping = true
		jump_started.emit()
	
	if event.is_action_released(jump_action):
		if jumping and jump_time < .5:
			jump_release_offset = jump_time
			jump_release_time = 1 - jump_time

func _physics_process(_delta: float) -> void:
	if jump_in_progress and target_character_body_3d.is_on_floor():
		jump_ended.emit()
		jump_in_progress = false
		jumping = false
		jump_time = 0.0
		jump_last_sample = 0.0
		jump_release_time = 1.0
		jump_release_offset = 1.0
		return
	
	if not jumping:
		return
	
	jump_time += _delta * jump_speed
	if jump_time > jump_release_time:
		jump_release_offset = 1.0
	var sample: float = jump_curve.sample(jump_time)
	var jump_vector: float = (sample - jump_last_sample) * jump_release_offset
	var up_direction: Vector3 = target_character_body_3d.global_basis.y
	target_character_body_3d.velocity += up_direction * jump_vector * jump_force
	jump_last_sample = sample
	jump_in_progress = true
	if jump_time >= 1:
		jump_ended.emit()
