class_name MdsUseItemSkill3D extends Node3D

signal item_used(item: MdsItem3D)

@export var use_action: String = "use"
@export var item_to_use: Node = null

var item: MdsItem3D
var _should_use: bool = false

func _input(event: InputEvent) -> void:
	if multiplayer.get_unique_id() != get_multiplayer_authority():
		return
	
	if event.is_action_pressed(use_action):
		_should_use = true

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(item_to_use):
		return
	
	if !_should_use:
		return
	
	# Item usage is a "one time" input
	_should_use = false
	
	item = item_to_use.get_meta(MdsItem3D.META)
	if !is_instance_valid(item):
		push_error("Item is invalid", item)
		return
	
	var usage: MdsItemUsage = item.item_resource.usage
	usage.use(item)
	item_used.emit(item)
