class_name MdsMovementSkill3D extends Node3D

@export var disabled: bool = false
@export var parent: CharacterBody3D
@export var speed: int = 10
@export var jump_cuvre: Curve = preload("res://addons/mds_lib/skills/movement/default_jump_curve.tres")
@export var jump_force: float = 10
@export var jump_speed: float = 1

@export var jump_action = "jump"
@export var up_action = "up"
@export var down_action = "down"
@export var left_action = "left"
@export var right_action = "right"

var direction = Vector3.ZERO
var backward_input: bool = false
var forward_input: bool = false
var right_input: bool = false
var left_input: bool = false
var jump_input: bool = false

var jump_in_progress: bool = false
var jump_offset: float = 0.0

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	
	if event.is_action_pressed(up_action):
		forward_input = true
	elif event.is_action_released(up_action):
		forward_input = false
	
	if event.is_action_pressed(down_action):
		backward_input = true
	elif event.is_action_released(down_action):
		backward_input = false
	
	if event.is_action_pressed(right_action):
		right_input = true
	elif event.is_action_released(right_action):
		right_input = false
		
	if event.is_action_pressed(left_action):
		left_input = true
	elif event.is_action_released(left_action):
		left_input = false
	
	if event.is_action_pressed(jump_action):
		jump_input = true
	elif event.is_action_released(jump_action):
		jump_input = false

func _physics_process(delta: float):
	if not is_multiplayer_authority():
		return
	
	if disabled:
		return
	
	var backward: Vector3 = Vector3.ZERO
	var forward: Vector3 = Vector3.ZERO
	var right: Vector3 = Vector3.ZERO
	var left: Vector3 = Vector3.ZERO
	var up: Vector3 = Vector3.ZERO
	
	if forward_input:
		forward = -parent.global_basis.z
	if backward_input:
		backward = parent.global_basis.z
	if right_input:
		right = parent.global_basis.x
	if left_input:
		left = -parent.global_basis.x
	
	if jump_input and parent.is_on_floor():
		jump_in_progress = true;
		jump_input = false
	
	if jump_in_progress:
		var jump_curve_force = jump_cuvre.sample(jump_offset)
		jump_offset += delta * jump_speed
		up = parent.global_basis.y * jump_curve_force * jump_force
		if jump_offset >= 1.0:
			jump_in_progress = false
	elif !parent.is_on_floor():
		var jump_curve_force = jump_cuvre.sample(jump_offset)
		jump_offset -= delta * jump_speed
		up = -parent.global_basis.y * jump_curve_force * jump_force
	else:
		jump_in_progress = false
		jump_offset = 0.0
	
	var target_velocity = (forward + backward + left + right).normalized() * speed + up
	parent.velocity = target_velocity
	# TODO | WARNING
	# Maybe the move and slide part should not be done here
	# it can maybe conflict with other node impacating physics' stuffs
	parent.move_and_slide()
