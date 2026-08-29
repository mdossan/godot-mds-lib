class_name MdsCameraShaker3D extends Node3D

static var META: String = "mds_camera_shaker_3d"
static var GROUP: String = "mds_camera_shaker_3d"

@export var parent: Node3D
@export var target_camera: Camera3D
@export var offset_x: float = 0.0
@export var offset_y: float = 0.0
@export var shake_amount: float = .1
@export var shake_duration: float = .1
@export var is_shaking: bool = false

func _ready() -> void:
	parent.set_meta(META, self)
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
