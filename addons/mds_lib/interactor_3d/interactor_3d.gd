class_name MdsInteractor3D extends Area3D

static var META: String = "mds_interactor_3d"

signal interacted(interactable: MdsInteractable3D)

@export var parent: Node3D
@export var shape: Shape3D = preload("res://addons/mds_lib/interactor_3d/interactor_3d_default_shape.tres")
@export var interact_action: String = "interact"

var should_interact: bool = false

func _ready():
	if shape != null:
		%InteractionShape.shape = shape
	parent.set_meta(META, self)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(interact_action):
		should_interact = true

func _physics_process(delta: float) -> void:
	if multiplayer.get_unique_id() != get_multiplayer_authority():
		return
	
	if should_interact:
		should_interact = false
		# TODO: Only one ?
		for interactable in get_overlapping_areas():
			if interactable is MdsInteractable3D:
				interactable.interact(parent)
				interacted.emit(interactable)
