class_name MdsMovementSkill3D extends Node3D

signal direction_changed(x: float, y: float, z: float)

@export var parent: CharacterBody3D
@export var speed: int = 10
@export var disabled: bool = false

@export_group("Action Names")
@export var up_action = "up"
@export var down_action = "down"
@export var left_action = "left"
@export var right_action = "right"

var direction = Vector3.ZERO
var backward_input: float = 0.0
var forward_input: float = 0.0
var right_input: float = 0.0
var left_input: float = 0.0

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	
	if event.is_action_pressed(up_action):
		forward_input = 1.0
	elif event.is_action_released(up_action):
		forward_input = 0.0
	
	if event.is_action_pressed(down_action):
		backward_input = 1.0
	elif event.is_action_released(down_action):
		backward_input = 0.0
	
	if event.is_action_pressed(right_action):
		right_input = 1.0
	elif event.is_action_released(right_action):
		right_input = 0.0
		
	if event.is_action_pressed(left_action):
		left_input = 1.0
	elif event.is_action_released(left_action):
		left_input = 0.0

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
	
	if forward_input > 0.0:
		forward = -parent.global_basis.z
	if backward_input > 0.0:
		backward = parent.global_basis.z
	if right_input > 0.0:
		right = parent.global_basis.x
	if left_input > 0.0:
		left = -parent.global_basis.x
	
	var target_velocity = (forward + backward + left + right).normalized() * speed + up
	parent.velocity += target_velocity
	direction_changed.emit(
		right_input - left_input,
		0,
		forward_input - backward_input,
	)
