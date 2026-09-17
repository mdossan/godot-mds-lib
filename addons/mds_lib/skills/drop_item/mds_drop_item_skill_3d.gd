class_name MdsDropSkill3D extends Node3D

static var META = "mds_drop_skill_3d"

signal dropped

@export var parent: Node3D
@export var item_to_drop: MdsItem3D
@export var mds_inventory: MdsInventory3D

func _input(event: InputEvent):
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	
	if !event.is_action_pressed("drop"):
		return
	
	drop()

func _ready() -> void:
	parent.set_meta(META, self)

func drop():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	
	if !is_instance_valid(item_to_drop):
		return
	
	item_to_drop.dropped.emit()
	dropped.emit(item_to_drop)
