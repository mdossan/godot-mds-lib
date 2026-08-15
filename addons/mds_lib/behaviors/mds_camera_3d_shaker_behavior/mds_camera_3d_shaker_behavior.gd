class_name MdsCamera3DShakerBehavior extends Node3D

static var GROUP: String = "mds_camera_3d_shaker_behavior"

@export var target_camera: Camera3D
@export var offset_x: float = 0.0
@export var offset_y: float = 0.0
@export var shake_amount: float = .1
@export var shake_duration: float = .1
@export var is_shaking: bool = false

func _ready() -> void:
	add_to_group(GROUP)

func _physics_process(_delta: float) -> void:
	if not is_shaking:
		return
	
	offset_x = randf_range(-shake_amount, shake_amount)
	offset_y = randf_range(-shake_amount, shake_amount)
	target_camera.position = Vector3.ZERO
	target_camera.position += target_camera.global_basis.x * offset_x
	target_camera.position += target_camera.global_basis.y * offset_y

func shake(amount: float = shake_amount, duration: float = shake_duration):
	shake_amount = amount
	shake_duration = duration
	is_shaking = true
	%ShakeTimer.wait_time = shake_duration
	%ShakeTimer.start()

func _on_shake_timer_timeout() -> void:
	is_shaking = false
